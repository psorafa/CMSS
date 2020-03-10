#!C:\progra~1\Git\bin\sh.exe
set -e

TARGETPATH=${1}

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importAccounts.apex" "data/tree/businessAccounts.json" "{1}" "$TARGETPATH"
scripts/sh/bamboo/util/mergeJson.sh "$TARGETPATH" "data/tree/personAccounts.json" "{0}" "$TARGETPATH"



