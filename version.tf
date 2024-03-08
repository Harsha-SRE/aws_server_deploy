terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
#   backend "s3" {
#     bucket = "statefilestorage"
#     key    = "statefile/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#     shared_credentials_file = "~/.aws/credentials"
#   }
}