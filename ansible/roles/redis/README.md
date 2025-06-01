# Redis Role

This Ansible role installs and configures Redis from the official Redis repository with secure defaults.

## Features

- Installs latest stable Redis from official repositories
- Configures Redis with security-focused settings
- Binds to specific network interfaces for controlled access
- Enables protected mode for enhanced security
- Service management with automatic startup

## Security Configuration

### Network Security
- **Bind Configuration**: Redis bound to specific IP addresses (localhost + private IP)
- **Protected Mode**: Enabled to prevent unauthorized access from untrusted networks
- **No Authentication**: Relies on network-level security (firewall protection)

### Default Configuration
- Listens on standard port `6379`
- Memory management with appropriate defaults
- Logging enabled for monitoring and debugging

## Variables

The role accepts the following variables:

```yaml
redis_bind_ip: "10.0.1.100"  # Private IP address to bind Redis
```

## Network Configuration

Redis is configured to:
- Bind to `127.0.0.1` (localhost) for local connections
- Bind to the specified private IP for network access
- Protected mode ensures only authorized network access

## Repository Management

- Downloads and installs Redis GPG key securely
- Adds official Redis APT repository with proper signing verification
- Updates package cache automatically

## Service Management

- Enables Redis service for automatic startup
- Starts Redis immediately after configuration
- Idempotent configuration management

## Usage

Include this role in your playbook:

```yaml
- name: Deploy Redis
  hosts: redis_servers
  become: yes
  roles:
    - base
    - ssh-keys
    - redis
  vars:
    redis_bind_ip: "{{ ansible_default_ipv4.address }}"
``` 

