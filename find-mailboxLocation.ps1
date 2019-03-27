Get-MsolUser -UsageLocation US |
Where-Object isLicensed -eq $true |
Select-Object -Property DisplayName, UserPrincipalName, isLicensed,
                        @{label='MailboxLocation';expression={
                            switch ($_.MSExchRecipientTypeDetails) {
                                      1 {'Onprem'; break}
                                      2147483648 {'Office365'; break}
                                      default {'Unknown'}
                                  }
                        }}
