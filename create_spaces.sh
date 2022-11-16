#!/bin/bash

export PATH=$PATH:$(pwd)/bin

# Do not use user credentials provided in JupyterLab context
unset USER_ACCESS_TOKEN

ADMIN_USERNAME=rafal.bigaj
ADMIN_UID=$(cpd-cli user-mgmt get-user "$ADMIN_USERNAME" --profile default | jq -r '.uid')

N_USERS=100
N_SPACES=100 # # of projects per user

N_USERS=2
N_SPACES=2

SPACE_MEMBERS=$(cat <<__EOD__
[{"role": "admin", "id": "$ADMIN_UID", "type": "user"}]
__EOD__
)

# List already created projects
cpdctl space list

for uidx in $(seq 1 $N_USERS); do
    # create a user - space owner
    username="space-user-$uidx"
    password=password
    context="$username-context"
    ./create_user.sh "$username" "$password"

    # Switch cpdctl context to use the new user
    cpdctl config context set "$context" --profile default --username "$username" --password "$password"

    # List already created projects
    export CPD_CONTEXT="$context"
    cpdctl space list

    for sidx in $(seq 1 $N_SPACES); do
        space_name="deployment-space-$uidx-$sidx"
        echo Creating deployment space "$space_name"...
        space_id=$(cpdctl space create --name "$space_name" --output json --raw-output --jmes-query 'metadata.id')
        echo New deployment space ID: "$space_id"
        
        echo Adding admin user as deployment space members...
        cpdctl space member create --space-id "$space_id" --members "$SPACE_MEMBERS"

        echo Importing deployment space assets...
        cpdctl asset import start --space-id "$space_id" --import-file archives/space-assets.zip
    done
done
