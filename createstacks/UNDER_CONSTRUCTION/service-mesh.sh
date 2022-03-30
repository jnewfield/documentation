#!/bin/bash
CTLRNODES=1
WRKNODES=2
CLOUD=vsphere
# vsphere or aws
if [ $CLOUD == aws ]; then
	# Login
	az login
fi
echo Initiating testenv command...
testenv stack create service-mesh \
	--cloud $CLOUD \
 	--kubernetes-version v1.16.8 \
	--num-control-nodes $CTLRNODES \
	--num-worker-nodes $WRKNODES \
	--vsphere-control-node-disk-size 60 \
	--tag cli
	--tag servicemesh
	--tag $CLOUD
# Get stackid
stackid=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
# Store stack symbols
stacksymbols=`testenv stack show symbols $stackid`
echo -e "* Stack-ID:\n$stackid\n"
# Print node ips
nodeips=`jq '.control_host_ips[]' <<< $stacksymbols | tr -d '"'`
nodeusername=`jq '.control_node_ssh_username' <<< $stacksymbols | tr -d '"'`
echo -e "* Node IPs:"
i=1
for host in $nodeips
do
        echo -e "ssh $nodeusername@$host"
        ((i=i+1))
done
echo
# Print worker ips
workerips=`jq '.worker_node_ips[]' <<< $stacksymbols | tr -d '"'`
workerusername=`jq '.worker_node_ssh_username' <<< $stacksymbols | tr -d '"'`
echo -e "* Worker IPs:"
i=1
for host in $workerips
do
        echo -e "ssh $workerusername@$host"
        ((i=i+1))
done
echo
# Print misc
echo "* Edit known hosts if ssh fails due to existing host entry"
echo "gawk -i inplace '!/<host_ip>/' /Users/newfield/.ssh/known_hosts"
echo
