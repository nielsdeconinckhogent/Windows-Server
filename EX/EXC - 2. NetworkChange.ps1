<#
.SYNOPSIS
  Naam van netwerkadapter veranderen en het IP adres toekennen
.DESCRIPTION
  Dit script zal de netwerkadapter veranderen naar Intern. Intern zal bijgevolg het IP adres 192.168.100.30 toegewezen krijgen.
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
        Rename-NetAdapter -Name "Ethernet0" -NewName "Intern" -ErrorAction Stop
    
}

function SetIPAndDns {
    $adapter = get-netadapter -Name "Intern"
    New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress 192.168.100.30 -PrefixLength 24 -DefaultGateway 192.168.100.10 -ErrorAction Stop
    
    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses ("192.168.100.10")
}

function ResetScript {
    Rename-NetAdapter -Name "Intern" -NewName "Ethernet0" -ErrorAction Stop  
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------
while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal de netwerkadapter van $env:computername veranderen naar Intern en het ip adres veranderen."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        if($netwerkAdapters.Count -eq 0) {
            Write-Host -ForegroundColor Red "U bezit geen netwerkadapters. Uitvoer wordt afgebroken."
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

  