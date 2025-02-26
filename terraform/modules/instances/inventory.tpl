[nat_servers]
${nat_instance.tags.Name} ansible_host=${nat_instance.private_ip}

[cluster_hosts]
%{ for host in cluster_hosts ~}
${host.tags.Name} ansible_host=${host.private_ip}
%{ endfor ~}