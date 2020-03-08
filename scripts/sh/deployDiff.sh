
#!/bin/bash
CURRENT_BRANCH=$1
SOURCE_BRANCH=$2
FOLDER=${3-"cmss"}
TARGET=${4-"deploy"}

set -e

mkdir -p "$TARGET/deploy"
mkdir -p "$TARGET/destroy"
mkdir -p "$TARGET/packageDeploy"
mkdir -p "$TARGET/packageDestroy"

#echo "Changes to Deploy.."
#git diff -z --ignore-blank-lines --name-only --diff-filter="ACMRT" "${CURRENT_BRANCH}" "${SOURCE_BRANCH}" ${FOLDER} |
#while read -d $'\0' FILE
#do
#    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
#    mkdir "$TARGET/deploy/$FOLDER" -p
#    cp "$FILE" "$TARGET/deploy/$FILE"
#done
#sfdx force:source:convert -p "$TARGET/deploy" -d "$TARGET/packageDeploy"

git diff -z --ignore-blank-lines --name-only --diff-filter="D" "${CURRENT_BRANCH}" "${SOURCE_BRANCH}" ${FOLDER} |
while read -d $'\0' FILE
do
    FOLDER=$(echo $FILE | sed 's|\(.*\)/.*|\1|')
    mkdir "$TARGET/destroy/$FOLDER" -p
    touch "$TARGET/destroy/$FILE"
done

#go back to original commit and copy deleted files
echo "checkout previous version.."
git checkout $SOURCE_BRANCH
find "$TARGET/destroy" -type f 
while read FILE
do 
  echo "original: $FILE"
  echo "${FILE##*"deploy/destroy"}"
done

#sfdx force:source:convert -p "$TARGET/destroy" -d "$TARGET/packageDestroy"
#cp "$TARGET/packageDestroy/package.xml" "$TARGET/packageDeploy/destructiveChanges.xml"
