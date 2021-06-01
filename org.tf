resource "aws_organizations_organization" "organization" {
  count                         = var.create_organization ? 1 : 0
  enabled_policy_types          = flatten(["AISERVICES_OPT_OUT_POLICY", var.additional_enable_policy_types])
  aws_service_access_principals = var.aws_service_access_principals
  # The above features require feature_set to be set to ALL.
  feature_set = "ALL"
}

data "aws_organizations_organization" "my_organization" {
  count = var.create_organization ? 0 : 1
}

resource "null_resource" "enabled_policies" {
  count = var.create_organization ? 0 : 1

  triggers = {
    my_organization_root_id = local.my_organization_root
    enabled_policy_types    = join(" ", flatten(["AISERVICES_OPT_OUT_POLICY", var.additional_enable_policy_types]))
    python                  = var.python_interpreter
  }

  provisioner "local-exec" {
    command = "${self.triggers.python} ${path.module}/local-exec/aws_organizations_organization_enabled_policies.py enable ${self.triggers.my_organization_root_id} ${self.triggers.enabled_policy_types}"
  }
}