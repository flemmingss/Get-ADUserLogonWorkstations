<#
.Synopsis
   Get AD User LogonWorkstations
.DESCRIPTION
   Get AD User LogonWorkstations for users with LogonWorkstations restrictions
.EXAMPLE
   Get-ADUserLogonWorkstations -Username <username>
   Returns users in the LogonWorkstations list
.EXAMPLE
   Get-ADUserLogonWorkstations -Username <username> -Details
   Returns users in the LogonWorkstations list and includes which ones are enabled, disabled and non-existent
.NOTES
  Author: Flemming Sørvollen Skaret
#>

function Get-ADUserLogonWorkstations
{
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
    [string]$Username,
    [Parameter(Mandatory=$false)]
    [switch]$Details
    )

    try
    {
        Get-ADUser -Identity $Username | Out-Null #Check if user exist. Non-existent will result in error
        [bool]$Username_exist = $true
        $LogonWorkstations = ((Get-Aduser -Identity $Username -Properties LogonWorkstations).LogonWorkstations).split(",") #Command will fail if there is no LogonWorkstations

        foreach ($Computer in $LogonWorkstations)
        {
            if($Details)
            {
                try    
                {
                    Get-ADComputer -Identity $Computer | Out-Null # Check if Computer exist in AD. Non-existent will result in error

                    if ((Get-ADComputer -Identity $Computer).Enabled) #Check if Computer is enabled in AD
                    {
                        Write-host "$Computer - Enabled" -ForegroundColor green
                    }
                    else
                    {
                        Write-host "$Computer - Disabled" -ForegroundColor yellow
                    }
                }
                catch
                {
                    write-host "$Computer - Non-existent" -ForegroundColor red
                }
            }
            else
            {
                write-host $Computer
            }
        }
    }
    catch
    {
        if ($Username_exist)
        {
            Write-Host "user $Username don't have any LogonWorkstations restrictions. "
        }
        else
        {
            Write-Host "user $Username don't exist"
        }
    }
    finally
    {
        [bool]$Username_exist = $false
    }
}
