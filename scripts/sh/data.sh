#!/bin/bash
set -e

ALIAS="${1}"

mkdir scripts/apex/tmp -p

accountsScript="scripts/apex/tmp/importAccounts.apex"
scripts/sh/data/Accounts.sh "$accountsScript"

set -o xtrace
sfdx force:apex:execute --apexcodefile $accountsScript --targetusername $ALIAS

rm -r scripts/apex/tmp

