# RDS Role - Percona MySQL 8.0

This Ansible role installs and configures Percona Server for MySQL 8.0 with telemetry completely disabled.

## Features

- Installs Percona Server for MySQL 8.0 from official repositories
- Creates application database and user
- **Completely disables Percona telemetry system**
- Configures MySQL with secure defaults
- Enables binary logging and slow query logging

## Telemetry Disabling

This role implements comprehensive telemetry disabling as per [Percona documentation](https://docs.percona.com/percona-server/8.0/telemetry.html):

### 1. Installation-time Telemetry
- Disabled via `PERCONA_TELEMETRY_DISABLE=1` environment variable during package installation

### 2. Continuous Telemetry
- **Telemetry Agent**: Service `percona-telemetry-agent` is stopped and disabled
- **DB Component**: Uninstalled via `UNINSTALL COMPONENT "file://component_percona_telemetry"`
- **Configuration**: `percona_telemetry_disable=1` added to MySQL configuration

## Variables

```yaml
rds_root_password: "secure_root_password"
rds_app_password: "secure_app_password"
rds_database_name: "app_database"
rds_username: "app_user"
```

## Security Features

- Root authentication changed from `auth_socket` to `mysql_native_password`
- Application user with limited privileges
- MySQL bound to all interfaces (secured by firewall)
- Binary logging enabled for point-in-time recovery

## Configuration

The role deploys a custom MySQL configuration (`/etc/mysql/mysql.conf.d/mysqld.cnf`) with:
- Telemetry permanently disabled
- Performance optimizations
- Logging enabled
- UTF8MB4 character set
- Secure defaults 

