#!C:\progra~1\Git\bin\sh.exe
set -e

SCRIPT_PATH=${1}
JSON_PATH=${2}
MARKER=${3}
TMP_PATH=${4}

scriptString=$(<"$SCRIPT_PATH")
jsonData=$(grep "" "$JSON_PATH" | awk '{print}' ORS='')

mergedString=${scriptString/"$MARKER"/$jsonData}
echo "$mergedString" > "$TMP_PATH"
