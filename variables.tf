variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}



variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "Dev-vpc"
}

variable "subnet_az" {
  description = "Availability Zone for the subnet"
  type        = string
  default     = "us-east-1b"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_name" {
  description = "Name tag for the subnet"
  type        = string
  default     = "Dev-sub1"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-05c13eab67c5d8861"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = ""
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP to the instance"
  type        = bool
  default     = true
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = ""
}

variable "ebs_az" {
  description = "Availability Zone for the EBS volume"
  type        = string
  default     = "us-east-1b"
}

variable "ebs_size" {
  description = "Size of the EBS volume in gigabytes"
  type        = number
  default     = 20
}

variable "ebs_name" {
  description = "Name tag for the EBS volume"
  type        = string
  default     = ""
}


#################
## Domain ##
#############


# variable "domain_name" {
#   description = "The domain name for the ACM certificate"
#   default = ""
# }

# variable "zone_id" {
#   description = "The Route 53 hosted zone ID"
#   default = ""
# }

# variable "record_name" {
#   description = "The DNS validation record name"
#   default = ""
# }
