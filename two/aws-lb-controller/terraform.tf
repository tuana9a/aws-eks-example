terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.two.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.two.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.two.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.two.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.two.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.two.token
  }
}
