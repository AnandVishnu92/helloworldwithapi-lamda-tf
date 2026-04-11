terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/lambda_function.zip"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "hello-world-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "hello_world" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "hello-world-function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  depends_on       = [data.archive_file.lambda_zip, aws_iam_role_policy_attachment.lambda_basic_execution]
}

# API Gateway REST API
resource "aws_apigatewayv2_api" "hello_world_api" {
  name          = "hello-world-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["*"]
  }
}

# API Gateway Integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.hello_world_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.hello_world.invoke_arn
  payload_format_version = "2.0"
}

# API Gateway Route
resource "aws_apigatewayv2_route" "hello_world_get" {
  api_id    = aws_apigatewayv2_api.hello_world_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "hello_world_stage" {
  api_id      = aws_apigatewayv2_api.hello_world_api.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  depends_on = [aws_cloudwatch_log_group.api_logs]
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/hello-world-api"
  retention_in_days = 7
}

# Lambda permission for API Gateway invocation
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.hello_world_api.execution_arn}/*/*"
}
