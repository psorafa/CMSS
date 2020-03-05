#!C:\progra~1\Git\bin\sh.exe
LOG_FILE=log.txt
rm ${LOG_FILE}
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)
set -e

ALIAS=$1
TEST=${2-"RunLocalTests"}
PACKAGE=${3-"cmss"}

if [ -z "$ALIAS" ]
then
    echo "Org Alias is required"
    exit -1
fi

set -o xtrace

#deploy to org (CHECK ONLY SO FAR FOR TESTING)
sfdx force:source:deploy --sourcepath $PACKAGE --targetusername $ALIAS --testlevel $TEST --checkonly

set +o
echo "Deploy Successfull!"