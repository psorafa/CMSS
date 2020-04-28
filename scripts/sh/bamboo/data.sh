#!C:\progra~1\Git\bin\sh.exe

# arguments:

#   1: Org Alias to create data in - required

set -e

AALIAS="${1}"

mkdir scripts/apex/tmp -p

TARGETPATH="scripts/apex/tmp"

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importAccounts.apex" "data/tree/businessAccounts.json" "{1}" "$TARGETPATH/importAccounts.apex"
scripts/sh/bamboo/util/mergeJson.sh "$TARGETPATH/importAccounts.apex" "data/tree/personAccounts.json" "{0}" "$TARGETPATH/importAccounts.apex"

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importProducts.apex" "data/tree/products.json" "{0}" "$TARGETPATH/importProducts.apex"

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importOpportunities.apex" "data/tree/opportunities.json" "{0}" "$TARGETPATH/importOpportunities.apex"
scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importOpportunities.apex" "data/tree/opportunities2.json" "{0}" "$TARGETPATH/importOpportunities2.apex"

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importAssets.apex" "data/tree/assets.json" "{0}" "$TARGETPATH/importAssets.apex"

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importTasks.apex" "data/tree/assetTasks.json" "{0}" "$TARGETPATH/importTasks.apex"
scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importTasks.apex" "data/tree/assetTasks2.json" "{0}" "$TARGETPATH/importTasks2.apex"

scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importAssetAccountRelations.apex" "data/tree/assetAccountRelations.json" "{0}" "$TARGETPATH/importAssetAccountRelations.apex"
scripts/sh/bamboo/util/mergeJson.sh "scripts/apex/importAssetAccountRelations.apex" "data/tree/assetAccountRelations2.json" "{0}" "$TARGETPATH/importAssetAccountRelations2.apex"

set -o xtrace
if [ -z "$ALIAS" ];
then
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAccounts.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importProducts.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importOpportunities.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importOpportunities2.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssets.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importTasks.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importTasks2.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssetAccountRelations.apex"
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssetAccountRelations2.apex"
else
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAccounts.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importProducts.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importOpportunities.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importOpportunities2.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssets.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importTasks.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importTasks2.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssetAccountRelations.apex" --targetusername $ALIAS
    sfdx force:apex:execute --apexcodefile "$TARGETPATH/importAssetAccountRelations2.apex" --targetusername $ALIAS
fi

rm -r scripts/apex/tmp