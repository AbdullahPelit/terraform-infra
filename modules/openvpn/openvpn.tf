resource "aws_security_group" "openvpn_sg" {
  name        = "${var.name}-${var.environment}-sg"
  description = "Allow internal traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # TODO: change later for specific cidr 
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16"] # TODO: change later for specific cidr 
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # TODO: change later for specific cidr 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}-${var.environment}-sg"
  }
}

resource "aws_instance" "openvpn_instance" {
  ami                         = "ami-0e001c9271cf7f3b9"
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.ec2_keypair
  vpc_security_group_ids      = [aws_security_group.openvpn_sg.id]
  iam_instance_profile        = var.instance_role
  associate_public_ip_address = var.public_ip

  disable_api_termination = true
  tags = {
    Name       = "${var.name}-${var.environment}",
    CostCenter = "${var.name}-${var.environment}"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  user_data  = <<-EOF
    #!/bin/bash
    curl -o /home/ubuntu/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    chmod +x /home/ubuntu/openvpn-install.sh
  EOF

  depends_on = [aws_security_group.openvpn_sg]
}

resource "aws_eip" "openvpn_eip" {
  domain   = "vpc"
  instance = aws_instance.openvpn_instance.id

  tags = {
    Name = "${var.name}-${var.environment}-eip"
  }
}