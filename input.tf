variable "namespace" {
  default     = "example"
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  default     = "prod"
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "repo_name" {
  description = "GitHub repository name of the application to be built (and deployed to Elastic Beanstalk if configured)"
}

variable "branch" {
  default     = "master"
  description = "Branch of the GitHub repository, _e.g._ `master`"
}

variable "build_image" {
  default     = "aws/codebuild/standard:2.0"
  description = "Docker image for build environment, _e.g._ `aws/codebuild/standard:2.0` or `aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0`"
}

variable "build_compute_type" {
  default     = "BUILD_GENERAL1_SMALL"
  description = "`CodeBuild` instance size.  Possible values are: ```BUILD_GENERAL1_SMALL``` ```BUILD_GENERAL1_MEDIUM``` ```BUILD_GENERAL1_LARGE```"
}

variable "buildspec" {
  default     = "buildspec.yml"
  description = " Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)"
}

variable "delimiter" {
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "tags" {
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit', 'XYZ')`"
}

variable "privileged_mode" {
  default     = false
  description = "If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}

variable "environment_variables" {
  default = [
    {
      name  = "NO_ADDITIONAL_BUILD_VARS"
      value = "TRUE"
    },
  ]

  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build"
}

variable "s3_bucket" {
  default     = "example-codepipeline-cache"
  description = "s3 bucket for caching"
}

variable "s3_bucket_arn" {
  default     = "arn:aws:s3:::example-codepipeline-cache"
  description = "s3 bucket arn for caching"
}

variable "vpc_id" {
  default     = "vpc-xxxxxxxxx"
  description = "VPC id for where the codebuild should live"
}

variable "subnet_ids" {
  default = [
    "subnet-xxxxxxxxx",
    "subnet-xxxxxxxxx",
  ]

  description = "Lambda function subnet ids. These should belong to the same VPC where the RDS is."
}

variable "security_group_ids" {
  default = [
    "sg-xxxxxxxxx",
  ]

  description = "Lambda security groups that connect to the VPC where the RDS is"
}
