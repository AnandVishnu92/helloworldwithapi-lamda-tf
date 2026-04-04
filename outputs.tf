output "api_endpoint" {
  description = "The API Gateway endpoint URL"
  value       = "${aws_apigatewayv2_api.hello_world_api.api_endpoint}/"
}

output "lambda_function_name" {
  description = "The Lambda function name"
  value       = aws_lambda_function.hello_world.function_name
}

output "api_id" {
  description = "The API Gateway ID"
  value       = aws_apigatewayv2_api.hello_world_api.id
}
