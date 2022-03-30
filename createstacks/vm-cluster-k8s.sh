#!/bin/bash
# vars
OS=ubuntu-20.04
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
HOSTS=3
CLOUD=vsphere
# vsphere or aws
if [ $CLOUD == aws ]; then
	# Login to azure
	az login
fi
echo Initiating testenv command...
testenv stack create vm-cluster \
	--cloud $CLOUD \
	--os $OS \
	--num-hosts $HOSTS \
	--vsphere-host-disk-size 40 \
	--tag cli \
	--tag k8s
	--tag $OS
	--tag $CLOUD
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
## ansible for k8s nodes
# Create k8s hosts file for ansible use
cat <<EOF | tee /tmp/hosts.yaml
# kic hosts from script ~/.testenv/my/createstacks/vm-cluster-k8s.sh
testenv:
  hosts:
EOF
# Create k8s hosts and username variables for ansible use
cat <<EOF | tee /tmp/testenvansiblevars
# kic vars from script ~/.testenv/my/createstacks/vm-cluster-k8s.sh
user: $vmusername
EOF
i=1
for host in $hostips
do
        echo "host$i: $host" >> /tmp/testenvansiblevars;
        cat <<EOF | tee -a /tmp/hosts.yaml
    host$i:
      ansible_host: "{{ host$i }}"
      ansible_user: "{{ user }}"
EOF
        ((i=i+1))
done
echo
# Run ansible playbook to install Kubernetes cluster
ansible-playbook ~/.testenv/my/ansible/playbooks/k8s/vm-cluster-k8s.yaml
# Print symbols
echo -e "* Stack-ID:\n$stackid\n"
echo -e "* Host IPs VM:"
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
