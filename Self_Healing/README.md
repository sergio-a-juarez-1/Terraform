# Terraform Self-Healing Sandbox Environment (Killercoda-Style)

A production-grade, declarative Infrastructure-as-Code (IaC) configuration designed to provision ephemeral, self-healing sandbox environments on AWS. 

This architecture implements a strict, automated **2-hour session decay countdown** and an on-demand **manual reset command**, directly replicating the core user-experience flow of interactive cloud labs like Killercoda or Katacoda.

## 🚀 Key Features
* **Automated Ephemeral Lifecycles:** Deploys a background system daemon (`atd`) during bootstrap initialization that automatically tears down, prunes dependencies, and reboots the system cleanly every 2 hours.
* **Infinite Re-Queuing Loop:** Implements an automated operational safety layer that registers a fresh 2-hour self-healing timer upon reboot, ensuring the environment remains permanently ready for the next student session.
* **On-Demand Manual Reset Shorthand:** Deploys a secure CLI helper utility (`reset-env`) into the system execution path, allowing users to instantly roll back a broken configuration manually.
* **Dynamic Compute Provisioning:** Automatically queries and maps the newest stable Canonical Ubuntu Server 24.04 LTS release dynamically to ensure image parity across regional cloud boundaries.
* **Hardened Privilege Separation:** Implements explicit, passwordless elevation scopes tailored specifically to the reset script pathway, preventing unprivileged users from misusing root system parameters.

---

## 🔒 Architectural Breakdown: Why "Self-Healing"?

Unlike cloud-native scaling infrastructures that rely on heavy external load balancers and orchestrators to replace dead machines, this architecture utilizes **Local Node Self-Healing (In-Place Self-Remediation)**. The infrastructure automatically repairs state corruption and configuration drift through two distinct vectors:

1. **User-Triggered Self-Healing (On-Demand):** If a user corrupts core networking components, breaks container stacks, or locks themselves out of a tool, they execute `reset-env`. The machine instantly wipes the altered runtime state and triggers an automated system remediation loop back to the pristine baseline.
2. **Time-Triggered Self-Healing (Automated Fail-Safe):** If a user configures a destructive firewall rule, triggers a kernel panic, or breaks remote access channels entirely, human intervention is still not required. The independent, local system countdown clock acts as a cryptographic fuse that forces a full state purge and environment reboot automatically when the 2-hour threshold expires.

---

## 📂 Project Isolation & Monorepo Setup

### 1. Isolate the Project via Sparse-Checkout
To pull this specific tool out of your repository workspace without cluttering your system with your complete monorepo setup, open your terminal and run:

```bash
# Initialize an empty local directory
mkdir Self_Healing && cd Self_Healing
git init

# Link your multi-project workspace as the remote engine
git remote add origin https://github.com/sergio-a-juarez-1/Terraform.git

# Enable sparse-checkout and pull the target server directory
git sparse-checkout set Self_Healing
git pull origin main
```

### 2. File Structure
Ensure your working directory matches this structure inside `Self_Healing/`:
```text
.
├── main.tf        # Master resource maps, security definitions, and cloud-init routines
├── variables.tf   # Infrastructure parameters, region mapping, and configuration handles
├── outputs.tf     # Runtime status trackers and immediate deployment command connections
└── README.md      # Platform documentation and execution runbooks
```

---

## ⚡ Deployment & Execution

### Prerequisites
Before initializing the workspace infrastructure, ensure your local controller machine has the required binaries installed:
1. **Terraform CLI** (v1.5.0+)
2. **AWS CLI** configured with appropriate administrative programmatic access policies.

### Run the Deployment Pipeline
Initialize your working directory, validate configuration semantics, and execute the automated build chain:

```bash
# Initialize backend tracking engines and download providers
terraform init

# Validate syntactic and structural structure integrity
terraform validate

# Provision the cloud workspace infrastructure footprint
terraform apply -var="key_name=your-aws-ssh-key-name" -auto-approve
```

---

## 🛠️ Interactive Session Management & Controls

Once the build successfully completes, Terraform will automatically print your target access vectors to your terminal console interface.

### 1. Connecting to your Interactive Sandbox
Log into your freshly provisioned, interactive training sandbox via standard SSH protocols:
```bash
ssh ubuntu@<SANDBOX_PUBLIC_IP>
```

### 2. Inspecting Remaining Session Time
Your active environment tracks how long the session has remaining before it executes an automated roll-back script. To view the active system countdown clock queue, run:
```bash
atq
```

### 3. Executing an On-Demand Manual Reset
If you break a cluster configuration, run into a kernel lock, or corrupt essential learning packages, execute the custom platform shortcut anywhere inside the sandbox terminal:
```bash
reset-env
```
*The command will purge active session structures, clear out non-persistent Docker configurations, reschedule a fresh 2-hour expiration ticket, and cleanly reboot the node into a pristine baseline configuration state within seconds.*

---

## 🛟 Teardown & Permanent Destruction
When your training iterations are completed and you need to completely remove the cloud instance footprints from your cloud profile provider, run:

```bash
terraform destroy -var="key_name=your-aws-ssh-key-name" -auto-approve
```
