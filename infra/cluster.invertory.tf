# [for i in linode_instance.nomad_servers:{name=1.label, subnet_ip = linode_instance.nomad_servers[0].interface[1].ipv4.vpc, region=i.region}]
# linode_instance.nomad_servers[*].interface[1].ipv4.vpc


resource "local_file" "ansible_inventory" {
    depends_on = [linode_instance.nomad-servers, linode_instance.nomad-clients] # wait for instances to be created
    content = templatefile("${path.module}/templates/ansible.inventory.tpl", {
        repo_dir = local.repo_dir
        servers = [for i in linode_instance.nomad-servers: {
            name = i.label
            public_ip = i.ip_address
            subnet_ip = i.interface[1].ipv4[0].vpc
            region = i.region
        }]
        clients = [for i in linode_instance.nomad-clients: {
            name = i.label
            public_ip = i.ip_address
            subnet_ip = i.interface[1].ipv4[0].vpc
            region = i.region
        }]
    })
    filename = "${local.repo_dir}/${var.ansible_config_dir}/inventory.ini"
}