terraform {
  backend "s3" {
    bucket         = "putting-scene-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "putting-scene-terraform-locks"
    encrypt        = true
  }
}
