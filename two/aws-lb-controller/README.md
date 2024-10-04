# add aws lb controller

Official guide from aws: https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html

# possible errors

```log
{"level":"error","ts":"2024-10-04T02:50:27Z","msg":"Reconciler error","controller":"service","namespace":"default","name":"nginx-loadbalancer","reconcileID":"174a5cfb-4aa1-4132-b780-b1ad9628b745","error":"unable to resolve at least one subnet (0 match VPC and tags: [kubernetes.io/role/internal-elb])"}
```
