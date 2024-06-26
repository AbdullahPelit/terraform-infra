variable "vpc_module" {}
variable "eks_module" {}
variable "eks_worker_ami" {}
variable "nodegroup_name" {}
variable "instance_type" {}
variable "min_size" {}
variable "max_size" {}
variable "volume_size" {}
variable "volume_type" {}
variable "environment" {}
variable "project_name" {}
variable "taint" {}
variable "labels" {}
variable "instance_list" {
    type = list(string)
    default = ["t3.xlarge", "t3.large", "t3a.large", "t3a.xlarge"]
}
variable "capacity_type" {
  
}
