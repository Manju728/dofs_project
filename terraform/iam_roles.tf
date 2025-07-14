# resource "aws_iam_role" "lambda_exec" {
#   name = "lambda_exec"
#   assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
# }

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "LambdaAssumeRolePolicy"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_role_lambda" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_role_policy_attachment" "admin_role_sfn" {
  role       = aws_iam_role.step_function_exec.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_policy" "admin_policy" {
  name        = "AllowAllPolicy"
  description = "IAM policy with full access to all AWS services and resources"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role" "step_function_exec" {
  name = "step_function_exec_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# resource "aws_iam_role" "codebuild_role" {
#   name = "codebuild_role"
#   assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
# }

# resource "aws_iam_role" "codepipeline_role" {
#   name = "codepipeline_role"
#   assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
# }# Placeholder for iam_roles.tf in dofs-project/terraform/cicd
