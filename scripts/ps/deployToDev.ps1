
$ErrorActionPreference = "Stop"
function CheckLastExitCode {
    param ([int[]]$SuccessCodes = @(0))
    if (!$?) {
        Write-Host "Last command failed" -ForegroundColor Red
        exit
    }
    if ($SuccessCodes -notcontains $LastExitCode) {
        Write-Host "EXE RETURNED EXIT CODE $LastExitCode" -ForegroundColor Red
        exit
    }
}

$ALIAS = "cmss-Dev"

$source = Join-Path scripts sh ignores .forceignore_sandbox
Copy-Item $source -Destination ".forceignore"
CheckLastExitCode

sfdx force:source:deploy -p cmss -u $ALIAS --ignorewarnings
CheckLastExitCode
sfdx force:org:open -u $ALIAS
CheckLastExitCode

$orgInfo = sfdx force:org:display --json -u $ALIAS | ConvertFrom-Json
CheckLastExitCode
$instanceUrl = $orgInfo.result.instanceUrl
CheckLastExitCode

# manual steps:
# Start-Process "$instanceUrl/lightning/setup/PermSets/page?address=%2F0PS1j000000ZOVE%2Fe%3Fs%3DSystemPermissions"
# Start-Process "$instanceUrl/lightning/setup/PermSets/page?address=%2F0PS1j000000ZOVI%2Fe%3Fs%3DSystemPermissions"
