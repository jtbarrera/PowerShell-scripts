<#
Function: OS-Key-Remove <parameter> 
Purpose:
The funtion will by default query local machine for status OS key. It can optionally remove the OS key from the OS and the registry hive.
Parameter:
    status (optional, default)
    remove (optional)
Usage:
To remove OS license.
OS-Key-Remove remove
#>

Function OS-Key-Remove {

   [CmdletBinding()] 
    Param( 
         
        [Parameter(Mandatory=$False,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)] [String[]]$para = "status" #default
    ) 

    Begin 
    { 
    } 

    Process 
    { 
        try{
            $retryCount = 3
            $outFilePath = "c:\temp"
            $outFile = "scriptresult.txt"
            
            #create result file
            New-item -path $outFilePath -name $outFile -ItemType "file" 
            
            #Removing the KEY 
            while ($retryCount -gt 0) 
            { 
                if($para -eq "remove") {
                    Write-Output "Removing License Key..." | out-file $outFilePath\$outFile -Append
                    #trying to Uninstall key.... 
                    #cscript $env:SystemRoot\system32\slmgr.vbs /upk
                    Write-Output "Removing License Key from Registry..." | out-file $outFilePath\$outFile -Append
                    #trying to remove key from registry
                    #cscript $env:SystemRoot\system32\slmgr.vbs /cpky
                #verification process
                }
                if($para -eq "remove" -Or $para -eq "status") {
                                Write-Output "Verifying Activation Status..." | out-file $outFilePath\$outFile -Append
                                #checking the activation status..... 
                                $slmgrResult = cscript $env:SystemRoot\system32\slmgr.vbs /dli 
                                [string]$licenseStatus = ($slmgrResult | select-string -pattern "^License Status:") 
                                $licenseStatus = $LicenseStatus.Remove(0,16) 
 
                                if ( $licenseStatus -match "Licensed")  
                                { 
                                    Write-Host "Windows Licensed" -ForegroundColor Green
                                    Write-Output "Windows Licensed" | out-file $outFilePath\$outFile -Append
                                    $retryCount = 0 
                                } 
                 
                                else 
                                { 
                                    Write-Host "Windows NOT Licensed." -ForegroundColor Red 
                                    Write-Output "Windows NOT Licensed." | out-file $outFilePath\$outFile -Append
                                    $retryCount = $retryCount - 1 
                                } 
 
                                if ( $retryCount -gt 0 )  
                                { 
                                    Write-Host "Retrying Process. Will try $retryCount more time(s)" -ForegroundColor Yellow 
                                    Write-Output "Retrying Process. Will try $retryCount more time(s)" | out-file $outFilePath\$outFile -Append
                                }
                }
            }
     
     }
    catch 
    { 
        Write-Warning "Error during process!"  
    } 
  }

    End 
    {     
    } 
}
OS-Key-Remove 
