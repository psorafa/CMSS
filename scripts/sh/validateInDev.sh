#!/bin/bash
set -e

ALIAS=${1-"cmss_dev"}
TEST=${2-"RunLocalTests"}
PACKAGE=${3-"cmss"}

set -o xtrace

#validate deployment
sfdx force:source:deploy --sourcepath $PACKAGE --targetusername $ALIAS --testlevel $TEST --checkonly

set +o
echo "Validation Successfull!"