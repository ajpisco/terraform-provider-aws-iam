# Create each policy with the definition from input
data "aws_iam_policy" "custom_policy" {
  for_each = toset(var.policies)

  name = each.value
}

# Create the role with the created/AWS policies
resource "aws_iam_role" "custom_role" {
  name               = var.name
  description        = var.description
  assume_role_policy = var.assumed_policy_json
  managed_policy_arns = concat(
    var.managed_policy_arns,
    [for policy in data.aws_iam_policy.custom_policy : policy.arn]
  )
}

# Attach each created policy to the new role
resource "aws_iam_policy_attachment" "custom_policy_attach" {
  for_each = toset(var.policies)

  name       = data.aws_iam_policy.custom_policy["${each.key}"].name
  roles      = [aws_iam_role.custom_role.name]
  policy_arn = data.aws_iam_policy.custom_policy["${each.key}"].arn
}
