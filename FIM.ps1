Write-Host ""
Write-Host "What would you like to do?"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring fiels with saved Baseline?"
Write-Host ""

$response = Read-Host -Prompt "Please enter 'A' or 'B' "

Function Calculate-File-Hash($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}
Function Erase-Baseline-If-Already-Exists(){
    $baselineExists= Test-Path -Path .\baseline.txt

    if($baselineExists){
    #Delete it
    Remove-Item -Path .\baseline.txt
    }
}


if($response -eq "A".ToUpper()){
    #Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    #Calculate the hash from the target files and store in baseline.txt

    #Collect all files in the target folder
    $files = Get-ChildItem -Path C:\Users\shriv\OneDrive\Desktop\FIM\Files
    
    #For file, calculate the has, and write to baseline.txt
    foreach($f in $files){
        $hash = Calculate-File-Hash $f.FullName

        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
       }
}
    #Write-Host "Calculate Hashes, make new baseline.txt" -ForegroundColor Cyan

elseif($response -eq "B".ToUpper()){
    
    $fileHashDictionary = @{}

    #Load file | hash from baseline.txt and store them in the dictionary
    $filePathsandHashes = Get-Content -Path .\baseline.txt

    foreach($f in $filePathsandHashes){
        $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
        }
    
    

    #Begin <continuously> monitoring files with saved baseline
    Write-Host "Read existing baseline.txt, start monitoring files." -ForegroundColor Yellow

    while($true){
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path C:\Users\shriv\OneDrive\Desktop\FIM\Files

        #For file, calculate the has, and write to baseline.txt

        foreach($f in $files){
        $hash = Calculate-File-Hash $f.FullName

        #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

        #Notify if a new file has been created
        if($fileHashDictionary[$hash.Path] -eq $null){
            #A new file has been created
            Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
          }
          else{
          #Notify if a new file has been changed
        if($fileHashDictionary[$hash.Path] -eq $hash.Hash){
            #The file has not been changed
           }
            else {
            #File has been compromised!, notify the user
            Write-host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
        }
       }
       
      }
      foreach($key in $fileHashDictionary.Keys){
            $baselineFileStillExists = Test-Path -Path $key
            if(-Not $baselineFileStillExists){
            #One of the baseline files must have deleted, notify the user
            Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
}

