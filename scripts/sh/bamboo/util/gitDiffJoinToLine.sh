#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Current Commit to deploy - required
#   2: Previously deployed Commit - required
#   3: git diff filter - required
#   4: subfolder to compare - require

SOURCE_BRANCH=${1}
CURRENT_BRANCH=${2}
FILTER=${3}
FOLDER=${4}

my_array=( $(scripts/sh/bamboo/util/diff.sh $CURRENT_COMMIT $SOURCE_COMMIT $FILTER $FOLDER) )
printf '%s,' "${my_array[@]}"