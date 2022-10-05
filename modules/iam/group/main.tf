# Get each policy with the definition from input
data "aws_iam_policy" "custom_policy" {
  for_each = toset(var.policies)

  name = each.value
}

# Create the group with the created/AWS policies
resource "aws_iam_group" "custom_group" {
  name               = var.name
  path = var.path
}

# Attach each created policy to the new group
resource "aws_iam_group_policy_attachment" "custom_group_policy_attach" {
  for_each = toset(var.policies)

  group       = aws_iam_group.custom_group.id
  policy_arn = data.aws_iam_policy.custom_policy["${each.key}"].arn
}

# Attach each managed policy to the new group
resource "aws_iam_group_policy_attachment" "managed_group_policy_attach" {
  for_each = toset(var.managed_policy_arns)

  group       = aws_iam_group.custom_group.id
  policy_arn = each.value
}
