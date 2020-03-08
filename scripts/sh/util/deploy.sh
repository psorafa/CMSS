#!/bin/bash
set -e

ALIAS=$3

TEST=${4-"RunLocalTests"}
PATH=${5-"cmss"}

if [ -z "$CURRENT_BRANCH" ]
then
    echo "Current Branch (param1) is not specified"
    exit -1
fi

if [ -z "$SOURCE_BRANCH" ]
then
    echo "Current Branch (param2) is not specified"
    exit -1
fi

if [ -z "$ALIAS" ]
then
    echo "Org Alias (param3) is not specified"
    exit -1
fi

#get changed files
FILES_TO_CHANGE="$(getFilesByFilter "$CURRENT_BRANCH" "$SOURCE_BRANCH" "ACMRT" "/")"
FILES_TO_CHANGE_SIZE=$(echo -n "$FILES_TO_CHANGE" | wc -c)

#deploy
if [[ $FILES_TO_CHANGE_SIZE -gt 0 ]]
then
    COMMAND_DEPLOY="sfdx force:source:deploy --sourcepath \"${FILES_TO_CHANGE::-1}\" --targetusername $ALIAS --testlevel $TEST --checkonly"
    #sfdx force:source:deploy --sourcepath \"${FILES_TO_CHANGE::-1}\" --targetusername $ALIAS --testlevel $TEST --checkonly
    echo "$COMMAND_DEPLOY"
    echo "$(eval "${COMMAND_DEPLOY}")"
fi

#get deleted files
#FILES_TO_DELETE="$(getFilesByFilter "$CURRENT_BRANCH" "$SOURCE_BRANCH" "D" "cmss/")"
#FILES_TO_DELETE_SIZE=$(echo -n "$FILES_TO_DELETE" | wc -c)
#for FILE in $FILES_TO_DELETE; do
#    mkdir -p "$(dirname "${FILE::-1}")"
#    touch ${FILE::-1}
#done

#set -o xtrace


#delete
if [[ $FILES_TO_DELETE_SIZE -gt 0 ]];
then
    COMMAND_DELETE="sfdx force:source:deploy --sourcepath \"${FILES_TO_DELETE::-1}\" --targetusername $ALIAS --testlevel $TEST --checkonly"
    #sfdx force:source:delete --sourcepath \"${FILES_TO_DELETE::-1}\" --targetusername $ALIAS --testlevel $TEST --checkonly
    echo "$(eval "${COMMAND_DELETE}")"
fi

echo "Deploy Successfull!"