#!/bin/bash
ngx1=ngx1.es.f5net.com
ngx2=ngx2.es.f5net.com
cat <<EOF | tee ~/.testenv/my/ansible/playbooks/group_vars/ngxvars
# vars from script
ngx1: $ngx1
ngx2: $ngx2
EOF
i=2
host=vm2.es.f5net.com
eval "host$i=$host"
i=3
host=vm3.es.f5net.com
eval "host$i=$host"
echo $host2
echo $host3
