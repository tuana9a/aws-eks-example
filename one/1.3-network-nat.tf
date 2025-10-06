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
