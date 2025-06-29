# TODO

## Open Items

- [ ] Check all Ansible roles for production readiness (Redis, RabbitMQ, MySQL, Elasticsearch, NFS)
- [ ] Use floating IP for NFS server
- [ ] Configure VMs to use NFS for shared storage
- [ ] Migrate cloud-init configuration in 02-tf-vm to Ansible-based provisioning
- [ ] Implement observability stack (Promtail, Grafana, Loki) - existing code untested
- [ ] Implement automated backup solution (rsync or borgbackup) - exisiting code untested

## Ansible Role Improvements

The following improvements were identified for the Ansible roles:

- **Template-based Configuration**: Replace `lineinfile` modules with proper Jinja2 templates
- **Idempotency**: Ensure all tasks are fully idempotent and can be run multiple times safely
- **Variables and Flexibility**: Better variable management and role customization
- **Performance Optimizations**: Optimize role execution time and resource usage
- **Health Checks and Validation**: Add validation tasks to verify service status
- **Logging and Monitoring**: Standardize logging configuration across roles (prepare for Loki integration)
- **Security Improvements**: Harden service configurations and permissions
- **Error Handling**: Improve error handling and recovery mechanisms
- **Code Structure**: Better organization of tasks, handlers, and variables
