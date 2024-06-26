variable "environment" {
  description = "dev, test, preprod, stage, prod"
  type        = string
  default     = "common"
}

variable "project_name" {
  description = "Project/Domain name"
  type        = string
  default     = "test"
}

variable "location" {
  description = "Frankfurt"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "111111111"

}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "case-common-cluster"
}

# variable "opensearch_master_user" {
#   description = "Opensearch master user name"
#   type = string
#   default = "master"
# }

# variable "opensearch_master_passwd" {
#   description = "Opensearch master user passwd"
#   type = string
#   default = "passWDMaster123!"
# }
