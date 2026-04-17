variable "linode_api_token" {
    type = string
    sensitive = true
    description = "Linode API Token"
}


# To list available regions:
# curl --request GET \
#      --url https://api.linode.com/v4/regions \
#      --header 'accept: application/json'
variable "linode_region" {
    type = string
    description = "Linode Region"
    default = "nl-ams" # Netherlands, Amsterdam
}

variable "linode_instance_image" {
    type = string
    description = "Linode Instance Image"
    default = "linode/ubuntu24.04"
}

variable "linode_instance_type" {
    type = string
    description = "Linode Instance Type"
    default = "g6-standard-2"
}

variable "server_count"{
    type = number
    default = 3
}

variable "client_count"{
    type = number
    default = 3
}

variable "ansible_config_dir" {
    type = string
    default = "config"
}