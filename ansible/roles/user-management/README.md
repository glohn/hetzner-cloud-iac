# User Management Role

This Ansible role creates individual user accounts with SSH key authentication and sudo privileges, replacing the legacy approach of managing all SSH keys under the root user.

## Features

- Creates individual user accounts for each SSH key
- Configures SSH key authentication for each user
- Grants passwordless sudo privileges to all created users
- Supports flexible username formats including special characters (dots, hyphens, underscores)
- Secure password-less user accounts (SSH-only authentication)
- Individual accountability and audit trails
- **Automatic user removal** when users are removed from configuration
- **Safe manual user protection** - manually created users are not affected

## Security Benefits

### Enhanced Access Control
- **Individual Users**: Each SSH key gets its own dedicated user account
- **No Shared Root Access**: Root access limited to Ansible automation only
- **Key Isolation**: SSH key compromise affects only one user account
- **Sudo Logging**: All administrative actions logged with individual user attribution

### Secure Configuration
- **No Password Login**: Users created with `--disabled-password` for SSH-only access
- **Passwordless Sudo**: All users get `NOPASSWD:ALL` sudo access via `/etc/sudoers.d/ansible-managed-users`
- **Validated Configuration**: All sudoers modifications validated with `visudo`

## User Lifecycle Management

### User Creation
- Users are automatically created when added to the SSH keys configuration
- Each user gets their own home directory, SSH configuration, and sudo access

### User Removal
- **Automatic Cleanup**: Users removed from SSH keys configuration are automatically deleted
- **Source of Truth**: `/etc/sudoers.d/ansible-managed-users` determines which users are Ansible-managed
- **Manual User Protection**: Users created manually (not in sudoers file) are never touched by Ansible
- **Complete Removal**: Deleted users have their home directories and sudoers entries removed
- **Safety Check**: Built-in protection prevents removal of system accounts like `root`

### Manual vs Ansible-Managed Users
```bash
# Ansible-managed users (will be removed if not in config):
example ALL=(ALL) NOPASSWD:ALL      # ← Listed in /etc/sudoers.d/ansible-managed-users

# Manual users (safe from Ansible removal):
admin                            # ← NOT in sudoers file, created manually
```

## Variables

The role accepts the following variables:

```yaml
user_ssh_keys_b64: "eyJ1c2VyMSI6InNzaC1lZDI1NTE5IEFB..."  # Base64 encoded JSON of SSH keys
user_ssh_keys: {}                                            # Decoded SSH keys (auto-generated)
```

### SSH Keys Format

The `user_ssh_keys_b64` variable should contain a Base64-encoded JSON object:

```json
{
  "username1": "ssh-ed25519 AAAAC3NzaC1... user@host",
  "user.name": "ssh-rsa AAAAB3NzaC1... admin@company",
  "admin-user": "ssh-ed25519 AAAAC3NzaC1... ops@server"
}
```

## System Modifications

### User Account Creation
- Creates users via `adduser --disabled-password --gecos "" --force-badname`
- Adds users to sudo group via `usermod -aG sudo`
- Creates `/home/{username}` directories with proper ownership
- Shell set to `/bin/bash` for all users

### User Account Removal
- Reads `/etc/sudoers.d/ansible-managed-users` to identify Ansible-managed users
- Compares managed users with current configuration to find obsolete accounts
- Removes obsolete users completely (`userdel --remove`)
- Cleans up corresponding sudoers entries

### SSH Configuration
- Creates `/home/{username}/.ssh/` directories with mode 0700
- Manages individual `authorized_keys` files with exclusive key access
- Each user's `authorized_keys` contains only their specific SSH key

### Sudo Configuration
- Creates `/etc/sudoers.d/ansible-managed-users` with passwordless sudo rules
- Validates all sudoers modifications for syntax correctness
- Uses sudoers file as source of truth for user lifecycle management

## Usage

This role is automatically included in all service deployments:

```yaml
- name: Deploy Service
  hosts: servers
  become: yes
  roles:
    - base
    - user-management
    - service-role
  vars:
    user_ssh_keys_b64: "{{ user_ssh_keys_encoded }}"
```

## Idempotent Operations

- **User Creation**: Only creates users that don't already exist
- **User Removal**: Only removes users that are Ansible-managed and no longer in configuration
- **SSH Key Management**: Updates authorized_keys files safely
- **Sudo Configuration**: Manages sudoers rules without conflicts
- **Repeatable**: Can be run multiple times without side effects

## Dependencies

- **Target OS**: Debian 12 (Bookworm) or compatible
- **Commands**: Requires `adduser`, `usermod`, `userdel`, and `visudo` utilities
- **Privileges**: Requires root access for user and sudo management
- **SSH Keys**: Requires valid SSH public keys in the input data 

