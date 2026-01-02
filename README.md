# ceph8_lab
Lab to create a ceph8 cluster

## Requeriments

- Software: kcli tool instaled. It's used to create VMs.

- Hardware: 3x6Gb RAM and 4x3vCPU

## Create infra

```kcli create plan -f kcli_ceph8_plan.yml CEPH8```

## Prepare nodes

```ansible-playbook -i inventory 01_prepare.yml```

## Run ceph preflight playbook

```
ssh ceph8-1.internal.lab
cd /usr/share/cephadm-ansible
ansible-playbook -i hosts cephadm-preflight.yml --extra-vars "ceph_origin=rhcs"
```

## Bootstrap ceph8-1 node

Update bootstrap.sh script with user and password and run it.

```
./bootstrap.sh
```

This will create a ceph8 cluster with a single node. Next step, expand to other nodes.

## expand cluster

```
cephadm shell

#check cluster status
ceph -s

#add nodes
ceph orch host add ceph8-2.internal.lab
ceph orch host add ceph8-3.internal.lab

#label hosts to have 3 managers
ceph orch host label add ceph8-2.internal.lab _admin
ceph orch host label add ceph8-3.internal.lab _admin

#config 3 monitors
ceph orch apply mon --placement="3 ceph8-1.internal.lab ceph8-2.internal.lab ceph8-3.internal.lab"

#check if cluster network is defined
ceph config dump | grep cluster_network

#check osd
ceph orch ps --daemon_type osd

#add availables ods
ceph orch apply osd --all-available-devices

#check osd running state
ceph orch ps --daemon_type osd

#check cluster helth
ceph -s

#create a test pool and image
ceph osd pool create test-pool 32 32
rbd pool init test-pool
rbd create imagen_prueba --size 1024 --pool test-pool
rbd ls -p test-pool
```

## Poweroff cluster

```
ceph osd set noout

ceph osd set nobackfill

ceph osd set norecover

shutdown -h now #on all nodes
```
