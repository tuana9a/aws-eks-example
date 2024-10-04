# eks:zero

Simple EKS cluster with public control plane and public workers.

# how-to

Do not `terraform apply` the whole stack immediately as it will likely fail because of the dependent between each terraform resources.

Please comment out other terraform resource when apply the following order.

1. apply the `network.tf`
2. apply the `iam.tf`
3. apply the `main.tf` > `aws_eks_cluster.zero`
4. apply the `addon.tf` > `aws_eks_addon.zero_vpccni`, `aws_eks_addon.zero_kubeproxy`
5. apply the `main.tf` > `aws_eks_node_group.one`
6. apply the `addon.tf` > `aws_eks_addon.zero_coredns`

At this point it would be succeed and we can pull the kubeconfig as

```bash
aws eks update-kubeconfig --name zero
```