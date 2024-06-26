resource "aws_db_instance" "default" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "16"
  instance_class       = "db.t3.micro"
  identifier        = "${local.prefix}-db"
  username             = "test123"
  password             = "123test123!"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  backup_retention_period      = 1
  backup_window                = "03:00-04:00"
  maintenance_window           = "mon:04:00-mon:04:30"
  skip_final_snapshot          = true
  final_snapshot_identifier    = "${local.prefix}-db-snapshot"
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = false
  storage_encrypted            = true
  kms_key_id                   = aws_kms_key.rds-kms.arn

  parameter_group_name = aws_db_parameter_group.db_pmg.name

  # Enable Multi-AZ deployment for high availability
  multi_az = false

  tags = {
    Name = "${local.prefix}-db"
    CostCenter = "${local.prefix}-db"
    StartStopAutomation = "enabled"
  }

}

resource "aws_kms_key" "rds-kms" {
  description             = "RDS Encryption"
  deletion_window_in_days = 30

  tags = {
    Name = "RDS-KMS"
  }
}

resource "aws_db_parameter_group" "db_pmg" {
  name   = "postgres-pmg"
  family = "postgres16"

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role-dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "rds_monitoring_attachment" {
  name       = "rds-monitoring-attachment"
  roles      = [aws_iam_role.rds_monitoring_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}