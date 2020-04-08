#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Org Alias to Deploy - required
#   2: Current Commit to deploy - required
#   3: Previously deployed Commit - required
#   4: The Soure Path to Deploy - default "cmss"
#   5: What tests should be exeuted - default is empty, i.e. default for given Org
#   6: Mode - validation instead of deployment, default "deploy", other "validate"
#   7: Package Folder o use as temporary storage for deployment package

mkdir -p log
LOG_FILE=log/deployDiff.txt
rm ${LOG_FILE}
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

ALIAS=$1
PREVIOUS_COMMIT=$2
LATEST_COMMIT=$3
FOLDER=${4-"cmss"}
TEST=${5}
MODE=${6-"deploy"}
TARGET=${7-"deploy"}

#clear the folders
mkdir -p "$TARGET/packageDeploy"
find "$TARGET/packageDeploy/" -delete
mkdir -p "$TARGET/packageDestroy"
find "$TARGET/packageDestroy/" -delete

echo "DeployDiff $MODE with $TEST to $ALIAS from $PREVIOUS_COMMIT to $LATEST_COMMIT"

set -e

#clear the folders
mkdir -p "$TARGET/packageDeploy"
find "$TARGET/packageDeploy/" -delete
mkdir -p "$TARGET/packageDestroy"
find "$TARGET/packageDestroy/" -delete

set -o xtrace

echo "Checking Changes to Deploy.."
DEPLOY_ARTIFACTS=$(scripts/sh/bamboo/util/gitDiffJoinToLine.sh "${PREVIOUS_COMMIT}" "${LATEST_COMMIT}" "ACMRT" "${FOLDER}")
echo "To deploy:$DEPLOY_ARTIFACTS"
# convert temp source to Metadata package format
if [ -z "$DEPLOY_ARTIFACTS" ]; then
	echo "Nothing Changed to Deploy"
	mkdir -p "$TARGET/packageDeploy"
	cp "config/emptyPackage.xml" "$TARGET/packageDeploy/package.xml"
else
  	sfdx force:source:convert -p "$DEPLOY_ARTIFACTS" -d "$TARGET/packageDeploy"
fi

echo "Checking Changes to Delete.."
DELETE_ARTIFACTS=$(scripts/sh/bamboo/util/gitDiffJoinToLine.sh "${PREVIOUS_COMMIT}" "${LATEST_COMMIT}" "D" "${FOLDER}")
echo "To delete:$DELETE_ARTIFACTS"


if [ -z "$DELETE_ARTIFACTS" ]; then
	echo "Nothing to Delete"
else
	#go back to original commit and copy deleted files
	echo "checkout previous version to get deleted files.."
	git checkout $PREVIOUS_COMMIT

	sfdx force:source:convert -p "$DELETE_ARTIFACTS" -d "$TARGET/packageDestroy"

	echo "checkout current version again.."
	git checkout $LATEST_COMMIT

	echo "prepare destructiveChanges.xml"
	#prepare destructive xml manifest
	mkdir -p "$TARGET/packageDeploy"
	cp "$TARGET/packageDestroy/package.xml" "$TARGET/packageDeploy/destructiveChanges.xml"
fi

#deploy with destructive changes as well
if [ -z "$DELETE_ARTIFACTS" ] && [ -z "$DEPLOY_ARTIFACTS" ]; then
   echo "Nothing to deploy"
else
	if [ -z  "$TEST" ];	then
		if [ "validate" -eq  "$MODE" ]; then
			sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59 --checkonly
		else
			sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59
		fi	
	else
		if [ "validate" -eq  "$MODE" ];	then
			sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59 --testlevel $TEST --checkonly
		else
			sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59 --testlevel $TEST
		fi
	fi
   	echo "Deploy Successful"
fi
# this is to let other scripts know that the deployment was successful
touch successDeploy.tmp