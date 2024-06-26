terraform {
  backend "s3" {
    bucket = "tf-state-case"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}