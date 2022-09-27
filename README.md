# Get-ADUserLogonWorkstations
A function to Get AD User LogonWorkstations for users with LogonWorkstations restrictions
Also listing which ones are enabled, disabled and non-existent if -Details is used
Load function:
```powershell
Import-Module .\Get-ADUserLogonWorkstations.ps1
```

Run as wizard:
```powershell

Import-Module .\Get-ADUserLogonWorkstations.ps1
DO
{
  $username = Read-Host "Username"
  Get-ADUserLogonWorkstations -User $username -Details
  Write-Host "------------------------------------------"
} until ($username -eq "exit")
```


**Changelog**  
* 27.09.2022
    * Release
