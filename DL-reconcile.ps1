<#
.SYNOPSIS
    Automation to prune Exchange online distribution list using Azure AD queries and custom list. 

.DESCIPTION
    PowerShell designed to run from commandline or via Windows Task Manager. Running account must have evelated local and Office 365 account.
    All working files designed to run out of speified working directory.

.VARIABLES
    $WorkingDir = "<Directory for all working files>"
    $DistoList = "<Name of target distribution list>"
    $AdminName = "<Azure AD admin account used to query and run script>"

.Resource Files 
    cred.txt – Encrypted file used for authentication to Office 365 online service. 
    get-msoluser-DisabledOnly.csv – CSV file containing disabled office 365 accounts.
    get-msoluser-Exclusion.csv – CSV file containing manually edited email to be excluded. 
    get-msoluser-UnlicensedUsersOnly.csv – CSV file containing unlicensed Office 365 accounts. 

.TODO
    Optimize generated CSV files 
    Implement logging of removed accounts from distribution list
    Optimize script flow to test member exists in DL then remove member 
    Improve credential storage
#>

# Editable Variables
$WorkingDir = "C:\Scripts\PowerShell\DLReconcile"
$DistoList = "DistributionList"
$AdminName = "admin@contoso.com"

# Decrypting password and authenticating to Microsoft Online
$Pass = Get-Content "$WorkingDir\cred.txt" | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AdminName, $Pass
Import-Module MSOnline
Connect-MsolService -Credential $cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session

# Generate CSV files from O365 accounts
get-msoluser -All -UnlicensedUsersOnly | Export-Csv $WorkingDir\get-msoluser-UnlicensedUsersOnly.csv -NoTypeInformation
get-msoluser -All -EnabledFilter DisabledOnly | Export-Csv $WorkingDir\get-msoluser-DisabledOnly.csv -NoTypeInformation

# Remove members from target distribution list
$Userslist1 = Import-CSV $WorkingDir\get-msoluser-UnlicensedUsersOnly.csv
ForEach ($User1 in $Userslist1)
{
remove-DistributionGroupMember -Identity $DistoList -Member $User1.UserPrincipalName -Confirm:$false -BypassSecurityGroupManagerCheck
}

$Userslist2 = Import-CSV $WorkingDir\get-msoluser-DisabledOnly.csv
ForEach ($User2 in $Userslist2)
{
remove-DistributionGroupMember -Identity $DistoList -Member $User2.UserPrincipalName -Confirm:$false -BypassSecurityGroupManagerCheck
}

$Userslist3 = Import-CSV $WorkingDir\get-msoluser-Exclusion.csv
ForEach ($User3 in $Userslist3)
{
remove-DistributionGroupMember -Identity $DistoList -Member $User3.UserPrincipalName -Confirm:$false -BypassSecurityGroupManagerCheck
}
