#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Current Commit to deploy - required
#   2: Previously deployed Commit - required
#   3: git diff filter - required
#   4: subfolder to compare - require

SOURCE_COMMIT=${1}
TARGET_COMMIT=${2}
FILTER=${3}
FOLDER=${4}

set -e

IFS=$'\n'
ORIGINAL_FILES=$(git diff -w --ignore-blank-lines --name-only --diff-filter="${FILTER}" "${TARGET_COMMIT}" "${SOURCE_COMMIT}" -- ":!**/*/.*" "${FOLDER}" | sed s/\"//g)

for FILE in $ORIGINAL_FILES; do
    echo "${FILE}"
done