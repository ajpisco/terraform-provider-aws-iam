# Create each policy with the definition from input
resource "aws_iam_policy" "custom_policy" {
  name        = var.name
  description = can(var.policy.description) ? "${var.policy.description}" : null
  path        = can(var.policy.path) ? "${var.policy.path}" : null
  policy      = var.policy.policy
}