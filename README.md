# aws-eks-example

We have those examples for EKS setup from scratch

## [zero](zero/README.md) - EKS public control plane, public worker node

## [one](one/README.md) - EKS public control plane, private worker node

## [two](two/README.md) - EKS public control plane, private worker node but with
  - oidc provider
  - aws lb controller
  - cluster autoscaling

# find eks addon version

find version of single addon

```shell
export AWS_REGION="us-east-1"
kubernetes_version="1.28"
addon_name="coredns"
addon_name="kube-proxy"
addon_name="vpc-cni"
addon_name="aws-ebs-csi-driver"
aws eks describe-addon-versions --kubernetes-version "$kubernetes_version" --addon-name "$addon_name" --query 'addons[].addonVersions[].{Version: addonVersion, Default: compatibilities[0].defaultVersion}' | jq -r '.[] | [.Version,.Default] | @tsv' | sort -k1
```

or find all of them at a time

```bash
export AWS_REGION="us-east-1"
kubernetes_version="1.28"
for addon_name in coredns kube-proxy vpc-cni aws-ebs-csi-driver; do
    echo "=== $addon_name ===";
    aws eks describe-addon-versions --kubernetes-version "$kubernetes_version" --addon-name "$addon_name" --query 'addons[].addonVersions[].{Version: addonVersion, Default: compatibilities[0].defaultVersion}' | jq -r '.[] | [.Version,.Default] | @tsv' | sort -k1;
    echo;
done
```