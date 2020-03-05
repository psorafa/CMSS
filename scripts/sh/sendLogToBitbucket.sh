#!C:\progra~1\Git\bin\sh.exe

# arguments:

# Bamboo user:
#   1: name
#   2: password
# Bitbucket user:
#   3: name
#   4: password
# Other:
#   5: ${bamboo.buildKey}
#   6: ${bamboo.buildResultKey}
#   7: git project key
#   8: git repo key
#   9: git pull request key: ${bamboo.repository.pr.key}

if [ ! -f somefile.temp ];
then
  shopt -s expand_aliases
  alias jq=C:/Users/virt7173/bamboo-home/tools/jq-win64.exe

  # download log:
  curl -X GET --user ${1}:${2} "http://gitvyvoj.cmss.local:8086/download/${5}/build_logs/${6}.log" -o ${6}.log

  attachmentUrl=$(curl -k -u ${3}:${4} --insecure \
       -X POST "https://gitvyvoj.cmss.local:8443/projects/${7}/repos/${8}/attachments" \
       -H 'Content-Type: multipart/form-data;' \
       -F "files=@${6}.log" \
       | jq -j '.attachments[0].url')

  echo "Attachment URL: ${attachmentUrl}"

  curl -k -u ${3}:${4} \
       -H 'Content-type: application/json' \
       -X POST "https://gitvyvoj.cmss.local:8443/rest/api/latest/projects/${7}/repos/${8}/pull-requests/${9}/comments" \
       -d "{\"text\": \"Last build failed. See log file for more details: [${6}.log](${attachmentUrl})\"}"
fi