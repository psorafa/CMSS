
#!/bin/bash
CURRENT_COMMIT=$1
SOURCE_COMMIT=$2
FOLDER=${3-"cmss"}
TARGET=${4-"deploy"}

set -e

mkdir -p "$TARGET/deploy"
mkdir -p "$TARGET/destroy"
mkdir -p "$TARGET/packageDeploy"
mkdir -p "$TARGET/packageDestroy"

echo "Changes to Deploy.."
git diff -z --ignore-blank-lines --name-only --diff-filter="ACMRT" "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" ${FOLDER} |
while read -d $'\0' FILE
do
    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
    mkdir "$TARGET/deploy/$FOLDER" -p
    cp "$FILE" "$TARGET/deploy/$FILE"
done
sfdx force:source:convert -p "$TARGET/deploy" -d "$TARGET/packageDeploy"

git diff -z --ignore-blank-lines --name-only --diff-filter="D" "${SOURCE_COMMIT}" "${CURRENT_COMMIT}" ${FOLDER} |
while read -d $'\0' FILE
do
    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
    mkdir "$TARGET/destroy/$FOLDER" -p
    touch "$TARGET/destroy/$FILE"
done

#go back to original commit and copy deleted files
echo "checkout previous version.."
git checkout $SOURCE_COMMIT
find "$TARGET/destroy" -type f | while read FILENAME
do 
  cp "${FILENAME##*"deploy/destroy/"}" "$FILENAME"
done
echo "checkout current version.."
git checkout $CURRENT_COMMIT
sfdx force:source:convert -p "$TARGET/destroy" -d "$TARGET/packageDestroy"
cp "$TARGET/packageDestroy/package.xml" "$TARGET/packageDeploy/destructiveChanges.xml"

#deploy with destructive changes as well
set -o xtrace
sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --checkonly --targetusername cmss_dev