# https://docs.aws.amazon.com/eks/latest/userguide/creating-a-vpc.html

resource "aws_vpc" "two" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "two"
  }
}

resource "aws_subnet" "two1" {
  vpc_id            = aws_vpc.two.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "two1"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "two2" {
  vpc_id            = aws_vpc.two.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "two2"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "two3" {
  vpc_id            = aws_vpc.two.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "two3"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "two4" {
  vpc_id            = aws_vpc.two.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  map_public_ip_on_launch = false

  tags = {
    Name = "two4"

    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3212
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/subnet_discovery/
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# internet gateway for public internet facing
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.two.id
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.two.id
  tags = {
    Name = "public"
  }
}

# by default all traffic will go to internet gateway and travel to public internet
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route_table_association" "two1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.two1.id
}

resource "aws_route_table_association" "two2" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.two2.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.allocation_id
  subnet_id     = aws_subnet.two1.id

  tags = {
    Name = "nat"
  }
}

resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.two.id
  tags = {
    Name = "nat"
  }
}

# by default traffic will go the nat gateway
# and nat gateway lives under subnet one
# and subnet one has default route to internet gateway
# which will enable ec2 vm in private subnets access public internet
resource "aws_route" "nat" {
  route_table_id         = aws_route_table.nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# associate "nat" route table to subnet two
resource "aws_route_table_association" "two3" {
  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.two3.id
}

# associate "nat" route table to subnet two
resource "aws_route_table_association" "two4" {
  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.two4.id
}
