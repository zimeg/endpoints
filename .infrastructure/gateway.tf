resource "aws_api_gateway_rest_api" "endpoints" {
  name        = "endpoints"
  description = "a collection of public methods"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  parent_id   = aws_api_gateway_rest_api.endpoints.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "calendar" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "calendar"
}

resource "aws_api_gateway_resource" "calendar_proxy" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  parent_id   = aws_api_gateway_resource.calendar.id
  path_part   = "{path+}"
}

resource "aws_api_gateway_method" "calendar_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.endpoints.id
  resource_id   = aws_api_gateway_resource.calendar_proxy.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "calendar" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  resource_id = aws_api_gateway_resource.calendar_proxy.id
  http_method = aws_api_gateway_method.calendar_proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.calendar_v1.invoke_arn
}

# 404 Not Found

resource "aws_api_gateway_resource" "fallback" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  parent_id   = aws_api_gateway_rest_api.endpoints.root_resource_id
  path_part   = "{fallback+}"
}

resource "aws_api_gateway_integration" "fallback" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  resource_id = aws_api_gateway_resource.fallback.id
  http_method = "ANY"
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 404}"
  }
  depends_on = [aws_api_gateway_resource.fallback]
}

resource "aws_api_gateway_method" "fallback" {
  rest_api_id   = aws_api_gateway_rest_api.endpoints.id
  resource_id   = aws_api_gateway_resource.fallback.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "not_found" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  resource_id = aws_api_gateway_resource.fallback.id
  http_method = aws_api_gateway_integration.fallback.http_method
  status_code = "404"
}

resource "aws_api_gateway_integration_response" "not_found" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id
  resource_id = aws_api_gateway_resource.fallback.id
  http_method = aws_api_gateway_integration.fallback.http_method
  status_code = aws_api_gateway_method_response.not_found.status_code

  response_templates = {
    "application/json" = jsonencode({
      ok = false,
      error = {
        code    = "method_not_found",
        message = "The provided path has no $context.httpMethod method: $context.path",
      }
    })
  }
  depends_on = [aws_api_gateway_integration.fallback]
}

# Deployment

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_resource.calendar_proxy,
    aws_api_gateway_integration_response.not_found,
  ]
  triggers = {
    redeploy_calendar = sha1(jsonencode(aws_api_gateway_integration.calendar))
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.endpoints.id
  stage_name    = "prod"
}
