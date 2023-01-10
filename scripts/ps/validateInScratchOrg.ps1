# arguments:

#   1: Org Alias to use for the Validation Scratch Org - default "cmss_validate"
#   2: What tests should be exeuted - default is "RunLocalTests"

$ErrorActionPreference = "Stop"
function CheckLastExitCode {
    param ([int[]]$SuccessCodes = @(0))
    if (!$?) {
        Write-Host "Last CMD failed" -ForegroundColor Red
        Write-Host "Validation failed." -ForegroundColor Red
        exit
    }
    if ($SuccessCodes -notcontains $LastExitCode) {
        Write-Host "EXE RETURNED EXIT CODE $LastExitCode" -ForegroundColor Red
        Write-Host "Validation failed." -ForegroundColor Red
        exit
    }
}

$ALIAS=$args[0]
if ($null -eq $ALIAS) {
    $ALIAS = 'cmss_validate'
}

$TEST=$args[1]
if ($null -eq $TEST) {
    $TEST = 'RunLocalTests'
}

try
{
    if (7 -gt $PSVersionTable.PSVersion.Major)
    {
        Write-Host "Powershell version 7 required." -ForegroundColor Red
        Write-Host "Please update your powershell." -ForegroundColor Red
        exit
    }

    Write-Host "Validation started, creating scratch org..." -ForegroundColor Magenta
    #create scratch org
    sfdx force:org:create --setalias $ALIAS --durationdays 30 --definitionfile config/project-scratch-def.json
    CheckLastExitCode

    #install packages
    Write-Host "Installing packages..." -ForegroundColor Magenta
    sfdx force:package:beta:install --package 04t2x000001WtSIAA0 -r --publishwait 3 --wait 8 -u $ALIAS
    CheckLastExitCode
    sfdx force:package:beta:install --package 04t5p000000eegF -r --publishwait 3 --wait 8 -u $ALIAS
    CheckLastExitCode
    sfdx force:package:beta:install --package 04t1U000003Bnj3QAC -r --publishwait 3 --wait 8 -u $ALIAS
    CheckLastExitCode

    # set forceignore to scratch org compatible
    $source = Join-Path scripts sh ignores .forceignore_SO
    Copy-Item $source -Destination ".forceignore"
    CheckLastExitCode

    # enable platform encryption
    Write-Host "Enable platform encryption..." -ForegroundColor Magenta
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
    Write-Host "Now pushing the whole source, this may take a while (usually 10 - 20 min)" -ForegroundColor Magenta
    sfdx force:source:push --ignorewarnings --forceoverwrite --targetusername $ALIAS
    CheckLastExitCode

    # reset source tracking so the next push won't push everything again
    sfdx force:source:tracking:reset -p --targetusername $ALIAS
    CheckLastExitCode

    # add some permissions:
    sfdx force:user:permset:assign --permsetname "ReadAllData,EditAllData,CustomSearchConfiguration,CustomSearchFilter" --targetusername $ALIAS
    CheckLastExitCode

    #setup data
    Write-Host "Setting up data..." -ForegroundColor Magenta
    $script = Join-Path scripts ps data.ps1
    Invoke-Expression "$script $ALIAS"
    CheckLastExitCode

    Write-Host "Validation Successfull!" -ForegroundColor Green
} finally {
    #cleanup when done
    # revert changes to forceignore
    $source = Join-Path scripts sh ignores .forceignore_sandbox
    Copy-Item $source -Destination ".forceignore"
    # remove scratch org
	Write-Host "Deleting scratch org..." -ForegroundColor Magenta
    sfdx force:org:delete --targetusername $ALIAS --noprompt
	Write-Host "All done."
}