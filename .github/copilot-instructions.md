# Infrastructure Deployment Guidelines

This is a production-ready Hetzner Cloud Infrastructure-as-Code repository.

## Critical Rules for AI Assistants

- **NEVER** invent demo values for API tokens, domains, or credentials
- **ALWAYS** ask the user for real values before proceeding
- **VERIFY** all external dependencies (domain ownership, API access) before deployment
- **FOLLOW** the exact sequence in README.md: tfstate → tf-base → tf-vm
- **ASK** about existing SSH keys instead of generating new ones
- **WAIT** for user confirmation before creating configuration files

## File Handling Guidelines

- **OPEN files for user editing** instead of making programmatic changes
- **NEVER use command-line editors** (nano, vim, etc.) when interactive editing is expected
- **ALWAYS show file contents** when user needs to edit configuration files
- **LET USER EDIT** sensitive configuration instead of trying to automate it
- **CREATE .auto.tfvars files** by copying from templates, then open for user editing
- **PREFER interactive editing** over automated file modifications for credentials

## Repository Context

- Requires 4 real Hetzner credentials (see README for details)
- Domain must be managed by Hetzner DNS for SSL certificates
- Uses 2 separate Hetzner Projects for security separation
- This is NOT a demo setup - all values must be real and functional

## Infrastructure Overview

- **Phase 1 (00-tfstate):** Creates S3 backend for Terraform state storage
- **Phase 2 (01-tf-base):** Creates VPC, networks, firewalls
- **Phase 3 (02-tf-vm):** Creates application VMs (optional)
- **Phase 4 (Optional):** Enable services one by one after basic infrastructure works
- **Ansible:** Configures all services after Terraform deployment

## Common Pitfalls for AI Assistants

- Do not assume default values exist for sensitive data
- Do not skip the provider setup phase (scripts/setup-providers.sh)
- Do not proceed without verifying all prerequisites are met
- Do not suggest shortcuts that bypass security measures
- Do not use command-line editors when interactive editing is expected
- Do not automate sensitive credential entry

## Service Enablement Rules

**DETECT initial setup automatically by checking:**
- No `.auto.tfvars` files exist yet (they need to be copied from templates)
- No `providers.tf` files exist yet (setup-providers.sh not run)
- No terraform state files exist yet (never been deployed)

**IF initial setup detected:**
- Keep ALL server_type_* variables as null (disabled)
- Focus on base infrastructure only (VPC, DNS, networking)
- Let user test basic infrastructure before enabling services

**IF infrastructure already exists:**
- Services can be enabled/disabled as requested by user
- User has working base infrastructure and knows what they're doing
- Normal service management applies

