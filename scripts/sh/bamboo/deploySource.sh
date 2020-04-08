#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Org Alias to Deploy- required
#   2: What tests should be exeuted - default is empty, i.e. default for given Org
#   3: The Soure Path to Deploy - default "cmss"

mkdir -p log
LOG_FILE=log/deploySource.txt
rm ${LOG_FILE}
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

ALIAS=$1
TEST=${2-"RunLocalTests"}
PACKAGE=${3-"cmss"}

if [ -z "$ALIAS" ]
then
    echo "Org Alias is required"
    exit -1
fi

set -o xtrace
set -e

#deploy to org (CHECK ONLY SO FAR FOR TESTING)
if [ -z  "$TEST" ];
then
    sfdx force:source:deploy --sourcepath $PACKAGE --targetusername $ALIAS
else
    sfdx force:source:deploy --sourcepath $PACKAGE --targetusername $ALIAS --testlevel $TEST
fi

echo "Deploy Successfull!"
# this is to let other scripts know that the deployment was successful
touch successDeploy.tmp