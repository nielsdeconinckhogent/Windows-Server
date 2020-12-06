<#
.SYNOPSIS
  DHCP inschakelen en pool aanmaken
.DESCRIPTION
  Dit script zal DHCP activeren en configureren op de domeincontroller. 
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

function InstallDhcp {
    Install-WindowsFeature -Name DHCP -IncludeManagementTools -ErrorAction Stop
}
function ConfigureScope {
    Add-DhcpServerV4Scope -Name "HoGent-CORONA" -StartRange 192.168.100.160 -EndRange 192.168.100.200 -SubnetMask 255.255.255.0 -ErrorAction Stop
}

function SetDns {
    Set-DhcpServerV4OptionValue -DnsServer 192.168.100.10 -Router 192.168.100.10 -ErrorAction Stop
}

function ActivateDHCP {
    Add-DhcpServerInDC -DnsName win-dc-alfa.niels.corona -ErrorAction Stop
}



#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal DHCP activeren en configureren op deze server."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            InstallDhcp
            ConfigureScope
            SetDns
            ActivateDHCP
            Restart-service dhcpserver
            Write-Host -ForegroundColor Green "Gelukt!"
        }
        catch {
            Write-Host -ForegroundColor Red "Er ging iets mis. DHCP is reeds geconfigureerd."
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

