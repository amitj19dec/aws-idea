## Policy ##
```{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowBedrockFullAccess",
      "Effect": "Allow",
      "Action": "bedrock:*",
      "Resource": [
				"arn:aws:bedrock:*:982534393096:data-automation-profile/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:async-invoke/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:flow/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:agent/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:evaluation-job/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:knowledge-base/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:blueprint/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:automated-reasoning-policy/uais-abcde-*:*",
				"arn:aws:bedrock:*:982534393096:guardrail-profile/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:application-inference-profile/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:inference-profile/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:data-automation-project/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:marketplace/model-endpoint/all-access",
				"arn:aws:bedrock:*:982534393096:provisioned-model/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:session/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:default-prompt-router/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:guardrail/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:model-invocation-job/uais-abcde-*",
				"arn:aws:bedrock:*::foundation-model/*",
				"arn:aws:bedrock:*:982534393096:agent-alias/uais-abcde-*/*",
				"arn:aws:bedrock:*:982534393096:data-automation-invocation/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:prompt-router/uais-abcde-*",
				"arn:aws:bedrock:*:982534393096:prompt/uais-abcde-*:*"
			]
    },
    {
      "Sid": "DenyCustomModelListActions",
      "Effect": "Deny",
      "Action": [
        "bedrock:ListCustomModelDeployments",
        "bedrock:ListCustomModels",
        "bedrock:ListAsyncInvokes"
        "
      ],
      "Resource": "*"
    }
  ]
}
```


## Bedrock: ##

These are the resource ARN related to Bedrock
agent


agent-alias


application-inference-profile


async-invoke


automated-reasoning-policy


automated-reasoning-policy-version


bedrock-marketplace-model-endpoint


blueprint


custom-model


custom-model-deployment


data-automation-invocation-job


data-automation-profile


data-automation-project


default-prompt-router


evaluation-job


flow


flow-alias


flow-execution


foundation-model


guardrail


guardrail-profile


imported-model


inference-profile


knowledge-base


model-copy-job


model-customization-job


model-evaluation-job


model-import-job


model-invocation-job


prompt


prompt-router


prompt-version


provisioned-model


session



### Write Actions ###
```
All write actions

AssociateAgentCollaborator

AssociateAgentKnowledgeBase

AssociateThirdPartyKnowledgeBase

BatchDeleteEvaluationJob

CancelAutomatedReasoningPolicyBuildWorkflow

CreateAgent

CreateAgentActionGroup

CreateAgentAlias

CreateAutomatedReasoningPolicy

CreateAutomatedReasoningPolicyTestCase

CreateAutomatedReasoningPolicyVersion

CreateBlueprint

CreateBlueprintVersion

CreateCustomModel

CreateCustomModelDeployment

CreateDataAutomationProject

CreateDataSource

CreateEvaluationJob

CreateFlow

CreateFlowAlias

CreateFlowVersion

CreateFoundationModelAgreement

CreateGuardrail

CreateGuardrailVersion

CreateInferenceProfile

CreateInvocation

CreateKnowledgeBase

CreateMarketplaceModelEndpoint

CreateModelCopyJob

CreateModelCustomizationJob

CreateModelEvaluationJob

CreateModelImportJob

CreateModelInvocationJob

CreatePrompt

CreatePromptRouter

CreatePromptVersion

CreateProvisionedModelThroughput

CreateSession

DeleteAgent

DeleteAgentActionGroup

DeleteAgentAlias

DeleteAgentMemory

DeleteAgentVersion

DeleteAutomatedReasoningPolicy

DeleteAutomatedReasoningPolicyBuildWorkflow

DeleteAutomatedReasoningPolicyTestCase

DeleteBlueprint

DeleteCustomModel

DeleteCustomModelDeployment

DeleteDataAutomationProject

DeleteDataSource

DeleteFlow

DeleteFlowAlias

DeleteFlowVersion

DeleteFoundationModelAgreement

DeleteGuardrail

DeleteImportedModel

DeleteInferenceProfile

DeleteKnowledgeBase

DeleteKnowledgeBaseDocuments

DeleteMarketplaceModelAgreement

DeleteMarketplaceModelEndpoint

DeleteModelInvocationLoggingConfiguration

DeletePrompt

DeletePromptRouter

DeleteProvisionedModelThroughput

DeleteResourcePolicy

DeleteSession

DeregisterMarketplaceModelEndpoint

DisassociateAgentCollaborator

DisassociateAgentKnowledgeBase

EndSession

IngestKnowledgeBaseDocuments

InvokeBlueprintRecommendationAsync

InvokeBuilder

InvokeDataAutomationAsync

PrepareAgent

PrepareFlow

PutFoundationModelEntitlement

PutInvocationStep

PutModelInvocationLoggingConfiguration

PutResourcePolicy

PutUseCaseForModelAccess

RegisterMarketplaceModelEndpoint

Rerank

RetrieveAndGenerate

StartAutomatedReasoningPolicyBuildWorkflow

StartAutomatedReasoningPolicyTestWorkflow

StartFlowExecution

StartIngestionJob

StopEvaluationJob

StopFlowExecution

StopIngestionJob

StopModelCustomizationJob

StopModelInvocationJob

UpdateAgent

UpdateAgentActionGroup

UpdateAgentAlias

UpdateAgentCollaborator

UpdateAgentKnowledgeBase

UpdateAutomatedReasoningPolicy

UpdateAutomatedReasoningPolicyAnnotations

UpdateAutomatedReasoningPolicyTestCase

UpdateBlueprint

UpdateDataAutomationProject

UpdateDataSource

UpdateFlow

UpdateFlowAlias

UpdateGuardrail

UpdateKnowledgeBase

UpdateMarketplaceModelEndpoint

UpdatePrompt

UpdateProvisionedModelThroughput

UpdateSession
```


### List Actions ###
```
All list actions

ListAgentActionGroups

ListAgentAliases

ListAgentCollaborators

ListAgentKnowledgeBases

ListAgents

ListAgentVersions

ListAsyncInvokes

ListAutomatedReasoningPolicies

ListAutomatedReasoningPolicyBuildWorkflows

ListAutomatedReasoningPolicyTestCases

ListAutomatedReasoningPolicyTestResults

ListBlueprints

ListCustomModelDeployments

ListCustomModels

ListDataAutomationProjects

ListDataSources

ListEvaluationJobs

ListFlowAliases

ListFlowExecutionEvents

ListFlowExecutions

ListFlows

ListFlowVersions

ListFoundationModelAgreementOffers

ListFoundationModels

ListGuardrails

ListImportedModels

ListInferenceProfiles

ListIngestionJobs

ListInvocations

ListInvocationSteps

ListKnowledgeBaseDocuments

ListKnowledgeBases

ListModelCopyJobs

ListModelCustomizationJobs

ListModelEvaluationJobs

ListModelImportJobs

ListModelInvocationJobs

ListPromptRouters

ListPrompts

ListProvisionedModelThroughputs

ListSessions

```

### Read actions ###
```
ApplyGuardrail

CallWithBearerToken

DetectGeneratedContent

ExportAutomatedReasoningPolicyVersion

GenerateQuery

GetAgent

GetAgentActionGroup

GetAgentAlias

GetAgentCollaborator

GetAgentKnowledgeBase

GetAgentMemory

GetAgentVersion

GetAsyncInvoke

GetAutomatedReasoningPolicy

GetAutomatedReasoningPolicyAnnotations

GetAutomatedReasoningPolicyBuildWorkflow

GetAutomatedReasoningPolicyBuildWorkflowResultAssets

GetAutomatedReasoningPolicyNextScenario

GetAutomatedReasoningPolicyTestCase

GetAutomatedReasoningPolicyTestResult

GetBlueprint

GetBlueprintRecommendation

GetCustomModel

GetCustomModelDeployment

GetDataAutomationProject

GetDataAutomationStatus

GetDataSource

GetEvaluationJob

GetExecutionFlowSnapshot

GetFlow

GetFlowAlias

GetFlowExecution

GetFlowVersion

GetFoundationModel

GetFoundationModelAvailability

GetGuardrail

GetImportedModel

GetInferenceProfile

GetIngestionJob

GetInvocationStep

GetKnowledgeBase

GetKnowledgeBaseDocuments

GetMarketplaceModelEndpoint

GetModelCopyJob

GetModelCustomizationJob

GetModelEvaluationJob

GetModelImportJob

GetModelInvocationJob

GetModelInvocationLoggingConfiguration

GetPrompt

GetPromptRouter

GetProvisionedModelThroughput

GetResourcePolicy

GetSession

GetUseCaseForModelAccess

InvokeAgent

InvokeAutomatedReasoningPolicy

InvokeFlow

InvokeInlineAgent

InvokeModel

InvokeModelWithResponseStream

ListMarketplaceModelEndpoints

ListTagsForResource

OptimizePrompt

RenderPrompt

Retrieve

ValidateFlowDefinition
```
<img width="1352" height="539" alt="image" src="https://github.com/user-attachments/assets/0344a165-1972-4f3c-8f2e-e063d35b8cc3" />


<img width="1387" height="663" alt="image" src="https://github.com/user-attachments/assets/85729b11-2987-4133-88d2-f875bc9336bf" />

