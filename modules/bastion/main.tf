# Fetch latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}

# Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.app_name}-${var.environment}-bastion-sg"
  description = "Security group for SSM-accessible bastion host"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.app_name}-${var.environment}-bastion-sg" }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

  tags = {
    Name        = "${var.app_name}-${var.environment}-bastion"
    Environment = var.environment
    SSMAccess   = "true" # Optional custom tag for clarity
  }
}

# IAM Role for Bastion Host
resource "aws_iam_role" "bastion_role" {
  name = "${var.app_name}-${var.environment}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = { Name = "${var.app_name}-${var.environment}-bastion" }
}

# SSM access for bastion (for session manager)
resource "aws_iam_role_policy_attachment" "bastion_ssm_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile for Bastion
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.app_name}-${var.environment}-bastion-profile"
  role = aws_iam_role.bastion_role.name

  tags = { Name = "${var.app_name}-${var.environment}-bastion" }
}
