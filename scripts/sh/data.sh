#!/bin/bash

# arguments:

#   1: Org Alias to create data in - required

set -e

ALIAS="${1}"

mkdir -p scripts/apex/tmp

TARGETPATH="scripts/apex/tmp"

scripts/sh/util/mergeJson.sh "scripts/apex/importAccounts.apex" "data/tree/businessAccounts.json" "{1}" "$TARGETPATH/importAccounts.apex"
scripts/sh/util/mergeJson.sh "$TARGETPATH/importAccounts.apex" "data/tree/personAccounts.json" "{0}" "$TARGETPATH/importAccounts.apex"

scripts/sh/util/mergeJson.sh "scripts/apex/importProducts.apex" "data/tree/products.json" "{0}" "$TARGETPATH/importProducts.apex"

scripts/sh/util/mergeJson.sh "scripts/apex/importOpportunities.apex" "data/tree/opportunities.json" "{0}" "$TARGETPATH/importOpportunities.apex"
scripts/sh/util/mergeJson.sh "scripts/apex/importOpportunities.apex" "data/tree/opportunities2.json" "{0}" "$TARGETPATH/importOpportunities2.apex"

scripts/sh/util/mergeJson.sh "scripts/apex/importAssets.apex" "data/tree/assets.json" "{0}" "$TARGETPATH/importAssets.apex"

scripts/sh/util/mergeJson.sh "scripts/apex/importTasks.apex" "data/tree/assetTasks.json" "{0}" "$TARGETPATH/importTasks.apex"
scripts/sh/util/mergeJson.sh "scripts/apex/importTasks.apex" "data/tree/assetTasks2.json" "{0}" "$TARGETPATH/importTasks2.apex"

scripts/sh/util/mergeJson.sh "scripts/apex/importAssetAccountRelations.apex" "data/tree/assetAccountRelations.json" "{0}" "$TARGETPATH/importAssetAccountRelations.apex"
scripts/sh/util/mergeJson.sh "scripts/apex/importAssetAccountRelations.apex" "data/tree/assetAccountRelations2.json" "{0}" "$TARGETPATH/importAssetAccountRelations2.apex"

scripts/sh/util/mergeJson.sh "scripts/apex/importAccountRelations.apex" "data/tree/accountRelations.json" "{0}" "$TARGETPATH/importAccountRelations.apex"

set -o xtrace

sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAccounts.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importProducts.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importOpportunities.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importOpportunities2.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssets.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importTasks.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importTasks2.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssetAccountRelations.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssetAccountRelations2.apex" --targetusername $ALIAS
sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAccountRelations.apex" --targetusername $ALIAS
sfdx sfdmu:run -p data/custom-search --sourceusername csvfile --targetusername $ALIAS
git checkout -- data/custom-search/target

rm -r scripts/apex/tmp