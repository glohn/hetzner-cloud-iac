# Hetzner Cloud Infrastructure as Code

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites and Setup](#prerequisites-and-setup)
- [Required API Tokens and Credentials](#required-api-tokens-and-credentials)
- [Quick Start](#quick-start)
- [Bootstrap Process](#bootstrap-process)
- [Configuration](#configuration)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Overview

This project provides Infrastructure as Code (IaC) templates to provision and manage infrastructure on Hetzner Cloud using **Terraform** and **Ansible**. It includes modules for services like databases, message queues, caching layers, and networking.

## Features

- **Terraform Modules**: Reusable infrastructure components 
- **Ansible Playbooks**: Configuration management and service deployment 
- **Multi-Service Support**: Redis, RabbitMQ, MySQL (Percona), Elasticsearch, NFS 
- **Network Security**: Firewall rules and VPC configuration 
- **SSL/TLS**: Automated certificate management via Hetzner DNS 
- **State Management**: Terraform state handling with S3-compatible backend 

## Project Structure

```
├── 00-tfstate/           # Terraform state management
├── 01-tf-base/           # Base infrastructure (VPC, DNS, etc.)
├── 02-tf-vm/             # Virtual machine provisioning
├── tf-modules/           # Reusable Terraform modules
├── ansible/              # Configuration management
├── scripts/              # Helper scripts
└── Makefile              # Automated setup and deployment
```

## Prerequisites and Setup

1. **Hetzner Cloud Projects**
   
   For security reasons, this setup uses **two separate Hetzner Cloud projects**:
   
   **Project 1 (State Storage)**:
   - Create a dedicated project for Terraform state storage
   - Create S3-compatible object storage credentials
   - This project contains only the S3 bucket for state files
   
   **Project 2 (Infrastructure)**:
   - Create a separate project for the actual infrastructure
   - Generate an API token with read/write permissions
   - Deploy all VMs, networks, and services here
   
   **Security Rationale**: S3 credentials in Hetzner Cloud grant access to the entire project. By separating state storage from infrastructure, we ensure that deployed services cannot access Terraform state files, which may contain sensitive information.

2. **Required Tools**
   - [Terraform](https://www.terraform.io/) >= 1.10, < 1.11.2 (**Recommended: 1.10.x**)
   - [Ansible](https://www.ansible.com/) >= 2.9
   - SSH client for server access
   
   **⚠️ Important**: Terraform versions 1.11.2 and later have known issues with S3-compatible backends (including Hetzner Object Storage). Use Terraform 1.10.x for reliable operation with this setup.

3. **DNS Configuration**
   
   **Important**: The domain/subdomain used must be managed by Hetzner DNS for automated certificate validation to work.
   
   **Option A - Full Domain**:
   - Transfer your domain's DNS management to Hetzner Cloud DNS
   - Go to [Hetzner DNS Console](https://dns.hetzner.com/)
   - Add your domain as a DNS zone
   
   **Option B - Subdomain (Recommended)**:
   - Go to [Hetzner DNS Console](https://dns.hetzner.com/)
   - Add your main domain as a DNS zone (e.g., `example.com`)
   - At your current DNS provider, set NS records for the subdomain `hcloud.yourdomain.com` to point to Hetzner's nameservers
   - This delegates only the `hcloud.*` subdomain to Hetzner while keeping the main domain elsewhere
   
   **Required Steps**:
   1. Create a DNS zone in [Hetzner DNS Console](https://dns.hetzner.com/) (e.g., `example.com`)
   2. Configure NS records at your DNS provider: `hcloud.example.com` → Hetzner nameservers
   3. Set `domainname` in `01-tf-base/terraform.auto.tfvars` to match the DNS zone name (e.g., `example.com`)
   4. Generate Hetzner DNS API token for automated certificate validation
   
   **Example**:
   - DNS Zone in Hetzner: `example.com`
   - NS delegation at DNS provider: `hcloud.example.com` → Hetzner nameservers
   - Terraform creates: `myproject.hcloud.example.com`, `admin.myproject.hcloud.example.com`
   - You only delegate `hcloud.*` subdomain to Hetzner, main domain stays with your provider

## Required API Tokens and Credentials

Before you can deploy the infrastructure, you need to obtain **4 different secrets**. Here's how to get them:

### 1. Hetzner Cloud API Token (`hcloud_token`)

**Purpose**: Manages your infrastructure (VMs, networks, load balancers, etc.)

**How to get it**:
1. Go to [Hetzner Cloud Console](https://console.hetzner-cloud.de/)
2. Create or select your **Infrastructure Project** (Project 2)
3. Navigate to **"Security"** → **"API Tokens"**
4. Click **"Generate API Token"**
5. Name: e.g. your project name
6. Permissions: **Read & Write**
7. **Important**: Copy the token immediately - it's only shown once!

### 2. Hetzner DNS API Token (`hcloud_dns_token`)

**Purpose**: Manages DNS records for automated SSL certificate validation

**How to get it**:
1. Go to [Hetzner DNS Console](https://dns.hetzner.com/)
2. Navigate to **"API Tokens"**
3. Click **"Create new token"**
4. Name: e.g. your project name with `-dns` suffix
5. **Important**: Copy the token immediately - it's only shown once!

### 3. S3 Access Key (`s3_access_key`) & Secret Key (`s3_secret_key`)

**Purpose**: Terraform state storage in S3-compatible object storage

**How to get it**:
1. Go to [Hetzner Cloud Console](https://console.hetzner-cloud.de/)
2. Create or select your **State Storage Project** (Project 1)
3. Navigate to **"Security"** → **"S3 Credentials"**
4. Click **"Generate S3 Credentials"**
5. Name: e.g. your project name with `-tfstate` suffix
6. Copy both **Access Key ID** and **Secret Access Key**
7. **Important**: The secret key is only shown once during creation!

**Note**: The S3 bucket will be created automatically by Terraform during deployment.

### Summary Checklist

Before proceeding, ensure you have:
- [ ] **Project 1 (State Storage)**: Created + S3 credentials generated
- [ ] **Project 2 (Infrastructure)**: Created + API token generated
- [ ] **DNS Zone**: Created in Hetzner DNS Console + nameservers configured
- [ ] **DNS Token**: Generated in Hetzner DNS Console
- [ ] All **4 secrets** copied to `00-tfstate/secrets.auto.tfvars` (2 API tokens + 2 S3 credentials)
- [ ] **Configuration files**: Created and customized `.auto.tfvars` files in all 3 directories

**Security Note**: Never commit the `secrets.auto.tfvars` file to version control. It's already in `.gitignore`.

## Quick Start

This project includes an automated Makefile that handles all setup and deployment steps interactively.

### Two-Step Deployment

1. **Clone and setup**
   ```bash
   git clone https://github.com/glohn/hetzner-cloud-iac.git
   cd hetzner-cloud-iac
   
   # Interactive setup - collects all credentials and configuration
   make setup
   ```
   
   The setup process will interactively ask you for:
   - Your 4 API credentials (Hetzner Cloud, DNS, S3 access/secret keys)
   - Service passwords (RabbitMQ, MySQL)
   - Domain name and SSH configuration
   - Project settings (name, location, bucket prefix)

2. **Deploy infrastructure**
   ```bash
   # Automated deployment in correct sequence
   make deploy
   ```
   
   This automatically:
   - Deploys S3 state storage with local backend
   - Switches to S3 backend and migrates state
   - Deploys base infrastructure (VPC, DNS, certificates)
   - Deploys virtual machines and services

### Additional Commands

```bash
make help    # Show all available commands
make clean   # Remove all generated configuration files
```

> **Note**: For manual deployment or troubleshooting, see the [Bootstrap Process](#bootstrap-process) section below.

## Bootstrap Process

**Important**: The first deployment requires generating provider configuration files from templates.

### Prerequisites for Bootstrap

Before starting the bootstrap process, ensure the configuration is properly set:

**Generate provider configuration files**:
```bash
# Generate providers.tf from templates with your bucket configuration
./scripts/setup-providers.sh
```

This script reads your `bucket_prefix`, `project`, `location`, and `minio_domain` from `00-tfstate/terraform.auto.tfvars` and generates all `providers.tf` files accordingly.

**How the template system works:**
- All `providers.tf.template` files contain placeholder variables (e.g., `BUCKET_PREFIX-PROJECT-tfstate`, `LOCATION.MINIO_DOMAIN`)
- The script replaces these placeholders with your actual configuration values
- Generated `providers.tf` files are automatically ignored by Git to keep the repository generic
- This separates your personal configuration from the generic repository code

**File Structure Example:**
```
00-tfstate/
├── providers.tf.template    # Generic template (in repository)
├── providers.tf             # Generated file (gitignored)
├── terraform.tfvars         # Generic example values (in repository)
└── terraform.auto.tfvars    # Your specific values (gitignored)
```

### Deployment Process

With the template system, deployment is straightforward:

```bash
# 1. Generate provider configurations (run after any config changes)
./scripts/setup-providers.sh

# 2. Deploy S3 bucket and configure shared secrets (initial local state)
cd 00-tfstate
terraform init && terraform apply

# 3. Migrate state from local to S3 bucket
# Edit 00-tfstate/providers.tf:
# - Change: #backend "s3" { → backend "s3" {
# - Change: backend "local" { → #backend "local" {
terraform init -migrate-state

# 4. Deploy base infrastructure
cd ../01-tf-base
terraform init && terraform apply

# 5. Deploy virtual machines (includes automatic Ansible configuration)
cd ../02-tf-vm
terraform init && terraform apply
```

### Subsequent Runs

After the initial deployment, all subsequent runs use the S3 backend automatically:
```bash
cd 00-tfstate && terraform init && terraform apply
cd ../01-tf-base && terraform init && terraform apply  
cd ../02-tf-vm && terraform init && terraform apply
```

**Note**: Always run `./scripts/setup-providers.sh` after:
- Cloning the repository
- Changing any variables in `00-tfstate/terraform.auto.tfvars`
- Pulling updates that modify `.template` files

## Configuration

### Terraform Variables

**Configuration Files:**
- `terraform.tfvars`: Non-sensitive configuration (domain, IPs, etc.)
- `secrets.auto.tfvars`: Sensitive credentials (API tokens, passwords)

**Key variables in `secrets.auto.tfvars`:**
- `hcloud_token`: API token for Infrastructure Project (Project 2)
- `hcloud_dns_token`: DNS API token for certificate validation (from Hetzner DNS)
- `s3_access_key` / `s3_secret_key`: S3 credentials from State Storage Project (Project 1)
- `rabbitmq_admin_password`: RabbitMQ admin password
- `rds_root_password` / `rds_app_password`: MySQL passwords

**Variables to configure in `terraform.auto.tfvars` files:**

**Note**: The repository contains example values in `terraform.tfvars` files. Copy these to `terraform.auto.tfvars` and customize with your real values. The `.auto.tfvars` files are automatically loaded by Terraform and excluded from version control.

**In `00-tfstate/terraform.auto.tfvars`:**
- `bucket_prefix`: Your personal prefix for S3 bucket names (e.g., "yourname", "company")
- `project`: Your project name (e.g., "my-company")
- `location`: Hetzner location (e.g., "nbg1", "fsn1", "hel1")
- `minio_domain`: S3 endpoint domain (e.g., "your-objectstorage.com")

**In `01-tf-base/terraform.auto.tfvars`:**
- `cidr_block`: CIDR block for private network (e.g., "10.0.0.0/16")
- `domainname`: Your domain name - must match the DNS zone name in Hetzner DNS
- `user_keys`: SSH public keys for server access
- `allowed_ssh_ips`: IP ranges allowed for SSH access
- `default_image`: OS image for VMs (e.g., "debian-12")
- `volume_size_nfs`: NFS volume size in GB (e.g., 10)
- `volume_size_rds`: RDS volume size in GB (e.g., 10)
- `server_type_*`: Set to `null` to disable services you don't need

**In `02-tf-vm/terraform.auto.tfvars`:**
- `load_balancer_type`: Load balancer size (e.g., "lb11")
- `server_type_*`: VM types for different services (set to `null` to disable)
- `number_instances_sw_web`: Number of Shopware web server instances

### Services

The project supports deployment of:
- **MySQL (Percona 8.0)**: Database server with automated backups
- **Redis**: In-memory caching and session storage
- **RabbitMQ**: Message queue service
- **Elasticsearch**: Search and analytics engine
- **NFS**: Network file system for shared storage

## Security

- All services are deployed in a private network
- Firewall rules restrict access to necessary ports only
- SSH access is limited to specified IP ranges
- SSL/TLS certificates are automatically managed
- Database credentials are user-defined, excluded from version control, but stored in Terraform state

## Contributing

Contributions are not accepted as this is an archived learning project. However, you're welcome to fork the repository and adapt it for your own use cases.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built for exploring Hetzner Cloud infrastructure
- Uses Hetzner Cloud as a cost-effective infrastructure provider
- Inspired by modern DevOps and automation principles

---

**About this project**: This repository represents my learning journey with Hetzner Cloud from April-July 2025. It was developed entirely in my private time to explore Hetzner Cloud's capabilities and is provided as-is for educational and reference purposes.

