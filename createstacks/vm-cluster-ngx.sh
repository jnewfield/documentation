#!/bin/bash
# vars
MOS=ubuntu-20.04
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
MHOSTS=2
# Login
az login
echo Initiating testenv command...
testenv stack create vm-cluster \
	--cloud vsphere \
	--os $MOS \
	--num-hosts $MHOSTS \
	--vsphere-host-disk-size 20 \
	--tag cli \
	--tag master
# Get stackid
stackid=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
# Capture stack symbols
stacksymbols=`testenv stack show symbols $stackid`
# Capture vm ips
hostips=`jq '.host_ips[]' <<< $stacksymbols | tr -d '"'`
vmusername=`jq '.host_ssh_username' <<< $stacksymbols | tr -d '"'`
i=1
for host in $hostips
do
	eval "host$i=$host"
        ((i=i+1))
done
# Create hosts file for ansible use
cat <<EOF | tee ~/.testenv/my/ansible/playbooks/hosts.yaml
# Hosts from script ~/.testenv/my/createstacks/vm-cluster-ngx.sh
vmclusterngx:
  hosts:
EOF
# Create hosts and username variables for for ansible use
cat <<EOF | tee /tmp/testenvansiblevars
# vars from script ~/.testenv/my/createstacks/vm-cluster-ngx.sh
user: $vmusername
EOF
i=1
for host in $hostips
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
# Run ansible playbook to install NGINX+
ansible-playbook ~/.testenv/my/ansible/playbooks/ngx/vm-cluster-ngx-install.yaml
# Print symbols
echo -e "* Stack-ID:\n$stackid\n"
echo -e "* Host IPs:"
i=1
for host in $hostips
do
        echo -e "ssh $vmusername@$host"
        ((i=i+1))
done
echo
# Print misc
echo "* Edit known hosts if ssh fails due to existing host entry"
echo "gawk -i inplace '!/<host_ip>/' /Users/newfield/.ssh/known_hosts"
echo
