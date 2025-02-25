# INFRA-DEPLOY

## Infrastructure schema
![infra_v0.1](assets/infra.svg)

# Usage
## Ansible
*As a Windows user, I'm using WSL (Debian 12) to run ansible playbook*
### NatSrv
**Extra vars :**
```bash
ansible-playbook -i inventory.yml --private-key ~/.ssh/ria2_sysadm --user admin natsrv.yml
```
### Setup docker host
**Extra vars :**
- *create_user* : is the user to create on the host to be used by the devs
```bash
ansible-playbook -i inventory.yml --private-key ~/.ssh/ria2_sysadm --user admin install_docker.yml
```
# Setup
## Terraform
>*Version used : [v1.10.2](https://releases.hashicorp.com/terraform/1.10.2/)*

1. Configure your AWS in ~/.aws/config & ~/.aws/credentials under a profile named "RIA2"
	or
2.  Change the profile name in terraform/version.tf