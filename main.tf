locals {
  project_name = "${var.name}-${var.stage}"
}

resource "aws_codebuild_project" "cicd" {
  name          = "${local.project_name}"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.s3_bucket}"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    # https://github.com/terraform-providers/terraform-provider-aws/issues/5563
    environment_variable = "${var.environment_variables}"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${local.project_name}-build"
      stream_name = "${local.project_name}-build"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "${var.buildspec}"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id = "${var.vpc_id}"

    subnets = "${var.subnet_ids}"

    security_group_ids = "${var.security_group_ids}"
  }

  tags = "${var.tags}"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${local.project_name}"
  role_arn = "${aws_iam_role.codepipeline.arn}"

  artifact_store {
    location = "${var.s3_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        PollForSourceChanges = "false"
        RepositoryName       = "${var.repo_name}"
        BranchName           = "${var.branch}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.cicd.name}"
      }
    }
  }
}
