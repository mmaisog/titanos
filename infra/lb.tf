# Create a Load Balancer
resource "aws_elb" "hello_app_elb" {
  name            = "hello-app-elb"
  subnets         = [aws_subnet.hello_app_subnet.id]
  security_groups = [aws_security_group.hello_app_elb_sg.id]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }
}

# Create a security group for the Load Balancer
resource "aws_security_group" "hello_app_elb_sg" {
  name        = "hello-app-elb-sg"
  description = "Security group for the Load Balancer"
  vpc_id      = aws_vpc.hello_app_vpc.id

  # Allow inbound traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}