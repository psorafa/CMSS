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

mapfile -t my_array < <(scripts/sh/bamboo/util/gitDiff.sh "$SOURCE_COMMIT" "$TARGET_COMMIT" "$FILTER" $FOLDER)
my_line=$(printf '%s,' "${my_array[@]}")
echo ${my_line::-1}