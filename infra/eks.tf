# Create an EKS cluster
resource "aws_eks_cluster" "hello_app_eks_cluster" {
  name     = "hello-app-eks-cluster"
  role_arn = aws_iam_role.hello_app_eks_role.arn

  # Use the VPC and subnet created earlier
  vpc_config {
    security_group_ids = [aws_security_group.hello_app_eks_sg.id]
    subnet_ids         = [aws_subnet.hello_app_subnet.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.hello_app_eks_policy,
    aws_iam_role_policy_attachment.hello_app_eks_service_policy,
  ]
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "hello_app_eks_role" {
  name        = "hello-app-eks-role"
  description = "IAM role for the EKS cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Create a node group for the EKS cluster
resource "aws_eks_node_group" "hello_app_eks_node_group" {
  cluster_name    = aws_eks_cluster.hello_app_eks_cluster.name
  node_group_name = "hello-app-eks-node-group"
  node_role_arn   = aws_iam_role.hello_app_eks_node_role.arn

  # Use the VPC and subnet created earlier
  subnet_ids = [aws_subnet.hello_app_subnet.id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t2.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.hello_app_eks_node_policy,
    aws_iam_role_policy_attachment.hello_app_eks_container_registry_policy,
  ]
}