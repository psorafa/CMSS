#!C:\progra~1\Git\bin\sh.exe
ALIAS=$1
CURRENT_COMMIT=$2
SOURCE_COMMIT=$3
FOLDER=${4-"cmss"}
TARGET=${5-"deploy"}

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
done

echo "Checking Changes to Deploy.."
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
done
echo "checkout current version again.."
git checkout $CURRENT_COMMIT

set -o xtrace
sfdx force:source:convert -p "$TARGET/deploy" -d "$TARGET/packageDeploy"
sfdx force:source:convert -p "$TARGET/destroy" -d "$TARGET/packageDestroy"

echo "prepare destructiveChanges.xml"
cp "$TARGET/packageDestroy/package.xml" "$TARGET/packageDeploy/destructiveChanges.xml"

#deploy with destructive changes as well
sfdx force:mdapi:deploy --deploydir  "$TARGET/packageDeploy" --checkonly --targetusername $ALIAS --wait 59