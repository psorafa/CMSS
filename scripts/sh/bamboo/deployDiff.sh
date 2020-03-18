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

echo "Checking Changes to Deploy.."
git diff -z --ignore-blank-lines --name-only --diff-filter="ACMRT" "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" ${FOLDER} |
while read -d $'\0' FILE
do
	#copy changed files to temp location
  	echo $FILE
    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
    mkdir "$TARGET/deploy/$FOLDER" -p
    cp "$FILE" "$TARGET/deploy/$FILE"
	#ensure that required meta files are present too, e.g. .cls and .cls-meta.xml
    if [[ -f "$FILE-meta.xml" ]]; then
    	cp "$FILE-meta.xml" "$TARGET/deploy/$FILE-meta.xml"
    fi
done

echo "Checking Changes to Delete.."
git diff -z --ignore-blank-lines --name-only --diff-filter="D" "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" ${FOLDER} |
while read -d $'\0' FILE
do
	#create empty files for deletion changes
    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
    mkdir "$TARGET/destroy/$FOLDER" -p
    touch "$TARGET/destroy/$FILE"
done

#go back to original commit and copy deleted files
echo "checkout previous version to get deleted files.."
git checkout $SOURCE_COMMIT
find "$TARGET/destroy" -type f | while read FILENAME
do 
	#copy the original content of deleted files so that convert would work
  	cp "${FILENAME##*"deploy/destroy/"}" "$FILENAME"  	  
	#ensure that required meta files are present too, e.g. .cls and .cls-meta.xml
  	if [[ -f "${FILENAME##*"deploy/destroy/"}-meta.xml" ]]; then
    	cp "${FILENAME##*"deploy/destroy/"}-meta.xml" "$FILENAME-meta.xml"
  	fi
done
echo "checkout current version again.."
git checkout $CURRENT_COMMIT

set -o xtrace
# convert temp source to Metadata package format
if [ -z "$(ls -A $TARGET/deploy)" ]; then
  	echo "Nothing Changed to Deploy"
else
  	sfdx force:source:convert -p "$TARGET/deploy" -d "$TARGET/packageDeploy"
fi

if [ -z "$(ls -A $TARGET/destroy)" ]; then
	echo "Nothing to Delete"
else
	sfdx force:source:convert -p "$TARGET/destroy" -d "$TARGET/packageDestroy"
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