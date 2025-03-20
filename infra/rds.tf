# Create an RDS instance
resource "aws_db_instance" "hello_app_rds_instance" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.t2.micro"
  name                 = "helloappdb"
  username             = "helloappuser"
  password             = "helloapppassword"
  parameter_group_name = "default.postgres12"
  vpc_security_group_ids = [aws_security_group.hello_app_rds_sg.id]
}

# Create a security group for the RDS instance
resource "aws_security_group" "hello_app_rds_sg" {
  name        = "hello-app-rds-sg"
  description = "Security group for the RDS instance"
  vpc_id      = aws_vpc.hello_app_vpc.id

  # Allow inbound traffic on port 5432
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}