variable "name" {
  type        = string
  description = "Name to be used by the IAM Group"
}

variable "path" {
  type        = string
  description = "Path to be used by the IAM Group"
}

variable "policies" {
  type        = list(any)
  description = "Policies definition"
  default     = []
}

variable "managed_policy_arns" {
  type        = list(string)
  description = "List of managed ARNs to attach to the role"
  default     = []
}