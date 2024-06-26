# data "aws_secretsmanager_secret" "rds_secret" {
#   name = "mydbcredentials"
# }

# data "aws_secretsmanager_secret_version" "rds_secret_version" {
#   secret_id = data.aws_secretsmanager_secret.rds_secret.id
# }