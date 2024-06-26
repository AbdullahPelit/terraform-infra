resource "aws_launch_template" "launch_template" {
  name_prefix   = local.autoscaling_group_name
  image_id      = local.eks_worker_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [local.cluster_node_security_group_id]

  user_data = "${base64encode(<<EOF
#!/bin/bash -xe
/etc/eks/bootstrap.sh ${local.cluster_name} --kubelet-extra-args ${local.kubelet-extra-args}
EOF
)}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      delete_on_termination = "true"
      encrypted             = "true"
    }
  }

  # iam_instance_profile {
  #   name = "${local.cluster_node_instance_profile_name}"
  # }

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.cluster_name}-node"
    }
  }
    
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    local.cluster_node_security_group_id
  ]

}
