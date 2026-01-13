output "lambda_function_name" {
  description = "Nom de la fonction Lambda"
  value       = aws_lambda_function.ecf_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN de la fonction Lambda"
  value       = aws_lambda_function.ecf_lambda.arn
}

output "api_gateway_url" {
  description = "URL de l'API Gateway"
  value       = "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/hello"
}
