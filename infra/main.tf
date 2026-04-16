terraform {
    required_providers {
        linode = {
            source ="linode/linode"
            version = "=3.11.0"
        }
    }
}

provider "linode" {
    token = var.linode_api_token

}