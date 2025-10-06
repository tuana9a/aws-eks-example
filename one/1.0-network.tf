# https://docs.aws.amazon.com/eks/latest/userguide/creating-a-vpc.html

resource "aws_vpc" "one" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "one"
  }
}

resource "aws_subnet" "one_public_a" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "one_public_a"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "one_private_a" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "one_private_a"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "one_public_b" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "one_public_b"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "one_private_b" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  map_public_ip_on_launch = false

  tags = {
    Name = "one_private_b"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/internal-elb" = "1"
  }
}
