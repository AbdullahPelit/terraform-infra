locals {
  #general prefix
  prefix = "${var.project_name}-${var.environment}"
  cluster_name          = "${local.prefix}-cluster"

}
