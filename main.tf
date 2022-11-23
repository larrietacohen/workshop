# MALA PRACTICA

# provider "aws" {
#     region = "us-east-1"
#     access_key = "XXXXXXX"
#     secret_key = "XXXXXXXXXXXX"
# }

# MEDIO SECURITY LEVEL
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Backend
terraform {
  backend "s3" {
    bucket = "workshop-terraform-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = "true"
#    dynamodb_table = "terraform-lock"
  }
}
