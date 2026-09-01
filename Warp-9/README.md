# Terraform Masterclass: Fundamentals & Associate Certification Prep

Welcome to the ultimate **Terraform Masterclass** repository! This repository brings together the complete, production-grade configuration files, provider structures, and automation modules from both of our comprehensive Terraform tracks:

1. **Course 1: Zero to Infrastructure-as-Code Hero** (Fundamentals, AWS Networking, Compute, and Modularization)
2. **Course 2: HashiCorp Certified Associate Prep** (Advanced Engine Architecture, Provider Internals, Deep State Mastery, and Exam Prep)

---

## 📊 Combined Course Metrics
* **Total Content Scope:** 28 Sections • 201 Lectures • ~6h 40m total runtime
* **Target Milestone:** Build production AWS infrastructure and clear the **HashiCorp Certified Terraform Associate** examination.
* **Core Tooling:** Terraform CLI, AWS Cloud Provider, HashiCorp Vault Provider, Sentinel, and Terraform Cloud.

---

## 📂 Combined Repository Structure

```text
├── 01-environment-setup/    # Cross-platform workspace setups (Mac/Windows/Linux) and IAM access keys
├── 02-core-workflow/        # Standard tf init, validate, plan, apply, and destroy workflows
├── 03-hcl-data-types/       # Basic to advanced variables (Strings, Lists, Maps, Tuples, and multi-tier Objects)
├── 04-networking-compute/   # Production AWS VPC frameworks, Elastic IPs, Security Groups, and Dynamic Blocks
├── 05-modular-engineering/  # Custom local child modules, Terraform Registry consumption, and data flow pipelines
├── 06-advanced-variables/   # Env variables, CLI inputs, runtime variable precedence, .tfvars, and .auto.tfvars
├── 07-provider-plumbing/    # Multi-provider architectures (AWS + Vault APIs), local vs remote provisioners (exec)
├── 08-cli-command-center/   # Deep plumbing: fmt, taint/untaint, import, and detailed debugging logs
├── 09-state-architecture/   # State mechanics: list, pull, mv, rm, refresh, remote backends, and force-unlocking
├── 10-enterprise-security/  # Policy-as-Code with Sentinel, secure secret injections, and sensitive key protection
├── 11-workspace-isolation/  # Creating, swapping, and managing distinct isolated environments via workspaces
└── 12-terraform-cloud/      # Cloud-managed pipelines, VCS triggers, and OSS vs Cloud vs Enterprise comparisons
```

---

## 🛠️ Getting Started

### Prerequisites
* Your preferred IDE (VS Code with HashiCorp Terraform extensions installed)
* Terraform CLI engine running locally on your shell path
* Active AWS Free Tier account with programmatic IAM user keys mapped out

### Execution Pipeline Walkthrough
```bash
# 1. Clone the combined master repository
git clone https://github.com

# 2. Change directories to the targeted exam review block
cd terraform-masterclass/08-cli-command-center

# 3. Format and clean up HCL code style guidelines 
terraform fmt

# 4. Syntactically validate code configurations prior to dry-runs
terraform validate

# 5. Initialize provider modules and check target pipelines
terraform init && terraform plan
```

---

## 📘 Detailed Syllabus Breakdown

### 🏗️ Course 1: Core Fundamentals & Practical Cloud Infrastructure
* **HCL Schemas & Inputs:** Moving past base Strings into production-grade Lists, maps, and objects to systematically configure infrastructure blocks without hardcoded values.
* **AWS Provisioning Engine:** Automating the rollout of customized Virtual Private Clouds (`VPC`), isolated subnet layers, security groups, relational database clusters (`RDS`), and highly dynamic elastic host configurations (`EC2`).
* **Dry Block Architecture:** Implementing functional loops with nested `dynamic` arguments to radically minimize security group port duplication rules.
* **Modularity 101:** Isolating and wrapping structural infrastructure parameters into generic, scalable local packages that cleanly pass inputs and outputs across environments.

### 🎓 Course 2: Advanced Internal Operations & Certified Associate Prep
* **Provider & API Plumbing:** Understanding how Terraform wraps REST APIs. Setting up multi-provider manifests (e.g., mapping resource properties between AWS and local Vault engines) and handling remote/local script execution pipelines (`local-exec` / `remote-exec`).
* **Variable Precedence Masterclass:** Mapping out the strict priority hierarchy of parameter ingestions: passing variables from shell Environments, runtime CLI arguments, `.tfvars` manifests, up to prioritized `.auto.tfvars` configurations.
* **Surgical State Management:** Moving beyond basic states into target resource tracking via advanced data blocks. Correcting environments using plumbing commands like `state list`, `state pull`, safe migrations with `state mv`, and explicit manual item extraction via `state rm`.
* **Day-2 Enterprise Actions:** Implementing safe target adoptions with `terraform import`, automating team state file management across remote clouds (`S3 / DynamoDB Locking`), forcing backends out of deadlocks with `force-unlock`, and configuring Workspace environments to duplicate configurations quickly.
* **Enterprise Security & Cloud Scalability:** Protecting raw state configurations via secret runtime injection patterns, evaluating configuration states via `Sentinel` Policy-as-Code engines, and configuring automated remote runs via **Terraform Cloud**.
* **Associate Certification Boot Camp:** Breaking down the official examination patterns, formatting logic traps, registration processes, and strategic update review logs to clear the certification exam in record time.
