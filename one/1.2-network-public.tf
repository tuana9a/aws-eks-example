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