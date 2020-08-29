provider "aws" {
    region = "us-east-2"
}

resource "aws_key_pair" "my_key" {
  key_name   = "ec2-user"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjPzbxovG+SqZ2aVkAK8FzlQK1ps/xeT+UgJTsMpTFSD8OJJ37J4Gm7qn8g32eEzzegBtaoxG8J3DRgkB4HV8MKhUNMaTVDqlF4fVjjCVgZm5vyelQCdIBs/vd4V4xD5sws9hb3Rsq9hYbAeGY31f2mOIFi9E+5xUO0PcpeDymqsXAdryhzTmVhvMaLf6TjipDxCmVeDMOXxDutG9vIgW7UW0m/6WTZR/OVaa4WhTJHYOAwHuWLCLulBwUCGOTdiKkg/V9v2ZLQRMnic4qUSTnWHyIbqBO2buiRewwKtVPKp0ipx0m3ElrOdz5WbfgxoumbU3yCTRC8raLdfuFx+Iiw== cloud_user"
}

resource "aws_instance" "Jenkins_Server" {
  ami           = "ami-0f4aeaec5b3ce9152"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.DevOps_Project_SG.id]
  key_name = aws_key_pair.my_key.key_name

  tags = {
    Name = "Jenkins_Server"
  }
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_security_group" "DevOps_Project_SG" {
    name = "DevOps_Project_SG"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id      = data.aws_vpc.default.id

    tags = {
    Name = "DevOps_Project_SG"
  }
}


variable "sg_traffic_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
      description = string
    }))
    default     = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
          description = "ssh"
        },
        {
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
          description = "jenkins"
        },
    ]
}

resource "aws_security_group_rule" "sg_rules_ingress" {
  count = length(var.sg_traffic_rules)

  type              = "ingress"
  from_port         = var.sg_traffic_rules[count.index].from_port
  to_port           = var.sg_traffic_rules[count.index].to_port
  protocol          = var.sg_traffic_rules[count.index].protocol
  cidr_blocks       = [var.sg_traffic_rules[count.index].cidr_block]
  description       = var.sg_traffic_rules[count.index].description
  security_group_id = aws_security_group.DevOps_Project_SG.id
}


resource "aws_security_group_rule" "sg_rules_egress" {
  count = length(var.sg_traffic_rules)

  type              = "egress"
  from_port         = var.sg_traffic_rules[count.index].from_port
  to_port           = var.sg_traffic_rules[count.index].to_port
  protocol          = var.sg_traffic_rules[count.index].protocol
  cidr_blocks       = [var.sg_traffic_rules[count.index].cidr_block]
  description       = var.sg_traffic_rules[count.index].description
  security_group_id = aws_security_group.DevOps_Project_SG.id
}

output "Jenkins_Server_Public_IP" {
    value       = aws_instance.Jenkins_Server.public_ip
    description = "The public ip of Jenkins Server"
}