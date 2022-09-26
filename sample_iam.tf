data "aws_iam_policy_document" "assumed_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "custom_policy1" {
  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "custom_policy2" {
  statement {
    actions   = ["lambda:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "custom_policy3" {
  statement {
    actions   = ["iam:*"]
    resources = ["*"]
  }
}

module "sample_iam" {
  source = "./modules/iam"

  name                = "custom_role"
  assumed_policy_json = data.aws_iam_policy_document.assumed_policy.json

  # Optional
  policies = {
    "policy_name1" = {
      path        = "/path1/"
      description = "Policy number 1"
      policy      = data.aws_iam_policy_document.custom_policy1.json
    }
    "policy_name2" = {
      path   = "/path2/"
      policy = data.aws_iam_policy_document.custom_policy2.json
    }
    "policy_name3" = {
      policy = data.aws_iam_policy_document.custom_policy3.json
    }
  }

  # Optional
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  ]
}

output "sample_iam_arn" {
  value = module.sample_iam.role_arn
}