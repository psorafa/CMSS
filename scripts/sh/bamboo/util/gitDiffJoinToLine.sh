#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Current Commit to deploy - required
#   2: Previously deployed Commit - required
#   3: git diff filter - required
#   4: subfolder to compare - require

SOURCE_COMMIT=${1}
CURRENT_COMMIT=${2}
FILTER=${3}
FOLDER=${4}

my_array=( $(scripts/sh/bamboo/util/gitDiff.sh "$CURRENT_COMMIT" "$SOURCE_COMMIT" "$FILTER" $FOLDER) )
my_line=$(printf '%s,' "${my_array[@]}")
echo ${my_line::-1}