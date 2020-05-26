## CodePipeline

resource "aws_iam_role" "codepipeline" {
  name = "${local.project_name}-codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# https://docs.aws.amazon.com/codecommit/latest/userguide/auth-and-access-control-permissions-reference.html#aa-acp
# codecommit:UploadArchive
# Required to allow the service role for CodePipeline to upload repository changes into a pipeline. This is an IAM policy permission only, not an API action that you can call.
#
# codecommit:GetUploadArchiveStatus
# Required to determine the status of an archive upload: whether it is in progress, complete, cancelled, or if an error occurred. This is an IAM policy permission only, not an API action that you can call.
#
# codecommit:CancelUploadArchive
# Required to cancel the uploading of an archive to a pipeline. This is an IAM policy permission only, not an API action that can be called.
resource "aws_iam_role_policy" "codepipeline" {
  name = "${aws_iam_role.codebuild.name}"
  role = "${aws_iam_role.codepipeline.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:Get*",
        "s3:PutObject"
      ],
      "Resource": [
        "${var.s3_bucket_arn}",
        "${var.s3_bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:CancelUploadArchive",
        "codecommit:UploadArchive",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

## CodeBuild

resource "aws_iam_role" "codebuild" {
  name = "${local.project_name}-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# https://docs.aws.amazon.com/codebuild/latest/userguide/vpc-support.html
# https://docs.aws.amazon.com/codebuild/latest/userguide/auth-and-access-control-iam-identity-based-access-control.html#customer-managed-policies-example-create-vpc-network-interface\
# https://stevenensslen.com/how-to-fix-provisioning-fault-codebuild-is-experiencing-issues/
resource "aws_iam_role_policy" "codebuild" {
  role = "${aws_iam_role.codebuild.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:Describe*",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:Head*"
      ],
      "Resource": [
        "arn:aws:s3:::example-app-secrets/*",
        "arn:aws:s3:::example-app-secrets"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.s3_bucket_arn}",
        "${var.s3_bucket_arn}/*"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:CreateNetworkInterfacePermission"
        ],
        "Resource": "arn:aws:ec2:*:*:network-interface/*",
        "Condition": {
            "StringEquals": {
                "ec2:Subnet": [
                    "arn:aws:ec2:*:*:subnet/${element(var.subnet_ids, 0)}",
                    "arn:aws:ec2:*:*:subnet/${element(var.subnet_ids, 1)}"
                ],
                "ec2:AuthorizedService": "codebuild.amazonaws.com"
            }
        }
    }
  ]
}
POLICY
}
