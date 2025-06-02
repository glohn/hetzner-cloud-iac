# Base Role

This Ansible role provides essential system configuration for Debian-based servers, establishing a standardized baseline for all services.

## Features

- System package updates and essential tool installation
- Timezone configuration for Europe/Berlin
- Enhanced bash shell configuration with improved history and completion
- Security baseline with fail2ban installation
- Administrative tools for monitoring and troubleshooting

## System Configuration

### Package Management
- **Updates**: APT cache refresh and full system upgrade
- **Cleanup**: Automatic removal of unused packages and cache cleanup
- **Security**: Non-interactive upgrade process to prevent hanging

### Essential Tools Installed
- **Security**: `fail2ban` for intrusion prevention
- **Network**: `dnsutils`, `net-tools`, `iftop` for network diagnostics
- **Monitoring**: `htop`, `iotop`, `nmon`, `sysstat` for system monitoring
- **Storage**: `ncdu`, `lsof`, `tree` for disk and file analysis
- **Development**: `git`, `rsync`, `tmux`, `screen` for development and remote work
- **Archives**: `unzip`, `unrar-free` for archive handling
- **Database**: `redis-tools` for Redis administration

### Timezone Configuration
- **Location**: Europe/Berlin timezone
- **System-wide**: Affects all services and log timestamps

### Bash Shell Enhancement

#### Root User Configuration
- **Colored Output**: Enables colored `ls` output and directory highlighting
- **Enhanced History**: 100,000 command history with timestamps
- **Improved Aliases**: 
  - `ll` for detailed directory listing
  - `ls` with color support
- **Tab Completion**: Enhanced bash completion for commands and options

#### History Settings
```bash
HISTTIMEFORMAT="%F - %T "  # Timestamps in history
HISTSIZE=100000            # Large history buffer
```

## Security Configuration

### SSH Hardening
- Removes problematic `ClientAliveInterval` settings
- Maintains secure SSH defaults

### Intrusion Prevention
- **fail2ban**: Automatically installed and enabled
- Protects against brute force attacks
- Uses default Debian configuration

## Usage

This role is automatically included in all service deployments:

```yaml
- name: Deploy Service
  hosts: servers
  become: yes
  roles:
    - base              # Always first
    - user-management   # Then user and SSH key management
    - service-role      # Finally the specific service
```

## File Modifications

### `/root/.bashrc`
- Uncomments and enables colored output settings
- Adds comprehensive history configuration
- Enables bash completion features

### System Configuration
- Updates `/etc/timezone` to Europe/Berlin
- Modifies `/etc/ssh/sshd_config` (removes ClientAliveInterval)
- Installs packages system-wide via APT

## Idempotent Operations

- **Package Updates**: Only updates when cache is older than 1 hour
- **Configuration Changes**: Only modifies settings when necessary
- **File Modifications**: Uses `lineinfile` and `blockinfile` for safe changes
- **Repeatable**: Can be run multiple times without side effects

## Dependencies

- **Target OS**: Debian 12 (Bookworm) or compatible
- **Network Access**: Requires internet for package downloads
- **Privileges**: Requires root access for system configuration

