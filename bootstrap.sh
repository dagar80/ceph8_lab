#! /bin/bash

cephadm bootstrap --cluster-network 192.168.125.0/24 --mon-ip 192.168.122.161 \
--registry-url registry.redhat.io --registry-username USERNAME --registry-password PASSWORD \
--yes-i-know --initial-dashboard-user admin --initial-dashboard-password redhat123 \
--ssh-private-key /home/ceph-admin/.ssh/id_rsa --ssh-public-key /home/ceph-admin/.ssh/id_rsa.pub \
--ssh-user ceph-admin --allow-fqdn-hostname
