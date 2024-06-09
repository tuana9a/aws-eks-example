resource "aws_vpc" "zero" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "zero"
  }
}

resource "aws_subnet" "zero_one" {
  vpc_id                  = aws_vpc.zero.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "zero_one"
  }
}

resource "aws_subnet" "zero_two" {
  vpc_id                  = aws_vpc.zero.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "zero_two"
  }
}

resource "aws_subnet" "zero_three" {
  vpc_id                  = aws_vpc.zero.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "zero_three"
  }
}

resource "aws_internet_gateway" "zero" {
  vpc_id = aws_vpc.zero.id
}

resource "aws_route" "public" {
  route_table_id         = aws_vpc.zero.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.zero.id
}
