# eks:two

Simple EKS cluster with public control plane and private workers. But this time we add load balancer and auto scaling.

```bash
aws eks update-kubeconfig --name two
```

# available annotations for k8s service to work with aws lb controller

https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.8/guide/service/annotations/
