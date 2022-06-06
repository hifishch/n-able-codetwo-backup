#Powershell Check Licensing for CodeTwo M365 Backup
#Author: Andreas Walker a.walker@glaronia.ch
#Licence: GNU General Public License v3.0
#Version: 1.0.0 / 06.06.2022

Param (
[int]$maxOfset = -30
)


#Load and parse Licensing XML
[xml]$LicenseXML = Get-Content -Path 'C:\ProgramData\CodeTwo Backup\BackupLicense.3.xml'
$LicenseDATA = ConvertFrom-Json $LicenseXML.LicenseKeyResponse.LicenseKeyDescPayload

#Check if License is still Valid
if ((Get-Date $LicenseDATA.ValidTill) -lt ((Get-Date).AddDays($maxOfset)))
    {
    Write-Host ERROR - The License $LicenseDATA.LicenseKey will expire on (Get-Date $LicenseDATA.ValidTill)
    Exit 1001
    }
    else
        {
        Write-Host OK - The License $LicenseDATA.LicenseKey will expire on (Get-Date $LicenseDATA.ValidTill)
        Exit 0
        }