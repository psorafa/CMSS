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

mkdir -p "$TARGET/deploy"
mkdir -p "$TARGET/destroy"
mkdir -p "$TARGET/packageDeploy"
mkdir -p "$TARGET/packageDestroy"

set -o xtrace

echo "Checking Changes to Deploy.."
DEPLOY_ARTIFACTS=""
git diff -z --ignore-blank-lines --name-only --diff-filter="ACMRT" "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" ${FOLDER} |
while read -d $'\0' FILE
do
	#copy changed files to temp variable
	echo $FILE
	DEPLOY_ARTIFACTS="$FILE,$DEPLOY_ARTIFACTS"
done
echo $DEPLOY_ARTIFACTS

echo "Checking Changes to Delete.."
DELETE_ARTIFACTS=""
git diff -z --ignore-blank-lines --name-only --diff-filter="D" "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" ${FOLDER} |
while read -d $'\0' FILE
do
	#copy deleted files to temp variable
	echo $FILE
	DELETE_ARTIFACTS="$FILE,$DELETE_ARTIFACTS"
done
echo $DELETE_ARTIFACTS

# convert temp source to Metadata package format
if [ -z "$DEPLOY_ARTIFACTS" ]; then
  	echo "Nothing Changed to Deploy"
else
  	sfdx force:source:convert -p "$DEPLOY_ARTIFACTS" -d "$TARGET/packageDeploy"
fi

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
	cp "$TARGET/packageDestroy/package.xml" "$TARGET/packageDeploy/destructiveChanges.xml"
fi

#deploy with destructive changes as well
if [ -z  "$TEST" ];
then
  	sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59
else
	sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59 --testlevel $TEST
fi
# this is to let other scripts know that the deployment was successful
touch successDeploy.tmp