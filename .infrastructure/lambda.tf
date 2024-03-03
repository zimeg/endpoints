resource "aws_lambda_layer_version" "llrt" {
  layer_name   = "LLRT"
  description  = "Low Latency Runtime for JavaScript"
  license_info = "Apache 2.0 License"

  filename                 = "${path.module}/../.dist/llrt-lambda-arm.zip"
  compatible_architectures = ["arm64"]
  compatible_runtimes      = ["provided.al2023"]
}

locals {
  calendar_v1_files = fileset("${path.module}/../calendar/v1", "**/*")
}

resource "null_resource" "calendar_v1_trigger" {
  triggers = {
    hash = join("", [for file in local.calendar_v1_files : filesha256("${path.module}/../calendar/v1/${file}")])
  }
}

data "archive_file" "calendar_v1" {
  type        = "zip"
  source_dir  = "${path.module}/../calendar/v1"
  excludes    = fileset("${path.module}/../calendar/v1", "**/*.test.js")
  output_path = "${path.module}/../.dist/calendar-v1.zip"

  depends_on = [null_resource.calendar_v1_trigger]
}

resource "aws_lambda_function" "calendar_v1" {
  function_name = "endpoints-calendar-v1"
  description   = "measurements for dates of the present"
  role          = aws_iam_role.endpoint_executor.arn

  filename      = data.archive_file.calendar_v1.output_path
  handler       = "index.handler"
  runtime       = "provided.al2023"
  architectures = ["arm64"]
  layers        = [aws_lambda_layer_version.llrt.arn]

  source_code_hash = data.archive_file.calendar_v1.output_base64sha256
  depends_on       = [data.archive_file.calendar_v1]
}

resource "aws_lambda_permission" "calendar_v1" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.calendar_v1.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.endpoints.execution_arn}/*/*"
}
