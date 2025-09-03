# This script will create a single-node cluster, else it will create a multi-node cluster
#!/bin/bash
#set -x
# vars
#OS=ubuntu-20.04
OS=ubuntu-22.04
#OS=centos-7
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
## ubuntu-22.04 results in hosts getting assigned the same ip address, 10.155.195.146
HOSTS=3
#HOSTS=1
CLOUD=vsphere
CLUSTER=multi-node
if [[ "$HOSTS" == 1 ]]; then CLUSTER=single-node; fi
# Choose from latest Kubernetes version, currently v1.24-v1.29
# See Installing Kubeadm for latest supported versions:  https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
KUBEVER=v1.33
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
	--tag k8s \
	--tag $OS \
	--tag $CLOUD \
  --tag $CLUSTER
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
# Variables to use inside ansible
#  cri-docker packages to install - https://github.com/Mirantis/cri-dockerd/releases
 case "$OS" in
	ubuntu-20.04) 
    criDockerPkg="cri-dockerd_0.4.0.3-0.ubuntu-focal_amd64.deb"
    criDockerRepoVer="0.4.0"
	 ;;
  ubuntu-22.04)
    criDockerPkg="cri-dockerd_0.4.0.3-0.ubuntu-jammy_amd64.deb"
    criDockerRepoVer="0.4.0"
 ;;
  placeholder1) criDockerPkg=""
     ;;
	*)
		;;
esac
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
# Get latest release from https://github.com/Mirantis/cri-dockerd/releases
criDockerPkg: $criDockerPkg
criDockerRepoVer: $criDockerRepoVer
kubeVer: $KUBEVER
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
if [[ "$HOSTS" == 1 ]]; then
  ansible-playbook ~/.testenv/my/ansible/playbooks/k8s/vm-cluster-singlenode-k8s.yaml
else
  ansible-playbook ~/.testenv/my/ansible/playbooks/k8s/vm-cluster-multinode-k8s.yaml
fi
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
