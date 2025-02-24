# ##### NAT Gateways #####
# resource "aws_eip" "public_1a" {
#   depends_on = [aws_internet_gateway.this]
# }

# resource "aws_eip" "public_1b" {
#   depends_on = [aws_internet_gateway.this]
# }

# resource "aws_nat_gateway" "public_1a" {
#   allocation_id = aws_eip.public_1a.id
#   subnet_id     = aws_subnet.public_us_east_1a.id

#   tags = {
#     Name = var.public_tag
#   }

#   depends_on = [aws_internet_gateway.this]
# }

# resource "aws_nat_gateway" "public_1b" {
#   allocation_id = aws_eip.public_1b.id
#   subnet_id     = aws_subnet.public_us_east_1b.id

#   tags = {
#     Name = var.private_tag
#   }

#   depends_on = [aws_internet_gateway.this]
# }
