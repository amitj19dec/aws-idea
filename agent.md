# Building a Travel Booking Agent with Action Groups

Let me walk you through designing and building a **Corporate Travel Assistant Agent** - a moderately complex example that demonstrates multiple action groups working together.

## Business Scenario

**Goal**: Create an AI agent that helps employees book corporate travel, checking company policies, finding flights/hotels, and managing bookings.

**Key Requirements**:
- Check corporate travel policies
- Search and book flights
- Find and reserve hotels
- Calculate travel budgets
- Generate expense reports
- Send notifications to managers

## Design Approach

### Step 1: Identify Required Actions
Break down the travel booking process into discrete, actionable components:

1. **Policy Validation** - Check if travel meets company guidelines
2. **Flight Management** - Search, book, modify flights
3. **Hotel Management** - Search, book, modify hotels
4. **Budget Calculation** - Calculate costs and check budgets
5. **Approval Workflow** - Send requests to managers
6. **Expense Reporting** - Generate travel expense documents

### Step 2: Map Actions to Action Groups

```
Travel Agent
├── PolicyActionGroup (validates travel requests)
├── FlightActionGroup (manages flight bookings)
├── HotelActionGroup (manages hotel bookings)
├── BudgetActionGroup (handles financial calculations)
├── ApprovalActionGroup (manages approval workflow)
└── ExpenseActionGroup (generates reports)
```

## Action Group Implementation

### Action Group 1: Policy Validation

**Purpose**: Validate travel requests against corporate policies

**OpenAPI Schema**:
```yaml
openapi: 3.0.0
info:
  title: Corporate Travel Policy API
  version: 1.0.0
  description: Validates travel requests against corporate policies

paths:
  /validateTravel:
    post:
      summary: Validate travel request against corporate policy
      description: Checks if travel meets company guidelines
      operationId: validateTravelRequest
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                employeeId:
                  type: string
                  description: Employee ID requesting travel
                destination:
                  type: string
                  description: Travel destination
                departureDate:
                  type: string
                  format: date
                  description: Departure date
                returnDate:
                  type: string
                  format: date
                  description: Return date
                purpose:
                  type: string
                  description: Business purpose of travel
                estimatedCost:
                  type: number
                  description: Estimated total cost
              required:
                - employeeId
                - destination
                - departureDate
                - returnDate
                - purpose
      responses:
        '200':
          description: Policy validation result
          content:
            application/json:
              schema:
                type: object
                properties:
                  approved:
                    type: boolean
                  maxBudget:
                    type: number
                  restrictions:
                    type: array
                    items:
                      type: string
                  requiresApproval:
                    type: boolean
```

**Lambda Function**:
```python
import json
import boto3
from datetime import datetime

def lambda_handler(event, context):
    # Extract parameters from Bedrock Agent event
    parameters = event['parameters']
    
    employee_id = parameters['employeeId']
    destination = parameters['destination']
    estimated_cost = float(parameters['estimatedCost'])
    purpose = parameters['purpose']
    
    # Business logic for policy validation
    policy_result = validate_corporate_policy(
        employee_id, destination, estimated_cost, purpose
    )
    
    return {
        'response': {
            'actionGroup': event['actionGroup'],
            'function': event['function'],
            'responseBody': {
                'TEXT': {
                    'body': json.dumps(policy_result)
                }
            }
        }
    }

def validate_corporate_policy(employee_id, destination, cost, purpose):
    # Connect to corporate policy database
    # This is simplified - real implementation would check:
    # - Employee travel grade/level
    # - Destination approval status
    # - Budget limits
    # - Advance booking requirements
    
    employee_data = get_employee_data(employee_id)
    
    # Example policy checks
    max_budget = get_max_budget_for_employee(employee_data['level'])
    requires_approval = cost > 5000 or is_international(destination)
    
    restrictions = []
    if cost > max_budget:
        restrictions.append(f"Cost exceeds budget limit of ${max_budget}")
    
    if not is_business_purpose_valid(purpose):
        restrictions.append("Business purpose requires clarification")
    
    return {
        'approved': len(restrictions) == 0,
        'maxBudget': max_budget,
        'restrictions': restrictions,
        'requiresApproval': requires_approval
    }
```

### Action Group 2: Flight Management

**OpenAPI Schema** (excerpt):
```yaml
paths:
  /searchFlights:
    post:
      summary: Search available flights
      operationId: searchFlights
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                origin:
                  type: string
                  description: Departure airport code
                destination:
                  type: string
                  description: Arrival airport code
                departureDate:
                  type: string
                  format: date
                returnDate:
                  type: string
                  format: date
                  description: Return date for round trip
                passengers:
                  type: integer
                  default: 1
                preferredAirline:
                  type: string
                  description: Preferred airline if any
                maxPrice:
                  type: number
                  description: Maximum acceptable price

  /bookFlight:
    post:
      summary: Book a specific flight
      operationId: bookFlight
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                flightId:
                  type: string
                  description: ID of the flight to book
                passengerInfo:
                  type: object
                  properties:
                    firstName:
                      type: string
                    lastName:
                      type: string
                    email:
                      type: string
                paymentMethod:
                  type: string
                  description: Corporate card or billing code
```

**Lambda Function**:
```python
def lambda_handler(event, context):
    function_name = event['function']
    parameters = event['parameters']
    
    if function_name == 'searchFlights':
        return handle_flight_search(event, parameters)
    elif function_name == 'bookFlight':
        return handle_flight_booking(event, parameters)
    
def handle_flight_search(event, parameters):
    # Integration with airline APIs (Amadeus, Sabre, etc.)
    flight_results = search_flights_external_api(
        origin=parameters['origin'],
        destination=parameters['destination'],
        departure_date=parameters['departureDate'],
        return_date=parameters.get('returnDate'),
        max_price=parameters.get('maxPrice')
    )
    
    # Filter based on corporate travel policies
    approved_flights = filter_corporate_approved_flights(flight_results)
    
    response_text = format_flight_search_results(approved_flights)
    
    return {
        'response': {
            'actionGroup': event['actionGroup'],
            'function': event['function'],
            'responseBody': {
                'TEXT': {
                    'body': response_text
                }
            }
        }
    }

def handle_flight_booking(event, parameters):
    # Book the flight through external API
    booking_result = book_flight_external_api(
        flight_id=parameters['flightId'],
        passenger_info=parameters['passengerInfo'],
        payment_method=parameters['paymentMethod']
    )
    
    # Store booking in corporate travel database
    store_booking_record(booking_result)
    
    # Send confirmation
    response_text = f"Flight booked successfully. Confirmation: {booking_result['confirmationCode']}"
    
    return {
        'response': {
            'actionGroup': event['actionGroup'],
            'function': event['function'],
            'responseBody': {
                'TEXT': {
                    'body': response_text
                }
            }
        }
    }
```

### Action Group 3: Budget Calculation

**Lambda Function**:
```python
def lambda_handler(event, context):
    parameters = event['parameters']
    
    # Calculate comprehensive travel budget
    flight_cost = float(parameters.get('flightCost', 0))
    hotel_cost = float(parameters.get('hotelCost', 0))
    days = int(parameters.get('days', 1))
    destination = parameters['destination']
    employee_id = parameters['employeeId']
    
    # Get per-diem rates for destination
    per_diem = get_per_diem_rate(destination)
    
    # Calculate total budget
    total_budget = calculate_total_budget(
        flight_cost, hotel_cost, days, per_diem, employee_id
    )
    
    budget_breakdown = {
        'flightCost': flight_cost,
        'hotelCost': hotel_cost,
        'mealAllowance': per_diem['meals'] * days,
        'incidentalAllowance': per_diem['incidentals'] * days,
        'totalEstimated': total_budget['total'],
        'withinBudget': total_budget['approved'],
        'budgetLimit': total_budget['limit']
    }
    
    return {
        'response': {
            'actionGroup': event['actionGroup'],
            'function': event['function'],
            'responseBody': {
                'TEXT': {
                    'body': json.dumps(budget_breakdown, indent=2)
                }
            }
        }
    }
```

## Agent Configuration Process

### Step 1: Create the Agent

```bash
# Using AWS CLI to create agent
aws bedrock-agent create-agent \
    --agent-name "CorporateTravelAssistant" \
    --foundation-model "anthropic.claude-3-sonnet-20240229-v1:0" \
    --instruction "You are a corporate travel assistant that helps employees book business travel while ensuring compliance with company policies. You can validate travel requests, search and book flights and hotels, calculate budgets, and manage approval workflows."
```

### Step 2: Create Service Role and Permissions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": [
        "arn:aws:lambda:*:*:function:travel-policy-*",
        "arn:aws:lambda:*:*:function:travel-flight-*",
        "arn:aws:lambda:*:*:function:travel-hotel-*",
        "arn:aws:lambda:*:*:function:travel-budget-*",
        "arn:aws:lambda:*:*:function:travel-approval-*",
        "arn:aws:lambda:*:*:function:travel-expense-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::travel-agent-schemas/*"
    }
  ]
}
```

### Step 3: Add Action Groups to Agent

```python
import boto3

bedrock_agent = boto3.client('bedrock-agent')

# Add Policy Action Group
bedrock_agent.create_agent_action_group(
    agentId='AGENT123',
    agentVersion='DRAFT',
    actionGroupName='PolicyActionGroup',
    description='Validates travel requests against corporate policies',
    actionGroupExecutor={
        'lambda': 'arn:aws:lambda:us-east-1:123456789012:function:travel-policy-validator'
    },
    apiSchema={
        's3': {
            's3BucketName': 'travel-agent-schemas',
            's3ObjectKey': 'policy-action-group-schema.yaml'
        }
    }
)

# Add Flight Action Group
bedrock_agent.create_agent_action_group(
    agentId='AGENT123',
    agentVersion='DRAFT',
    actionGroupName='FlightActionGroup',
    description='Manages flight search and booking operations',
    actionGroupExecutor={
        'lambda': 'arn:aws:lambda:us-east-1:123456789012:function:travel-flight-manager'
    },
    apiSchema={
        's3': {
            's3BucketName': 'travel-agent-schemas',
            's3ObjectKey': 'flight-action-group-schema.yaml'
        }
    }
)

# Continue for other action groups...
```

## Example Agent Interactions

### Conversation Flow 1: Simple Booking

**User**: "I need to book a trip from New York to San Francisco next Tuesday to Thursday for a client meeting."

**Agent Process**:
1. **Policy Validation**: Calls PolicyActionGroup to check if travel is approved
2. **Flight Search**: Calls FlightActionGroup to find available flights
3. **Budget Calculation**: Calls BudgetActionGroup to estimate costs
4. **Booking**: If approved, books the flight

**Agent Response**: "I've found several flights for your NYC to SFO trip. Based on your employee level, you're approved for up to $2,500. Here are the best options within policy..."

### Conversation Flow 2: Complex Multi-Step Booking

**User**: "I need to plan a 5-day business trip to London for a conference, including hotel and all expenses."

**Agent Process**:
1. **Policy Check**: Validates international travel requirements
2. **Flight Search**: Finds transatlantic flights
3. **Hotel Search**: Finds business-class hotels near conference
4. **Budget Calculation**: Calculates total trip cost including per-diem
5. **Approval Check**: Determines if manager approval needed
6. **Booking or Approval**: Either books directly or initiates approval workflow

**Agent Response**: "For your London conference trip, I've found flights and hotels totaling $4,200. Since this exceeds your $3,000 limit, I'll need to send this for manager approval. Shall I proceed with the approval request?"

## Advanced Features

### Integration Patterns

**1. External API Integration**:
```python
# In Lambda functions, integrate with:
# - Airline booking systems (Amadeus, Sabre)
# - Hotel booking platforms (Booking.com API, Expedia)
# - Corporate systems (HR database, expense systems)
# - Financial systems (corporate card APIs)
```

**2. Knowledge Base Integration**:
- Upload corporate travel policies to Bedrock Knowledge Base
- Agent automatically references policies during conversations
- Provides policy explanations and updates

**3. Multi-Agent Collaboration**:
- Escalate complex requests to specialized agents
- Handoff between booking agent and expense processing agent

### Error Handling and Edge Cases

```python
def handle_booking_errors(booking_result):
    if booking_result['status'] == 'FAILED':
        if 'SOLD_OUT' in booking_result['error']:
            return "This flight is now sold out. Let me find alternative options."
        elif 'PAYMENT_FAILED' in booking_result['error']:
            return "Payment authorization failed. Please check with finance team."
        else:
            return "Booking failed. I'll connect you with a human agent."
    
    return format_success_response(booking_result)
```

### Monitoring and Analytics

```python
# CloudWatch metrics for tracking
def log_agent_metrics(action_group, function, success, duration):
    cloudwatch = boto3.client('cloudwatch')
    
    cloudwatch.put_metric_data(
        Namespace='TravelAgent',
        MetricData=[
            {
                'MetricName': 'ActionGroupInvocation',
                'Dimensions': [
                    {'Name': 'ActionGroup', 'Value': action_group},
                    {'Name': 'Function', 'Value': function}
                ],
                'Value': 1 if success else 0,
                'Unit': 'Count'
            }
        ]
    )
```

## Benefits of This Design

**Modularity**: Each action group handles a specific domain
**Scalability**: Easy to add new action groups (car rentals, travel insurance)
**Maintainability**: Individual Lambda functions can be updated independently
**Testability**: Each action group can be tested in isolation
**Reusability**: Action groups can be shared across different agents

This design demonstrates how action groups transform a simple chatbot into a capable business application that can actually execute complex, multi-step workflows while maintaining corporate compliance and policies.
