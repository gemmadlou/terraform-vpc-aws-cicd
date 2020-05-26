# AWS CICD

Terraform module to create AWS CodePipeline with Codebuild for CICD inside a VPC.

---

This module supports one use case:

1. _CodeCommit -> CodePipeline/CodeBuild._ This module gets the code from CodeCommit repository and builds it via the buildspec.yml.

---

## Using this module

```terraform
terraform {
  provider = "aws.eu_west"

  backend "s3" {
    bucket = "example-infrastructure"
    key    = "<UNIQUE_KEY>"
    region = "eu-west-1"
  }
}

provider "template" {
  version = "~> 1.0"
}

provider "aws" {
  region = "eu-west-1"
}

module "aws-cicd" {
  source                = "../modules/aws-cicd"
  name                  = "${var.name}"
  repo_name             = "${var.name}"
  environment_variables = "${var.environment_variables}"
}

```
