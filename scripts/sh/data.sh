#!/bin/bash
scriptString=$(<scripts/apex/importAccount.apex)
jsonData=$(<data/tree/Account.json)

echo ${scriptString/"{0}"/$jsonData} > scripts/apex/tmp/importAccount.apex

sfdx force:apex:execute --apexcodefile scripts/apex/tmp/importAccount.apex --targetusername cmss
