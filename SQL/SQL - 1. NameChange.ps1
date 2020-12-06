<#
.SYNOPSIS
  Omzetten van computernaam
.DESCRIPTION
  Dit script zal da naam van de server instellen op WIN-SQL
.NOTES
  Version:        1.0
  Author:         Niels de Coninck
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Error actie op stop zetten
$ErrorActionPreference = "Stop"


#----------------------------------------------------------[Declarations]----------------------------------------------------------

$go = 1
$originalName = $env:computername

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function RenameComputer {
    Rename-Computer -NewName "WIN-SQL" -Restart
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal de naam van $env:computername veranderen in WIN-SQL."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            RenameComputer
        }
        catch {
            Write-Host -ForegroundColor Red "Er ging iets mis. Naam werd reeds veranderd."
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

