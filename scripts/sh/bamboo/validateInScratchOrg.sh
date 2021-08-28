#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Org Alias to use for the Validation Scratch Org - default "cmss_validate"
#   2: Dev Hub Alias - optional, uses local default if blank
#   3: What tests should be exeuted - default is empty, i.e. none
#   4: Scratch Org Defnition File path - defualt "conf/project-scratch-def.json"
#   5: Expiry days for the Scratch Org (in case script fails to delete it) - default 1

mkdir -p log
LOG_FILE=log/validateInScratchOrg.txt
SUCCESS_FILE=successScratchOrg.tmp

if [ -f $LOG_FILE ];
then
    rm ${LOG_FILE}
fi
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

if [ -f SUCCESS_FILE ];
then
    rm ${SUCCESS_FILE}
fi

set -e

ALIAS=${1-"cmss_validate"}
DEVHUB=${2}
TEST=${3-"RunLocalTests"}
CONF=${4-"config/project-scratch-def.json"}
DAYS=${5-1}
killAll=0

#wrap sfdx source push with timeout
pushWithTimeout() {
    timeout -k 1 15m \
    sfdx force:source:deploy --ignorewarnings --targetusername "$1" --sourcepath "$2"
}

#cleanup when done
function finish {
    if (($? == 124)); then
      echo "Push seems to be stuck, please re-run validation manually."
      killAll=1
    fi
    # remove scratch org
    echo "Deleting scratch org..."
    sfdx force:org:delete --targetusername $ALIAS --noprompt
    echo "Done."
    if (($killAll == 1)); then
      kill -9 -$$
    fi
}
trap finish EXIT
set -o xtrace

#workaround for "SyntaxError: Unexpected token < in JSON at position 1" bug
sfdx force:config:set restDeploy=false
#create scratch org
echo "Creating scratch org..."
if [ -z "$DEVHUB" ];
then
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile $CONF
else
    sfdx force:org:create --setalias $ALIAS --durationdays $DAYS --definitionfile $CONF --targetdevhubusername $DEVHUB
fi

#install packages
sfdx force:package:install --package 04t2x000001WtSIAA0 -r --publishwait 3 --wait 8 -u $ALIAS
sfdx force:package:install --package 04t5p000000eegF -r --publishwait 3 --wait 8 -u $ALIAS

#push source
echo "Pushing source..."
pushWithTimeout $ALIAS cmss/main/
pushWithTimeout $ALIAS cmss/integrations/
pushWithTimeout $ALIAS cmss/customer-360/
pushWithTimeout $ALIAS cmss/customer-search/
pushWithTimeout $ALIAS cmss/consent-icons/
pushWithTimeout $ALIAS cmss/consent-management/
pushWithTimeout $ALIAS cmss/activity-management/
pushWithTimeout $ALIAS cmss/opportunity-management/
pushWithTimeout $ALIAS cmss/portfolio-management/
pushWithTimeout $ALIAS cmss/product-contract/
pushWithTimeout $ALIAS cmss/case-management/
pushWithTimeout $ALIAS cmss/app/

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

# this is to let other scripts know that the build was successful
touch ${SUCCESS_FILE}