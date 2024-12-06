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
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "one_one"
  }
}

resource "aws_subnet" "one_two" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "one_two"
  }
}

resource "aws_subnet" "one_three" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "one_three"
  }
}

# ----- PUBLIC -----
# internet gateway for public internet facing
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

# by default all traffic will go to internet gateway and travel to public internet
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

# associate the "public" route table to public subnet "one", making subnet "one" is the public internet facing subnet
resource "aws_route_table_association" "one_one" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.one_one.id
}

# ----- NAT -----
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat"
  }
}

# nat gate way live under subnet one - which is a public internet facing subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.allocation_id
  subnet_id     = aws_subnet.one_one.id

  tags = {
    Name = "nat"
  }
}

resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.one.id
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

resource "aws_route_table_association" "one_two" {
  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.one_two.id
}

resource "aws_route_table_association" "one_three" {
  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.one_three.id
}
