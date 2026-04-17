[servers]
%{ for server in servers ~}
${ server.name } ansible_ssh_host=${ server.public_ip } ansible_user=root ansible_ssh_private_key_file=${ repo_dir }/ssh/id_ed25519
%{ endfor ~}

[clients]
%{ for client in clients ~}
${ client.name } ansible_ssh_host=${ client.public_ip } ansible_user=root ansible_ssh_private_key_file=${ repo_dir }/ssh/id_ed25519
%{ endfor ~}