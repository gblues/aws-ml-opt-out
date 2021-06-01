locals {
  optOutPolicy = {
    services = {
      default = {
        opt_out_policy = {
          "@@assign" = "optOut"
        }
      }
    }
  }
  my_organization_root = var.create_organization ? "UNUSED" : data.aws_organizations_organization.my_organization[0].roots == null ? "NO-ORGANIZATION-FOUND" : data.aws_organizations_organization.my_organization[0].roots[0].id
}

resource "aws_organizations_policy" "org-policy" {
  content     = jsonencode(local.optOutPolicy)
  name        = "OptOutOfAllAIServicesPolicy"
  type        = "AISERVICES_OPT_OUT_POLICY"
  description = "Opt out of all Amazon AI services at an organization level"
}

resource "aws_organizations_policy_attachment" "org-policy-attachment" {
  count     = var.create_organization ? 1 : 0
  policy_id = aws_organizations_policy.org-policy.id
  target_id = aws_organizations_organization.organization[0].roots[0].id
}

resource "aws_organizations_policy_attachment" "my-org-policy-attachment" {
  count     = var.create_organization ? 0 : 1
  policy_id = aws_organizations_policy.org-policy.id
  target_id = local.my_organization_root
}