#!/bin/bash
ALIAS="${1}"

mkdir scripts/apex/tmp

accountsScript="scripts/apex/tmp/importAccount.apex"
scripts/sh/data/Accounts.sh "$accountsScript"

set -o xtrace
sfdx force:apex:execute --apexcodefile $accountsScript --targetusername $ALIAS

rm -r scripts/apex/tmp

