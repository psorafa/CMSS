#!/bin/bash

# arguments:

#   1: Org Alias to setup - default "cmss"
#   2: Expiry days for the Scratch Org - default 10
#   3: Scratch Org Definition File path - default "conf/project-scratch-def.json"
#   4: Dev Hub Alias - optional, uses local default if blank

set -e

ALIAS=${1-"cmss"}
DAYS=${2-10}
CONF=${3-"config/project-scratch-def.json"}
DEVHUB=${4}

#cleanup when done
function finish {
    # revert changes to forceignore
    cp scripts/sh/ignores/.forceignore_sandbox .forceignore
}
trap finish EXIT
set -o xtrace

#create scratch org
if [ -z  "$DEVHUB" ];
then
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF --setdefaultusername
else
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile  $CONF --targetdevhubusername  $DEVHUB --setdefaultusername
fi

#install packages
sfdx force:package:install --package 04t2x000001WtSIAA0 -r --publishwait 3 --wait 8 -u $ALIAS
sfdx force:package:install --package 04t5p000000eegF -r --publishwait 3 --wait 8 -u $ALIAS
sfdx force:package:install --package 04t1U000003Bnj3QAC -r --publishwait 3 --wait 8 -u $ALIAS

# set forceignore to scratch org compatible
cp scripts/sh/ignores/.forceignore_SO .forceignore

# enable platform encryption
sfdx force:source:deploy -p cmss/scratch-orgs-only/permissionsets --targetusername $ALIAS
sfdx force:user:permset:assign --permsetname "ManageEncryptionKeys" --targetusername $ALIAS
sfdx force:data:record:create -s TenantSecret -v "Description=scratchOrgTest" --targetusername $ALIAS
sfdx force:source:deploy -p cmss/scratch-orgs-only/settings --targetusername $ALIAS
sfdx force:data:record:create -s TenantSecret -v "Description=scratchOrgTest Type=DeterministicData" --targetusername $ALIAS

#push source
sfdx force:source:push --ignorewarnings --forceoverwrite --targetusername $ALIAS

# reset source tracking so the next push won't push everything again
sfdx force:source:tracking:reset -p --targetusername $ALIAS

# add some permissions:
sfdx force:user:permset:assign --permsetname "ReadAllData,EditAllData,CustomSearchConfiguration,CustomSearchFilter" --targetusername $ALIAS

#setup data
scripts/sh/data.sh $ALIAS

set +o
echo "Org $ALIAS created!"
