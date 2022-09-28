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

locals {
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
    "policy_name11" = {
      path        = "/path1/"
      description = "Policy number 1"
      policy      = data.aws_iam_policy_document.custom_policy1.json
    }
  }

  roles = {
    "sample1" : {
      assumed_policy_json = data.aws_iam_policy_document.assumed_policy.json

      # Optional
      policies = ["policy_name1", "policy_name2", "policy_name3"]

      # Optional
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
        "arn:aws:iam::aws:policy/AutoScalingFullAccess"
      ]
    },
    "sample2" : {
      assumed_policy_json = data.aws_iam_policy_document.assumed_policy.json

      # Optional
      policies = ["policy_name11", "policy_name2", "policy_name3"]

      # Optional
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
        "arn:aws:iam::aws:policy/AutoScalingFullAccess"
      ]
    },
    "sample3" : {
      assumed_policy_json = data.aws_iam_policy_document.assumed_policy.json
    }
  }

}

module "sample_iam_policies" {
  for_each = local.policies
  source   = "./modules/iam/policy"

  name   = each.key
  policy = each.value

}

module "sample_iam_roles" {
  for_each = local.roles
  source   = "./modules/iam/role"

  name = each.key

  assumed_policy_json = lookup(each.value, "assumed_policy_json", null)
  policies            = lookup(each.value, "policies", [])
  managed_policy_arns = lookup(each.value, "managed_policy_arns", [])

  depends_on = [
    module.sample_iam_policies
  ]
}

output "created_policies" {
  value = [for policy in module.sample_iam_policies : policy.name]
}

output "created_roles" {
  value = [for role in module.sample_iam_roles : role.name]
}