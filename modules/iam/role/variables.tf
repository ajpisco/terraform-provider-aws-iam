variable "name" {
  type        = string
  description = "Name to be used by the IAM Role"
}

variable "description" {
  type        = string
  description = "Description for the IAM Role"
  default     = ""
}

variable "assumed_policy_json" {
  type        = string
  description = "Policy with the assume policys"
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