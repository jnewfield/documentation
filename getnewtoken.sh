#1/bin/bash
# Get and set new testenv token

#curl -X POST -H "Content-Type: application/json" -d '{"email": "j.newfield@f5.com"}' https://testenv-backend.indigo.f5net.com/signup
# Go to email, get otp and etner here:
#read -p "OTP: " otp
otp=123456
echo $otp
echo -X POST -H "Content-Type: application/json" -d $(printf '{"email": "j.newfield@f5.com", "token": "%s"}' $otp)
printf '%s\n' $otp
tokendata=\'$(printf '{"email": "j.newfield@f5.com", "token": "%s"}' $otp)\'
echo $tokendata
#curlcmd=$(echo curl -X POST -H "Content-Type: application/json" -d $tokendata https://testenv-backend.indigo.f5net.com/verify)
echo $curlcmd
echo curl -X POST -H "Content-Type: application/json" -d $tokendata https://testenv-backend.indigo.f5net.com/verify
#echo $token
#sed -i 's/token:.*/token: $token/' ~/.testenv/config.yaml
#cat ~/.testenv/config.yaml