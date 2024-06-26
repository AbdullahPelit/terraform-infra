resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "SSM-${var.environment}"

  role = aws_iam_role.ssm_role.name
}