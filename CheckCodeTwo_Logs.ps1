#Powershell Check Error Logs for CodeTwo M365 Backup
#Author: Andreas Walker a.walker@glaronia.ch
#Licence: GNU General Public License v3.0
#Version: 1.0.0 / 06.06.2022

Param (
[int]$maxAge = 24
)

#Calculate Data Limits
$LimitDate = ((Get-Date).AddHours(0-$maxAge))

#Load and parse Licensing XML
[xml]$AlertsXML = Get-Content -Path 'C:\ProgramData\CodeTwo Backup\Alerts_3.xml'
$Failed = ($AlertsXML.EngineAlertCollection.anyType | Where-Object -Property Created -gt $LimitDate | Where-Object -Property JobTypeNews -EQ 'Backup' | Where-Object -Property type -like '*fail*')
$Stats = ($AlertsXML.EngineAlertCollection.anyType | Where-Object -Property Created -gt $LimitDate | Where-Object -Property JobTypeNews -EQ 'Backup' | Where-Object -Property type -like '*Stats*')
$LastStats = $Stats | Select-Object -Last 1

#Test for Failed
if ($Failed.Count -gt 1)
    {Write-Host ERROR-CodeTwo logs containing $Failed.Count failed messages in the last $maxAge hours.
    Write-Host Anyway there where $Stats.Count backup-stats for the same time period in the logs. The last record reports $LastStats.ItemsBackedup backed up items and $LastStats.ItemsScanned items scanned in $LastStats.MailboxesCount mailboxes.
    Write-Host Please check CodeTwo logs for further reference.
    $Failed | Select-Object type,Created,JobName,JobTypeNews
    Exit 1001}

if ($Stats.Count -lt 1)
    {Write-Host ERROR-CodeTwo Logs do not contain any Backup-Stats.
    Write-Host Please check CodeTwo if there were any backups running
    Exit 1001}

if ($Stats.Count -gt 1)
    {Write-Host OK-There where $Stats.Count backup-stats for the last $maxAge hours in the logs. The last record reports $LastStats.ItemsBackedup backed up items and $LastStats.ItemsScanned items scanned in $LastStats.MailboxesCount mailboxes.
    Exit 0}


Write-Host ERROR-The Script came to an unexpected end. Please check script!
Exit 1001