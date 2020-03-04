#!/bin/bash
set -e

TARGETPATH=${1}

echo $TARGETPATH

scripts/sh/util/mergeJson.sh "scripts/apex/importPersonAccounts.apex" "data/tree/Account.json" "{0}" "$TARGETPATH"



