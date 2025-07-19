################################
# Hetzner Cloud Infrastructure #
# Version: 1.0.0               #
# Created by: Guido Lohn       #
# Last modified: 2025-07-18    #
################################

VERSION = 1.0.0

.DEFAULT_GOAL := help

.PHONY: setup check-prerequisites create-files configure-secrets configure-base configure-tfstate setup-providers deploy clean help

# ======================
# HELP & INFORMATION
# ======================

help: ## Show this help message
	@printf "\n\033[1m\033[36mHetzner Cloud Infrastructure Setup (v$(VERSION))\033[0m\n\n"
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  \033[36mmake\033[0m \033[33m<target>\033[0m\n\nTargets:\n"} \
	/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@printf "\n\033[1mQuick Start (mandatory order):\033[0m\n"
	@printf "  1. \033[33mmake setup\033[0m   (REQUIRED: interactive configuration)\n"
	@printf "  2. \033[33mmake deploy\033[0m  (automated deployment)\n\n"

# ======================
# MAIN TARGETS
# ======================

setup: check-prerequisites create-files configure-secrets configure-base configure-tfstate setup-providers ## Complete interactive setup process
	@echo ""
	@printf "\033[32mSetup completed successfully!\033[0m\n"
	@echo ""
	@printf "\033[1m===============================================\033[0m\n"
	@printf "\033[1mNEXT STEPS - DEPLOYMENT PROCESS:\033[0m\n"
	@printf "\033[1m===============================================\033[0m\n"
	@echo ""
	@echo "1. DEPLOY STATE STORAGE (initial local state):"
	@echo "   cd 00-tfstate"
	@echo "   terraform init && terraform apply"
	@echo ""
	@echo "2. MIGRATE TO S3 BACKEND:"
	@echo "   Edit 00-tfstate/providers.tf:"
	@echo "   - Change: #backend \"s3\" { → backend \"s3\" {"
	@echo "   - Change: backend \"local\" { → #backend \"local\" {"
	@echo "   terraform init -migrate-state"
	@echo ""
	@echo "3. DEPLOY BASE INFRASTRUCTURE:"
	@echo "   cd ../01-tf-base"
	@echo "   terraform init && terraform apply"
	@echo ""
	@echo "4. DEPLOY VIRTUAL MACHINES:"
	@echo "   cd ../02-tf-vm"
	@echo "   terraform init && terraform apply"
	@echo ""
	@printf "\033[1m===============================================\033[0m\n"
	@printf "\033[32mAll credentials collected - ready to deploy!\033[0m\n"
	@printf "\033[33mTIP: Run 'make deploy' for automated deployment\033[0m\n"
	@printf "\033[1m===============================================\033[0m\n"

deploy: ## Deploy infrastructure (automated deployment process)
	@echo ""
	@printf "\033[36mStarting infrastructure deployment...\033[0m\n"
	@echo ""
	@printf "\033[36mValidating setup prerequisites...\033[0m\n"
	@if [ ! -f "00-tfstate/secrets.auto.tfvars" ]; then \
		printf "\033[31msecrets.auto.tfvars not found. Run 'make setup' first.\033[0m\n"; \
		exit 1; \
	fi
	@if [ ! -f "00-tfstate/terraform.auto.tfvars" ]; then \
		printf "\033[31m00-tfstate/terraform.auto.tfvars not found. Run 'make setup' first.\033[0m\n"; \
		exit 1; \
	fi
	@if [ ! -f "01-tf-base/terraform.auto.tfvars" ]; then \
		printf "\033[31m01-tf-base/terraform.auto.tfvars not found. Run 'make setup' first.\033[0m\n"; \
		exit 1; \
	fi
	@if [ ! -f "02-tf-vm/terraform.auto.tfvars" ]; then \
		printf "\033[31m02-tf-vm/terraform.auto.tfvars not found. Run 'make setup' first.\033[0m\n"; \
		exit 1; \
	fi
	@if [ ! -f "00-tfstate/providers.tf" ]; then \
		printf "\033[31mproviders.tf files not found. Run 'make setup' first.\033[0m\n"; \
		exit 1; \
	fi
	@if [ ! -f "01-tf-base/providers.tf" ]; then \
		printf "\033[31mproviders.tf files not found. Run 'make setup' first.\033[0m\n"; \
		exit 1; \
	fi
	@if [ ! -f "02-tf-vm/providers.tf" ]; then \
		printf "\033[31mproviders.tf files not found. Run 'make setup' first.\033[0m\n"; \
		exit 1; \
	fi
	@printf "\033[32mAll setup prerequisites satisfied\033[0m\n"
	@echo ""
	@printf "\033[33mStep 1/4: Deploy state storage...\033[0m\n"
	@cd 00-tfstate && terraform init && terraform apply -auto-approve
	@if [ $$? -eq 0 ]; then \
		echo ""; \
		printf "\033[33mStep 1.5/4: Switching to S3 backend...\033[0m\n"; \
		sed -i -e 's/^  #backend "s3" {/  backend "s3" {/' \
		       -e 's/^  #  /    /' \
		       -e 's/^  #}/  }/' \
		       -e 's/^  backend "local" {/  #backend "local" {/' \
		       -e 's/^    path = "terraform.tfstate"/  #  path = "terraform.tfstate"/' \
		       -e '/^  #  path = "terraform.tfstate"$$/,/^  }$$/ s/^  }/  #}/' \
		       00-tfstate/providers.tf; \
		echo ""; \
		printf "\033[33mStep 2/4: Migrate state to S3...\033[0m\n"; \
	else \
		printf "\033[31mStep 1 failed. Stopping deployment.\033[0m\n"; \
		exit 1; \
	fi
	@cd 00-tfstate && echo "yes" | terraform init -migrate-state
	@echo ""
	@printf "\033[33mStep 3/4: Deploy base infrastructure...\033[0m\n"
	@cd 01-tf-base && terraform init && terraform apply -auto-approve
	@echo ""
	@printf "\033[33mStep 4/4: Deploy virtual machines...\033[0m\n"
	@cd 02-tf-vm && terraform init && terraform apply -auto-approve
	@echo ""
	@printf "\033[32mDeployment completed successfully!\033[0m\n"

# ======================
# UTILITY TARGETS
# ======================

check-prerequisites: ## Check if required tools are installed
	@printf "\033[36mChecking prerequisites...\033[0m\n"
	@command -v terraform >/dev/null || { printf "\033[31mTerraform not found. Please install Terraform >= 1.10, < 1.11.2\033[0m\n"; exit 1; }
	@terraform_version=$$(terraform version | head -1 | sed 's/Terraform v//'); \
	case "$$terraform_version" in \
		1.10.*|1.11.0|1.11.1) echo "Found Terraform $$terraform_version" ;; \
		*) printf "\033[31mTerraform $$terraform_version incompatible. Required: >= 1.10, < 1.11.2\033[0m\n"; exit 1 ;; \
	esac
	@command -v ansible >/dev/null || { printf "\033[31mAnsible not found. Please install Ansible >= 2.9\033[0m\n"; exit 1; }
	@ansible_version=$$(ansible --version | head -1 | sed 's/ansible \[core //; s/\].*//; s/ansible //'); \
	echo "Found Ansible $$ansible_version"
	@command -v curl >/dev/null || { printf "\033[31mcurl not found. Please install curl\033[0m\n"; exit 1; }
	@curl_version=$$(curl --version | head -1 | sed 's/curl //; s/ (.*//' ); \
	echo "Found curl $$curl_version"
	@printf "\033[32mAll prerequisites satisfied\033[0m\n"

clean: ## Remove all generated .auto.tfvars and providers.tf files
	@printf "\033[36mCleaning generated files...\033[0m\n"
	@rm -f 00-tfstate/secrets.auto.tfvars
	@rm -f 00-tfstate/terraform.auto.tfvars
	@rm -f 01-tf-base/terraform.auto.tfvars
	@rm -f 02-tf-vm/terraform.auto.tfvars
	@rm -f 00-tfstate/providers.tf
	@rm -f 01-tf-base/providers.tf
	@rm -f 02-tf-vm/providers.tf
	@printf "\033[32mCleaned all generated files\033[0m\n"

# ======================
# INTERNAL TARGETS
# ======================

create-files: ## Create terraform.auto.tfvars files from templates
	@printf "\033[36mCreating terraform.auto.tfvars files...\033[0m\n"
	@cp 00-tfstate/terraform.tfvars 00-tfstate/terraform.auto.tfvars
	@cp 01-tf-base/terraform.tfvars 01-tf-base/terraform.auto.tfvars
	@cp 02-tf-vm/terraform.tfvars 02-tf-vm/terraform.auto.tfvars
	@printf "\033[32mCreated all terraform.auto.tfvars files\033[0m\n"

configure-secrets: ## Collect API credentials interactively
	@echo ""
	@printf "\033[36mCollecting API credentials interactively...\033[0m\n"
	@echo ""
	@echo "You need 4 credentials from Hetzner Cloud:"
	@echo "1. Hetzner Cloud API Token (from Infrastructure Project)"
	@echo "2. Hetzner DNS API Token (from Hetzner DNS Console)"  
	@echo "3. S3 Access Key (from State Storage Project)"
	@echo "4. S3 Secret Key (from State Storage Project)"
	@echo ""
	@read -p "Enter Hetzner Cloud API Token: " hcloud_token; \
	read -p "Enter Hetzner DNS API Token: " hcloud_dns_token; \
	read -p "Enter S3 Access Key: " s3_access_key; \
	read -p "Enter S3 Secret Key: " s3_secret_key; \
	echo ""; \
	echo "Setting service passwords (you can change these later)..."; \
	read -p "RabbitMQ admin password [SecureRabbitMQ2025!]: " rabbitmq_password; \
	rabbitmq_password=$${rabbitmq_password:-SecureRabbitMQ2025!}; \
	read -p "MySQL root password [SecureMySQL2025!]: " rds_root_password; \
	rds_root_password=$${rds_root_password:-SecureMySQL2025!}; \
	read -p "MySQL app password [SecureApp2025!]: " rds_app_password; \
	rds_app_password=$${rds_app_password:-SecureApp2025!}; \
	echo ""; \
	echo "Writing secrets to 00-tfstate/secrets.auto.tfvars..."; \
	echo "# Generated by make setup - DO NOT COMMIT TO VERSION CONTROL" > 00-tfstate/secrets.auto.tfvars; \
	echo "# Fill in your actual Hetzner Cloud credentials below" >> 00-tfstate/secrets.auto.tfvars; \
	echo "" >> 00-tfstate/secrets.auto.tfvars; \
	echo "s3_access_key    = \"$$s3_access_key\"" >> 00-tfstate/secrets.auto.tfvars; \
	echo "s3_secret_key    = \"$$s3_secret_key\"" >> 00-tfstate/secrets.auto.tfvars; \
	echo "hcloud_token     = \"$$hcloud_token\"" >> 00-tfstate/secrets.auto.tfvars; \
	echo "hcloud_dns_token = \"$$hcloud_dns_token\"" >> 00-tfstate/secrets.auto.tfvars; \
	echo "" >> 00-tfstate/secrets.auto.tfvars; \
	echo "# Service Passwords (usernames = project name)" >> 00-tfstate/secrets.auto.tfvars; \
	echo "rabbitmq_admin_password = \"$$rabbitmq_password\"" >> 00-tfstate/secrets.auto.tfvars; \
	echo "rds_root_password       = \"$$rds_root_password\"" >> 00-tfstate/secrets.auto.tfvars; \
	echo "rds_app_password        = \"$$rds_app_password\"" >> 00-tfstate/secrets.auto.tfvars; \
	printf "\033[32mSuccessfully created 00-tfstate/secrets.auto.tfvars with your credentials\033[0m\n"

configure-base: ## Configure base infrastructure (domain, SSH keys, IPs)
	@echo ""
	@printf "\033[36mConfiguring base infrastructure...\033[0m\n"
	@read -p "Enter your domain name: " domain; \
	current_ip=$$(curl -s -4 ifconfig.me 2>/dev/null || echo "0.0.0.0"); \
	echo "Current IP detected: $$current_ip"; \
	read -p "Use current IP ($$current_ip) for SSH access? [Y/n]: " use_ip; \
	if [ "$$use_ip" = "n" ] || [ "$$use_ip" = "N" ]; then \
		read -p "Enter allowed SSH IP (format: x.x.x.x/32): " ssh_ip; \
	else \
		ssh_ip="$$current_ip/32"; \
	fi; \
	echo "Available SSH keys:"; \
	ls ~/.ssh/*.pub 2>/dev/null | head -5 || echo "No SSH keys found in ~/.ssh/"; \
	read -p "Enter SSH key filename [id_ed25519.pub]: " keyfile; \
	keyfile=$${keyfile:-id_ed25519.pub}; \
	if [ -f "$$HOME/.ssh/$$keyfile" ]; then \
		key_content=$$(cat "$$HOME/.ssh/$$keyfile"); \
		key_user=$$(echo "$$key_content" | awk '{print $$3}' | cut -d'@' -f1); \
		sed -i "/domainname[[:space:]]*=/ s/\"[^\"]*\"/\"$$domain\"/" 01-tf-base/terraform.auto.tfvars; \
		sed -i 's|"[^"]*" = "ssh-[^"]*"|"'"$$key_user"'" = "'"$$key_content"'"|' 01-tf-base/terraform.auto.tfvars; \
		sed -i '/allowed_ssh_ips = \[/,/\]/c\
allowed_ssh_ips = [\
  "'"$$ssh_ip"'"\
]' 01-tf-base/terraform.auto.tfvars; \
		printf "\033[32mConfigured 01-tf-base/terraform.auto.tfvars\033[0m\n"; \
	else \
		printf "\033[31mSSH key file not found: ~/.ssh/$$keyfile\033[0m\n"; \
		exit 1; \
	fi

configure-tfstate: ## Configure tfstate settings (project, bucket, location)
	@echo ""
	@printf "\033[36mConfiguring tfstate settings...\033[0m\n"
	@read -p "Enter project name: " project; \
	read -p "Enter bucket prefix (e.g. your-name): " bucket_prefix; \
	read -p "Enter Hetzner location [nbg1]: " location; \
	location=$${location:-nbg1}; \
	s3_domain="your-objectstorage.com"; \
	sed -i "/project[[:space:]]*=/ s/\"[^\"]*\"/\"$$project\"/" 00-tfstate/terraform.auto.tfvars; \
	sed -i "/bucket_prefix[[:space:]]*=/ s/\"[^\"]*\"/\"$$bucket_prefix\"/" 00-tfstate/terraform.auto.tfvars; \
	sed -i "/location[[:space:]]*=/ s/\"[^\"]*\"/\"$$location\"/" 00-tfstate/terraform.auto.tfvars; \
	sed -i "/minio_domain[[:space:]]*=/ s/\"[^\"]*\"/\"$$s3_domain\"/" 00-tfstate/terraform.auto.tfvars; \
	printf "\033[32mConfigured 00-tfstate/terraform.auto.tfvars\033[0m\n"

setup-providers: ## Generate provider configurations from templates
	@echo ""
	@printf "\033[36mSetting up provider configurations...\033[0m\n"
	@if [ -f "./scripts/setup-providers.sh" ]; then \
		chmod +x ./scripts/setup-providers.sh; \
		./scripts/setup-providers.sh; \
		printf "\033[32mGenerated providers.tf files\033[0m\n"; \
	else \
		printf "\033[31mscripts/setup-providers.sh not found\033[0m\n"; \
		exit 1; \
	fi

 