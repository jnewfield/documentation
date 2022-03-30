#!/bin/bash
CLOUD=vsphere
# vsphere or aws
# Get ip address to allow to aws stack
read -p "Internet facing client ip address to allow to aws stack (google 'what's my ip'): " ip
# Validate ip is an ip address
if !([[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]); then
  echo "$ip is not a valid ip address"
  echo "exit 1"
  echo
fi
# Logon to aws
#echo Logon to aws to activate aws profile
#aws sso login
if [ $CLOUD == aws ]; then
	# Logon to azure
	az login
fi
# Run create aws stack command
echo Creating stack...
testenv stack create windows-ad \
	--cloud $CLOUD \
	--tag cli
	--tag $CLOUD
	--tag ActiveDirectory
# Extract newly created stackid
stackid=`echo $(cat ~/.testenv/latest_stack_id | tr -d '"')`
# Store stack symbols
stacksymbols=`testenv stack show symbols $stackid`
echo -e "* Stack-ID:\n$stackid\n"
# Print ad ip
adip=`jq '.windows_ad_host_ip' <<< $stacksymbols | tr -d '"'`
echo -e "* Win AD IP:\n$adip"
# Print win username
username=`jq '.winrm_username' <<< $stacksymbols | tr -d '"'`
echo -e "* Uername:\n$username"
# Print win password
password=`jq '.winrm_password' <<< $stacksymbols | tr -d '"'`
echo -e "* Password:\n$password\n"
# Print win domain
domain=`jq '.windows_user_domain_format' <<< $stacksymbols | tr -d '"' | awk '{print tolower($0)}'`
echo -e "* Domain:\n$domain\n"
echo -e "* Setup AD:\n\t1. Create Group: CN=devops,OU=Distribution Lists,OU=Groups\n\t2. Change password restrictions: Group Policy Management -> Forest -> Domains -> <domain_name> -> right-click Default Domain Policy and click Edit -> Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Account Policies -> Password Policy\n\t3. Create User: testenv Testenv12#\n\t4. Add devops in 'Member Of' of user\n"
