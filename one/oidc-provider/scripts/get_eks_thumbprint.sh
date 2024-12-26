#!/bin/bash

# https://github.com/hashicorp/terraform-provider-aws/issues/10104#issuecomment-534466094

aws_region=$1
thumbprint=$(echo | openssl s_client -connect oidc.eks.$aws_region.amazonaws.com:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}')
echo "{\"thumbprint\":\"$thumbprint\"}"
