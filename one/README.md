# eks:one

Simple EKS cluster with public control planes and private workers.

```bash
aws eks update-kubeconfig --name one
```

# changelog

file `iam.tf` was splitted into 2 files: `eks-cluster-iam.tf` and `eks-node-iam.tf`

file `main.tf` was splitted into 2 files: `eks-cluster.tf` and `eks-node-group.tf`
