#!C:\progra~1\Git\bin\sh.exe
set -e

ALIAS=${1-"cmss_validate"}
TEST=${2-"RunLocalTests"}
CONF=${3-"config/project-scratch-def.json"}
DEVHUB=${4}
DAYS=${5-1}

#cleanup when done
function finish {
    # remove scratch org
    echo "Deleting scratch org..."
    sfdx force:org:delete --targetusername $ALIAS --noprompt
    echo "Done."
}
trap finish EXIT
set -o xtrace

#create scratch org
echo "Creating scratch org..."
if [ -n  "$DEVHUB"];
then
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF
else
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF --targetdevhubusername  $DEVHUB
fi

#push source
echo "Pushing source..."
sfdx force:source:push --targetusername $ALIAS

#run tests
echo "Running tests..."
# disabled for now as there are no tests yet
# sfdx force:apex:test:run --targetusername $ALIAS --testlevel $TEST --codecoverage --resultformat human

set +o
echo "Validation Successfull!"

# this is to let other scripts know that the build was successful
touch success.temp