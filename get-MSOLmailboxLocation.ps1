import-csv .\emailbox.csv | ForEach-Object { get-msoluser -UserPrincipalName $_.mail `
| Select-Object -Property displayname, UserPrincipalName, isLicensed, `
@{label='MailboxLocation';expression={ `
                              switch ($_.MSExchRecipientTypeDetails) { `
                                        1 {'Onprem'; break} `
                                        2147483648 {'Office365'; break} `
                                        default {'Unknown'} `
                                    } `
                          }}} '
 | export-csv .\emailbox-location.csv -NoTypeInformation
