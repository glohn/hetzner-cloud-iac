# Observability Role

This Ansible role deploys a complete PLG (Promtail, Loki, Grafana) stack for centralized log aggregation and monitoring on Hetzner infrastructure.

## Overview

The role provides:
- **Loki**: Log aggregation system for storing and querying logs
- **Promtail**: Log shipping agent that sends logs to Loki
- **Grafana**: Web-based analytics and monitoring platform with Loki integration

## Features

- ✅ Official Grafana APT repository installation
- ✅ Complete PLG stack configuration
- ✅ Automatic Grafana datasource provisioning
- ✅ Security hardening with dedicated service users
- ✅ Comprehensive health checks
- ✅ Log rotation configuration
- ✅ Template-based configuration management
- ✅ Production-ready defaults

## Requirements

- Ubuntu/Debian-based system
- Systemd init system
- Internet connectivity for package installation

## Role Variables

### Network Configuration
```yaml
loki_bind_ip: "{{ ansible_default_ipv4.address }}"
loki_port: 3100
loki_grpc_port: 9096
promtail_port: 9080
grafana_port: 3000
```

### Service Configuration
```yaml
observability_packages:
  - loki
  - promtail
  - grafana

observability_services:
  - loki
  - promtail
  - grafana
```

### Loki Configuration
```yaml
loki_config_dir: "/etc/loki"
loki_data_dir: "/var/lib/loki"
loki_log_level: "info"
loki_retention_period: "168h"  # 7 days
```

### Grafana Configuration
```yaml
grafana_config_dir: "/etc/grafana"
grafana_data_dir: "/var/lib/grafana"
grafana_admin_user: "admin"
grafana_admin_password: "admin"  # Change in production!
grafana_domain: "localhost"
```

### Log Monitoring
```yaml
promtail_log_paths:
  - "/var/log/syslog"
  - "/var/log/auth.log"
  - "/var/log/nginx/*.log"
  - "/var/log/apache2/*.log"
```

### Security & Operations
```yaml
observability_security_hardening: true
observability_health_check_enabled: true
observability_configure_logging: true
observability_log_retention_days: 7
```

## Dependencies

- tf-modules/global/firewall (for firewall rules)
- tf-modules/services/observability (for VM provisioning)

## Example Playbook

```yaml
- hosts: observability
  become: yes
  roles:
    - observability
  vars:
    grafana_admin_password: "your-secure-password"
    grafana_domain: "monitoring.example.com"
    promtail_log_paths:
      - "/var/log/syslog"
      - "/var/log/auth.log"
      - "/var/log/nginx/*.log"
      - "/var/log/application/*.log"
```

## Post-Installation

1. **Access Grafana**: http://your-server:3000
   - Username: `admin`
   - Password: Set via `grafana_admin_password`

2. **Verify Loki**: http://your-server:3100/ready

3. **Check Promtail**: http://your-server:9080/ready

## Architecture

```
[Log Sources] → [Promtail] → [Loki] → [Grafana]
     ↓              ↓          ↓         ↓
  Syslog        Shipper    Storage   Visualization
  Auth logs     Agent      Query        UI
  App logs      Parser     API       Dashboards
```

## Security Considerations

- Dedicated service users with restricted shells
- Secure file permissions (640/750)
- Log rotation configured
- Minimal network exposure
- Regular security updates recommended

## Monitoring & Health Checks

The role includes comprehensive health checks:
- Service availability
- HTTP endpoint validation
- Metrics endpoint verification
- Grafana database connectivity
- Datasource configuration validation

## Troubleshooting

### Common Issues

1. **Service fails to start**: Check logs with `journalctl -u service-name`
2. **Port conflicts**: Verify no other services use the configured ports
3. **Permission issues**: Ensure data directories have correct ownership
4. **Network connectivity**: Verify firewall allows configured ports

### Log Locations
- Loki: `/var/log/loki/`
- Promtail: `/var/log/promtail/`
- Grafana: `/var/log/grafana/`
