#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Current Commit to deploy - required
#   2: Previously deployed Commit - required
#   3: git diff filter - required
#   4: subfolder to compare - require

CURRENT_BRANCH=${1}
SOURCE_BRANCH=${2}
FILTER=${3}
FOLDER=${4}

IFS=$'\n'
ORIGINAL_FILES=$(git diff -w --ignore-blank-lines --name-only --diff-filter="${FILTER}" "${CURRENT_BRANCH}" "${SOURCE_BRANCH}" "${FOLDER}" | sed s/\"//g)

for FILE in $ORIGINAL_FILES; do
    echo "${FILE}"
done