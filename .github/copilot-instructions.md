# Infrastructure Deployment Guidelines

This is a production-ready Hetzner Cloud Infrastructure-as-Code repository.

## Critical Rules for AI Assistants

- **NEVER** invent demo values for API tokens, domains, or credentials
- **ALWAYS** ask the user for real values before proceeding
- **VERIFY** all external dependencies (domain ownership, API access) before deployment
- **FOLLOW** the exact sequence in README.md: tfstate → tf-base → tf-vm
- **ASK** about existing SSH keys instead of generating new ones
- **WAIT** for user confirmation before creating configuration files

## Repository Context

- Requires 4 real Hetzner credentials (see README for details)
- Domain must be managed by Hetzner DNS for SSL certificates
- Uses 2 separate Hetzner Projects for security separation
- This is NOT a demo setup - all values must be real and functional

## Infrastructure Overview

- **Phase 1 (00-tfstate):** Creates S3 backend for Terraform state storage
- **Phase 2 (01-tf-base):** Creates VPC, networks, firewalls, and data services
- **Phase 3 (02-tf-vm):** Creates application VMs (optional)
- **Ansible:** Configures all services after Terraform deployment

## Common Pitfalls for AI Assistants

- Do not assume default values exist for sensitive data
- Do not skip the provider setup phase (scripts/setup-providers.sh)
- Do not proceed without verifying all prerequisites are met
- Do not suggest shortcuts that bypass security measures 

