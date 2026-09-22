#!/bin/bash
# killercoda-loop.sh
# An infinite infrastructure loop executing local clean configurations

WORKSPACE_DIR="/path/to/your/terraform/project"
cd "$WORKSPACE_DIR"

while true; do
  echo "🚀 Provisioning clean training environment..."
  terraform apply -auto-approve

  echo "⏱️ Sandbox active. Sleeping for 2 hours..."
  sleep 2h

  echo "🔥 Time expired! Tearing down infrastructure..."
  terraform destroy -auto-approve
  
  echo "⏳ Resting before rebuilding..."
  sleep 10s
done
