# [for i in linode_instance.nomad_servers:{name=1.label, subnet_ip = linode_instance.nomad_servers[0].interface[1].ipv4.vpc, region=i.region}]
# linode_instance.nomad_servers[*].interface[1].ipv4.vpc


resource "local_file" "ansible_inventory" {
    content = "${linode_instance.nomad_servers[*].interface[1].ipv4.vpc}"
    filename = "${local.repo_dir}/ansible/inventory.txt"
}