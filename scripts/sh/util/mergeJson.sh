#!/bin/bash
set -e

SCRIPT_PATH=${1}
JSON_PATH=${2}
MARKER=${3}
TMP_PATH=${4}

scriptString=$(<"$SCRIPT_PATH")
jsonData=$(<"$JSON_PATH")

echo ${scriptString/"$MARKER"/$jsonData} > "$TMP_PATH"
