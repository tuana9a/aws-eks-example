# https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html

# To get thumbprint https://github.com/hashicorp/terraform-provider-aws/issues/10104#issuecomment-534466094
# aws_region=ap-southeast-1
# echo | openssl s_client -connect oidc.eks.$aws_region.amazonaws.com:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}'

data "external" "eks_thumbprint" {
  program = ["bash", "./scripts/get_eks_thumbprint.sh", data.aws_region.current.name]
}

resource "aws_iam_openid_connect_provider" "eks_one" {
  url = data.aws_eks_cluster.one.identity[0].oidc[0].issuer
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [data.external.eks_thumbprint.result.thumbprint]
}
