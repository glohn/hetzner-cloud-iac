# RabbitMQ Role

This Ansible role installs and configures RabbitMQ message broker from official repositories with modern Erlang support.

## Features

- Installs RabbitMQ from official Cloudsmith repositories
- Includes modern Erlang packages for optimal performance
- Enables RabbitMQ Management Plugin for web-based administration
- Configures multi-interface listening for flexibility
- Creates administrative user with full permissions
- Service management with automatic startup

## Components Installed

### Core Packages
- **RabbitMQ Server**: Latest stable version from official repository
- **Modern Erlang**: Contemporary Erlang runtime from Cloudsmith
- **Management Plugin**: Web-based administration interface

### Repository Sources
- **Team RabbitMQ**: Main signing key and package source
- **Cloudsmith Erlang**: Modern Erlang runtime packages
- **Cloudsmith RabbitMQ**: Official RabbitMQ server packages

## Network Configuration

### Listener Configuration
- **AMQP on Localhost**: `127.0.0.1:5672` for local connections
- **AMQP on Private IP**: Private network access for application connectivity
- **Management Interface**: Public IP access for remote administration

### Default Ports
- **AMQP Protocol**: `5672` (message broker)
- **Management Web UI**: `15672` (web interface)

## Configuration

This role is automatically configured with:

- **AMQP Binding**: Localhost and private network IP
- **Management Interface**: Accessible on all interfaces (secured by firewall)
- **Admin User**: Project name with configured password
- **Network Access**: Private IP for AMQP, public IP for web management

All configuration values are provided by the deployment automation.

## Security Features

### Access Control
- AMQP bound to localhost and private network only
- Management interface accessible from public IP
- Administrative user with controlled permissions
- Network-level security via firewall rules

### User Management
- Default `guest` user remains localhost-only
- Custom admin user with administrator tag
- Full permissions on default virtual host `/`

## Management Interface

The role enables the RabbitMQ management plugin providing:
- Web-based administration console
- REST API for programmatic management
- Queue, exchange, and binding visualization
- Performance monitoring and metrics

## Service Management

- **Auto-start**: RabbitMQ enabled for automatic startup
- **Immediate Start**: Service started after configuration
- **Readiness Check**: Waits for RabbitMQ to be fully operational
- **User Creation**: Admin user created after service is ready

## Repository Security

- **GPG Verification**: All repositories signed and verified
- **Secure Downloads**: Keys downloaded over HTTPS
- **Proper Key Management**: Keys stored in system keyrings directory

## Usage

This role is automatically invoked during RabbitMQ server provisioning. No manual configuration is required.

The role configures:
- AMQP listeners on localhost and private network IP
- Management web interface on all interfaces  
- Administrative user with project-based credentials

## Post-Installation

After successful deployment:
1. Access management interface at `http://public-ip:15672`
2. Login with configured admin credentials
3. Configure virtual hosts, users, and permissions as needed
4. Connect applications to AMQP endpoint on private IP 

