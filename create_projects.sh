export PATH=$PATH:$(pwd)

# List already created projects
cpdctl project list

N=2

for i in $(seq 1 $N); do
    project_name="project-$i"
    echo Creating project "$project_name"...
    project_location=$(cpdctl project create --name "$project_name" --output json --raw-output --jmes-query 'location')
    project_id=$(basename $project_location)
    echo New project ID: "$project_id"
    
    echo Importing project assets...
    cpdctl asset import start --project-id "$project_id" --import-file archives/project-assets.zip
done