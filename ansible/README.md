# Ansible Configuration Management

This directory contains Ansible playbooks and roles for automated configuration management of Hetzner Cloud infrastructure. The Ansible setup is tightly integrated with Terraform modules and provides automated service deployment and configuration.

## Architecture

```
ansible/
├── ansible.cfg              # Ansible configuration
├── *.yml                   # Service-specific playbooks
├── playbooks/              # Additional playbooks
│   └── install_docker.yml  # Docker installation
└── roles/                  # Ansible roles
    ├── base/               # Base system configuration
    ├── user-management/    # SSH key and user management
    ├── elasticsearch/      # Elasticsearch service
    ├── nfs/                # NFS server
    ├── rabbitmq/           # RabbitMQ message queue
    ├── rds/                # MySQL (Percona) database
    └── redis/              # Redis cache
```

## Integration with Terraform

### Automatic Provisioning
Ansible is automatically triggered by Terraform modules during infrastructure deployment:

1. **VM Creation**: Terraform creates VMs and waits for SSH availability
2. **Ansible Execution**: Terraform executes Ansible playbooks with proper variables
3. **Log Management**: Ansible logs are copied to target servers (`/var/log/ansible.log`)
4. **Cleanup**: Temporary SSH keys are automatically removed

### Variable Passing
Terraform passes configuration variables to Ansible:
- Service passwords (RDS, RabbitMQ)
- Network configuration (bind IPs, subnets)
- User SSH keys (base64 encoded)
- Volume device paths for data stores

### Example Integration
```hcl
# In Terraform module
resource "null_resource" "ansible_provision" {
  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -i '${server_ip},' \
      --private-key=/tmp/ansible_key \
      --extra-vars="rds_root_password=${var.rds_root_password}" \
      ../ansible/rds.yml
    EOT
  }
}
```

## Playbooks

### Service Playbooks
Each service has a dedicated playbook that follows a consistent pattern:

- **rds.yml**: MySQL (Percona 8.0) database server
- **redis.yml**: Redis cache server
- **rabbitmq.yml**: RabbitMQ message queue
- **elasticsearch.yml**: Elasticsearch search engine
- **nfs.yml**: NFS file server

### Playbook Structure
```yaml
- name: Deploy Service
  hosts: all
  become: true
  vars:
    service_specific_vars: "{{ service_specific_vars }}"
  roles:
    - base              # Always first
    - user-management   # SSH key management
    - service-role      # Service-specific role
```

## Roles

### Core Roles

#### base
- **Purpose**: Essential system configuration for all servers
- **Features**: Package updates, timezone, bash configuration, fail2ban
- **Documentation**: See `roles/base/README.md`

#### user-management
- **Purpose**: SSH key and user account management
- **Features**: Deploys user SSH keys from Terraform variables
- **Integration**: Receives base64-encoded SSH keys from Terraform

### Service Roles

#### rds (MySQL/Percona)
- **Purpose**: MySQL 8.0 (Percona) database server
- **Features**: Database installation, user creation, volume mounting
- **Configuration**: Root and application passwords from Terraform

#### redis
- **Purpose**: Redis cache server
- **Features**: Redis installation, configuration, security
- **Network**: Binds to private network interface

#### rabbitmq
- **Purpose**: RabbitMQ message queue
- **Features**: RabbitMQ installation, admin user creation
- **Management**: Web management interface enabled

#### elasticsearch
- **Purpose**: Elasticsearch search engine
- **Features**: Elasticsearch installation and configuration
- **Security**: Basic authentication and network binding

#### nfs
- **Purpose**: NFS file server
- **Features**: NFS server setup, export configuration
- **Storage**: Volume mounting and export management

## Configuration

### Ansible Configuration (`ansible.cfg`)
```ini
[defaults]
log_path = /tmp/ansible.log
log_level = INFO
```

### SSH Configuration
- **Key Management**: Temporary SSH keys generated by Terraform
- **Host Key Checking**: Disabled for automated deployment
- **User**: Root user for system configuration

### Logging
- **Local Logs**: `/tmp/ansible-<service>.log` during execution
- **Remote Logs**: Copied to `/var/log/ansible.log` on target servers
- **Log Level**: INFO for debugging and audit trails

## Known Limitations

The following improvements have been identified for the Ansible roles:

### Template-based Configuration
- **Current**: Uses `lineinfile` modules for configuration changes
- **Improvement**: Replace with proper Jinja2 templates for better maintainability

### Idempotency
- **Current**: Most tasks are idempotent but could be improved
- **Improvement**: Ensure all tasks can be run multiple times safely

### Variables and Flexibility
- **Current**: Basic variable management
- **Improvement**: Better variable organization and role customization options

### Performance Optimizations
- **Current**: Standard execution time
- **Improvement**: Optimize role execution and resource usage

### Health Checks and Validation
- **Current**: Basic service installation
- **Improvement**: Add validation tasks to verify service status and functionality

### Logging and Monitoring
- **Current**: Basic logging configuration
- **Improvement**: Standardize logging across roles (preparation for Loki integration)

### Security Improvements
- **Current**: Basic security configuration
- **Improvement**: Harden service configurations and permissions

### Error Handling
- **Current**: Basic error handling
- **Improvement**: Better error handling and recovery mechanisms

## Usage Examples

### Manual Playbook Execution
```bash
# Run specific service playbook
ansible-playbook -i 'server-ip,' --private-key=~/.ssh/key rds.yml

# With extra variables
ansible-playbook -i 'server-ip,' \
  --extra-vars="rds_root_password=secret123" \
  rds.yml
```

### Docker Installation
```bash
# Install Docker on existing servers
ansible-playbook -i inventory playbooks/install_docker.yml
```

## Troubleshooting

### Common Issues

#### SSH Connection Problems
- **Symptom**: Ansible cannot connect to servers
- **Solution**: Check SSH keys, network connectivity, and firewall rules
- **Debug**: Use `ansible -m ping` to test connectivity

#### Service Configuration Failures
- **Symptom**: Services fail to start after configuration
- **Solution**: Check service logs and Ansible logs
- **Debug**: Manually verify configuration files

#### Variable Passing Issues
- **Symptom**: Variables not properly passed from Terraform
- **Solution**: Check Terraform extra-vars formatting
- **Debug**: Add debug tasks to verify variable values

### Debugging

#### Log Analysis
```bash
# Check Ansible execution logs
tail -f /tmp/ansible-<service>.log

# Check service logs on target server
journalctl -u <service-name> -f

# Check copied Ansible logs on server
tail -f /var/log/ansible.log
```

#### Manual Testing
```bash
# Test individual tasks
ansible-playbook --tags="install" playbook.yml

# Dry run mode
ansible-playbook --check playbook.yml

# Verbose output
ansible-playbook -vvv playbook.yml
```

## Development Guidelines

### Adding New Roles
1. **Create role structure manually**: Follow the existing pattern (tasks/, defaults/, handlers/, templates/)
2. **Follow project naming conventions**: Use service-name for role names
3. **Include base dependencies**: Always use `base` and `user-management` roles first
4. **Add role-specific README.md**: Document the role's purpose and variables
5. **Test with Terraform integration**: Ensure the role works with the Terraform provisioning

### Project-Specific Patterns
- Roles are manually created, not generated with ansible-galaxy
- All roles follow the same execution pattern: base → user-management → service
- Configuration is passed from Terraform via extra-vars
- Temporary SSH keys are managed by Terraform, not Ansible
- All roles must work with Debian 12 (Bookworm)

## Future Improvements

### Planned Enhancements
- **Production Readiness**: Review and harden all roles for production use
- **Template Migration**: Replace lineinfile with Jinja2 templates
- **Observability**: Integrate with Loki/Grafana stack
- **Backup Integration**: Add automated backup solutions
- **Cloud-init Migration**: Move from cloud-init to Ansible-based provisioning

### Integration Opportunities
- **Monitoring**: Prometheus/Grafana integration
- **Logging**: Centralized logging with Loki
- **Backup**: Automated backup with rsync/borgbackup
- **Security**: Enhanced security scanning and hardening

---

**Note**: This Ansible setup is specifically designed for Hetzner Cloud infrastructure and integrates tightly with the Terraform modules in this project. 