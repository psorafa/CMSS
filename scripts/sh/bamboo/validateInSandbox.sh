#!C:\progra~1\Git\bin\sh.exe
set -e

# arguments:

#   1: Org Alias to validate against - default "cmss_dev"
#   2: What tests should be exeuted - default is empty, i.e. default for given Org
#   3: The Soure Path to Validate - default "cmss"
mkdir -p log
LOG_FILE=log/validateInSandbox.txt
SUCCESS_FILE=successSandbox.tmp
if [ -f $LOG_FILE ];
then 
    rm ${LOG_FILE}
fi
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

if [ -f $SUCCESS_FILE ];
then
    rm ${SUCCESS_FILE}
fi

ALIAS=${1-"cmss_dev"}
TEST=${2-"RunLocalTests"}
PACKAGE=${3-"cmss"}

set -o xtrace

#validate deployment
if [ -z  "$TEST" ];
then
    sfdx force:source:deploy --sourcepath $PACKAGE --targetusername $ALIAS --checkonly
else
    sfdx force:source:deploy --sourcepath $PACKAGE --targetusername $ALIAS --testlevel $TEST --checkonly
fi

set +o
echo "Validation Successfull!"

# this is to let other scripts know that the build was successful
touch ${SUCCESS_FILE}