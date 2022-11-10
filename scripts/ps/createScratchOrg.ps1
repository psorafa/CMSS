
# arguments:

#   1: Org Alias to setup - default "cmss"

$ErrorActionPreference = "Stop"
function CheckLastExitCode {
    param ([int[]]$SuccessCodes = @(0))
    if (!$?) {
        Write-Host "Last CMD failed" -ForegroundColor Red
        #GoToWrapperDirectory in my code I go back to the original directory that launched the script
        exit
    }
    if ($SuccessCodes -notcontains $LastExitCode) {
        Write-Host "EXE RETURNED EXIT CODE $LastExitCode" -ForegroundColor Red
        #GoToWrapperDirectory in my code I go back to the original directory that launched the script
        exit
    }
}

$ALIAS=$args[0]
if ($ALIAS -eq $null) {
    $ALIAS = 'cmss'
}

try {

    echo "Creating scratch org..."
    #create scratch org
    sfdx force:org:create --setalias $ALIAS --durationdays 30 --definitionfile config/project-scratch-def.json --setdefaultusername
    CheckLastExitCode

    #install packages
    sfdx force:package:install --package 04t2x000001WtSIAA0 -r --publishwait 3 --wait 8 -u $ALIAS
    CheckLastExitCode
    sfdx force:package:install --package 04t5p000000eegF -r --publishwait 3 --wait 8 -u $ALIAS
    CheckLastExitCode
    sfdx force:package:install --package 04t1U000003Bnj3QAC -r --publishwait 3 --wait 8 -u $ALIAS
    CheckLastExitCode

    # set forceignore to scratch org compatible
    Copy-Item "scripts/sh/ignores/.forceignore_SO" -Destination ".forceignore"
    CheckLastExitCode

    # enable platform encryption
    sfdx force:source:deploy -p cmss/scratch-orgs-only/permissionsets --targetusername $ALIAS
    CheckLastExitCode
    sfdx force:user:permset:assign --permsetname "ManageEncryptionKeys" --targetusername $ALIAS
    CheckLastExitCode
    sfdx force:data:record:create -s TenantSecret -v "Description=scratchOrgTest" --targetusername $ALIAS
    CheckLastExitCode
    sfdx force:source:deploy -p cmss/scratch-orgs-only/settings --targetusername $ALIAS
    CheckLastExitCode
    sfdx force:data:record:create -s TenantSecret -v "Description=scratchOrgTest Type=DeterministicData" --targetusername $ALIAS
    CheckLastExitCode

    #push source
    sfdx force:source:push --ignorewarnings --forceoverwrite --targetusername $ALIAS
    CheckLastExitCode

    # reset source tracking so the next push won't push everything again
    sfdx force:source:tracking:reset -p --targetusername $ALIAS
    CheckLastExitCode

    # add some permissions:
    sfdx force:user:permset:assign --permsetname "ReadAllData,EditAllData,CustomSearchConfiguration,CustomSearchFilter" --targetusername $ALIAS
    CheckLastExitCode

    #setup data
    Invoke-Expression "scripts/ps/data.ps1 $ALIAS"

    Write-Host "Org $ALIAS created!" -ForegroundColor Green

} finally {
    #cleanup when done
    # revert changes to forceignore
    Copy-Item "scripts/sh/ignores/.forceignore_sandbox" -Destination ".forceignore"
}