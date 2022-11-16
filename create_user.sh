#!/bin/bash

export PATH=$PATH:$(pwd)/bin

username=$1
password=$2

payload=$(cat <<__EOD__
{
   "username":"$username",
   "displayName":"$username",
   "user_roles":[
      "zen_user_role",
      "zen_developer_role",
      "wkc_data_scientist_role"
   ],
   "password":"$password"
}
__EOD__
)
echo $payload > user.json

echo "Creating user $username..."

cpd-cli user-mgmt upsert-user "$username" --data user.json --profile default
rm -f user.json