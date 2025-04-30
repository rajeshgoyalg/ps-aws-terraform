terraform {
  backend "s3" {
    bucket         = "ps-terraform-state"
    key            = "services/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
} 