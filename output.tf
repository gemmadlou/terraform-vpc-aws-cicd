output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = "${local.project_name}"
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = "${aws_codepipeline.codepipeline.id}"
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = "${aws_codepipeline.codepipeline.arn}"
}

output "codebuild_role_name" {
  description = "Codebuild role name to extend IAM credentials"
  value = "${aws_iam_role.codebuild.name}"
}