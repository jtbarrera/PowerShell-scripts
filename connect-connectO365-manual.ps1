$AdminName = "UPN Name"
$Pass = Get-Content "Path\file.txt" | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AdminName, $Pass

Import-Module MSOnline
Connect-MsolService -Credential $cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
