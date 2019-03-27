<#

#>
Import-Module ActiveDirectory

$speadsheet = "c:\script\example_spreadsheet.xlsx"
$worksheet = "worksheet_name"

Import-Excel -Path $spreadsheet -WorksheetName worksheet |
ForEach-Object {
            if ($_."Office" -match ".") {
                Get-ADUser -Identity $_."UserPrincipalName".Split("@")[0] | Disable-ADAccount
            }
            else {
                # held for failed IFs
            }
}  | export-csv C:\scripts\AD-disabled.csv -NoTypeInformation

Import-CSV C:\scripts\AD-disabled.csv |
ForEach-Object {
            $TargetOU = ($_."DistinguishedName" -split ",")[2].substring(3)
            $_ | Add-Member -MemberType NoteProperty -Name Site -Value $TargetOU -PassThru 
} | Export-CSV C:\scripts\AD-disabled-withTargetOU.csv -NoTypeInformation
