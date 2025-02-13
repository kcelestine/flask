resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_us_east_1a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.subnet_az_1a
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_tag
  }
}

resource "aws_subnet" "public_us_east_1b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.subnet_az_1b
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_tag
  }
}

resource "aws_subnet" "private_us_east_1a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.subnet_az_1a

  tags = {
    Name = var.private_tag
  }
}

resource "aws_subnet" "private_us_east_1b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.subnet_az_1b

  tags = {
    Name = var.private_tag
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.public_tag
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = var.public_tag
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.private_tag
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_us_east_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_us_east_1a.id
  route_table_id = aws_route_table.private.id
}
