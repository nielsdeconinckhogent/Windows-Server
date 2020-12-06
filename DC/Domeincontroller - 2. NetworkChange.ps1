<#
.SYNOPSIS
  Namen van netwerkadapters veranderen en het IP adres aan Intern toekennen
.DESCRIPTION
  Dit script zal de netwerkadapters veranderen naar NAT & Intern. Intern zal bijgevolg het IP adres 192.168.100.10 toegewezen krijgen.
.NOTES
  Version:        1.0
  Author:         Niels de Coninck
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Error actie op stop zetten
$ErrorActionPreference = "Stop"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$go = 1
$netwerkAdapters = Get-Netadapter

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function RenameAdapter {
        Rename-NetAdapter -Name "Ethernet0" -NewName "NAT" -ErrorAction Stop
        Rename-NetAdapter -Name "Ethernet1" -NewName "Intern" -ErrorAction Stop
    
}

function SetIPAndDns {
    $adapter = get-netadapter -Name "Intern"
    New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress 192.168.100.10 -PrefixLength 24 -ErrorAction Stop
    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses ("127.0.0.1")
    
}

function ResetScript {
    Rename-NetAdapter -Name "NAT" -NewName "Ethernet0" -ErrorAction Stop
    Rename-NetAdapter -Name "Intern" -NewName "Ethernet1" -ErrorAction Stop
    Set-NetIPInterface -InterfaceAlias 'Ethernet1' -Dhcp Enabled -ErrorAction Stop
    
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------
while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal de netwerkadapters van $env:computername veranderen naar NAT & Intern en het ip adres van Intern veranderen."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "BENODIGDHEDEN: - 2 netwerkadapters genaamd Ethernet0 & Ethernet1"
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        if($netwerkAdapters.Count -lt 2) {
            Write-Host -ForegroundColor Red "U bezit geen 2 netwerkadapters. Uitvoer wordt afgebroken."
            exit 
        }
        else {
            try {
                $go = 0
                RenameAdapter 
                Write-Host -ForegroundColor Green "Hernoeming gelukt!"

                SetIPAndDns 
                Write-Host -ForegroundColor Green "IP adres gelukt!"
            }
            catch [System.Exception]{
                Write-Host -ForegroundColor Red "Er liep iets mis. Veranderingen terugzetten."
                ResetScript
            }
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

  