Get-Mailbox | Select PrimarySmtpAddress | Export-csv -Path .\migration.csv -NoTypeInformation

