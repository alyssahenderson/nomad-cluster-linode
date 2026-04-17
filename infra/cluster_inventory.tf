
# [for i in linode_instance.nomad_servers:{name=i.label, public_ip=i.ip_address, subnet_ip=linode_instance.nomad_servers[0].interface[1].ipv4[0].vpc, region=i.region}]
# linode_instance.nomad_servers[0].interface[1].ipv4[0].vpc

resource "local_file" "ansible_inventory" {
    depends_on = [ linode_instance.nomad-servers, linode_instance.nomad-clients]
    content = templatefile("${path.module}/templates/ansible.inventory.tpl", {
        servers = [
            for i in linode_instance.nomad-servers: {
                name=i.label
                public_ip=i.ip_address
                subnet_ip=i.interface[1].ipv4[0].vpc
                region=i.region
            }
        ]
        clients = [
            for i in linode_instance.nomad-clients: {
                name=i.label
                public_ip=i.ip_address
                subnet_ip=i.interface[1].ipv4[0].vpc
                region=i.region
            }
        ]
        repo_dir = local.repo_dir
    })
    filename = "${local.repo_dir}/${var.ansible_config_dir}/inventory.ini"
}