# AWS Self-Healing Infrastructure Architecture (Local Simulation)

A production-grade Terraform blueprint that implements an **Elastic Auto Scaling Group (ASG)** integrated with an **Application Load Balancer (ALB)**. 

This infrastructure-as-code pattern models high-availability cloud behaviors locally by routing cloud API hooks into **LocalStack / Floci** running inside isolated container networks. This enables zero-cost testing of architecture failures, auto-remediation loops, and local cluster validation.

## 🚀 Architectural Mechanics
* **Elastic Load Balancing:** Provisions an Application Load Balancer to natively route incoming public network streams across distributed underlying machine instances.
* **Proactive Eviction Detection:** Polls underlying web servers aggressively every 10 seconds. If a runtime daemon crashes or locks up, the platform tags the backend target group as unhealthy.
* **Automated Remediation Loop:** The Auto Scaling Group dynamically tracks Load Balancer health hooks (`health_check_type = "ELB"`). The millisecond an application engine registers as dead, the cluster kills the virtual host and brings up a clean replica using the baseline Launch Template configuration.

---

## 🔒 Security Design (Zero Hardcoded Secrets)
This repository strictly follows DevSecOps compliance structures. The orchestration files contain **no plaintext access keys, secret tokens, or authenticating credentials**. 

The local provider profile uses dummy parameters (`mock_key` / `mock_secret`) that are valid **only** against your local development container context loop and will instantly reject public cloud operations if executed externally.

---

## 📂 Project Isolation & Setup

### 1. Isolate the Project via Sparse-Checkout
To pull this specific tool out of your repository workspace without cluttering your system with your complete monorepo setup, open your terminal and run:

```bash
# Initialize an empty local directory
mkdir self-healing && cd self-healing
git init

# Link your multi-project workspace as the remote engine
git remote add origin https://github.com/sergio-a-juarez-1/Terraform

# Enable sparse-checkout and pull the target server directory
git sparse-checkout set Self_Healing
git pull origin main
```

## 🛠️ Requirements & Setup

### 1. Fire Up the Mock Cloud Engine
Launch your isolated local Amazon infrastructure simulation cluster using your native machine container engine wrapper:
```bash
docker run -d --name floci -p 4566:4566 floci/floci:latest
```

### 2. Standard Workspace Provisioning
Initialize your project tree to download the corresponding HashiCorp provider plugins, validate deployment topology, and apply changes:
```bash
# Initialize local tracking extensions
terraform init

# Validate configuration blueprints
terraform plan

# Apply infrastructure definitions
terraform apply --auto-approve
```

---

## 💥 Chaos Engineering & Self-Healing Verification

To test the self-healing remediation systems without configuring native environment profiles, pass standard mock credentials directly inline to your local command interface chains:

### A. List Active Compute Virtual Nodes
Query the active architecture state to view your current baseline server allocation pool:
```bash
AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock aws --endpoint-url=http://localhost:4566 ec2 describe-instances --region us-east-1 --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output table
```

### B. Force a Hardware Failure (Chaos Injection)
Select one of the active `InstanceId` values returned from the table above and forcefully terminate it to simulate a localized failure:
```bash
AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock aws --endpoint-url=http://localhost:4566 ec2 terminate-instances --region us-east-1 --instance-ids <TARGET_INSTANCE_ID>
```

### C. Observe Automatic Remediation
Wait roughly 15 seconds for the mock cloud monitoring checks to report back to the Auto Scaling engine, then review your cluster mapping again:
```bash
AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock aws --endpoint-url=http://localhost:4566 ec2 describe-instances --region us-east-1 --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output table
```
The architecture metrics will display your targeted instance heading into a `terminated` phase, while an entirely new, system-managed `InstanceId` automatically boots up in a `pending` state to preserve cluster baseline capacity.

---

## 🌐 Moving to Real AWS (Production Migration)

To promote this blueprint from your local `floci` container directly into your real production AWS cloud account, follow these two migration adjustments:

1. **Remove the Mock Endpoints:** Open `main.tf` and delete or comment out the `endpoints {}` map block along with the `access_key` and `secret_key` declarations inside the provider declaration scope.
2. **Authenticate with Cloud IAM:** Export your true cloud IAM access credentials or AWS SSO profiles in your desktop terminal:
   ```bash
   export AWS_ACCESS_KEY_ID="......"
   export AWS_SECRET_ACCESS_KEY="......"
   export AWS_DEFAULT_REGION="us-east-1"
   ```
Rerun `terraform apply` to cleanly construct the same resilient, self-healing layout on real cloud infrastructure.

