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
  vpc_id                  = aws_vpc.one.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

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

resource "aws_subnet" "one_four" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "one_four"
  }
}

resource "aws_internet_gateway" "one" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "one"
  }
}

resource "aws_eip" "one_three" {
  domain = "vpc"
}

resource "aws_nat_gateway" "one_three" {
  allocation_id = aws_eip.one_three.allocation_id
  subnet_id     = aws_subnet.one_one.id

  tags = {
    Name = "one_three"
  }
}

resource "aws_eip" "one_four" {
  domain = "vpc"
}

resource "aws_nat_gateway" "one_four" {
  allocation_id = aws_eip.one_four.allocation_id
  subnet_id     = aws_subnet.one_two.id

  tags = {
    Name = "one_four"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_one_one" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.one_one.id
}

resource "aws_route_table_association" "public_one_two" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.one_two.id
}

resource "aws_route_table" "one_three" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "one_three"
  }
}

resource "aws_route_table_association" "nat_one_three" {
  route_table_id = aws_route_table.one_three.id
  subnet_id      = aws_subnet.one_three.id
}

resource "aws_route_table" "one_four" {
  vpc_id = aws_vpc.one.id
  tags = {
    Name = "one_four"
  }
}

resource "aws_route_table_association" "nat_one_four" {
  route_table_id = aws_route_table.one_four.id
  subnet_id      = aws_subnet.one_four.id
}

resource "aws_route" "public_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.one.id
}

resource "aws_route" "nat_one_three" {
  route_table_id         = aws_route_table.one_three.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.one_three.id
}

resource "aws_route" "nat_one_four" {
  route_table_id         = aws_route_table.one_four.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.one_four.id
}
