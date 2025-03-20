
# Attach the necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "hello_app_eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.hello_app_eks_role.name
}

resource "aws_iam_role_policy_attachment" "hello_app_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.hello_app_eks_role.name
}

# Create an IAM role for the node group
resource "aws_iam_role" "hello_app_eks_node_role" {
  name        = "hello-app-eks-node-role"
  description = "IAM role for the node group"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "hello_app_eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.hello_app_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "hello_app_eks_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.hello_app_eks_node_role.name
}


# Create an S3 bucket
resource "aws_s3_bucket" "hello_app_s3_bucket" {
  bucket = "hello-app-s3-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }
}


