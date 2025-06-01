# NFS Role

This Ansible role installs and configures NFSv4 server with intelligent volume management for shared storage solutions.

## Features

- Installs and configures NFSv4 server (disables NFSv2/NFSv3 for security)
- Intelligent volume detection and mounting
- Automatic data backup and restoration during volume operations
- Configures secure NFS exports with proper permissions
- Service management with dependency handling
- Idempotent volume operations

## NFSv4 Configuration

### Security Features
- **NFSv4 Only**: Disables legacy NFSv2 and NFSv3 protocols
- **Minimal RPC**: Uses rpcbind only for service startup, not for dynamic port assignment
- **Stateless**: Uses NFSv4 stateless operations (no `statd`)
- **ID Mapping**: Enables `idmapd` for proper user/group mapping

### Service Configuration
- **NEED_STATD**: Disabled (`"no"`)
- **NEED_IDMAPD**: Enabled (`"yes"`)
- **RPCNFSDOPTS**: `--no-nfs-version 2 --no-nfs-version 3`
- **RPCMOUNTDOPTS**: `--no-nfs-version 2 --no-nfs-version 3`

## Volume Management

### Intelligent Detection
The role includes smart volume handling:
- **Mount Check**: Automatically detects if volume is already mounted
- **Skip Operations**: Bypasses volume setup if already configured
- **Data Protection**: Prevents data loss during operations

### Volume Operations
When volume setup is needed:
1. **Service Stop**: Safely stops NFS services
2. **Data Backup**: Backs up existing data to temporary location
3. **Mount Volume**: Mounts new volume to `/srv/nfs`
4. **Data Restore**: Restores backed up data to new volume
5. **Service Start**: Restarts NFS services
6. **Cleanup**: Removes temporary backup data

## Network Configuration

### Export Settings
- **Export Path**: `/srv/nfs/shared`
- **Client Access**: Network-based restriction using `nfs_client_network` variable
- **Export Options**: `rw,sync,no_subtree_check,root_squash,sec=sys`
- **NFSv4 Root**: `/srv/nfs`

### Firewall Considerations
NFSv4 uses simplified port configuration:
- **NFS Service**: Port `2049` (TCP/UDP)
- **No Additional Ports**: Unlike NFSv2/3, no random port assignment

## Directory Structure

```
/srv/nfs/                    # NFSv4 export root
├── shared/                  # Actual exported directory
└── [other-directories]/     # Additional non-exported directories
```

## Service Dependencies

### Required Services
- **rpcbind**: Required by Debian's NFS implementation (even for NFSv4-only)
- **nfs-kernel-server**: Main NFS server daemon

### Service Order
1. Start `rpcbind`
2. Start `nfs-kernel-server`
3. Exports become available

**Note**: Although NFSv4 theoretically doesn't need rpcbind, Debian's `nfs-kernel-server` package still requires it for proper startup, even with NFSv2/v3 disabled.

## Security Configuration

### Access Control
- **Root Squashing Enabled**: `root_squash` maps root to anonymous user for security
- **Synchronous Writes**: `sync` for data integrity
- **Subtree Checking Disabled**: `no_subtree_check` for performance
- **Network Access Control**: Only specified subnet can access exports

### ID Mapping
- **Domain Setting**: Configured in `/etc/idmapd.conf`
- **User/Group Mapping**: Proper UID/GID translation between client/server
- **NFSv4 ACLs**: Support for extended access control lists

## Idempotent Operations

### Volume Already Mounted
When the role detects that a volume is already mounted at `/srv/nfs`, it skips all volume-related operations to prevent service interruption and data loss. This ensures the shared directory exists without unnecessary operations.

### Fresh Installation
When volume setup is required, the role performs complete volume initialization while maintaining data integrity throughout the process.

## Usage

This role requires two variables:

- **`nfs_volume_device`**: Block device path for NFS storage volume  
- **`nfs_client_network`**: Network CIDR that should have access to NFS exports

These variables are provided by the deployment automation during server provisioning.

## Post-Installation

### Server Verification
```bash
# Check NFS exports
showmount -e localhost

# Check RPC services (should show nfs v4 only)
rpcinfo -p localhost

# Check mount point and usage
df -h /srv/nfs

# Verify NFSv4 service is running
systemctl status nfs-kernel-server
```

### Client Connection
```bash
# Mount from NFSv4 client (correct path)
mount -t nfs4 server-ip:/shared /mnt/nfs

# Verify NFSv4 mount
mount | grep nfs4
```

## Troubleshooting

### Quick Diagnostics
```bash
# Check service status
systemctl status nfs-kernel-server rpcbind

# View recent NFS logs
journalctl -u nfs-kernel-server --since "10 minutes ago"

# Check exports are active
cat /proc/fs/nfsd/exports

# Test local mount
showmount -e localhost
```

### Common Issues

**Service Won't Start:**
```bash
# Check configuration syntax
exportfs -ra
systemctl restart nfs-kernel-server
```

**Mount Failures:**
```bash
# Check firewall (if enabled)
ss -tulpn | grep :2049

# Verify export permissions
exportfs -v
```

**ID Mapping Problems:**
```bash
# Check idmapd status and domain
systemctl status nfs-idmapd
grep "^Domain" /etc/idmapd.conf
``` 

