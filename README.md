# Hello World API with Lambda and Terraform

A simple Infrastructure as Code (IaC) project that deploys a "Hello World" REST API using AWS Lambda, API Gateway, and Terraform.

## 📋 Prerequisites

Before deploying this project, ensure you have:

1. **AWS Account** - with appropriate credentials configured
2. **Terraform** - [Install Terraform](https://www.terraform.io/downloads.html) (v1.0+)
3. **AWS CLI** - [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
4. **Python** - for packaging the Lambda function (3.12+)

### Configure AWS Credentials

```bash
aws configure
```

Or set environment variables:
```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=us-east-1
```

### AWS Permissions Required

Your AWS user/role needs the following permissions to deploy this infrastructure:

**Required Permissions:**
- `iam:CreateRole`, `iam:DeleteRole`, `iam:GetRole`, `iam:PassRole` - For Lambda IAM role
- `lambda:*` - For Lambda function management
- `apigateway:*` - For API Gateway management
- `logs:*` - For CloudWatch Logs management

**Quick Setup Options:**

1. **Administrator Access** (Easiest):
   - Attach `AdministratorAccess` policy to your IAM user

2. **Power User Access** (Recommended for development):
   - Attach `PowerUserAccess` managed policy

3. **Custom Policy** (Most secure):
   - Use the provided `iam-policy.json` file
   - Create a custom IAM policy with the required permissions

**Troubleshooting Permission Errors:**
If you see `AccessDenied` errors during deployment, run:
```bash
chmod +x setup-aws.sh
./setup-aws.sh
```

This script will guide you through credential configuration options.

## 🚀 Quick Start

### Option 1: Using the Deploy Script
```bash
chmod +x deploy.sh
./deploy.sh
```

### Option 2: Using Make
```bash
make init
make plan
make apply
```

### Option 3: Manual Terraform Commands
```bash
# Package the Lambda function
zip -j lambda_function.zip index.py

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -out=tfplan

# Apply the configuration
terraform apply tfplan
```

## 📁 Project Structure

```
.
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── outputs.tf          # Output values (API endpoint, etc.)
├── terraform.tfvars    # Variable values
├── index.py            # Lambda function code
├── deploy.sh           # Automated deployment script
├── Makefile            # Make targets for common tasks
├── .gitignore         # Git ignore rules
└── README.md          # This file
```

## 🏗️ What Gets Created

This Terraform configuration creates:

1. **Lambda Function** - A simple Python function that returns a JSON response
2. **API Gateway HTTP API** - RESTful endpoint to trigger the Lambda function
3. **IAM Role** - Role for Lambda execution with basic CloudWatch Logs permissions
4. **CloudWatch Log Group** - For API Gateway access logs
5. **Lambda Permission** - Allows API Gateway to invoke the Lambda function

## 🧪 Testing the API

After deployment, test your API:

```bash
# Using curl
API_ENDPOINT=$(terraform output -raw api_endpoint)
curl "$API_ENDPOINT"

# Using Make
make test

# Expected response:
# {
#   "message": "Hello, World!",
#   "description": "This is a simple API powered by AWS Lambda and API Gateway",
#   "request_id": "..."
# }
```

## 📤 Outputs

After successful deployment, Terraform will output:

- `api_endpoint` - The full URL of your API Gateway endpoint
- `lambda_function_name` - The name of the Lambda function
- `api_id` - The API Gateway ID

View outputs anytime with:
```bash
terraform output
```

## 🧹 Cleanup

To destroy all AWS resources and avoid charges:

```bash
# Using Terraform
terraform destroy

# Using Make
make destroy
```

## 🔧 Terraform Commands Reference

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize the Terraform working directory |
| `terraform plan` | Show what changes will be made |
| `terraform apply` | Apply the Terraform configuration |
| `terraform destroy` | Destroy all resources |
| `terraform fmt` | Format Terraform files |
| `terraform validate` | Validate syntax and configuration |
| `terraform output` | Show output values |

## 📝 Make Commands Reference

| Command | Description |
|---------|-------------|
| `make init` | Initialize Terraform |
| `make plan` | Plan deployment |
| `make apply` | Apply configuration |
| `make destroy` | Destroy infrastructure |
| `make test` | Test the deployed API |
| `make fmt` | Format Terraform files |
| `make validate` | Validate configuration |
| `make clean` | Clean up generated files |

## 🔐 Security Considerations

- The Lambda function logs are stored in CloudWatch with 7-day retention
- API Gateway CORS is enabled for all origins (modify for production)
- IAM role uses minimal required permissions
- Sensitive data should not be logged or hardcoded

## 📚 Additional Resources

- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [AWS API Gateway Documentation](https://docs.aws.amazon.com/apigateway/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Terraform HTTP API Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api)

## 💡 Customization

### Change AWS Region
Edit `terraform.tfvars`:
```hcl
aws_region = "eu-west-1"  # Change to your desired region
```

### Modify the Lambda Response
Edit `index.py` and update the response body:
```python
'body': json.dumps({
    'message': 'Your custom message here!'
})
```

### Add More API Routes
Add additional `aws_apigatewayv2_route` resources in `main.tf`:
```hcl
resource "aws_apigatewayv2_route" "hello_world_post" {
  api_id    = aws_apigatewayv2_api.hello_world_api.id
  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
```

## 📞 Support

For issues or questions, refer to the AWS and Terraform documentation or check your Terraform state and logs.

---

**Made with ❤️ using Terraform**