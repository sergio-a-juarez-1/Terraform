terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- LOCALSTACK / FLOCI PROVIDER ROUTING ---
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_key"
  secret_key                  = "mock_secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Redirect all cloud API actions to your local container framework
  endpoints {
    ec2          = "http://localhost:4566"
    elb          = "http://localhost:4566"
    elbv2        = "http://localhost:4566"
    autoscaling  = "http://localhost:4566"
  }
}

# 1. Network Infrastructure Setup
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2. Security Perimeter Configuration
resource "aws_security_group" "web_sg" {
  name        = "self-healing-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Application Load Balancer
resource "aws_lb" "web_alb" {
  name               = "self-healing-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = data.aws_subnets.default.ids
}

# 4. Target Group with Fine-Tuned Aggressive Health Checks
resource "aws_lb_target_group" "web_tg" {
  name     = "self-healing-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10 # Check every 10 seconds for rapid local testing
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2 # Evict unhealthy nodes quickly
  }
}

# 5. Load Balancer Routing Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# 6. EC2 Deployment Configuration Template
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "self-healing-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  # Shell configuration script executed instantly at instance birth
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Self-Healing Server Online" > /var/www/html/index.html
              EOF
  )
}

# 7. Auto Scaling Group (The Automated Remediation Loop)
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.web_tg.arn]
  health_check_type   = "ELB" # Let the ALB health checker dictate node health
  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
  }
}

# 8. Output Routing Path
output "alb_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "The target endpoint URL of the self-healing web cluster."
}
