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
            #Removing the KEY 
            $retryCount = 3 
            while ($retryCount -gt 0) 
            { 
                if($para -eq "remove") {
                    Write-Output "Removing License Key..." 
                    #trying to Uninstall key.... 
                    #cscript $env:SystemRoot\system32\slmgr.vbs /upk
                    Write-Output "Removing License Key from Registry..."
                    #trying to remove key from registry
                    #cscript $env:SystemRoot\system32\slmgr.vbs /cpky
                #verification process
                }
                if($para -eq "remove" -Or $para -eq "status") {
                                Write-Output "Verifying Activation Status..." 
                                #checking the activation status..... 
                                $slmgrResult = cscript $env:SystemRoot\system32\slmgr.vbs /dli 
                                [string]$licenseStatus = ($slmgrResult | select-string -pattern "^License Status:") 
                                $licenseStatus = $LicenseStatus.Remove(0,16) 
 
                                if ( $licenseStatus -match "Licensed")  
                                { 
                                    Write-Host "Windows Licensed" -ForegroundColor Green 
                                    $retryCount = 0 
                                } 
                 
                                else 
                                { 
                                    Write-Host "Windows NOT Licensed." -ForegroundColor Red 
                                    $retryCount = $retryCount - 1 
                                } 
 
                                if ( $retryCount -gt 0 )  
                                { 
                                    Write-Host "Retrying Process. Will try $retryCount more time(s)" -ForegroundColor Yellow 
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