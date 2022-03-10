#!/bin/bash
# vars
NIMOS=centos-7
NGXOS=centos-7
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
NIMHOSTS=1
NGXHOSTS=2
# Login
az login
echo Initiating testenv command...
#testenv stack create vm-cluster --cloud vsphere --num-hosts 1 --os centos-7 --vsphere-host-disk-size 80 --tag NIM --tag cli
testenv stack create vm-cluster \
	--cloud vsphere \
	--os $NIMOS \
	--num-hosts $NIMHOSTS \
	--vsphere-host-disk-size 100 \
	--tag cli \
	--tag nim
# Get stackid
stackid1=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
testenv stack create vm-cluster \
	--cloud vsphere \
	--os $NGXOS \
	--num-hosts $NGXHOSTS \
	--vsphere-host-disk-size 40 \
	--tag cli \
	--tag nginx
# Get stackid
stackid2=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
# Capture stack symbols1
stacksymbols1=`testenv stack show symbols $stackid1`
# Capture vm1 ip
hostips1=`jq '.host_ips[]' <<< $stacksymbols1 | tr -d '"'`
vmusername1=`jq '.host_ssh_username' <<< $stacksymbols1 | tr -d '"'`
i=1
for host in $hostips1
do
	eval "host$i=$host"
        ((i=i+1))
done
# Store stack symbols2
stacksymbols2=`testenv stack show symbols $stackid2`
hostips2=`jq '.host_ips[]' <<< $stacksymbols2 | tr -d '"'`
vmusername2=`jq '.host_ssh_username' <<< $stacksymbols2 | tr -d '"'`
## ansible for nim nodes
# Create nim hosts file for ansible use
cat <<EOF | tee ~/.testenv/my/ansible/playbooks/hosts.yaml
# nim hosts from script ~/.testenv/my/createstacks/vm-cluster-nim.sh
testenv:
  hosts:
EOF
# Create nim host and username variables for ansible use
cat <<EOF | tee /tmp/testenvansiblevars
# nim vars from script ~/.testenv/my/createstacks/vm-cluster-nim.sh
user: $vmusername1
EOF
i=1
for host in $hostips1
do
        echo "host$i: $host" >> /tmp/testenvansiblevars;
        cat <<EOF | tee -a ~/.testenv/my/ansible/playbooks/hosts.yaml
    host$i:
      ansible_host: "{{ host$i }}"
      ansible_user: "{{ user }}"
EOF
        ((i=i+1))
done
echo
# Run ansible playbook ...
if [[ $NGXOS == *"centos"* ]]; then
	ansible-playbook ~/.testenv/my/ansible/playbooks/ngx/vm-cluster-ngx-centos-install.yaml
	ansible-playbook ~/.testenv/my/ansible/playbooks/nim/vm-cluster-nim-centos-install.yaml
else
        ansible-playbook ~/.testenv/my/ansible/playbooks/ngx/vm-cluster-ngx-ubuntu-install.yaml
	ansible-playbook ~/.testenv/my/ansible/playbooks/nim/vm-cluster-nim-ubuntu-install.yaml
fi

#ansible-playbook ~/.testenv/my/ansible/playbooks/vm-cluster-nim.yaml
## ansible for ngx nodes
# Create ngx hosts file for ansible use
cat <<EOF | tee ~/.testenv/my/ansible/playbooks/hosts.yaml
# ngx hosts from script ~/.testenv/my/createstacks/vm-cluster-nim.sh
testenv:
  hosts:
EOF
# Create ngx hosts and username variables for for ansible use
cat <<EOF | tee /tmp/testenvansiblevars
# ngx vars from script ~/.testenv/my/createstacks/vm-cluster-nim.sh
user: $vmusername2
EOF
i=1
for host in $hostips2
do
        echo "host$i: $host" >> /tmp/testenvansiblevars;
        cat <<EOF | tee -a ~/.testenv/my/ansible/playbooks/hosts.yaml
    host$i:
      ansible_host: "{{ host$i }}"
      ansible_user: "{{ user }}"
EOF
        ((i=i+1))
done
echo
# Run ansible playbook to ...
if [[ $NGXOS == *"centos"* ]]; then
	ansible-playbook ~/.testenv/my/ansible/playbooks/ngx/vm-cluster-ngx-centos-install.yaml
else
	ansible-playbook ~/.testenv/my/ansible/playbooks/ngx/vm-cluster-ngx-ubuntu-install.yaml
fi
# Print symbols
echo -e "* Stack-ID1:\n$stackid1\n"
echo -e "* Host IPs VM1:"
i=1
for host in $hostips1
do
        echo -e "ssh $vmusername1@$host"
        ((i=i+1))
done
echo
echo -e "* Stack-ID2:\n$stackid2\n"
echo -e "* Host IPs VM2:"
i=2
for host in $hostips2
do
        echo -e "ssh $vmusername2@$host"
        ((i=i+1))
done
echo
# Print misc
echo "* Edit known hosts if ssh fails due to existing host entry"
echo "gawk -i inplace '!/<host_ip>/' /Users/newfield/.ssh/known_hosts"
echo
