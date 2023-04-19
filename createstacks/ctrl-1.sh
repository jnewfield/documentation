#!/bin/bash
CTRLOS=centos-7;
#CTRLOS=ubuntu-20.04;
#CTRLOS=redhat-7;
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
NGXOS=ubuntu-20.04;
#RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-14/controller-installer-3.14.0.tar.gz
#RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-22/controller-installer-3.22.1.tar.gz
#DO_NOT_USE RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-22/controller-installer-3.22.2.tar.gz
#RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-22/controller-installer-3.22.3.tar.gz
RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-22/controller-installer-3.22.5.tar.gz
#RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-22/controller-installer-3.22.6.tar.gz
#RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-19/apim-controller-installer-3.19.4.tar.gz
#Next is APIM-3.19.4-P1
#RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-dev/apim-controller-packages/controller-installer/apim-release-3-19/offline-controller-installer-614098828.tar.gz
#RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/controller-packages/release-3-19/apim-controller-installer-3.19.5.tar.gz
NUMCTRL=1;
CREATEDBHOST=false;
MULTINODE=false;
NUMNGX=2;
CLOUD=vsphere;
HA=0;
#if [ $CLOUD == aws ]; then
#	# Login
#	az login
#fi
az login
echo Initiating testenv command...
command="testenv stack create nginx-ctrl \
	--cloud $CLOUD \
  --create-db-host $CREATEDBHOST \
	--ctrl-os $CTRLOS \
	--ctrl-tarball-url $RELEASE \
	--datapath-os $NGXOS \
	--enable-multinode-ctrl $MULTINODE \
	--nginxplus-version 25 \
	--num-ctrl-hosts $NUMCTRL \
	--num-datapath-ha-ips $HA  \
	--num-datapaths $NUMNGX \
	--enable-features AppSec \
	--tag general \
	--tag cli \
	--tag cloud_$CLOUD \
	--tag ctrl_$CTRLOS_$NUMCTRL \
	--tag ngx_$NGXOS_$NUMNGX"
echo "$ ${command}"
${command}
# Get stackid
stackid=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
# Store stack symbols
stacksymbols=`testenv stack show symbols $stackid`
echo -e "* Stack-ID:\n$stackid\n"
# Print ctrl float ip and dashboard url
ctrlip=`jq '.ctrl_floating_ip' <<< $stacksymbols | tr -d '"'`
echo -e "* Ctrl Float IP:\n$ctrlip"
ctrlurl=`jq '.ctrl_dashboard_url' <<< $stacksymbols | tr -d '"'`
echo -e "* Ctrl Dashboard URL:\n$ctrlurl"
# Print ctrl ips
ctrlhosts=`jq '.control_host_ips[]' <<< $stacksymbols | tr -d '"'`
ctrlusername=`jq '.control_host_ssh_username' <<< $stacksymbols | tr -d '"'`
echo -e "* Ctrl hosts:"
i=1
for host in $ctrlhosts
do
        echo -e "CTRL$i:"
        echo -e "ssh $ctrlusername@$host"
        ((i=i+1))
done
echo
# Print datapath float ip
dpfloat=`jq '.datapath_floating_addrs[].ip' <<< $stacksymbols | tr -d '"'`
echo -e "* Datapath Float IP:\n$dpfloat"
# Print datapath ips
dphosts=`jq '.datapath_host_ips[]' <<< $stacksymbols | tr -d '"'`
dpusername=`jq '.datapath_host_ssh_username' <<< $stacksymbols | tr -d '"'`
echo -e "* Datapath hosts:"
for host in $dphosts
do
        echo -e "ssh $dpusername@$host"
done
echo
# Print workload ips
wlhosts=`jq '.workload_host_ips[]' <<< $stacksymbols | tr -d '"'`
wlusername=`jq '.workload_host_ssh_username' <<< $stacksymbols | tr -d '"'`
echo -e "* Workload hosts:"
for host in $wlhosts
do
        echo -e "$host"
        echo -e "ssh $wlusername@$host"
done
echo
# Print misc
echo -e "* Add njs to datapath hosts:\nsudo apt-get -y install nginx-plus-module-njs"
echo -e "* Add services to workload hosts:\ncurl -k https://gitlab.es.f5net.com/snippets/27/raw > script.sh && chmod +x script.sh && ./script.sh"
echo "* Edit known hosts if ssh fails due to existing host entry"
echo "gawk -i inplace '!/<host_ip>/' /Users/newfield/.ssh/known_hosts"
echo
