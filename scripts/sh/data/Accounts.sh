#!/bin/bash
set -e

TARGETPATH=${1}

scripts/sh/util/mergeJson.sh "scripts/apex/importAccounts.apex" "data/tree/businessAccounts.json" "{1}" "$TARGETPATH"
scripts/sh/util/mergeJson.sh "$TARGETPATH" "data/tree/personAccounts.json" "{0}" "$TARGETPATH"



