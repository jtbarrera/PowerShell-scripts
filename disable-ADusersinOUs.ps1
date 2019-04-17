$ADServer = "Domain-Controller-server"
$OUList = @('OU=OUcontainer1,DC=corp,DC=domain,DC=com','OU=OUcontainer2,DC=corp,DC=domain,DC=com')

$OUList | ForEach-Object {Get-ADUser -server $ADServer -Filter * -SearchBase $_ | Disable-ADAccount}
