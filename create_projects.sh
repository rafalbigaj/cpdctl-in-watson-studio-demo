#!/bin/bash

export PATH=$PATH:$(pwd)/bin

# Do not use user credentials provided in JupyterLab context
unset USER_ACCESS_TOKEN

ADMIN_USERNAME=rafal.bigaj
ADMIN_UID=$(cpd-cli user-mgmt get-user "$ADMIN_USERNAME" --profile default | jq -r '.uid')

N_USERS=100
N_PROJECTS=100 # # of projects per user

N_USERS=2
N_PROJECTS=4

PROJECT_MEMBERS=$(cat <<__EOD__
[{"user_name":"$ADMIN_USERNAME", "role": "admin", "id": "$ADMIN_UID"}]
__EOD__
)

for uidx in $(seq 1 $N_USERS); do
    # create a user - project owner
    username="project-user-$uidx"
    password=password
    context="$username-context"
    ./create_user.sh "$username" "$password"

    # Switch cpdctl context to use the new user
    cpdctl config context set "$context" --profile default --username "$username" --password "$password"

    # List already created projects
    export CPD_CONTEXT="$context"
    cpdctl project list

    for pidx in $(seq 1 $N_PROJECTS); do
        project_name="project-$uidx-$pidx"
        echo Creating project "$project_name"...
        project_location=$(cpdctl project create --name "$project_name" --output json --raw-output --jmes-query 'location')
        project_id=$(basename $project_location)
        echo New project ID: "$project_id"
        
        echo Adding admin user as project members...
        cpdctl project member create --project-id "$project_id" --members "$PROJECT_MEMBERS"

        echo Importing project assets...
        cpdctl asset import start --project-id "$project_id" --import-file archives/project-assets.zip
    done
done