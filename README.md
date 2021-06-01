# aws-ml-opt-out

A Terraform module to opt out of AWS artificial intelligence/machine learning (AI/ML) data collection.

## Purpose

Unless you explicitly opt out, any data you feed through AWS' AI services gets kept in some form and used for ...
well, for whatever Amazon sees fit.

This module makes it really easy to opt out.

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

### modifying an existing organization
- set `create_organization` to false
- set `aws_organization` to your organization's ID attribute
- if you populate `additional_enabled_policy_types` then that will be honored

