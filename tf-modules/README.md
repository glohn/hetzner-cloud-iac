# Terraform Modules

This directory contains reusable Terraform modules for Hetzner Cloud infrastructure components. The modules are organized by functionality and follow consistent patterns for maintainability and reusability.

## Architecture

The modules are organized into four main categories:

```
tf-modules/
├── vpc/                          # Network infrastructure
├── data-stores/                  # Database and storage services
│   ├── nfs/                     # NFS server
│   ├── rds/                     # MySQL (Percona) database
│   └── redis/                   # Redis cache
├── services/                    # Application and infrastructure services
│   ├── vm/                      # Virtual machines
│   ├── certificate/             # SSL/TLS certificates
│   ├── dns/                     # DNS management
│   ├── elasticsearch/           # Elasticsearch service
│   ├── loadbalancer/            # Load balancers
│   ├── rabbitmq/                # RabbitMQ message queue
│   └── ssh/                     # SSH key management
└── global/                      # Cross-cutting concerns
    ├── firewall/                # Firewall rules
    └── firewall-attachment-ssh/ # SSH firewall attachments
```

## Module Categories

### VPC
- **Purpose**: Network infrastructure foundation
- **Components**: Private networks, subnets, network zones
- **Key Features**: CIDR management, multi-subnet support

### Data Stores
- **Purpose**: Database and persistent storage services
- **Components**: MySQL (RDS), Redis, NFS
- **Key Features**: Automated provisioning, volume management, Ansible integration

### Services
- **Purpose**: Application and infrastructure services
- **Components**: VMs, load balancers, DNS, certificates
- **Key Features**: Auto-scaling support, SSL/TLS automation, service discovery

### Global
- **Purpose**: Cross-cutting security and networking concerns
- **Components**: Firewall rules and attachments
- **Key Features**: Centralized security policies

## Module Design Patterns

### Standard Module Structure
Each module follows this structure:
```
module-name/
├── main.tf          # Primary resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
└── versions.tf      # Provider requirements (if needed)
```

### Common Variables
All modules implement these standard variables:
- `project`: Project name for resource naming
- `location`: Hetzner Cloud location (e.g., nbg1, fsn1)
- `network_id`: Private network ID for VPC integration

### Naming Conventions
- **Resources**: `${var.project}-service-name` (e.g., `myproject-rds`)
- **Variables**: Snake case (e.g., `server_type_rds`)
- **Outputs**: Descriptive names matching resource purpose

### Conditional Resource Creation
Many modules support conditional creation using null values:
```hcl
# Module creates resources only if server_type is not null
server_type_rds = null  # Disables RDS creation
server_type_rds = "cx22"  # Enables RDS with cx22 server type
```

## Integration Patterns

### Ansible Integration
Data store and service modules automatically trigger Ansible provisioning:
- Wait for SSH availability
- Execute Ansible playbooks with proper variables
- Clean up temporary SSH keys
- Copy logs to target servers

### Firewall Integration
Services integrate with the global firewall system:
- Each service has dedicated firewall rules
- Firewall IDs passed as variables
- Automatic attachment to servers

### State Dependencies
Modules use Terraform remote state for cross-layer dependencies:
- `01-tf-base` outputs consumed by `02-tf-vm`
- State stored in S3 backend
- Consistent variable passing between layers

## Development Guidelines

### Adding New Modules

1. **Choose the right category** (vpc/data-stores/services/global)
2. **Follow naming conventions** for consistency
3. **Implement standard variables** (project, location, etc.)
4. **Add conditional creation** using null checks
5. **Include proper validation** for variables
6. **Document outputs** clearly

### Variable Validation
Use validation blocks for critical parameters:
```hcl
variable "volume_size_rds" {
  validation {
    condition     = var.volume_size_rds >= 10 && var.volume_size_rds <= 10240
    error_message = "Volume size must be between 10 GB and 10 TB."
  }
}
```

### Security Best Practices
- Mark sensitive variables with `sensitive = true`
- Use private networks for internal communication
- Implement proper firewall rules
- Generate strong passwords automatically

### Testing
- Test conditional resource creation (null vs. defined values)
- Verify Ansible integration works correctly
- Check firewall rule application
- Validate cross-module dependencies

## Usage Examples

### Basic Service Deployment
```hcl
module "rds" {
  source = "../tf-modules/data-stores/rds"
  
  project               = "myproject"
  location              = "nbg1"
  server_type_rds       = "cx22"
  volume_size_rds       = 20
  network_id            = module.vpc.network_id
  firewall_id_rds       = module.firewall.firewall_id_rds
  # ... other required variables
}
```

### Conditional Deployment
```hcl
# Enable or disable services via variables
server_type_rds       = var.enable_database ? "cx22" : null
server_type_redis     = var.enable_cache ? "cx11" : null
```

## Troubleshooting

### Common Issues
- **Ansible provisioning fails**: Check SSH key configuration and network connectivity
- **Firewall blocking access**: Verify firewall rules and attachments
- **Resource creation skipped**: Check if conditional variables are set to null
- **State dependencies**: Ensure proper module execution order

### Debugging
- Use `terraform plan` to verify resource creation
- Check Ansible logs in `/var/log/ansible.log` on target servers
- Verify network connectivity with `terraform console`
- Review firewall rules in Hetzner Cloud console

## Contributing

When contributing new modules or modifications:
1. Follow the established patterns and conventions
2. Add proper validation and error handling
3. Test with both enabled and disabled configurations
4. Update this documentation if adding new categories
5. Ensure Ansible integration works correctly

---

**Note**: These modules are designed specifically for Hetzner Cloud and may require adaptation for other cloud providers. 