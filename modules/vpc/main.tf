resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}

# resource "aws_subnet" "public_us_east_1a" {
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = var.subnet_az_1a
#   map_public_ip_on_launch = true

#   tags = {
#     Name = var.public_tag
#   }
# }

# resource "aws_subnet" "public_us_east_1b" {
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = "10.0.3.0/24"
#   availability_zone       = var.subnet_az_1b
#   map_public_ip_on_launch = true

#   tags = {
#     Name = var.public_tag
#   }
# }

# resource "aws_subnet" "private_us_east_1a" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = var.subnet_az_1a

#   tags = {
#     Name = var.private_tag
#   }
# }

# resource "aws_subnet" "private_us_east_1b" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "10.0.4.0/24"
#   availability_zone = var.subnet_az_1b

#   tags = {
#     Name = var.private_tag
#   }
# }

# resource "aws_internet_gateway" "this" {
#   vpc_id = aws_vpc.this.id

#   tags = {
#     Name = var.public_tag
#   }
# }


# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.this.id
#   }

#   tags = {
#     Name = var.public_tag
#   }
# }

# resource "aws_route_table" "private_1a" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.public_1a.id
#   }

#   tags = {
#     Name = var.private_tag
#   }
# }

# resource "aws_route_table" "private_1b" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.public_1b.id
#   }

#   tags = {
#     Name = var.private_tag
#   }
# }

# # resource "aws_route_table_association" "public_1a" {
# #   subnet_id      = aws_subnet.public_us_east_1a.id
# #   route_table_id = aws_route_table.public.id
# # }

# # resource "aws_route_table_association" "public_1b" {
# #   subnet_id      = aws_subnet.public_us_east_1b.id
# #   route_table_id = aws_route_table.public.id
# # }

# resource "aws_route_table_association" "private_1a" {
#   subnet_id      = aws_subnet.public_us_east_1a.id
#   route_table_id = aws_route_table.private_1a.id
# }

# resource "aws_route_table_association" "private_1b" {
#   subnet_id      = aws_subnet.public_us_east_1b.id
#   route_table_id = aws_route_table.private_1b.id
# }


# # ### VPC Flow Logs
# # resource "aws_s3_bucket" "vpc_flow_logs" {
# #   bucket = var.s3_flow_logs
# # }

# # resource "aws_flow_log" "vpc_flow_log" {
# #     #count = "${var.enable_vpc_flow_log}"
# #     iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
# #     log_destination      = aws_s3_bucket.vpc_flow_logs.arn
# #     log_destination_type = "s3"
# #     traffic_type         = "ALL"
# #     vpc_id               = aws_vpc.this.id

# # }

# # resource "aws_iam_role" "vpc_flow_logs" {
# #   name = "enable_vpc_flow_log"
# #   #count = "${var.enable_vpc_flow_log}"
# #   assume_role_policy = <<EOF
# # {
# #   "Version": "2012-10-17",
# #   "Statement": [
# #     {
# #       "Sid": "",
# #       "Effect": "Allow",
# #       "Principal": {
# #         "Service": "vpc-flow-logs.amazonaws.com"
# #       },
# #       "Action": "sts:AssumeRole"
# #     }
# #   ]
# # }
# # EOF
# # }
# # resource "aws_iam_role_policy" "example" {
# #   name = "enable_vpc_flow_log"
# #   #count = "${var.enable_vpc_flow_log}"
# #   role = "${aws_iam_role.vpc_flow_logs.id}"
# #   policy = <<EOF
# # {
# #   "Version": "2012-10-17",
# #   "Statement": [
# #     {
# #       "Action": [
# #         "logs:CreateLogGroup",
# #         "logs:CreateLogStream",
# #         "logs:PutLogEvents",
# #         "logs:DescribeLogGroups",
# #         "logs:DescribeLogStreams"
# #       ],
# #       "Effect": "Allow",
# #       "Resource": "*"
# #     }
# #   ]
# # }
# # EOF
# # }

# permanently delete


resource "aws_flow_log" "this" {
  log_destination      = aws_s3_bucket.vpc_flow_log.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id
}

resource "aws_s3_bucket" "vpc_flow_log" {
  bucket = var.s3_flow_logs

  force_destroy = true
}

