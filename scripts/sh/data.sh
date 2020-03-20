#!/bin/bash

# arguments:

#   1: Org Alias to create data in - required

set -e

ALIAS="${1}"

mkdir scripts/apex/tmp -p

accountsScript="scripts/apex/tmp/importAccounts.apex"
scripts/sh/data/Accounts.sh "$accountsScript"

productScript="scripts/apex/tmp/importProducts.apex"
scripts/sh/data/Products.sh "$productScript"

opportunityScript="scripts/apex/tmp/importOpportunities.apex"
scripts/sh/data/Opportunities.sh "$opportunityScript"

assetScript="scripts/apex/tmp/importAssets.apex"
scripts/sh/data/Assets.sh "$assetScript"

set -o xtrace
if [ -z "$ALIAS" ];
then
    sfdx force:apex:execute --apexcodefile $accountsScript
    sfdx force:apex:execute --apexcodefile $productScript
    sfdx force:apex:execute --apexcodefile $opportunityScript
    sfdx force:apex:execute --apexcodefile $assetScript
else
    sfdx force:apex:execute --apexcodefile $accountsScript --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile $productScript --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile $opportunityScript --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile $assetScript --targetusername $ALIAS
fi

rm -r scripts/apex/tmp

