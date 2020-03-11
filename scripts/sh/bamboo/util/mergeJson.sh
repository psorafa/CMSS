#!C:\progra~1\Git\bin\sh.exe
set -e

SCRIPT_PATH=${1}
JSON_PATH=${2}
MARKER=${3}
TMP_PATH=${4}

scriptString=$(<"$SCRIPT_PATH")
jsonData=$(grep "" "$JSON_PATH" | awk '{print}' ORS='')

echo ${scriptString/"$MARKER"/$jsonData} > "$TMP_PATH"
