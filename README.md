# aws-eks-example

See [zero](zero/README.md)

## find eks addon version

```shell
# find version of single addon
export AWS_REGION=us-east-1
kubernetes_version=1.26
addon_name=coredns
addon_name=kube-proxy
addon_name=vpc-cni
addon_name=aws-ebs-csi-driver
aws eks describe-addon-versions \
    --kubernetes-version "$kubernetes_version" \
    --addon-name $addon_name \
    --query 'addons[].addonVersions[].{Version: addonVersion, Default: compatibilities[0].defaultVersion}' | jq -r '.[] | [.Version,.Default] | @tsv'

# or find all of them at a time
export AWS_REGION=us-east-1
kubernetes_version=1.26
for addon_name in coredns kube-proxy vpc-cni aws-ebs-csi-driver; do
    echo "== $addon_name ==";
    aws eks describe-addon-versions \
        --kubernetes-version "$kubernetes_version" \
        --addon-name $addon_name \
        --query 'addons[].addonVersions[].{Version: addonVersion, Default: compatibilities[0].defaultVersion}' | jq -r '.[] | [.Version,.Default] | @tsv';
    echo;
done
```