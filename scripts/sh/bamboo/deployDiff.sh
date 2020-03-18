#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Org Alias to Deploy - required
#   2: Current Commit to deploy - required
#   3: Previously deployed Commit - required
#   4: The Soure Path to Deploy - default "cmss"
#   5: What tests should be exeuted - default is empty, i.e. default for given Org
#   6: Package Folder o use as temporary storage for deployment package

mkdir -p log
LOG_FILE=log/deployDiff.txt
rm ${LOG_FILE}
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

ALIAS=$1
CURRENT_COMMIT=$2
SOURCE_COMMIT=$3
FOLDER=${4-"cmss"}
TEST=${5}
TARGET=${6-"deploy"}

set -e

#clear the folders
mkdir -p "$TARGET/packageDeploy"
find "$TARGET/packageDeploy/" -delete
mkdir -p "$TARGET/packageDestroy"
find "$TARGET/packageDestroy/" -delete

set -o xtrace

echo "Checking Changes to Deploy.."
DEPLOY_ARTIFACTS=$(scripts/sh/bamboo/util/gitDiffJoinToLine.sh "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" "ACMRT" "${FOLDER}")
echo $DEPLOY_ARTIFACTS
# convert temp source to Metadata package format
if [ -z "$DEPLOY_ARTIFACTS" ]; then
  	echo "Nothing Changed to Deploy"
else
  	sfdx force:source:convert -p "$DEPLOY_ARTIFACTS" -d "$TARGET/packageDeploy"
fi

echo "Checking Changes to Delete.."
DELETE_ARTIFACTS=$(scripts/sh/bamboo/util/gitDiffJoinToLine.sh "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" "D" "${FOLDER}")
echo $DELETE_ARTIFACTS


if [ -z "$DELETE_ARTIFACTS" ]; then
	echo "Nothing to Delete"
else
	#go back to original commit and copy deleted files
	echo "checkout previous version to get deleted files.."
	git checkout $SOURCE_COMMIT

	sfdx force:source:convert -p "$DELETE_ARTIFACTS" -d "$TARGET/packageDestroy"

	echo "checkout current version again.."
	git checkout $CURRENT_COMMIT

	echo "prepare destructiveChanges.xml"
	#prepare destructive xml manifest
	mkdir -p "$TARGET/packageDeploy"
	cp "$TARGET/packageDestroy/package.xml" "$TARGET/packageDeploy/destructiveChanges.xml"
fi

#deploy with destructive changes as well
if [ -z "$(ls -A $TARGET/packageDeploy)" ]; then
   echo "Nothing to deploy"
else
	if [ -z  "$TEST" ];	then
		sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59
	else
		sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59 --testlevel $TEST
	fi
   	echo "Deploy Successful"
fi
# this is to let other scripts know that the deployment was successful
touch successDeploy.tmp