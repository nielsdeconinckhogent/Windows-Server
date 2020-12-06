<#
.SYNOPSIS
  Packages installer voor Exchange Server.
.DESCRIPTION
  Dit script zal de de benodigde packages installeren om later de installatie van exchange server te voltooien. 
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

function MountIso {
    Mount-DiskImage -ImagePath "C:\Users\Administrator.NIELS\Desktop\mu_exchange_server_2019_x64_dvd_5fa4d915.iso"
}

function ExtendSchema {
    E:\Setup.EXE /PrepareSchema /IAcceptExchangeServerLicenseTerms
}

function PrepareAD {
    E:\Setup.exe /PrepareAD /OrganizationName:"Niels Corona" /IAcceptExchangeServerLicenseTerms
}

function InstallRSATClustering {
    Install-WindowsFeature RSAT-Clustering-CmdInterface
}

function ExchangeSetup {
   E:\Setup.exe /IAcceptExchangeServerLicenseTerms /mode:Install /role:Mailbox /DomainController:WIN-DC-ALFA /on:"Niels Corona"
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal Exchange Server 2016 installeren en configureren alsook het AD schema uitbreiden."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            MountIso -ErrorAction Stop
            ExtendSchema -ErrorAction Stop
            PrepareAD -ErrorAction Stop
            InstallRSATClustering -ErrorAction Stop
            ExchangeSetup -ErrorAction Stop
        }
        catch {
            Write-Host -ForegroundColor Red "Er ging iets mis."
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

