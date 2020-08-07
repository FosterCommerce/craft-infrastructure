# README

## Install Ansible Galaxy dependencies

```bash
ansible-galaxy install -r requirements.yaml
```

## Generate key

```bash
ssh-keygen -t rsa -b 4096 -C "deploy@<host-or-ip>" -q -N ""
```

In the GitHub repository secrets add a new secret called
`WEBSERVER_PRIVATE_KEY` and copy the private key value from the key file
generated above into that secret. This will be the secret used for deploys.

```bash
# Copy private key
# Using xclip on Ubuntu
cat /path/to/deploy/key | xclip -selection c

# Using pbcopy on MacOS (I haven't tested this)
cat /path/to/deploy/key | pbcopy
```

All future webservers will need to have the same public key configured, or if a
new one needs to be configured, the `WEBSERVER_PRIVATE_KEY` will need to be
updated on GitHub.

## Create an ansible_hosts file

Create a file which contains a list of hosts for provisioning, for example
`ansible_hosts`:

```yaml
[webservers]
23.96.112.111
23.96.112.123
23.96.112.55
```

The `webservers` group is required because the playbooks are specifically for
webservers.

## Provision deploy user

From a machine which has ssh access to the VM:

```bash
ansible-playbook \
  --extra-vars "deploy_key=$(cat /path/to/deploy/key.pub)" \
  --inventory=ansible_hosts \
  -u azureuser \
  infrastructure/ansible/add-deploy-user.yaml
```

### TODO

- Set up networking to allow ssh and only allow http from the load-balancer.

## Provision webserver

**Note** This playbook assumes a load balanced environment

```bash
ansible-playbook \
  --inventory=ansible_hosts \
  -u azureuser \
  infrastructure/ansible/provision-webservers.yaml
```
