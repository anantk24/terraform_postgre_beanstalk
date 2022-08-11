provider "aws" {
  region = "ap-south-1"
}
resource "aws_rds_cluster_instance" "postgresql" {
  depends_on = [aws_rds_cluster.postgresql-root]
  engine              = "aurora-postgresql"
  instance_class      = "db.r6g.large"
  cluster_identifier  = "database-1"
  monitoring_interval = 0
  promotion_tier      = 1
}
resource "aws_rds_cluster" "postgresql-root" {
  engine                         = "aurora-postgresql"
  engine_mode                    = "provisioned"
  backup_retention_period        = 7
  cluster_identifier             = "database-1"
  copy_tags_to_snapshot          = true
  enable_global_write_forwarding = false
  skip_final_snapshot            = true

  database_name      = "db"
  master_username    = "api"
  master_password    = "api"
}
