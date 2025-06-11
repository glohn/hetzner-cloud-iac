# Hetzner Cloud Infrastructure as Code

## Overview

This project provides Infrastructure as Code (IaC) templates for provisioning and managing infrastructure on Hetzner Cloud using Terraform and Ansible. It includes modules for common infrastructure components like databases, message queues, caching, and networking.

## Features

- **Terraform Modules**: Reusable infrastructure components
- **Ansible Playbooks**: Configuration management and service deployment
- **Multi-Service Support**: Redis, RabbitMQ, MySQL (Percona), Elasticsearch, NFS
- **Network Security**: Firewall rules and VPC configuration
- **SSL/TLS**: Automated certificate management
- **State Management**: Terraform state handling with S3 backend

## Architecture

```
├── 00-tfstate/           # Terraform state management
├── 01-tf-base/           # Base infrastructure (VPC, DNS, etc.)
├── 02-tf-vm/             # Virtual machine provisioning
├── tf-modules/           # Reusable Terraform modules
├── ansible/              # Configuration management
└── scripts/              # Helper scripts
```

## Prerequisites

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
   
   > **Security Rationale**: S3 credentials in Hetzner Cloud grant access to the entire project. By separating state storage from infrastructure, we ensure that deployed services cannot access Terraform state files, which may contain sensitive information.

2. **Required Tools**
   - [Terraform](https://www.terraform.io/) >= 1.0
   - [Ansible](https://www.ansible.com/) >= 2.9
   - SSH client for server access

3. **DNS Configuration**
   
   **Important**: The domain/subdomain used must be managed by Hetzner DNS for automated certificate validation to work.
   
   **Option A - Full Domain**:
   - Transfer your domain's DNS management to Hetzner Cloud DNS
   
   **Option B - Subdomain (Recommended)**:
   - Create a subdomain (e.g., `hcloud.yourdomain.com`)
   - At your current DNS provider, set NS records for the subdomain to point to Hetzner's nameservers
   - Configure Hetzner DNS to manage only this subdomain
   
   **Required**:
   - Hetzner DNS API token for automated certificate validation
   - Domain/subdomain configured in Hetzner Cloud DNS

## Quick Start

1. **Clone and prepare the repository**
   ```bash
   git clone https://github.com/glohn/hetzner-cloud-iac.git
   cd hetzner-cloud-iac
   ```

2. **Configure variables**
   ```bash
   # IMPORTANT: Copy and configure secrets file with your actual credentials
   cp 00-tfstate/secrets.auto.tfvars.example 00-tfstate/secrets.auto.tfvars
   
   # Edit secrets.auto.tfvars with your actual values:
   # - API tokens (Hetzner Cloud & DNS)
   # - S3 credentials 
   # - Service passwords
   
   # Edit existing terraform.tfvars files in each directory with your values
   # (these files already exist with example/placeholder values)
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

**Key variables in `terraform.tfvars`:**
- `domainname`: Your domain name
- `user_keys`: SSH public keys for server access
- `allowed_ssh_ips`: IP ranges allowed for SSH access

### Service Configuration

The project supports deployment of:
- **MySQL (Percona 8.0)**: Database server with automated backups
- **Redis**: In-memory caching and session storage
- **RabbitMQ**: Message queue service
- **Elasticsearch**: Search and analytics engine
- **NFS**: Network file system for shared storage

## Security

- All services are deployed within a private VPC
- Firewall rules restrict access to necessary ports only
- SSH access is limited to specified IP ranges
- SSL/TLS certificates are automatically managed
- Database credentials are securely generated

## Contributing

Contributions are not accepted as this is an archived learning project. However, you're welcome to fork the repository and adapt it for your own use cases.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built for exploring Hetzner Cloud infrastructure
- Uses Hetzner Cloud as a cost-effective infrastructure provider
- Inspired by modern DevOps and automation principles

---

**About this project**: This repository represents my learning journey with Hetzner Cloud from April-June 2025. It was developed entirely in my private time to explore Hetzner Cloud's capabilities and is provided as-is for educational and reference purposes.

