#!/bin/bash
CTRLOS=centos-7;
#CTRLOS=ubuntu-20.04;
#CTRLOS=redhat-7;
# --os {amazonlinux-2,centos-7,centos-8,debian-9,debian-10,debian-11,freebsd-13,oracle-7,redhat-7,redhat-8,ubuntu-16.04,ubuntu-18.04,ubuntu-20.04}
CLOUD=vsphere;
LOGLEVEL=debug;
RELEASE=https://nginxdevopssvcs.blob.core.windows.net/cylon-indigo-generic-release/platform-packages/release-2-10-1/platform-repo-2.10.1.tar.gz
ENABLENAP=true;
#NAPVER=4.100.1;
#NAPVER=4.218.0;
NAPVER=4.218.0;
#NAPVER=4.279.0;
#NAPVER=4.402.0;
#NAPVER=4.457.0;
NGXCTRLTYPE=nginx-plus;
NGXPLSVER=28;
NUMNGX=2;
TAGRELEASE="nms_$(echo $RELEASE | awk -F/ '{print $6}')";

if [ $CLOUD == aws ]; then
	# Login
 	az login --use-device-code
fi
#az login --use-device-code

echo Initiating testenv command...
command="testenv stack create nginx-ctrl-v4 \
	--cloud $CLOUD \
  --ctrl-log-level $LOGLEVEL \
	--ctrl-tarball-url $RELEASE \
  --enable-nap $ENABLENAP
  --nap-version $NAPVER \
  --nginx-ctrl-type $NGXCTRLTYPE \
  --nginxplus-version $NGXPLSVER \
  --num-datapaths $NUMNGX \
  --tag $TAGRELEASE \
	--tag cli"
echo "$ ${command}"
${command}
# Get stackid
stackid=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
# Store stack symbols
stacksymbols=`testenv stack show symbols $stackid`
echo -e "* Stack-ID:\n$stackid\n"

# Print misc
echo "* Edit known hosts if ssh fails due to existing host entry"
echo "gawk -i inplace '\!/<host_ip>/' /Users/newfield/.ssh/known_hosts\n"
echo -e "* On platform install Security Monitoring:\nsudo apt-get update\nsudo apt-cache policy nms-sm\nsudo apt-get install nms-sm[=<build_ver>]\n"
echo -e "* On agent:"
echo -e "  - Create sm logging policy:\nsudo vim /etc/app_protect/conf/log_sm.json\n"
echo -e '{
    "filter": {
        "request_type": "illegal"
    },
    "content": {
        "format": "user-defined",
        "format_string": "%blocking_exception_reason%,%dest_port%,%ip_client%,%is_truncated_bool%,%method%,%policy_name%,%protocol%,%request_status%,%response_code%,%severity%,%sig_cves%,%sig_set_names%,%src_port%,%sub_violations%,%support_id%,%threat_campaign_names%,%violation_rating%,%vs_name%,%x_forwarded_for_header_value%,%outcome%,%outcome_reason%,%violations%,%violation_details%,%bot_signature_name%,%bot_category%,%bot_anomalies%,%enforced_bot_anomalies%,%client_class%,%client_application%,%client_application_version%,%transport_protocol%,%uri%,%request%",
        "escaping_characters": [
            {
                "from": ",",
                "to": "%2C"
            }
        ],
        "max_request_size": "2048",
        "max_message_size": "5k",
        "list_delimiter": "::"
    }
}'
echo -e "\n  - Implement nap logging to nginx (add below 'app_protect_enable on;' directive):\nsudo vim /etc/nginx/conf.d/default.conf\n"
echo -e "        app_protect_security_log_enable on;
        app_protect_security_log "/etc/app_protect/conf/log_sm.json" /var/log/app_protect/security.log;
        app_protect_security_log "/etc/app_protect/conf/log_sm.json" syslog:server=127.0.0.1:514;"
echo "\n  - Restart nginx:\nsudo systemctl restart nginx.service"
echo "\n  - Create a curl script that triggers nap events:\nvim bad-curl.sh\n"
echo -e '#!/bin/bash
while true
do
    curl "localhost/apple?1=<script>"
    sleep 0.5
  done'
echo "\n/bin/sh bad-curl.sh"
echo

# Print ctrl float ip and dashboard url
#ctrlip=`jq '.ctrl_floating_ip' <<< $stacksymbols | tr -d '"'`
#echo -e "* Ctrl Float IP:\n$ctrlip"
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
