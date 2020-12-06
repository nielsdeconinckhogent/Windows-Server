<#
.SYNOPSIS
  Routing installeren en configureren op de server
.DESCRIPTION
  Dit script zal de server omzetten naar een router zodat clients uit het domein toegang krijgen tot het internet.
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

function InstallRouting {
    Install-WindowsFeature Routing -IncludeManagementTools -ErrorAction Stop

    Install-RemoteAccess -VPNType RoutingOnly
    Netsh Routing IP NAT Install

    Netsh Routing IP NAT Add Interface "NAT"
    Netsh Routing IP NAT Set Interface "NAT" Mode=Full
    Netsh Routing IP NAT Add Interface "Intern"
    New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.0.0/24
    Netsh Routing IP NAT Show Interface
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal $env:computername upgraden naar een router."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            InstallRouting
        }
        catch {
            Write-Host -ForegroundColor Red "Er ging iets mis. Router werd reeds geconfigureerd"
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

