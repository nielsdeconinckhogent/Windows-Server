<#
.SYNOPSIS
  Mailboxes aanmaken voor users.
.DESCRIPTION
  Dit script zal mailboxes aanmaken voor gebruikers in AD die nog geen hebben. Dit script neemt enkel de gebruikers in de OU "Bedrijf" en onderliggende in acht.
.NOTES
  Version:        1.0
  Author:         Niels de Coninck
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Error actie op stop zetten
$ErrorActionPreference = "Stop"

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn


#----------------------------------------------------------[Declarations]----------------------------------------------------------


$UsersNo = Get-ADUser -SearchBase "OU=Corona, DC=niels, DC=corona" -Filter * -Properties mail | Where-Object {$_.mail -eq $null} | Measure-Object

$Users = Get-ADUser -SearchBase "OU=Corona, DC=niels, DC=corona" -Filter *

$MBXDbs = Get-MailboxDatabase

#-----------------------------------------------------------[Functions]------------------------------------------------------------


#-----------------------------------------------------------[Execution]------------------------------------------------------------

            $go = 0
            if ($UsersNo -ne 0) {
                
            
            ForEach ($MBXDB in $MBXDbs)
                {
                    $TotalItemSize = Get-MailboxStatistics -Database $MBXDB | ForEach-Object {$_.TotalItemSize.Value.ToMB()} | Measure-Object -sum
                    $TotalDeletedItemSize = Get-MailboxStatistics -Database $MBXDB.DistinguishedName | ForEach-Object {$_.TotalDeletedItemSize.Value.ToMB()} | Measure-Object -sum
     
                    $TotalDBSize = $TotalItemSize.Sum + $TotalDeletedItemSize.Sum

                If (($TotalDBSize -lt $SmallestDBsize) -or ($null -eq $SmallestDBsize))
                    {
                        $SmallestDBsize = $TotalDBSize
                        $SmallestDB = $MBXDB
                        Write-Host $SmallestDB
                    }
                }

        ForEach ($User in $Users)
        {
            If ($null -eq $(Get-ADUser $User -Properties mail).mail)
            {
                Enable-Mailbox -Identity $User.SamAccountName -Database $SmallestDB

            }
        }
    }
