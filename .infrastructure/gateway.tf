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

# Deployment

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.endpoints.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_resource.calendar_proxy,
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
