function Merge-CSVFiles { 
[cmdletbinding()] 
param( 
    [string[]]$CSVFiles, 
    [string]$OutputFile = "c:\merged.csv" 
) 
$Output = @(); 
foreach($CSV in $CSVFiles) { 
    if(Test-Path $CSV) { 
         
        $FileName = [System.IO.Path]::GetFileName($CSV) 
        $temp = Import-CSV -Path $CSV | select *, @{Expression={$FileName};Label="FileName"} 
        $Output += $temp 
 
    } else { 
        Write-Warning "$CSV : No such file found" 
    } 
 
} 
$Output | Export-Csv -Path $OutputFile -NoTypeInformation 
Write-Output "$OutputFile successfully created" 
 
} 

Merge-CSVFiles -CSVFiles C:\scripts\get-msoluser-DisabledOnly.csv,C:\scripts\get-msoluser-UnlicensedUsersOnly.csv,C:\scripts\get-msoluser-Exclusion.csv -OutputFile C:\scripts\get-msoluser-combined.csv
Import-Csv C:\scripts\get-msoluser-combined.csv | sort UserPrincipalName -Unique | Export-Csv c:\scripts\get-msoluser-unique.csv -NoTypeInformation

