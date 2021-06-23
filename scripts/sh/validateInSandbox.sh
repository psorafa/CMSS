#!/bin/bash
set -e

# arguments:

#   1: Org Alias to use for the Validation Scratch Org - default "cmss_validate"
#   2: What tests should be exeuted - default "RunLocalTests"
#   3: The Soure Path to Validate - default "cmss"

ALIAS=${1-"cmss_dev"}
TEST=${2-"RunLocalTests"}
PACKAGE=${3-"cmss"}

set -o xtrace

#validate deployment
if [ -z "$TEST" ];
then
    sfdx force:source:deploy --ignorewarnings --sourcepath $PACKAGE --targetusername $ALIAS --checkonly
else
    sfdx force:source:deploy --ignorewarnings --sourcepath $PACKAGE --targetusername $ALIAS --testlevel $TEST --checkonly
fi

set +o
echo "Validation Successfull!"