resource "aws_lambda_function" "lambda_https_test" {
    architectures                  = [
        "${var.lambda_arch}",
    ]
    function_name                  = "${var.stack}-lambda-https-test"
    image_uri                      = var.image_uri 
    layers                         = []
    memory_size                    = var.lambda_memory
    package_type                   = "Image"
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.lambda_https_test.arn
    tags                           = {}
    tags_all                       = {}
    timeout                        = var.lambda_timeout


    ephemeral_storage {
        size = var.lambda_storage
    }

    timeouts {}

    tracing_config {
        mode = "PassThrough"
    }
}

resource "aws_lambda_function_url" "lambda_https_test" {
    authorization_type = "NONE"
    function_name      = aws_lambda_function.lambda_https_test.function_name
    timeouts {}
}

resource "aws_iam_role" "lambda_https_test" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [
        "arn:aws:iam::${var.aws_account}:policy/service-role/AWSLambdaBasicExecutionRole-08decf42-fd61-4067-97bc-2ae192f54727",
    ]
    max_session_duration  = 3600
    name                  = "${var.stack}-lambda-https-test-role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}

    inline_policy {}
}

output "lambda_https_test_url" {
  value = aws_lambda_function_url.lambda_https_test.function_url
}