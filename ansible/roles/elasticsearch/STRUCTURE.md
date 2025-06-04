# Elasticsearch Role Structure Documentation

## Overview
This role has been refactored into a modular structure following best practices for maintainability, readability, and separation of concerns.

## Directory Structure
```
tasks/
├── main.yml                      # Main orchestration with 8 logical phases
├── repository.yml                # Repository setup (unchanged)
├── performance.yml               # System performance settings (unchanged) 
├── validate.yml                  # Health checks and validation (unchanged)
├── services.yml                  # Service startup and enablement
├── installation/                 # Pure installation tasks
│   ├── elasticsearch.yml        # Elasticsearch package installation only
│   └── kibana.yml               # Kibana package installation only
├── configuration/               # Core configuration tasks
│   ├── elasticsearch.yml        # Elasticsearch config (network, security, discovery)
│   └── kibana.yml               # Kibana config (template vs lineinfile)
├── security/                    # Security and hardening
│   └── hardening.yml           # User security, directory permissions, file modes
└── logging/                     # Logging and monitoring setup
    └── setup.yml               # Log directories, log4j2, logrotate, slow queries
```

## Execution Phases
The role executes in 8 logical phases:

1. **System Preparation** - Repository setup
2. **Service Installation** - Pure package installation without configuration  
3. **Core Configuration** - Network, security, discovery settings (creates config files)
4. **Security Hardening** - User hardening, permissions, file security (needs config files)
5. **System Performance Settings** - JVM heap, file limits, sysctl (needs config files and directories)
6. **Logging Configuration** - Comprehensive logging setup
7. **Service Startup** - Start and enable services
8. **Health Validation** - Comprehensive health checks and validation

## Benefits of New Structure

### Separation of Concerns
- **Installation** vs **Configuration** clearly separated
- **Security** hardening happens BEFORE configuration for proper file ownership
- **Logging** consolidated and optimized to minimize service restarts

### Maintainability
- Smaller, focused task files (6-40 lines each)
- Clear responsibility boundaries
- Easy to locate specific functionality

### Modularity
- Each phase can be easily modified independently
- New features can be added to appropriate sections
- Better testing isolation possible

### Logical Execution Order
- **Security first** - Users and directories exist before config files are created
- **Configuration grouped** - Core config and logging together to minimize restarts
- **Service startup delayed** - Only after all configuration is complete

## Migration Notes
- Original `elasticsearch.yml` and `kibana.yml` renamed to `.deprecated` 
- All functionality preserved and distributed to appropriate modules
- **Corrected execution order** - Security hardening now runs before configuration
- **Optimized restarts** - Logging config runs directly after core config
- Backward compatibility maintained through variables and conditionals

## Variable Dependencies
All existing variables continue to work unchanged:
- `install_kibana` - Controls Kibana installation and configuration
- `elasticsearch_security_hardening` - Controls security hardening phase
- `elasticsearch_configure_logging` - Controls logging configuration phase
- `elasticsearch_health_check_enabled` - Controls validation phase

This structure makes the role more maintainable while preserving all existing functionality. 

