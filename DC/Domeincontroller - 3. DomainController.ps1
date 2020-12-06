<#
.SYNOPSIS
  Server omzetten naar een domeincontroller in domein niels.corona
.DESCRIPTION
  Dit script zal de server omzetten naar een domeincontroller in het domein niels.corona
.NOTES
  Version:        1.0
  Author:         Niels de Coninck
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Error actie op stop zetten
$ErrorActionPreference = "Stop"


#----------------------------------------------------------[Declarations]----------------------------------------------------------

$go = 1

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function InstallADDS {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
}

function AddForest {
    Install-ADDSForest -DomainName niels.corona -SafeModeAdministratorPassword (ConvertTo-SecureString -String "NielsCorona123" -AsPlainText -Force) -Force -ErrorAction Stop
}

function InstallDNS {
    Install-ADDSDomainController -InstallDns -DomainName "niels.corona" -ErrorAction Stop
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal $env:computername omzetten naar een domeincontroller in het domein niels.corona."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Na de installatie zal de server zichzelf herstarten."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            InstallADDS
            AddForest
            InstallDNS
        }
        catch {
            Write-Host -ForegroundColor Red "Er ging iets mis. Domein reeds ingesteld"
        }
    }
    elseif($choice.Equals("n") -or $choice.Equals("N")) {
        Write-Host -ForegroundColor Yellow "Installatie afgebroken door gebruiker."
        exit
    }
    else {
        Write-Host -ForegroundColor Red "Ongeldige invoer!"
    }
}