#!C:\progra~1\Git\bin\sh.exe

# arguments:

# Bamboo user:
#   1: name
#   2: password
# Bitbucket user:
#   3: name
#   4: password
# Other:
#   5: ${bamboo.buildResultKey}
#   6: git project key
#   7: git repo key
#   8: git pull request key: ${bamboo.repository.pr.key}

if [ ! -f somefile.temp ];
then
  shopt -s expand_aliases
  alias jq=C:/Users/virt7173/bamboo-home/tools/jq-win64.exe

  attachmentUrl=$(curl -k -u ${3}:${4} --insecure \
       -X POST "https://gitvyvoj.cmss.local:8443/projects/${6}/repos/${7}/attachments" \
       -H 'Content-Type: multipart/form-data;' \
       -F "files=@log.txt" \
       | jq -j '.attachments[0].url')

  echo "Attachment URL: ${attachmentUrl}"

  curl -k -u ${3}:${4} \
       -H 'Content-type: application/json' \
       -X POST "https://gitvyvoj.cmss.local:8443/rest/api/latest/projects/${6}/repos/${7}/pull-requests/${8}/comments" \
       -d "{\"text\": \"Last build failed. See log file for more details: [${5}.log](${attachmentUrl})\"}"
fi