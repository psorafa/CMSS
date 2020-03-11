#!C:\progra~1\Git\bin\sh.exe
set -e

TARGETPATH=${1}

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importAssets.apex" "data/tree/assets.json" "{0}" "$TARGETPATH"