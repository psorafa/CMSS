# arguments:

#   1: Org Alias to use for the Validation Scratch Org - default "cmss_validate"
#   2: What tests should be exeuted - default is "RunLocalTests"

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
    $ALIAS = 'cmss_validate'
}

$TEST=$args[1]
if ($TEST -eq $null) {
    $TEST = 'RunLocalTests'
}

try {

	#create scratch org
	echo "Creating scratch org..."
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
    $source = Join-Path scripts sh ignores .forceignore_SO
    Copy-Item $source -Destination ".forceignore"
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
	echo "Validating source deploy sequence..."
	sfdx force:source:deploy --ignorewarnings --targetusername $ALIAS --sourcepath cmss
    CheckLastExitCode	

	# add some permissions:
	sfdx force:user:permset:assign --permsetname "ReadAllData,EditAllData,CustomSearchConfiguration,CustomSearchFilter" --targetusername $ALIAS
    CheckLastExitCode
	
	#run tests
	echo "Running tests..."
	sfdx force:apex:test:run --targetusername $ALIAS --testlevel $TEST --codecoverage --resultformat human
    CheckLastExitCode

	#validate data import
    $script = Join-Path scripts ps data.ps1
    Invoke-Expression "$script $ALIAS"	

	Write-Host "Validation Successfull!" -ForegroundColor Green

} finally {
    #cleanup when done
    # revert changes to forceignore
    $source = Join-Path scripts sh ignores .forceignore_sandbox
    Copy-Item $source -Destination ".forceignore"
    # remove scratch org
	Write-Host "Deleting scratch org..." -ForegroundColor Green	
    sfdx force:org:delete --targetusername $ALIAS --noprompt
	Write-Host "Done" -ForegroundColor Green		
}