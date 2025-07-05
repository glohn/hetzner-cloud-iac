# Hetzner Cloud Infrastructure as Code

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
└── scripts/              # Helper scripts
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
   - [Terraform](https://www.terraform.io/) >= 1.0
   - [Ansible](https://www.ansible.com/) >= 2.9
   - SSH client for server access

3. **DNS Configuration**
   
   **Important**: The domain/subdomain used must be managed by Hetzner DNS for automated certificate validation to work.
   
   **Option A - Full Domain**:
   - Transfer your domain's DNS management to Hetzner Cloud DNS
   - Go to [Hetzner DNS Console](https://dns.hetzner.com/)
   - Add your domain as a DNS zone
   - Update nameservers at your domain registrar to point to Hetzner's nameservers
   
   **Option B - Subdomain (Recommended)**:
   - Go to [Hetzner DNS Console](https://dns.hetzner.com/)
   - Add your main domain as a DNS zone (e.g., `example.com`)
   - At your current DNS provider, set NS records for the subdomain `hcloud.yourdomain.com` to point to Hetzner's nameservers
   - This delegates only the `hcloud.*` subdomain to Hetzner while keeping the main domain elsewhere
   
   **Required Steps**:
   1. Create a DNS zone in [Hetzner DNS Console](https://dns.hetzner.com/) (e.g., `example.com`)
   2. Configure NS records at your DNS provider: `hcloud.example.com` → Hetzner nameservers
   3. Set `domainname` in `01-tf-base/terraform.tfvars` to match the DNS zone name (e.g., `example.com`)
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
- [ ] **Domain name**: Set in `01-tf-base/terraform.tfvars` to match DNS zone name
- [ ] All **4 secrets** copied to `00-tfstate/secrets.auto.tfvars` (2 API tokens + 2 S3 credentials)

**Security Note**: Never commit the `secrets.auto.tfvars` file to version control. It's already in `.gitignore`.

## Quick Start

1. **Clone and prepare the repository**
   ```bash
   git clone https://github.com/glohn/hetzner-cloud-iac.git
   cd hetzner-cloud-iac
   ```

2. **Configure secrets and variables**
   ```bash
   # STEP 1: Create secrets file with your 4 API tokens/credentials
   cp 00-tfstate/secrets.auto.tfvars.example 00-tfstate/secrets.auto.tfvars
   
   # STEP 2: Edit secrets.auto.tfvars with your actual values:
   # - hcloud_token: Your Hetzner Cloud API token  
   # - hcloud_dns_token: Your Hetzner DNS API token
   # - s3_access_key: Your S3 Access Key ID
   # - s3_secret_key: Your S3 Secret Access Key
   # - Service passwords: Change to your own secure passwords
   
   # STEP 3: Configure basic settings in terraform.tfvars files
   # Edit these files with your domain, SSH keys, etc.:
   # - 00-tfstate/terraform.tfvars (project name, S3 domain)
   # - 01-tf-base/terraform.tfvars (domain, SSH keys, IP ranges)
   # - 02-tf-vm/terraform.tfvars (VM configuration)
   ```

3. **Initialize and apply infrastructure**
   ```bash
   # Start with state management
   cd 00-tfstate
   terraform init && terraform apply

   # Deploy base infrastructure
   cd ../01-tf-base
   terraform init && terraform apply

   # Deploy virtual machines (includes automatic Ansible configuration)
   cd ../02-tf-vm
   terraform init && terraform apply
   ```
   
   > **Note**: Ansible configuration is automatically triggered by Terraform during the VM deployment phase.

## Bootstrap Process

**Important**: The first deployment requires a special bootstrap process due to the S3 backend configuration.

### Prerequisites for Bootstrap

Before starting the bootstrap process, ensure the S3 backend configuration is properly set:

1. **Update bucket names in all `providers.tf` files**:
   - `00-tfstate/providers.tf`: Set correct bucket name and S3 endpoint
   - `01-tf-base/providers.tf`: Set correct bucket name and S3 endpoint  
   - `02-tf-vm/providers.tf`: Set correct bucket name and S3 endpoint

2. **Configure AWS profile** (optional but recommended):
   ```bash
   # Create ~/.aws/credentials with your Hetzner S3 credentials
   [hetzner-s3-tfstate]
   aws_access_key_id = your_s3_access_key
   aws_secret_access_key = your_s3_secret_key
   ```

### Initial Setup (First Run)

1. **Prepare the state management backend**
   ```bash
   cd 00-tfstate
   
   # Edit providers.tf: Comment out the S3 backend and uncomment local backend
   # Change from:
   #   backend "s3" { ... }
   # To:
   #   backend "local" {
   #     path = "terraform.tfstate"
   #   }
   
   terraform init
   terraform apply
   ```

2. **Migrate to S3 backend**
   ```bash
   # After successful S3 bucket creation, edit providers.tf again:
   # Comment out local backend and uncomment S3 backend
   
   terraform init --migrate-state
   
   # Verify migration worked
   terraform plan  # Should show no changes
   ```

3. **Continue with infrastructure deployment**
   ```bash
   # Now proceed with base infrastructure
   cd ../01-tf-base
   terraform init && terraform apply
   
   # Deploy VMs
   cd ../02-tf-vm  
   terraform init && terraform apply
   ```

### Subsequent Runs

After the initial bootstrap, all subsequent runs use the S3 backend automatically:
```bash
cd 00-tfstate && terraform init && terraform apply
cd ../01-tf-base && terraform init && terraform apply  
cd ../02-tf-vm && terraform init && terraform apply
```

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

**Variables in `terraform.tfvars` files:**

**In `00-tfstate/terraform.tfvars`:**
- `project`: Your project name (e.g., "my-company")
- `location`: Hetzner location (e.g., "nbg1", "fsn1", "hel1")
- `minio_domain`: S3 endpoint domain (e.g., "nbg1.your-objectstorage.com")

**In `01-tf-base/terraform.tfvars`:**
- `cidr_block`: CIDR block for private network (e.g., "10.0.0.0/16")
- `domainname`: Your domain name - must match the DNS zone name in Hetzner DNS
- `user_keys`: SSH public keys for server access
- `allowed_ssh_ips`: IP ranges allowed for SSH access
- `default_image`: OS image for VMs (e.g., "debian-12")
- `volume_size_nfs`: NFS volume size in GB (e.g., 10)
- `volume_size_rds`: RDS volume size in GB (e.g., 10)
- `server_type_*`: Set to `null` to disable services you don't need

**In `02-tf-vm/terraform.tfvars`:**
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

