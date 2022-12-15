
$ALIAS=$args[0]
if ($null -eq $ALIAS) {
    Write-Host "Alias argument is required." -ForegroundColor Red
    exit
}

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
try {
    if (!(sfdx plugins |Select-String -Pattern "sfdmu")) {
        Write-Host "Plugin not installed: sfdmu" -ForegroundColor Yellow
        Write-Host "Trying to install..." -ForegroundColor Yellow
        sfdx plugins:install sfdmu
    }

    sfdx sfdmu:run -p data/core-data --sourceusername csvfile --targetusername $ALIAS
    CheckLastExitCode
    sfdx sfdmu:run -p data/custom-search --sourceusername csvfile --targetusername $ALIAS
    CheckLastExitCode

    Write-Host "Data loading completed." -ForegroundColor Green
} finally {
    # cleanup when done
    git checkout -- data/core-data/target
    git checkout -- data/custom-search/target
}