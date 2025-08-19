## bot version
```
{
    "eventVersion": "1.09",
    "userIdentity": {
        "type": "AssumedRole",
        "principalId": "AROA6JQ45BUEHHME4SR22:ajaisw49@optumcloud.com",
        "arn": "arn:aws:sts::982534393096:assumed-role/AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2/ajaisw49@optumcloud.com",
        "accountId": "982534393096",
        "accessKeyId": "ASIA6JQ45BUECWYY72VS",
        "sessionContext": {
            "sessionIssuer": {
                "type": "Role",
                "principalId": "AROA6JQ45BUEHHME4SR22",
                "arn": "arn:aws:iam::982534393096:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2",
                "accountId": "982534393096",
                "userName": "AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2"
            },
            "attributes": {
                "creationDate": "2025-08-19T04:49:53Z",
                "mfaAuthenticated": "false"
            }
        }
    },
    "eventTime": "2025-08-19T05:22:19Z",
    "eventSource": "lex.amazonaws.com",
    "eventName": "CreateBotVersion",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "198.203.177.177",
    "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
    "requestParameters": {
        "botVersionLocaleSpecification": {
            "en_US": {
                "sourceBotVersion": "DRAFT"
            }
        },
        "description": "test",
        "botId": "6JK3M1NPPW"
    },
    "responseElements": {
        "botVersionLocaleSpecification": {
            "en_US": {
                "sourceBotVersion": "DRAFT"
            }
        },
        "botStatus": "Versioning",
        "description": "test",
        "botId": "6JK3M1NPPW",
        "botVersion": "1",
        "creationDateTime": 1755580939.744
    },
    "requestID": "3dc0fb91-37c7-4a4e-8066-14745f6d4dde",
    "eventID": "bb2d0055-9055-49f2-abe6-ab2407558456",
    "readOnly": false,
    "eventType": "AwsApiCall",
    "managementEvent": true,
    "recipientAccountId": "982534393096",
    "eventCategory": "Management"
}
```

## bot alias
```
{
    "eventVersion": "1.09",
    "userIdentity": {
        "type": "AssumedRole",
        "principalId": "AROA6JQ45BUEHHME4SR22:ajaisw49@optumcloud.com",
        "arn": "arn:aws:sts::982534393096:assumed-role/AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2/ajaisw49@optumcloud.com",
        "accountId": "982534393096",
        "accessKeyId": "ASIA6JQ45BUEI7NLJPOB",
        "sessionContext": {
            "sessionIssuer": {
                "type": "Role",
                "principalId": "AROA6JQ45BUEHHME4SR22",
                "arn": "arn:aws:iam::982534393096:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2",
                "accountId": "982534393096",
                "userName": "AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2"
            },
            "attributes": {
                "creationDate": "2025-08-19T04:49:53Z",
                "mfaAuthenticated": "false"
            }
        }
    },
    "eventTime": "2025-08-19T04:59:17Z",
    "eventSource": "lex.amazonaws.com",
    "eventName": "CreateBotAlias",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "198.203.181.181",
    "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
    "requestParameters": {
        "botId": "6JK3M1NPPW",
        "botAliasName": "test-alias-19aug"
    },
    "responseElements": {
        "botAliasId": "GDEU1GZ7G0",
        "botAliasName": "test-alias-19aug",
        "botId": "6JK3M1NPPW",
        "botAliasStatus": "Creating",
        "creationDateTime": 1755579557.634
    },
    "requestID": "2d810446-f7bd-4835-8e4d-4367d9dd5901",
    "eventID": "4e2f5b62-0507-4177-85c2-af646acca6b2",
    "readOnly": false,
    "eventType": "AwsApiCall",
    "managementEvent": true,
    "recipientAccountId": "982534393096",
    "eventCategory": "Management"
}
```

## base/lambda_lex_tagger.tf
```
# EventBridge Rule to capture Lex bot creation events
resource "aws_cloudwatch_event_rule" "lex_bot_creation" {
  name        = "${local.base_prefix}-lex-bot-tagging"
  description = "Capture Lex bot creation events for auto-tagging"
  
  event_pattern = jsonencode({
    source      = ["aws.lex"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["lex.amazonaws.com"]
      eventName   = ["CreateBot", "CreateBotVersion", "CreateBotAlias", "ImportBot"]
    }
  })

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

# Lambda function package
data "archive_file" "lex_tagger_zip" {
  type        = "zip"
  output_path = "${path.module}/lex_tagger.zip"
  source {
    content = <<EOF
import json
import boto3
import re
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        detail = event['detail']
        event_name = detail['eventName']
        request_parameters = detail['requestParameters']
        response_elements = detail['responseElements']
        user_identity = detail['userIdentity']
        aws_region = detail['awsRegion']
        
        # Step 1: Extract base_prefix from roleArn
        role_arn = request_parameters.get('roleArn')
        if not role_arn:
            logger.info("No roleArn found in request parameters")
            return {'statusCode': 200, 'body': 'No roleArn found'}
        
        # Extract role name: uais-{base_prefix}-lex-service-role
        role_name = role_arn.split('/')[-1]
        lex_role_pattern = r'^uais-([a-f0-9]{8})-lex-service-role$'
        match = re.match(lex_role_pattern, role_name)
        
        if not match:
            logger.info(f"Role {role_name} doesn't match pattern uais-{{base_prefix}}-lex-service-role")
            return {'statusCode': 200, 'body': 'Role pattern not matched'}
        
        base_prefix = match.group(1)
        logger.info(f"Extracted base_prefix: {base_prefix}")
        
        # Step 2: Get account ID from userIdentity
        account_id = user_identity.get('accountId')
        if not account_id:
            logger.error("No accountId found in userIdentity")
            return {'statusCode': 400, 'body': 'No accountId found'}
        
        # Step 3: Check authorization
        user_arn = user_identity.get('arn', '')
        
        # Condition 1: SSO user pattern
        sso_pattern = f"AWSReservedSSO_{account_id}_uais_{base_prefix}"
        
        # Condition 2: Lambda service role pattern  
        lambda_role_pattern = f"uais-{base_prefix}-lambda-exec-role"
        
        is_authorized = (sso_pattern in user_arn) or (lambda_role_pattern in user_arn)
        
        if not is_authorized:
            logger.warning(f"User {user_arn} not authorized for project {base_prefix}")
            return {'statusCode': 403, 'body': 'Not authorized'}
        
        logger.info(f"User authorized. Proceeding with tagging for project: {base_prefix}")
        
        # Step 4: Construct Lex ARN based on event type
        lex_arn = None
        
        if event_name in ['CreateBot', 'ImportBot']:
            bot_id = response_elements.get('botId')
            if bot_id:
                lex_arn = f"arn:aws:lex:{aws_region}:{account_id}:bot:{bot_id}"
        
        elif event_name == 'CreateBotVersion':
            bot_id = response_elements.get('botId')
            bot_version = response_elements.get('botVersion')
            if bot_id and bot_version:
                lex_arn = f"arn:aws:lex:{aws_region}:{account_id}:bot:{bot_id}:{bot_version}"
        
        elif event_name == 'CreateBotAlias':
            bot_id = response_elements.get('botId')
            bot_alias_id = response_elements.get('botAliasId')
            if bot_id and bot_alias_id:
                lex_arn = f"arn:aws:lex:{aws_region}:{account_id}:bot-alias:{bot_id}:{bot_alias_id}"
        
        if not lex_arn:
            logger.error(f"Could not construct Lex ARN for event {event_name}")
            return {'statusCode': 400, 'body': 'Could not construct ARN'}
        
        # Step 5: Apply the tag
        lex_client = boto3.client('lex', region_name=aws_region)
        project_alias_tag = f"uais-{base_prefix}"
        
        lex_client.tag_resource(
            resourceArn=lex_arn,
            tags={'project-alias': project_alias_tag}
        )
        
        logger.info(f"Successfully tagged {lex_arn} with project-alias: {project_alias_tag}")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Successfully tagged Lex resource',
                'lex_arn': lex_arn,
                'project_alias': project_alias_tag
            })
        }
        
    except Exception as e:
        logger.error(f"Error processing event: {str(e)}")
        return {'statusCode': 500, 'body': f'Error: {str(e)}'}
EOF
    filename = "lambda_function.py"
  }
}

# Lambda function
resource "aws_lambda_function" "lex_tagger" {
  filename         = data.archive_file.lex_tagger_zip.output_path
  function_name    = "${local.base_prefix}-lex-auto-tagger"
  role            = aws_iam_role.lambda_exec_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 60
  source_code_hash = data.archive_file.lex_tagger_zip.output_base64sha256

  vpc_config {
    subnet_ids         = values({ for k, v in module.spoke_vpc.private_subnet_attributes_by_az : split("/", k)[1] => v.id if split("/", k)[0] == "endpoints_subnet" })
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )

  depends_on = [aws_cloudwatch_log_group.lex_tagger_logs]
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lex_tagger_logs" {
  name              = "/aws/lambda/${local.base_prefix}-lex-auto-tagger"
  retention_in_days = 7

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

# EventBridge target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lex_bot_creation.name
  target_id = "LexTaggerLambdaTarget"
  arn       = aws_lambda_function.lex_tagger.arn
}

# Lambda permission for EventBridge
resource "aws_lambda_permission" "eventbridge_invoke" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lex_tagger.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lex_bot_creation.arn
}
```



```
{
    "eventVersion": "1.09",
    "userIdentity": {
        "type": "AssumedRole",
        "principalId": "AROA6JQ45BUEHHME4SR22:ajaisw49@optumcloud.com",
        "arn": "arn:aws:sts::982534393096:assumed-role/AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2/ajaisw49@optumcloud.com",
        "accountId": "982534393096",
        "accessKeyId": "ASIA6JQ45BUEC2NTEDL5",
        "sessionContext": {
            "sessionIssuer": {
                "type": "Role",
                "principalId": "AROA6JQ45BUEHHME4SR22",
                "arn": "arn:aws:iam::982534393096:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2",
                "accountId": "982534393096",
                "userName": "AWSReservedSSO_982534393096_uais_86ef73a8_92ad32004229c5b2"
            },
            "attributes": {
                "creationDate": "2025-08-18T13:42:29Z",
                "mfaAuthenticated": "false"
            }
        }
    },
    "eventTime": "2025-08-18T16:34:59Z",
    "eventSource": "lex.amazonaws.com",
    "eventName": "CreateBot",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "198.203.177.177",
    "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
    "requestParameters": {
        "botName": "uais-86ef73a8-newrole2",
        "roleArn": "arn:aws:iam::982534393096:role/uais-86ef73a8-lex-service-role",
        "botType": "Bot",
        "description": "test",
        "dataPrivacy": {
            "childDirected": false
        },
        "idleSessionTTLInSeconds": 300,
        "errorLogSettings": {
            "enabled": false
        }
    },
    "responseElements": {
        "botStatus": "Creating",
        "botName": "uais-86ef73a8-newrole2",
        "dataPrivacy": {
            "childDirected": false
        },
        "description": "test",
        "idleSessionTTLInSeconds": 300,
        "errorLogSettings": {
            "enabled": false
        },
        "botType": "Bot",
        "roleArn": "arn:aws:iam::982534393096:role/uais-86ef73a8-lex-service-role",
        "botId": "9GZXJ6T5EK",
        "creationDateTime": 1755534899.336
    },
    "requestID": "f30850be-1507-4cf8-8e43-c8ee856f48c1",
    "eventID": "93e24440-b412-4bd7-aef4-cae20f1beb01",
    "readOnly": false,
    "eventType": "AwsApiCall",
    "managementEvent": true,
    "recipientAccountId": "982534393096",
    "eventCategory": "Management"
}
```
