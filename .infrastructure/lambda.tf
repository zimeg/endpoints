resource "aws_lambda_layer_version" "llrt" {
  layer_name   = "LLRT"
  description  = "Low Latency Runtime for JavaScript"
  license_info = "Apache 2.0 License"

  filename                 = "../.dist/llrt-lambda-arm.zip"
  compatible_architectures = ["arm64"]
  compatible_runtimes      = ["provided.al2023"]
}
