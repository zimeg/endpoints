resource "aws_iam_role" "endpoint_executor" {
  name = "endpoint_executor"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com",
        ]
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_basic" {
  role       = aws_iam_role.endpoint_executor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
