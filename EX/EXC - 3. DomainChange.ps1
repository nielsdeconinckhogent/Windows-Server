<#
.SYNOPSIS
  Server toevoegen aan domein niels.corona
.DESCRIPTION
  Dit script zal de sql server toevoegen aan het domein niels.corona
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

function AddToDomain {
    add-computer –domainname niels.corona -domaincredential NIELS\Administrator -restart –force
    
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal de server toevoegen aan het domein niels.corona"
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            AddToDomain -ErrorAction Stop
            Start-Sleep -Seconds 5
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

