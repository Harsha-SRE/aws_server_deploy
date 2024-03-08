resource "aws_vpc" "Dev-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "Dev-sub1" {
  vpc_id            = aws_vpc.Dev-vpc.id
  availability_zone = var.subnet_az
  cidr_block        = var.subnet_cidr
  tags = {
    "Name" = var.subnet_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Dev-vpc.id
  tags = {
    "Name" = "Dev-IGW"
  }
}

resource "aws_route_table" "Dev-rt" {
  vpc_id = aws_vpc.Dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "test-rt"
  }
}

resource "aws_route_table_association" "Dev-rt1" {
  route_table_id = aws_route_table.Dev-rt.id
  subnet_id      = aws_subnet.Dev-sub1.id
}

resource "aws_security_group" "Dev-sg" {
  name        = "Dev-sg"
  vpc_id      = aws_vpc.Dev-vpc.id
  description = "Dev security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "dev-resources-iam-profile" {
  name = "ec2_profile"
  role = aws_iam_role.dev-resources-iam-role.name
}

resource "aws_iam_role" "dev-resources-iam-role" {
  name        = "dev-ssm-role"
  description = "The role for the developer resources EC2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    stack = "test"
  }
}

resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
  role       = aws_iam_role.dev-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "instance_count" {
  default = 1
}

variable "instance_names" {
  default = ["Dev-Static-Server-Instance"]
}

resource "aws_instance" "Dev-instance" {
  count                       = var.instance_count
  ami                         = "ami-0230bd60aa48260c6"  # Replace with your AMI ID
  instance_type               = "t2.micro"  # Replace with your instance type
  vpc_security_group_ids      = [aws_security_group.Dev-sg.id]
  subnet_id                   = aws_subnet.Dev-sub1.id
  key_name                    = "domain"  # Replace with your key name
  iam_instance_profile        = aws_iam_instance_profile.dev-resources-iam-profile.name
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/apache.sh", { html = file("${path.module}/html") })
  tags = {
    "Name"        = var.instance_names[count.index]
    "Environment" = "demo"
  }
  depends_on = [aws_subnet.Dev-sub1]
}

resource "aws_ebs_volume" "Dev-ebs" {
  count             = var.instance_count
  availability_zone = "us-east-1a"  # Replace with your desired availability zone
  size              = 8  # Replace with your desired EBS size
  tags = {
    "Name" = "${var.instance_names[count.index]}-ebs"
  }
  depends_on = [aws_instance.Dev-instance]
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.dev-resources-iam-role.name
}

## For ssl aws_acm_certificate
# resource "aws_acm_certificate" "dev-acm" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"

#   tags = {
#     Name = "ACMCertificate"
#   }
# }

# resource "aws_route53_record" "Domainrecord" {
#   zone_id = var.zone_id
#   name    = var.record_name
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_acm_certificate.dev.domain_validation_options.0.resource_record_name]

#   alias {
#     name                   = aws_acm_certificate.dev.domain_validation_options.0.resource_record_name
#     zone_id                = aws_acm_certificate.dev.domain_validation_options.0.resource_record_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_acm_certificate_validation" "acmvalidation" {
#   certificate_arn         = aws_acm_certificate.dev.arn
#   validation_record_fqdns = [aws_route53_record.dev.fqdn]
# }
