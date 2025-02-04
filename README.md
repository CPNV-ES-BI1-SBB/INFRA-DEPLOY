# INFRA-DEPLOY

## Infrastructure schema
![infra_v0.1](assets/infra.svg)
# Network configuration
## Routing tables
### Main (DMZ)

| DESTINATION | TARGET |
| ----------- | ------ |
| 0.0.0.0     | I-GW   |
| 10.0.0.0/16 | local  
### LAN-ETL

| DESTINATION | TARGET   |
| ----------- | -------- |
| 0.0.0.0     | 10.0.0.5 |
| 10.0.0.0/16 | local    |

### LAN-ELT

| DESTINATION | TARGET   |
| ----------- | -------- |
| 0.0.0.0     | 10.0.0.5 |
| 10.0.0.0/16 | local    |

## Security group rules (inbound - Only )
### ELT

| Type | (Protocol) | (Port range) | Source      | Allow/Deny | Description            |
| ---- | ---------- | ------------ | ----------- | ---------- | ---------------------- |
| SSH  |            |              | 10.0.0.5/32 | Allow      | SSH access from NatSrv |
### ETL

| Type | (Protocol) | (Port range) | Source      | Allow/Deny | Description            |
| ---- | ---------- | ------------ | ----------- | ---------- | ---------------------- |
| SSH  |            |              | 10.0.0.5/32 | Allow      | SSH access from NatSrv |
## Network ACL (VPC)

### Inbound

| Type        | (Protocol) | (Port range) | Source         | Allow/Deny | Description                          |
| ----------- | ---------- | ------------ | -------------- | ---------- | ------------------------------------ |
| SSH         |            |              | 193.5.240.9/32 | Allow      | SSH access  from CPNV                |
| All traffic | all        | all          | 0.0.0.0/0      | Deny       | Deny all unwanted traffic to the VPC |

### Outbound

| Type        | (Protocol) | (Port range) | Source    | Allow/Deny | Description |
| ----------- | ---------- | ------------ | --------- | ---------- | ----------- |
| All traffic | all        | all          | 0.0.0.0/0 | Allow      | (default)   |
| All traffic | all        | all          | 0.0.0.0/0 | Deny       | (default)   |

# Ansible
## Usage example
### Setup docker host
**Extra vars :**
- *create_user* : is the user to create on the host to be used by the devs
```bash
ansible-playbook -i '10.229.32.104,' --private-key ~/.ssh/ria2_sysadm --user root install_ansible.yml -e 'create_user=elt'
```

### NatSrv
**Extra vars :**
```bash
ansible-playbook -i '10.229.32.104,' --private-key ~/.ssh/ria2_sysadm --user root natsrv.yml -e 'ssh_keys=["key1", "key2"...]'
```