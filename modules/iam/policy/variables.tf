variable "name" {
  description = "Policy name"
}

variable "policy" {
  type        = map(any)
  description = "Policy definition"
  default     = {}
}