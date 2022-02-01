#!/bin/bash
# Login
az login
echo Initiating testenv command...
testenv stack create vm-cluster \
	--cloud vsphere \
	--os ubuntu-20.04 \
	--num-hosts 3 \
	--tag cli
# Get stackid
stackid=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
# Store stack symbols
stacksymbols=`testenv stack show symbols $stackid`
echo -e "* Stack-ID:\n$stackid\n"
# Print ctrl ips
hostips=`jq '.host_ips[]' <<< $stacksymbols | tr -d '"'`
ctrlusername=`jq '.host_ssh_username' <<< $stacksymbols | tr -d '"'`
echo -e "* Host IPs:"
i=1
for host in $hostips
do
        echo -e "ssh $ctrlusername@$host"
        ((i=i+1))
done
echo
# Print misc
echo "* Edit known hosts if ssh fails due to existing host entry"
echo "gawk -i inplace '!/<host_ip>/' /Users/newfield/.ssh/known_hosts"
echo
