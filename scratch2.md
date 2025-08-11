```
import os
import re

def get_project_prefix_from_function():
    """Extract project prefix from Lambda function name"""
    function_name = os.environ.get('AWS_LAMBDA_FUNCTION_NAME', '')
    # Function name pattern: uais-aaf481b1-comprehensive-qa-test
    match = re.match(r'(uais-[a-f0-9]{8})', function_name)
    if match:
        return match.group(1)
    return None
```

Testing lambda

```
import json
import boto3
import hashlib
import uuid
from datetime import datetime
from typing import Dict, Any
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

class ComprehensiveDocumentQA:
    def __init__(self):
        """Initialize all AWS service clients"""
        self.ssm = boto3.client('ssm')
        self.dynamodb = boto3.resource('dynamodb')
        self.bedrock_runtime = boto3.client('bedrock-agent-runtime')
        self.bedrock = boto3.client('bedrock-runtime')
        self.opensearch = boto3.client('opensearchservice')
        self.sagemaker = boto3.client('sagemaker-runtime')
        self.glue = boto3.client('glue')
        self.s3 = boto3.client('s3')
        
        # Optional services (may not be provisioned)
        try:
            self.neptune = boto3.client('neptunedata')
        except:
            self.neptune = None
            
        self.project_prefix = 'uais-aaf481b1'
        
    def test_parameter_store(self) -> Dict[str, Any]:
        """Test 1: Parameter Store - Read platform and write application params"""
        results = {}
        
        # Read from platform parameters (read-only)
        try:
            kb_id = self.ssm.get_parameter(
                Name=f'/params/{self.project_prefix}/platform/default-kb-id'
            )['Parameter']['Value']
            results['kb_id'] = kb_id
            
            opensearch_endpoint = self.ssm.get_parameter(
                Name=f'/params/{self.project_prefix}/platform/opensearch-endpoint'
            )['Parameter']['Value']
            results['opensearch_endpoint'] = opensearch_endpoint
        except Exception as e:
            logger.error(f"Platform param read failed: {e}")
            results['platform_read'] = 'failed'
        
        # Write to application parameters (full access)
        try:
            self.ssm.put_parameter(
                Name=f'/params/{self.project_prefix}/application/last-qa-run',
                Value=datetime.now().isoformat(),
                Type='String',
                Overwrite=True
            )
            results['application_write'] = 'success'
        except Exception as e:
            logger.error(f"Application param write failed: {e}")
            
        return results

    def test_dynamodb_operations(self, query_id: str, question: str) -> str:
        """Test 2: DynamoDB - Create tables and perform CRUD operations"""
        # Table for query history
        history_table_name = f'{self.project_prefix}-qa-history'
        
        # Table for feature cache
        cache_table_name = f'{self.project_prefix}-feature-cache'
        
        # Create tables if they don't exist
        for table_name in [history_table_name, cache_table_name]:
            try:
                self.dynamodb.create_table(
                    TableName=table_name,
                    KeySchema=[
                        {'AttributeName': 'id', 'KeyType': 'HASH'},
                        {'AttributeName': 'timestamp', 'KeyType': 'RANGE'}
                    ],
                    AttributeDefinitions=[
                        {'AttributeName': 'id', 'AttributeType': 'S'},
                        {'AttributeName': 'timestamp', 'AttributeType': 'S'}
                    ],
                    BillingMode='PAY_PER_REQUEST'
                )
                logger.info(f"Created table: {table_name}")
            except self.dynamodb.meta.client.exceptions.ResourceInUseException:
                logger.info(f"Table already exists: {table_name}")
        
        # Store query in history
        history_table = self.dynamodb.Table(history_table_name)
        history_table.put_item(
            Item={
                'id': query_id,
                'timestamp': datetime.now().isoformat(),
                'question': question,
                'processing_status': 'initiated'
            }
        )
        
        return query_id

    def test_glue_catalog(self) -> Dict[str, Any]:
        """Test 3: Glue Catalog - Read catalog metadata"""
        results = {}
        
        try:
            # Get the database
            catalog_name = f"{self.project_prefix}-glue-catalog"
            response = self.glue.get_database(Name=catalog_name)
            results['catalog_exists'] = True
            
            # List tables in the catalog
            tables = self.glue.get_tables(DatabaseName=catalog_name)
            results['table_count'] = len(tables.get('TableList', []))
            
        except self.glue.exceptions.EntityNotFoundException:
            logger.info("Glue catalog not found - expected if not yet created")
            results['catalog_exists'] = False
        except Exception as e:
            logger.error(f"Glue catalog error: {e}")
            
        return results

    def test_bedrock_kb_and_agents(self, question: str) -> Dict[str, Any]:
        """Test 4: Bedrock Knowledge Base and Agents"""
        results = {}
        
        # Get KB ID from parameters
        kb_id = self.ssm.get_parameter(
            Name=f'/params/{self.project_prefix}/platform/default-kb-id'
        )['Parameter']['Value']
        
        # Test Knowledge Base Retrieve & Generate
        try:
            kb_response = self.bedrock_runtime.retrieve_and_generate(
                input={'text': question},
                retrieveAndGenerateConfiguration={
                    'type': 'KNOWLEDGE_BASE',
                    'knowledgeBaseConfiguration': {
                        'knowledgeBaseId': kb_id,
                        'modelArn': 'arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-instant-v1'
                    }
                }
            )
            results['kb_answer'] = kb_response['output']['text']
            results['kb_citations'] = len(kb_response.get('citations', []))
        except Exception as e:
            logger.error(f"KB query failed: {e}")
            results['kb_answer'] = None
            
        # Test direct Bedrock model invocation
        try:
            direct_response = self.bedrock.invoke_model(
                modelId='amazon.titan-text-lite-v1',
                contentType='application/json',
                accept='application/json',
                body=json.dumps({
                    'inputText': f"Summarize this question in 10 words: {question}",
                    'textGenerationConfig': {
                        'maxTokenCount': 50,
                        'temperature': 0.7
                    }
                })
            )
            response_body = json.loads(direct_response['body'].read())
            results['direct_model_summary'] = response_body['results'][0]['outputText']
        except Exception as e:
            logger.error(f"Direct Bedrock invocation failed: {e}")
            
        # Test Bedrock Guardrails (if available)
        try:
            # Apply guardrail to check content
            guardrail_response = self.bedrock.apply_guardrail(
                guardrailIdentifier=f'{self.project_prefix}-guardrail',
                guardrailVersion='DRAFT',
                source='INPUT',
                content=[{'text': {'text': question}}]
            )
            results['guardrail_action'] = guardrail_response['action']
        except:
            logger.info("Guardrails not configured")
            
        return results

    def test_opensearch(self, query_id: str, question: str, answer: str) -> bool:
        """Test 5: OpenSearch - Store and search documents"""
        try:
            import requests
            from requests.auth import HTTPBasicAuth
            
            # Get OpenSearch endpoint
            endpoint = self.ssm.get_parameter(
                Name=f'/params/{self.project_prefix}/platform/opensearch-endpoint'
            )['Parameter']['Value']
            
            # Index the Q&A pair
            doc = {
                'query_id': query_id,
                'question': question,
                'answer': answer,
                'timestamp': datetime.now().isoformat(),
                'vector_embedding': [0.1] * 768  # Placeholder embedding
            }
            
            # Note: In real implementation, you'd use proper auth
            response = requests.post(
                f"https://{endpoint}/qa-index/_doc/{query_id}",
                json=doc,
                headers={'Content-Type': 'application/json'}
            )
            
            return response.status_code == 201
        except Exception as e:
            logger.error(f"OpenSearch indexing failed: {e}")
            return False

    def test_sagemaker_endpoints(self) -> Dict[str, Any]:
        """Test 6: SageMaker - Invoke endpoints and feature store"""
        results = {}
        
        # List available endpoints with our prefix
        sagemaker_client = boto3.client('sagemaker')
        try:
            endpoints = sagemaker_client.list_endpoints(
                NameContains=self.project_prefix
            )
            results['endpoint_count'] = len(endpoints['Endpoints'])
            
            # If an endpoint exists, invoke it
            if endpoints['Endpoints']:
                endpoint_name = endpoints['Endpoints'][0]['EndpointName']
                
                # Test endpoint invocation
                response = self.sagemaker.invoke_endpoint(
                    EndpointName=endpoint_name,
                    ContentType='application/json',
                    Body=json.dumps({'text': 'test query'})
                )
                results['endpoint_invocation'] = 'success'
        except Exception as e:
            logger.info(f"No SageMaker endpoints found: {e}")
            results['endpoint_count'] = 0
            
        # Test Feature Store access
        try:
            # This would work if feature groups exist
            response = self.sagemaker.batch_get_record(
                Identifiers=[
                    {
                        'FeatureGroupName': f'{self.project_prefix}-features',
                        'RecordIdentifiersValueAsString': ['feature-1']
                    }
                ]
            )
            results['feature_store'] = 'accessible'
        except:
            results['feature_store'] = 'not configured'
            
        return results

    def test_s3_through_kms(self) -> Dict[str, Any]:
        """Test 7: S3 access through KMS encryption context"""
        results = {}
        
        # Test workspace bucket access
        workspace_bucket = f'{self.project_prefix}-workspace-bucket'
        test_key = f'qa-test/{datetime.now().strftime("%Y%m%d")}/test.json'
        
        try:
            # Put object (should work with KMS)
            test_data = {
                'test': 'document QA system',
                'timestamp': datetime.now().isoformat()
            }
            
            self.s3.put_object(
                Bucket=workspace_bucket,
                Key=test_key,
                Body=json.dumps(test_data),
                ServerSideEncryption='aws:kms',
                SSEKMSKeyId=f'alias/{self.project_prefix}-kms-key'
            )
            results['s3_write'] = 'success'
            
            # Get object
            response = self.s3.get_object(
                Bucket=workspace_bucket,
                Key=test_key
            )
            results['s3_read'] = 'success'
            
        except Exception as e:
            logger.error(f"S3 operation failed: {e}")
            results['s3_error'] = str(e)
            
        # Test BYOD bucket (read-only)
        try:
            byod_bucket = f'{self.project_prefix}-byod-bucket'
            response = self.s3.list_objects_v2(
                Bucket=byod_bucket,
                MaxKeys=1
            )
            results['byod_access'] = 'read-only verified'
        except:
            results['byod_access'] = 'no access or empty'
            
        return results

    def test_neptune_graph(self, query_id: str) -> Dict[str, Any]:
        """Test 8: Neptune Graph Database (if available)"""
        results = {}
        
        if not self.neptune:
            results['neptune'] = 'not configured'
            return results
            
        try:
            # Test read operation (write operations are denied)
            response = self.neptune.execute_gremlin_query(
                gremlinQuery="g.V().limit(1).values('id')"
            )
            results['neptune_read'] = 'success'
        except Exception as e:
            logger.info(f"Neptune not available: {e}")
            results['neptune'] = 'not available'
            
        return results

    def update_query_status(self, query_id: str, status: str, results: Dict):
        """Update DynamoDB with final status"""
        table = self.dynamodb.Table(f'{self.project_prefix}-qa-history')
        table.update_item(
            Key={
                'id': query_id,
                'timestamp': datetime.now().isoformat()
            },
            UpdateExpression='SET processing_status = :status, results = :results',
            ExpressionAttributeValues={
                ':status': status,
                ':results': results
            }
        )


def lambda_handler(event, context):
    """Main Lambda handler - orchestrates all service tests"""
    
    qa_system = ComprehensiveDocumentQA()
    
    # Get question from event
    question = event.get('question', 'What are the best practices for ML model deployment?')
    query_id = str(uuid.uuid4())
    
    # Comprehensive test results
    test_results = {
        'query_id': query_id,
        'question': question,
        'timestamp': datetime.now().isoformat(),
        'service_tests': {}
    }
    
    try:
        # Test 1: Parameter Store
        logger.info("Testing Parameter Store...")
        test_results['service_tests']['parameter_store'] = qa_system.test_parameter_store()
        
        # Test 2: DynamoDB
        logger.info("Testing DynamoDB...")
        qa_system.test_dynamodb_operations(query_id, question)
        test_results['service_tests']['dynamodb'] = 'success'
        
        # Test 3: Glue Catalog
        logger.info("Testing Glue Catalog...")
        test_results['service_tests']['glue'] = qa_system.test_glue_catalog()
        
        # Test 4: Bedrock (KB, Models, Agents)
        logger.info("Testing Bedrock services...")
        bedrock_results = qa_system.test_bedrock_kb_and_agents(question)
        test_results['service_tests']['bedrock'] = bedrock_results
        test_results['answer'] = bedrock_results.get('kb_answer', 'No answer generated')
        
        # Test 5: OpenSearch
        logger.info("Testing OpenSearch...")
        opensearch_success = qa_system.test_opensearch(
            query_id, 
            question, 
            test_results['answer']
        )
        test_results['service_tests']['opensearch'] = 'indexed' if opensearch_success else 'failed'
        
        # Test 6: SageMaker
        logger.info("Testing SageMaker...")
        test_results['service_tests']['sagemaker'] = qa_system.test_sagemaker_endpoints()
        
        # Test 7: S3 through KMS
        logger.info("Testing S3/KMS...")
        test_results['service_tests']['s3_kms'] = qa_system.test_s3_through_kms()
        
        # Test 8: Neptune (if available)
        logger.info("Testing Neptune...")
        test_results['service_tests']['neptune'] = qa_system.test_neptune_graph(query_id)
        
        # Update final status
        qa_system.update_query_status(query_id, 'completed', test_results)
        
        # Store comprehensive results in application parameters
        qa_system.ssm.put_parameter(
            Name=f'/params/{qa_system.project_prefix}/application/last-comprehensive-test',
            Value=json.dumps(test_results, default=str)[:4096],  # SSM param size limit
            Type='String',
            Overwrite=True
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'query_id': query_id,
                'answer': test_results['answer'],
                'services_tested': len(test_results['service_tests']),
                'test_summary': {
                    service: 'pass' if results else 'fail' 
                    for service, results in test_results['service_tests'].items()
                }
            }, default=str)
        }
        
    except Exception as e:
        logger.error(f"Lambda execution failed: {e}")
        
        # Update status as failed
        qa_system.update_query_status(query_id, 'failed', {'error': str(e)})
        
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e),
                'query_id': query_id
            })
        }


# For local testing
if __name__ == "__main__":
    test_event = {
        'question': 'How do I implement a RAG system using Bedrock?'
    }
    result = lambda_handler(test_event, None)
    print(json.dumps(result, indent=2))
```


## **Step-by-Step Lambda Deployment Guide via AWS Console**
```
### **Prerequisites Check**
First, verify these resources exist in your account:
- IAM Role: `uais-aaf481b1-lambda-domain-exec-role`
- VPC: `uais-aaf481b1-vpc`
- Security Group: `uais-aaf481b1-lambda-sg`
- Parameter Store values under `/params/uais-aaf481b1/platform/`

---

### **Step 1: Prepare the Lambda Code**

1. **Create a local file** named `lambda_function.py` with the code you provided
2. **Create a ZIP file**:
   ```bash
   zip lambda_deployment.zip lambda_function.py
   ```
   
   Or if you're on Windows:
   - Right-click the `lambda_function.py` file
   - Select "Send to" → "Compressed (zipped) folder"

---

### **Step 2: Create Lambda Function in AWS Console**

1. **Navigate to Lambda**:
   - Go to AWS Console → Services → Lambda
   - Click **"Create function"**

2. **Basic Information**:
   - Choose: **"Author from scratch"**
   - Function name: `uais-aaf481b1-comprehensive-qa-test`
   - Runtime: **Python 3.9**
   - Architecture: **x86_64**

3. **Permissions**:
   - Expand "Change default execution role"
   - Select: **"Use an existing role"**
   - Choose role: **`uais-aaf481b1-lambda-domain-exec-role`**
   
4. Click **"Create function"**

---

### **Step 3: Upload Code**

1. In the Lambda function page, under **"Code source"**:
   - Click **"Upload from"** → **".zip file"**
   - Click **"Upload"** and select your `lambda_deployment.zip`
   - Click **"Save"**

---

### **Step 4: Configure VPC Settings**

1. Go to **"Configuration"** tab → **"VPC"**
2. Click **"Edit"**
3. Configure:
   - **VPC**: Select `uais-aaf481b1-vpc`
   - **Subnets**: Select the subnets named `uais-aaf481b1-endpoints-*` (select at least 2)
   - **Security groups**: Select `uais-aaf481b1-lambda-sg`
4. Click **"Save"**

---

### **Step 5: Configure General Settings**

1. Go to **"Configuration"** → **"General configuration"**
2. Click **"Edit"**
3. Set:
   - **Memory**: `1024 MB`
   - **Timeout**: `5 min 0 sec` (or enter 300 seconds)
   - **Ephemeral storage**: Keep default (512 MB)
4. Click **"Save"**

---

### **Step 6: Add Required Dependencies (Important!)**

Since the code uses `requests` library for OpenSearch, you need to add it:

**Option A: Quick Fix (Modify Code)**
1. Go to **"Code"** tab
2. Comment out the OpenSearch test section or replace with boto3 calls:

```python
def test_opensearch(self, query_id: str, question: str, answer: str) -> bool:
    """Test 5: OpenSearch - Store and search documents"""
    try:
        # Simplified version without requests library
        # Just verify we can describe the domain
        domain_name = f'{self.project_prefix}-opensearch'
        response = self.opensearch.describe_domain(DomainName=domain_name)
        logger.info(f"OpenSearch domain status: {response['DomainStatus']['Processing']}")
        return True
    except Exception as e:
        logger.error(f"OpenSearch test failed: {e}")
        return False
```

**Option B: Create Layer (Advanced)**
1. On your local machine:
   ```bash
   mkdir python
   pip install requests -t python/
   zip -r requests-layer.zip python
   ```
2. In Lambda console → Layers → Create layer
3. Upload the zip and attach to your function

---

### **Step 7: Create Test Event**

1. In the Lambda function, go to **"Test"** tab
2. Click **"Create new event"**
3. Event name: `TestDocumentQA`
4. Event JSON:
```json
{
  "question": "What are the best practices for deploying ML models in production?"
}
```
5. Click **"Save"**

---

### **Step 8: Test the Function**

1. Click **"Test"** button
2. Monitor the execution results
3. Check **"Monitor"** tab → **"View CloudWatch logs"** for detailed logs

---

### **Step 9: Troubleshooting Common Issues**

**If you get timeout errors:**
- Some services might not be provisioned yet
- Add try-catch blocks around each service test

**If you get permission errors:**
- Verify the Lambda execution role has all 5 policies attached
- Check in IAM → Roles → `uais-aaf481b1-lambda-domain-exec-role`

**If VPC connectivity fails:**
- Ensure VPC endpoints are created for all services
- Check security group allows outbound HTTPS (443)

---

### **Step 10: Simplified Test Version**

For initial testing, here's a minimal version that tests core services:

```python
import json
import boto3
from datetime import datetime
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """Simplified test for core services"""
    
    project_prefix = 'uais-aaf481b1'
    results = {}
    
    # Test 1: Parameter Store
    try:
        ssm = boto3.client('ssm')
        param = ssm.get_parameter(
            Name=f'/params/{project_prefix}/platform/vpc-id'
        )
        results['parameter_store'] = 'success'
        logger.info(f"VPC ID: {param['Parameter']['Value']}")
    except Exception as e:
        results['parameter_store'] = f'failed: {str(e)}'
    
    # Test 2: DynamoDB
    try:
        dynamodb = boto3.resource('dynamodb')
        table_name = f'{project_prefix}-test-table'
        
        # Try to create table
        table = dynamodb.create_table(
            TableName=table_name,
            KeySchema=[
                {'AttributeName': 'id', 'KeyType': 'HASH'}
            ],
            AttributeDefinitions=[
                {'AttributeName': 'id', 'AttributeType': 'S'}
            ],
            BillingMode='PAY_PER_REQUEST'
        )
        results['dynamodb'] = 'table created'
    except dynamodb.meta.client.exceptions.ResourceInUseException:
        results['dynamodb'] = 'table exists'
    except Exception as e:
        results['dynamodb'] = f'failed: {str(e)}'
    
    # Test 3: Bedrock
    try:
        bedrock = boto3.client('bedrock-runtime')
        response = bedrock.invoke_model(
            modelId='amazon.titan-text-lite-v1',
            contentType='application/json',
            accept='application/json',
            body=json.dumps({
                'inputText': 'Hello, this is a test',
                'textGenerationConfig': {
                    'maxTokenCount': 50
                }
            })
        )
        results['bedrock'] = 'success'
    except Exception as e:
        results['bedrock'] = f'failed: {str(e)}'
    
    # Test 4: Write to application parameters
    try:
        ssm.put_parameter(
            Name=f'/params/{project_prefix}/application/test-timestamp',
            Value=datetime.now().isoformat(),
            Type='String',
            Overwrite=True
        )
        results['app_param_write'] = 'success'
    except Exception as e:
        results['app_param_write'] = f'failed: {str(e)}'
    
    return {
        'statusCode': 200,
        'body': json.dumps(results, indent=2)
    }
```

---

### **Next Steps After Successful Deployment**

1. **Check CloudWatch Logs** for detailed execution logs
2. **Verify DynamoDB** - Check if tables were created
3. **Check Parameter Store** - Look for `/params/uais-aaf481b1/application/` values
4. **Iterate and Enhance** - Add more service tests as needed

This approach lets you test the infrastructure setup without dealing with complex dependencies initially!
```
