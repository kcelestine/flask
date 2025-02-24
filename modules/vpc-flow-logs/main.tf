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
# # }s


# resource "aws_flow_log" "this" {
#   log_destination      = aws_s3_bucket.vpc_flow_log.arn
#   log_destination_type = "s3"
#   traffic_type         = "ALL"
#   vpc_id               = aws_vpc.this.id
# }

# resource "aws_s3_bucket" "vpc_flow_log" {
#   bucket = var.s3_flow_logs

#   force_destroy = true
# }

