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

#push source
sfdx force:source:push --ignorewarnings --targetusername $ALIAS

#workaround to catch translation errors that silently fail in push
sfdx force:source:deploy --sourcepath cmss/app/default/translations --targetusername $ALIAS

# reset source tracking so the next push won't push everything again
sfdx force:source:tracking:reset -p

#setup data
scripts/sh/data.sh $ALIAS

set +o
echo "Org $ALIAS created!"
