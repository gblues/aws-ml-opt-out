variable "additional_enable_policy_types" {
  type        = list(string)
  description = "List of policy types to enable in addition to AISERVICES_OPT_OUT_POLICY, which is always enabled."
  default     = []
}

variable "aws_service_access_principals" {
  type        = set(string)
  default     = []
  description = "List of AWS service principal names for which you want to enable integration with your organization. Has no effect if create_organization is false."
}

variable "create_organization" {
  type        = bool
  default     = false
  description = "Whether or not to use this module to create your AWS organization."
}

variable "python_interpreter" {
  type        = string
  default     = "env python3"
  description = "The python interpreter to use for running the provisioner script"
}