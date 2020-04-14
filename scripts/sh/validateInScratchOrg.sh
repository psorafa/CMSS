#!/bin/bash

# arguments:

#   1: Org Alias to use for the Validation Scratch Org - default "cmss_validate"
#   2: Dev Hub Alias - optional, uses local default if blank
#   3: What tests should be exeuted - default is empty, i.e. none
#   4: Scratch Org Defnition File path - defualt "conf/project-scratch-def.json"
#   5: Expiry days for the Scratch Org (in case script fails to delete it) - default 1

set -e

ALIAS=${1-"cmss_validate"}
DEVHUB=${2}
TEST=${3-"RunLocalTests"}
CONF=${4-"config/project-scratch-def.json"}
DAYS=${5-1}

#cleanup when done
function finish {
    # remove scratch org
    echo "Deleting scratch org..."
    #sfdx force:org:delete --targetusername $ALIAS --noprompt
    echo "Done."
}
trap finish EXIT
set -o xtrace

#create scratch org
echo "Creating scratch org..."
if [ -z "$DEVHUB" ];
then
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile $CONF
else
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile $CONF --targetdevhubusername $DEVHUB
fi

#push source
echo "Validating source deploy sequence..."
sfdx force:source:deploy --targetusername $ALIAS --sourcepath cmss/main/default/
sfdx force:source:deploy --targetusername $ALIAS --sourcepath cmss/main/util/
sfdx force:source:deploy --targetusername $ALIAS --sourcepath cmss/customer-360/
sfdx force:source:deploy --targetusername $ALIAS --sourcepath cmss/customer-search/
sfdx force:source:deploy --targetusername $ALIAS --sourcepath cmss/activity-management/
sfdx force:source:deploy --targetusername $ALIAS --sourcepath cmss/product-contract/
sfdx force:source:deploy --targetusername $ALIAS --sourcepath cmss/app/

#run tests
if [ -n "$TEST" ];
then
    echo "Running tests..."
    sfdx force:apex:test:run --targetusername $ALIAS --testlevel $TEST --codecoverage --resultformat human
fi

#validate data import
scripts/sh/data.sh $ALIAS

set +o
echo "Validation Successfull!"
