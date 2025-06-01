# SSH Keys Role

This Ansible role manages SSH public keys in a designated section of the authorized_keys file, allowing coexistence with manually managed keys.

## Features

- Manages SSH keys via marked blocks in authorized_keys
- Supports base64-encoded key input for shell-safe handling
- Preserves manually added SSH keys outside managed blocks
- Idempotent key management with proper file permissions
- Creates required directories and files automatically
- Clean removal of managed blocks when no keys are defined

## Key Management Strategy

### Marked Block Approach
The role uses `blockinfile` with markers to manage a specific section:
```bash
# BEGIN ANSIBLE MANAGED SSH KEYS
ssh-rsa AAAAB3... user@hostname
ssh-ed25519 AAAAC3... another-user@host
# END ANSIBLE MANAGED SSH KEYS
```

### Coexistence with Manual Keys
- **Manual Keys**: Can be added above or below the managed block
- **Managed Keys**: Only within the marked section
- **No Conflicts**: Manual and managed keys coexist safely

## Base64 Encoding Support

### Input Format
The role accepts base64-encoded JSON for shell-safe key handling:
```yaml
user_ssh_keys_b64: "eyJrZXkxIjoic3NoLXJzYSBBQUFBQjMuLi4iLCJrZXkyIjoic3NoLWVkMjU1MTkgQUFBQUMzLi4uIn0="
```

### Automatic Decoding
- Decodes base64 input to JSON format
- Extracts individual SSH keys
- Handles keys with spaces in comments safely
- Supports all SSH key types (RSA, ED25519, ECDSA, etc.)

## Variables

```yaml
# Base64-encoded JSON containing SSH keys
user_ssh_keys_b64: ""

# Alternative: Direct JSON input (less safe for special characters)
user_ssh_keys: {}

# Example decoded structure:
user_ssh_keys:
  key1: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... user@hostname"
  key2: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... admin@domain.com"
```

## Security Features

### File Permissions
- **authorized_keys**: `600` (read/write owner only)
- **.ssh directory**: `700` (full access owner only)
- **Owner**: `root:root` (when managing root access)

### Input Validation
- Validates JSON structure after base64 decoding
- Handles malformed input gracefully
- Preserves existing authorized_keys content

## Idempotent Operations

### Key Addition
- Only adds keys if they're not already present
- Updates managed block content when keys change
- Preserves order and formatting of manual keys

### Key Removal
- Removes managed block entirely when no keys defined
- Leaves manual keys untouched
- Maintains clean authorized_keys file

### Block Management
```yaml
# When keys are present:
- name: Manage SSH keys in designated block
  ansible.builtin.blockinfile:
    marker: "# {mark} ANSIBLE MANAGED SSH KEYS"
    state: present

# When no keys defined:
- name: Remove managed block if no keys defined
  ansible.builtin.blockinfile:
    marker: "# {mark} ANSIBLE MANAGED SSH KEYS"
    state: absent
```

## Usage

This role requires the `user_ssh_keys_b64` variable containing base64-encoded SSH keys.

```yaml
- name: Deploy Service with SSH Key Management
  hosts: servers
  become: yes
  roles:
    - base
    - ssh-keys
    - service-role
  vars:
    user_ssh_keys_b64: "{{ lookup('env', 'USER_SSH_KEYS_B64') }}"
```

The role manages SSH keys in the `/root/.ssh/authorized_keys` file within marked blocks, allowing manual keys to coexist safely.

## Key Management in Practice

### Adding or Removing SSH Keys

1. **Update terraform.tfvars:**
   ```hcl
   user_keys = {
     "admin"     = "ssh-rsa AAAAB3... admin@workstation"
     "developer" = "ssh-ed25519 AAAAC3... dev@laptop"
     # Add new key or remove existing ones
   }
   ```

2. **Taint Ansible provisioners** (required for key changes):
   ```bash
   # Taint all service provisioners to re-run Ansible
   terraform taint 'module.redis[0].null_resource.ansible_provision[0]'
   terraform taint 'module.rabbitmq[0].null_resource.ansible_provision[0]'
   terraform taint 'module.rds[0].null_resource.ansible_provision[0]'
   terraform taint 'module.elasticsearch[0].null_resource.ansible_provision[0]'
   terraform taint 'module.nfs[0].null_resource.ansible_provision[0]'
   ```

3. **Apply changes:**
   ```bash
   terraform apply
   ```

### Why Taint is Required

The SSH-keys role only runs during Ansible provisioning. Since SSH key changes don't affect infrastructure resources, Terraform won't automatically re-run the provisioners. Tainting forces the provisioners to execute, updating SSH keys on all servers.

**Important**: SSH key changes only update `/root/.ssh/authorized_keys` files and do not trigger service restarts. Your running services (Redis, RabbitMQ, MySQL, etc.) continue operating without interruption.

### Verification

After applying changes, verify keys are updated:
```bash
# Check managed keys on any server
ssh root@server-ip "grep -A 10 'BEGIN ANSIBLE MANAGED SSH KEYS' /root/.ssh/authorized_keys"
``` 

