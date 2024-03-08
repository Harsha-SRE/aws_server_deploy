output "Dev-Ec2" {
  value = aws_instance.Dev-instance[*].public_ip
}

output "Dev-sg" {
  value = aws_security_group.Dev-sg
}

output "myfirst-sg_name" {
  value = aws_security_group.Dev-sg.name
}

output "myfirst-sg_ingress" {
  value = aws_security_group.Dev-sg.ingress
}

output "Dev-sg_egress" {
  value = aws_security_group.Dev-sg.egress
}

output "Dev-sg_ids" {
  value = aws_instance.Dev-instance[*].vpc_security_group_ids
}
