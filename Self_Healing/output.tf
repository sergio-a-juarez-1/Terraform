output "sandbox_public_ip" {
  value       = aws_instance.sandbox_node.public_ip
  description = "The target public IP point to connect to your training instance"
}

output "countdown_check_command" {
  value       = "ssh ubuntu@${aws_instance.sandbox_node.public_ip} 'atq'"
  description = "Run this in your terminal to inspect the active remaining time before automated self-healing triggers"
}

output "manual_reset_command" {
  value       = "ssh ubuntu@${aws_instance.sandbox_node.public_ip} 'reset-env'"
  description = "Run this from your terminal to trigger an instant on-demand remote environment rebuild"
}
