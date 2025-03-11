    resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
    }
    }

    data "aws_availability_zones" "available" {
    state = "available"
    }

    resource "aws_subnet" "public" {
    #for_each = { for idx, az in slice(data.aws_availability_zones.available.names, 0, length(data.aws_availability_zones.available.names)) : az => idx }
    #for_each = toset(data.aws_availability_zones.available.names)
        for_each = { for idx, az in slice(data.aws_availability_zones.available.names, 0, var.num_azs) : az => idx }

        vpc_id                  = aws_vpc.this.id
        cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value) # Allocates a /24 subnet per AZ
        availability_zone       = each.key
        map_public_ip_on_launch = true

        depends_on = [ aws_vpc.this ]

        tags = {
            Name = "public-${each.key}"
        }

    }

    resource "aws_subnet" "private_ec2" {
        for_each = { for idx, az in slice(data.aws_availability_zones.available.names, 0, var.num_azs) : az => idx }

        vpc_id            = aws_vpc.this.id
        cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + var.num_azs) # Different /24 subnet range for private
        availability_zone = each.key

        depends_on = [ aws_vpc.this ]

        tags = {
            Name = "private-${each.key}"
        }
    }

    resource "aws_subnet" "private_rds" {
        for_each = { for idx, az in slice(data.aws_availability_zones.available.names, 0, var.num_azs) : az => idx }

        vpc_id            = aws_vpc.this.id
        cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + (var.num_azs * 2))  # RDS subnet range, offset to separate from EC2 subnets
        availability_zone = each.key

        depends_on = [ aws_vpc.this ]
        
        tags = {
            Name = "private-${each.key}"
        }
    }

    resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = var.public_tag
    }
    }

    resource "aws_eip" "public" {
        for_each = aws_subnet.public
        domain = "vpc"
        depends_on = [aws_internet_gateway.this]
    }

    resource "aws_nat_gateway" "this" {
    for_each      = aws_subnet.public
    subnet_id     = aws_subnet.public[each.key].id
    allocation_id = aws_eip.public[each.key].id
    }

    resource "aws_route_table" "private" {
        for_each          = aws_nat_gateway.this
        vpc_id            = aws_vpc.this.id

        route {
            cidr_block      = "0.0.0.0/0"
            nat_gateway_id  = aws_nat_gateway.this[each.key].id
        }

        tags = {
            Name            = "private-${each.key}"
        }
    }

    resource "aws_route_table_association" "private" {
        for_each       = aws_nat_gateway.this
        subnet_id      = aws_subnet.private_ec2[each.key].id
        route_table_id = aws_route_table.private[each.key].id
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

    resource "aws_route_table_association" "public" {
        for_each       = aws_subnet.public
        subnet_id      = aws_subnet.public[each.key].id
        route_table_id = aws_route_table.public.id
    }


