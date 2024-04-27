terraform {
  backend "s3" {
    bucket = "ec2-server-tf1"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}