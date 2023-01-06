Write-Host ""
Write-Host "What would you like to do?"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring fiels with saved Baseline?"
Write-Host ""

$response = Read-Host -Prompt "Please enter 'A' or 'B' "

if($response -eq "A".ToUpper()){
    #Calculate the hash from the target files and store in baseline.txt
    Write-Host "Calculate Hashes, make new baseline.txt" -ForegroundColor Cyan
}
elseif($response -eq "B".ToUpper()){
    #Begin monitoring files with saved baseline
    Write-Host "Read existing baseline.txt, start monitoring files." -ForegroundColor Yellow
}
