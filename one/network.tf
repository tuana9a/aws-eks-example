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
  }
}

resource "aws_subnet" "one_private_a" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "one_private_a"
  }
}

resource "aws_subnet" "one_public_b" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "one_public_b"
  }
}

resource "aws_subnet" "one_private_b" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  map_public_ip_on_launch = false

  tags = {
    Name = "one_private_b"
  }
}

# ----- PUBLIC -----
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route_table_association" "one_public_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.one_public_a.id
}

resource "aws_route_table_association" "one_public_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.one_public_b.id
}

# ----- NAT -----
resource "aws_eip" "nat_a" {
  domain = "vpc"
  tags = {
    Name = "nat_a"
  }
}

resource "aws_eip" "nat_b" {
  domain = "vpc"
  tags = {
    Name = "nat_b"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.allocation_id
  subnet_id     = aws_subnet.one_public_a.id

  tags = {
    Name = "nat_a"
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.allocation_id
  subnet_id     = aws_subnet.one_public_b.id

  tags = {
    Name = "nat_b"
  }
}

resource "aws_route_table" "nat_a" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "nat_a"
  }
}

resource "aws_route_table" "nat_b" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "nat_b"
  }
}

resource "aws_route" "nat_a" {
  route_table_id         = aws_route_table.nat_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

resource "aws_route" "nat_b" {
  route_table_id         = aws_route_table.nat_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}

resource "aws_route_table_association" "one_private_a" {
  route_table_id = aws_route_table.nat_a.id
  subnet_id      = aws_subnet.one_private_a.id
}

resource "aws_route_table_association" "one_private_b" {
  route_table_id = aws_route_table.nat_b.id
  subnet_id      = aws_subnet.one_private_b.id
}
