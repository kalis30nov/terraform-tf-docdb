resource "aws_docdb_subnet_group" "main" {
  name       = "${var.name}-${var.env}"
  subnet_ids = var.subnets

  tags = merge(var.tags, {Name = "${var.name}-${var.env}"})

}

resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "DOCDB"
    from_port        = var.port_number
    to_port          = var.port_number
    protocol         = "tcp"
    cidr_blocks = var.allow_db_cidr
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {Name = "${var.name}-${var.env}-sg"})
}

resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb4.0"
  name        = "${var.name}-${var.env}"
  description = "${var.name}-${var.env}"
  tags = merge(var.tags, {Name = "${var.name}-${var.env}-pmg"})

}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "${var.name}-${var.env}"
  engine                  = "docdb"
  engine_version          = var.engine_version
  master_username         = data.aws_ssm_parameter.db_user.value
  master_password         = data.aws_ssm_parameter.db_password.value
  db_subnet_group_name    = aws_docdb_subnet_group.main.name
  db_cluster_parameter_group_name  = aws_docdb_cluster_parameter_group.main.name
  storage_encrypted = true
  kms_key_id = var.kms_arn
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  port = var.port_number
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = merge(var.tags, {Name = "${var.name}-${var.env}"})
}