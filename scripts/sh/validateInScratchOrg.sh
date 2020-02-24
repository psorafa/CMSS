#!/bin/bash
set -e

ALIAS=${1-"cmss_validate"}
TEST=${2-"RunLocalTests"}
CONF=${3-"config/project-scratch-def.json"}
DEVHUB=${4}
DAYS=${5-1}

#cleanup when done
function finish {
    # remove scratch org
    sfdx force:org:delete --targetusername $ALIAS --noprompt
}
trap finish EXIT
set -o xtrace

#create scratch org
if [ -n  "$DEVHUB"];
then
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF --setdefaultusername
else
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF --targetdevhubusername  $DEVHUB --setdefaultusername
fi

#deploy required settings
sfdx force:source:deploy -p "config/settings"
sfdx force:source:deploy -p "config/languages"

#push source
sfdx force:source:push

#run tests
sfdx force:apex:test:run --targetusername $ALIAS --testlevel $TEST --codecoverage --resultformat human

set +o
echo "Validation Successfull!"