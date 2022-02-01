#!/bin/bash
# Login
az login
echo Initiating testenv command...
testenv stack create nginx-ctrl \
	--cloud vsphere \
	--ctrl-os ubuntu-20.04 \
	--ctrl-tarball-url release-3-22 \
	--datapath-os ubuntu-20.04 \
	--enable-multinode-ctrl true \
	--nginxplus-version 25 \
	--num-ctrl-hosts 3 \
	--num-datapath-ha-ips 1 \
	--num-datapaths 4 \
	--enable-features AppSec \
	--tag Rivian-22294
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
