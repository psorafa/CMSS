#!/bin/bash
set -e

ALIAS=${1-"cmss"}
DAYS=${2-10}
CONF=${3-"config/project-scratch-def.json"}
DEVHUB=${4}

set -o xtrace

#create scratch org
if [ -n  "$DEVHUB"];
then
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF --setdefaultusername
else
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF --targetdevhubusername  $DEVHUB --setdefaultusername
fi

#push source
sfdx force:source:push --targetusername $ALIAS

#setup data
#tbc

set +o
echo "Org $ALIAS created!"
