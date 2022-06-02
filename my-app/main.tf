terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  access_key = "xxxxx"
  secret_key = "xxxxx"
}

module "my_app_1" {
    source = "../my-app-module"

    # our variables
    app_name = "myapp1"
    env = "dev"
    iam_instance_profile = "AWSEC2ReadOnlyAccess"
    user_data = filebase64("${path.module}/launch_script_1.sh")
}