$OUList = @('OU=firstOU,DC=corp,DC=company1,DC=com','OU=secondOU,DC=corp,DC=company1,DC=com')
$OUList | foreach-object { get-adcomputer -server DC01 -Filter "OperatingSystem -notlike '*server*'" -resultsetsize $null -searchbase $_ } | Select-Object name,distinguishedname,enabled,dnshostname | Export-CSV c:\scripts\computerAcctsExport.csv -NoTypeInformation -Encoding UTF8
