# Create a VPC
resource "aws_vpc" "hello_app_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet
resource "aws_subnet" "hello_app_subnet" {
  vpc_id            = aws_vpc.hello_app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

# Create a security group for the EKS cluster
resource "aws_security_group" "hello_app_eks_sg" {
  name        = "hello-app-eks-sg"
  description = "Security group for the EKS cluster"
  vpc_id      = aws_vpc.hello_app_vpc.id

  # Allow inbound traffic on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}