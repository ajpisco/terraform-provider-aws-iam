# Create each policy with the definition from input
resource "aws_iam_policy" "custom_policy" {
  for_each = var.policies

  name        = each.key
  description = can(each.value.description) ? "${each.value.description}" : null
  path        = can(each.value.path) ? "${each.value.path}" : null
  policy      = each.value.policy
}

# Attach each created policy to the new role
resource "aws_iam_policy_attachment" "custom_policy_attach" {
  for_each = var.policies

  name       = each.key
  roles      = [aws_iam_role.custom_role.name]
  policy_arn = aws_iam_policy.custom_policy["${each.key}"].arn
}

# Create the role with the created/AWS policies
resource "aws_iam_role" "custom_role" {
  name               = var.name
  description        = var.description
  assume_role_policy = var.assumed_policy_json
  managed_policy_arns = concat(
    var.managed_policy_arns,
    [for policy in aws_iam_policy.custom_policy : policy.arn]
  )
}

