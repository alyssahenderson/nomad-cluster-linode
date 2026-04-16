data "linode_profile" "me" {}

# Nomad servers -> tell the clients what containers to run

resource "linode_instance" "nomad-servers" {
    count = var.server_count # 3 , 5 , 7 (odd numbers)
    label = "nomad-server-${count.index + 1}"
    region = var.linode_region
    type = var.linode_instance_type
    image = var.linode_instance_image
    authorized_users = [data.linode_profile.me.username]

    interface {
        purpose = "public"
    }

    interface {
        purpose = "vpc"
        subnet_id = linode_vpc_subnet.ha-nomad-vpc-subnet.id
        ipv4 {
            vpc = "10.0.0.${count.index + 5}"  
        }
    }
}

# Nomad clients -> Run nomad servers Jobs

resource "linode_instance" "nomad-clients" {
    count = var.client_count # 3 , 5 , 7 (odd numbers)
    label = "nomad-client-${count.index + 1}"
    region = var.linode_region
    type = var.linode_instance_type
    image = var.linode_instance_image
    authorized_users = [data.linode_profile.me.username]

    interface {
        purpose = "public"
    }

    interface {
        purpose = "vpc"
        subnet_id = linode_vpc_subnet.ha-nomad-vpc-subnet.id
        ipv4 {
            vpc = "10.0.0.${count.index + var.server_count + 10}"  
        }
    }
}


