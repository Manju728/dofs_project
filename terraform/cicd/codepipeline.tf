resource "aws_codepipeline" "dofs_pipeline" {
  name     = "dofs-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type     = "S3"
  }
  stage {
  name = "Source"
  action {
    name             = "Source"
    category         = "Source"
    owner            = "ThirdParty"
    provider         = "GitHub"
    version          = "1"
    output_artifacts = ["source_output"]
    configuration = {
      Owner      = "Manju728"
      Repo       = "dofs_project"
      Branch     = "main"
      OAuthToken = "{{resolve:secretsmanager:github_oauth_token:SecretString}}"
    }
  }
}

stage {
  name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.terraform_build.name
      }
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_role_codepipeline" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_s3_bucket" "pipeline_bucket" {
    bucket = "dofs-pipeline-bucket"
}
