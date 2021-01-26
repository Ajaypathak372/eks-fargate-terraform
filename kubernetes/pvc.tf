resource "aws_security_group" "sg_efs" {
  description = "Security Group to allow NFS"
  name = "efs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = [ var.vpc_cidr ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "wordpress-efs"

  tags = {
    Name = "kubernetes-wordpress-pv"
  }
}

resource "aws_efs_mount_target" "mount_target" {
  count = length(var.efs_subnet_ids)

  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = element(var.efs_subnet_ids[*], count.index)
  security_groups = [ aws_security_group.sg_efs.id ]
}

resource "kubernetes_storage_class" "wordpress" {
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
}

resource "kubernetes_persistent_volume" "wordpress" {
  metadata {
    name = "efs-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    volume_mode = "Filesystem"
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "efs-sc"
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.efs.id
      }
    }
  }
  depends_on = [ kubernetes_storage_class.wordpress ]
}