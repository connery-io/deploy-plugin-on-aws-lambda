terraform {
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }
  }
}

# Lambda

module "aws_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.7"

  function_name                     = "${var.resource_name_prefix}${var.plugin_name}_${var.plugin_version}"
  handler                           = "dist/index.default"
  runtime                           = "nodejs20.x"
  publish                           = true
  memory_size                       = var.memory_size
  timeout                           = var.timeout
  cloudwatch_logs_retention_in_days = 7

  environment_variables = {
    HOSTING_MODE = "AWS_LAMBDA"
    API_KEY      = var.api_key
  }

  source_path = [
    {
      path             = "${path.module}/../dist",
      prefix_in_zip    = "dist",
      npm_requirements = false
    },
    {
      path             = "${path.module}/../node_modules",
      prefix_in_zip    = "node_modules",
      npm_requirements = false
    },
    {
      path             = "${path.module}/../package.json",
      prefix_in_zip    = "",
      npm_requirements = false
    }
  ]

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  tags = {
    connery_plugin_name    = var.plugin_name
    connery_plugin_version = var.plugin_version
  }
}

# API Gateway

module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 5.1"

  name               = "${var.resource_name_prefix}${var.plugin_name}_${var.plugin_version}"
  protocol_type      = "HTTP"
  create_domain_name = false

  routes = {
    "$default" = {
      integration = {
        uri = module.aws_lambda.lambda_function_arn
      }
    }
  }

  tags = {
    connery_plugin_name    = var.plugin_name
    connery_plugin_version = var.plugin_version
  }
}