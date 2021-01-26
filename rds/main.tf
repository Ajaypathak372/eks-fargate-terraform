resource "aws_security_group" "sg_rds" {
  vpc_id        = var.vpc_id

  ingress {
    description = "Allow only EKS to connect"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ var.vpc_cidr ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_rds_${terraform.workspace}"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.subnet_group_name}-${terraform.workspace}"
  subnet_ids = var.rds_subnet_ids
  tags = {
    Name = "RDS_SG_${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_db_instance" "default" {
  identifier             = "${var.identifier}-${terraform.workspace}"
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.db_name
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  db_subnet_group_name   = aws_db_subnet_group.default.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [ aws_security_group.sg_rds.id ]
  depends_on             = [ aws_db_subnet_group.default ]
}