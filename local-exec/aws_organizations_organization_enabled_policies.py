#!/usr/bin/env python3

from __future__ import print_function

import boto3
import json
import os
import sys

allowed_policies = [
    'AISERVICES_OPT_OUT_POLICY',
    'BACKUP_POLICY',
    'SERVICE_CONTROL_POLICY',
    'TAG_POLICY'
]

modes = [
    'enable',
    'disable'
]


def usage():
    print("usage: %s [enable|disable] policy1 policy2 ... policyN" % os.path.basename(sys.argv[0]))
    sys.exit(1)


def validate_args(mode, policies):
    if mode not in modes:
        print("Unrecognized mode: %s" % mode)
        usage()

    for policy in policies:
        if policy not in allowed_policies:
            print("Unsupported policy type: %s" % policy)
            usage()


def main():
    if len(sys.argv) < 4:
        usage()

    mode = sys.argv[1]
    root_id = sys.argv[2]
    policies = sys.argv[3:]

    validate_args(mode, policies)
    client = boto3.client("organizations")

    if mode == 'enable':
        for policy in policies:
            response = client.enable_policy_type(RootId=root_id, PolicyType=policy)
            print(json.dumps(response, indent=2))


if __name__ == '__main__':
    main()
