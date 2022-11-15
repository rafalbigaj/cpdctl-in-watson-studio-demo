export PATH=$PATH:$(pwd)

# List already created projects
cpdctl space list

N=2

for i in $(seq 1 $N); do
    space_name="deployment-space-$i"
    echo Creating deployment space "$space_name"...
    space_id=$(cpdctl space create --name "$space_name" --output json --raw-output --jmes-query 'metadata.id')
    echo New deployment space ID: "$space_id"
    
    echo Importing deployment space assets...
    cpdctl asset import start --space-id "$space_id" --import-file archives/space-assets.zip
done