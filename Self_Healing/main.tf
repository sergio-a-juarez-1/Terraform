resource "aws_instance" "training_node" {
  ami           = "ami-0c55b159cbfafe1f0" # Standard Target Ubuntu Server LTS
  instance_type = "t3.medium"
  key_name      = var.key_name

  tags = {
    Name = "killercoda-sandbox-node"
  }

  # Establish network and firewall parameters here...

  # Cloud-Init bootstrapping logic for self-healing environments
  user_data = <<-EOF
              #!/bin/bash
              # Update packages and install the 'at' scheduling daemon
              apt-get update -y
              apt-get install -y at curl

              # Start and enable the scheduled task runtime engine
              systemctl enable --now atd

              # Create the Automated Self-Destruct Routine (2-hour countdown)
              # This script deletes or restarts the localized workspace environment
              cat << 'SCRIPT' > /usr/local/bin/environment-reset.sh
              #!/bin/bash
              echo "⚠️ Environment lifecycle threshold reached! Initiating full workspace reset..."
              # Option A: For local Docker-based training sandboxes:
              docker system prune -af --volumes
              # Option B: For Cloud Instances, trigger a clean system reboot to default state
              # (Or use an external API call to trigger a local 'terraform apply -destroy')
              reboot
              SCRIPT
              chmod +x /usr/local/bin/environment-reset.sh

              # Register the 2-hour hard limit termination track
              echo "/usr/local/bin/environment-reset.sh" | at now + 2 hours

              # Create the Manual Reset CLI shorthand command
              cat << 'SCRIPT' > /usr/local/bin/reset-env
              #!/bin/bash
              echo "🔄 Manual system rebuild initiated by user. Purging active structures..."
              /usr/local/bin/environment-reset.sh
              SCRIPT
              chmod +x /usr/local/bin/reset-env
              EOF
}
