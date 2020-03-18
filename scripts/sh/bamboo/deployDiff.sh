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
  	echo $FILE
    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
    mkdir "$TARGET/deploy/$FOLDER" -p
    cp "$FILE" "$TARGET/deploy/$FILE"
    if EXISTS "$FILE-meta.xml" (
      cp "$FILE-meta.xml" "$TARGET/deploy/$FILE-meta.xml"
    )
done

echo "Checking Changes to Delete.."
git diff -z --ignore-blank-lines --name-only --diff-filter="D" "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" ${FOLDER} |
while read -d $'\0' FILE
do
    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
    mkdir "$TARGET/destroy/$FOLDER" -p
    touch "$TARGET/destroy/$FILE"
done

#go back to original commit and copy deleted files
echo "checkout previous version to get deleted files.."
git checkout $SOURCE_COMMIT
find "$TARGET/destroy" -type f | while read FILENAME
do 
  cp "${FILENAME##*"deploy/destroy/"}" "$FILENAME"
  if EXISTS "${FILENAME##*"deploy/destroy/"}-meta.xml" (
    cp "${FILENAME##*"deploy/destroy/"}-meta.xml" "$FILENAME-meta.xml"
  )
done
echo "checkout current version again.."
git checkout $CURRENT_COMMIT

set -o xtrace
sfdx force:source:convert -p "$TARGET/deploy" -d "$TARGET/packageDeploy"
sfdx force:source:convert -p "$TARGET/destroy" -d "$TARGET/packageDestroy"

echo "prepare destructiveChanges.xml"
cp "$TARGET/packageDestroy/package.xml" "$TARGET/packageDeploy/destructiveChanges.xml"

#deploy with destructive changes as well
if [ -z  "$TEST" ];
then
  	sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59
else
	sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --targetusername $ALIAS --wait 59 --testlevel $TEST
fi
# this is to let other scripts know that the deployment was successful
touch successDeploy.tmp