# https://docs.aws.amazon.com/eks/latest/userguide/creating-a-vpc.html

resource "aws_vpc" "one" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "one"
  }
}

resource "aws_subnet" "one_one" {
  vpc_id                  = aws_vpc.one.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "one_one"
  }
}

resource "aws_subnet" "one_two" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "one_two"
  }
}

resource "aws_subnet" "one_three" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "one_three"
  }
}

resource "aws_internet_gateway" "one" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "one"
  }
}

resource "aws_eip" "one" {
  domain = "vpc"
  tags = {
    Name = "one"
  }
}

resource "aws_nat_gateway" "one" {
  allocation_id = aws_eip.one.allocation_id
  subnet_id     = aws_subnet.one_one.id

  tags = {
    Name = "one"
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
  gateway_id             = aws_internet_gateway.one.id
}

resource "aws_route_table_association" "public_one_one" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.one_one.id
}

resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "nat"
  }
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.one.id
}

resource "aws_route_table_association" "nat_one_two" {
  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.one_two.id
}

resource "aws_route_table_association" "nat_one_three" {
  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.one_three.id
}
