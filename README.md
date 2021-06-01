# aws-ml-opt-out

A Terraform module to opt out of AWS artificial intelligence/machine learning (AI/ML) data collection.

## Purpose

Unless you explicitly opt out, any data you feed through AWS' AI services gets kept in some form and used for ...
well, for whatever Amazon sees fit.

This module makes it really easy to opt out.

I probably won't delete this repo, but at the same time I don't want to cause an outage if it goes
missing. So, if you decide to use this module in production, *please* fork it into an environment
you control, i.e. a corporate GHE instance or other similar source control system. The code is MIT-licensed,
so you can literally do whatever you want with it.

## Requirements
- terraform 0.13 or newer
- Python with boto3 module available

## Usage

This module can be used for both creating an organization or modifying an existing organization.

In the modifying use case, we leverage a Python script to invoke the boto3 API call to enable the
requested policy types. By default, the interpreter found with `env python3` will be used. If your
Python is in another path, you can specify it via the `python_interpreter` variable.

### creating an organization
- The `additional_enable_policy_types` and `aws_service_access_principals` are passed on to the
  `aws_organizations_organization` resource described [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization)
  
  Note that `AISERVICES_OPT_OUT_POLICY` is always present and does not need to be set explicitly.

Example:
```hcl
module "screw_you_skynet" {
  source = "https://github.com/gblues/aws-ml-opt-out"
  additional_enable_policy_types = ["TAG_POLICY"]
}
```

### modifying an existing organization
- set `create_organization` to false
- if you populate `additional_enabled_policy_types` then that will be honored
- `aws_service_access_principcals` is ignored

Example:
```hcl
module "alexa_opt_out_of_corporate_espionage" {
  source = "https://github.com/gblues/aws-ml-opt-out"
  create_organization = false
  additional_enable_policy_types = ["BACKUP_POLICY"]
}
```

### Troubleshooting

* If you set `create_organization` to `false` and get an error that mentions "NO-ORGANIZATION-FOUND", it means
  that Terraform couldn't find your organization, and you probably want to set `create_organization` to `true`
  
* An error that "env" cannot be executed means that you need to specify the path to your Python interpreter
  in the `python_interpreter` variable. This behavior is expected on Windows, but could occur on Linux/UNIX too
  if `env` is not in your PATH or if `env` can't find `python3`.
  