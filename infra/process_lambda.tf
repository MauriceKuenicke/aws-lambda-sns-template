locals {
  lambda_directory_name = "process_lambda"
  lambda_name = "ProcessLambda"
  entrypoint_handler = "my_lambda.lambda_handler"
  runtime = "python3.11"
}

# ============================================
# PACKAGE LAMBDA CODE AND DEPLOY TO BUCKET
# ============================================
resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ../src/${local.lambda_directory_name}/requirements.txt -t ../src/${local.lambda_directory_name}/"
  }

  triggers = {
    dependencies_versions = filemd5("../src/${local.lambda_directory_name}/requirements.txt")
  }
}

data "archive_file" "zip_lambda" {
  depends_on = [null_resource.install_dependencies]
  excludes   = [
    "__pycache__",
    "venv"
  ]
  type        = "zip"
  source_dir = "../src/${local.lambda_directory_name}"
  output_path = "./lambda_packages/${local.lambda_name}.zip"
}

## ============================================
## CREATE ACTUAL LAMBDA FUNCTION
## ============================================
resource "aws_lambda_function" "hello_world" {
  function_name = local.lambda_name
  filename = data.archive_file.zip_lambda.output_path
  runtime = local.runtime
  handler = local.entrypoint_handler
  source_code_hash = data.archive_file.zip_lambda.output_base64sha256
  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.lambda_name}-ExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ============================================
# OUTPUT
# ============================================
output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello_world.function_name
}