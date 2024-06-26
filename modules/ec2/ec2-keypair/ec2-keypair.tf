resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "${var.environment}-ec2-keypair"
  public_key = tls_private_key.generated_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.generated_key.private_key_pem}' > ./${var.environment}-ec2-keypair.pem"
  }
}

output "private_key" {
  value     = tls_private_key.generated_key.private_key_pem
  sensitive = true
}