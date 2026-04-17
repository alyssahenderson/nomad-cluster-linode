# Nomad Cluster on Linode

Deploy a production-ready, high-availability Nomad cluster on Linode using Terraform and Ansible.
Following the tutorial by Justin Mitchel

https://www.youtube.com/watch?v=D8KgwFFNFWA

Justin's repo:
https://github.com/jmitchel3/nomad-cluster-terraform-ansible-linode

I've just bumped the nomad/consul/linode provider to the latest versions available in 2026.

## What You Get

A 6-node Nomad cluster with:

- **3 Nomad servers** — handles cluster management and job scheduling
- **3 Nomad clients** — runs your containerized workloads
- **Consul** — service discovery and health monitoring for all nodes
- **VPC networking** — private communication between nodes
- **Docker + CNI plugins** — full container networking support on clients

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Linode VPC (10.0.0.0/24)             │
│                                                         │
│   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐   │
│   │ Nomad Srv 1 │   │ Nomad Srv 2 │   │ Nomad Srv 3 │   │
│   │ Consul Srv  │   │ Consul Srv  │   │ Consul Srv  │   │
│   │ 10.0.0.5    │   │ 10.0.0.6    │   │ 10.0.0.7    │   │
│   └─────────────┘   └─────────────┘   └─────────────┘   │
│                                                         │
│   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐   │
│   │ Nomad Cli 1 │   │ Nomad Cli 2 │   │ Nomad Cli 3 │   │
│   │ Consul Cli  │   │ Consul Cli  │   │ Consul Cli  │   │
│   │ 10.0.0.13   │   │ 10.0.0.14   │   │ 10.0.0.15   │   │
│   └─────────────┘   └─────────────┘   └─────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

A Linode account with an API token. 

Push the token:

```bash
echo "linode_api_tokn=\"your_api_token\"" >> infra/terraform.tfvars
```

## Quick Start

### 1. Plan the infrastructure

```bash
cd infra
terraform plan
```

### 2. Apply and provision

```bash
terraform apply
```

This creates all Linode instances, configures VPC networking, and generates an Ansible inventory at `inventory.ini`.

### 3. Run Ansible to configure the cluster

```bash
cd ../config
ansible-playbook -i inventory.ini main.yaml
```

Ansible will:
- Install Consul on all nodes (server mode on Nomad servers, client mode on clients)
- Install Nomad on all nodes
- Install Docker and CNI plugins on client nodes
- Start all services

### 4. Submit a job

```bash
# Check the cluster is healthy
nomad server members -address=http://10.0.0.5:4646

# Run the hello-world example
nomad run ../samples-jobs/hello-world.hcl

# Check job status
nomad job status hello-world
```

## Sample Jobs

| Job | Description |
|-----|-------------|
| `hello-world.hcl` | Simple Docker web server |
| `cfe-nginx.hcl` | Nginx with HTTP health checks |
| `iac-python.hcl` | Python web application |
| `load-balancing.hcl` | Nginx load balancer with Consul service discovery |

## Key Files

### Infrastructure (Terraform)

| File | Purpose |
|------|---------|
| `main.tf` | Linode provider configuration |
| `cluster_instance.tf` | Nomad server and client instance definitions |
| `cluster_vpc.tf` | VPC and subnet setup |
| `cluster_inventory.tf` | Dynamic Ansible inventory generation |
| `variables.tf` | Configurable variables |

### Configuration (Ansible)

| File | Purpose |
|------|---------|
| `main.yaml` | Main playbook to configure all nodes |
| `inventory.ini` | Static inventory (or use Terraform-generated) |
| `consul/` | Consul installation and configuration role |
| `nomad/` | Nomad installation and configuration role |
| `docker_install/` | Docker runtime installation role |
| `cni_plugins/` | CNI plugins for container networking |

## Connecting to the Cluster

Nomad UI: `http://10.0.0.5:4646`

Consul UI: `http://10.0.0.5:8500`

## Tear Down

```bash
# Destroy all Linode resources
cd infra
terraform destroy
```

## Versions

| Component | Version |
|-----------|---------|
| Nomad | 1.8.1 |
| Consul | 1.19.0 |
| Terraform (Linode provider) | 3.11.0 |
| CNI Plugins | 1.5.1 |
