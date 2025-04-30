terraform {
  backend "s3" {
    bucket         = "putty-scene-terraform-state"
    key            = "terraform.tfstate"  # This will be overridden by workspace
    region         = "ap-south-1"
    dynamodb_table = "putty-scene-terraform-locks"
    encrypt        = true
  }
} 