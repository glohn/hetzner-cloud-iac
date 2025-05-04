#cloud-config

users:
  - name: ansible
    shell: /bin/bash
    groups: sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys: []

write_files:
  - path: /home/ansible/.ssh/id_ansible
    content: |
      ${ansible_private_key}
    owner: ansible:ansible
    permissions: '0600'

