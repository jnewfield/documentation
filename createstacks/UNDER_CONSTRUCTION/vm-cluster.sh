#!/bin/bash
# Vars
MOS=ubuntu-20.04
WOS=centos-7
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
MHOSTS=0
WHOSTS=2
# Login
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
az login
echo Initiating testenv command...
#testenv stack create vm-cluster --cloud vsphere --num-hosts 1 --os centos-7 --vsphere-host-disk-size 80 --tag CreatePID=4215124 --tag gui 
testenv stack create vm-cluster \
	--cloud vsphere \
	--os $MOS \
	--num-hosts $MHOSTS \
	--vsphere-host-disk-size 80 \
	--tag cli
	--tag master
# Get stackid
stackid1=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
testenv stack create vm-cluster \
	--cloud vsphere \
	--os $WOS \
	--num-hosts $WHOSTS \
	--vsphere-host-disk-size 20 \
	--tag cli
	--tag workers
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
# Create host variables for ansible use
cat <<EOF | tee ~/.testenv/my/ansible/playbooks/group_vars/vmclustervars
# vars from script ~/.testenv/my/vm-cluster.sh
host1: $host1
EOF
i=2
for host in $hostips2
do
	echo "host$i: $host" >> ~/.testenv/my/ansible/playbooks/group_vars/vmclustervars
        ((i=i+1))
done
echo
# Run ansible to install kuberntes
ansible-playbook ~/.testenv/my/ansible/playbooks/vm-cluster.yaml
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
