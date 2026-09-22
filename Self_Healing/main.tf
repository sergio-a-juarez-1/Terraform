terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Dynamically query the latest official Ubuntu Server LTS release
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical Official Owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "sandbox_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]

  tags = {
    Name        = "killercoda-sandbox-environment"
    Environment = "Training"
  }

  # Hardened User Data Deployment Block (Using "EOF" prevents inner bash variable interpolation failures)
  user_data = <<-"EOF"
              #!/bin/bash
              set -e

              # 1. Enforce Non-Interactive Package Installation Configuration
              export DEBIAN_FRONTEND=noninteractive
              apt-get update -y
              apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" at curl sudo

              # 2. Start and Enable the Scheduling Engine
              systemctl daemon-reload
              systemctl enable --now atd

              # 3. Create the Base Reset Execution Script
              cat << 'SCRIPT' > /usr/local/bin/environment-reset.sh
              #!/bin/bash
              echo "⚠️ Sandbox session limits reached. Initiating automatic environment roll-back..."
              
              # Safely handle Docker container teardowns if present
              if command -v docker &> /dev/null; then
                docker system prune -af --volumes
              fi

              # Self-Healing Rescheduling Hook: Queue the next 2-hour reset marker before recycling the system
              echo "/usr/local/bin/environment-reset.sh" | at now + 2 hours

              echo "🔄 Cycling system state down..."
              reboot
              SCRIPT
              chmod 0755 /usr/local/bin/environment-reset.sh

              # 4. Trigger the Initial 2-Hour Expiration Fuse
              echo "/usr/local/bin/environment-reset.sh" | at now + 2 hours

              # 5. Build the Student-Facing CLI Manual Reset Link
              cat << 'SCRIPT' > /usr/local/bin/reset-env
              #!/bin/bash
              if [ "$EUID" -ne 0 ]; then
                echo "🔑 Administrative elevation required. Rerunning via sudo..."
                sudo "$0" "$@"
                exit $?
              fi

              echo "🔄 Manual workspace rebuild initiated by user. Flushing session timelines..."
              
              # Purge existing queued tasks from the active 'at' scheduler loop to clear the board
              for job in $(atq | awk '{print $1}'); do 
                atrm "$job"
              done

              # Fire the base configuration execution script immediately
              /usr/local/bin/environment-reset.sh
              SCRIPT
              chmod 0755 /usr/local/bin/reset-env

              # 6. Authorize Passwordless Sudo Access Strictly for the reset-env Binary Path
              echo "ubuntu ALL=(ALL) NOPASSWD: /usr/local/bin/reset-env" > /etc/sudoers.d/99-reset-env
              chmod 0440 /etc/sudoers.d/99-reset-env
              EOF
}

resource "aws_security_group" "sandbox_sg" {
  name        = "killercoda-sandbox-security-perimeter"
  description = "Provides ingress boundaries for secure sandbox training networks"

  ingress {
    description = "SSH Connection Gateway"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Hardened alternative: Restrict to your home/office WAN IP block
  }

  egress {
    description = "Unrestricted WAN Outbound Access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
