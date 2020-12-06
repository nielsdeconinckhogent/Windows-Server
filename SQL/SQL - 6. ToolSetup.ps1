<#
.SYNOPSIS
  SQL Server Management tools downloaden en installeren
.DESCRIPTION
  Dit script zal SQL Server Management tools downloaden van de microsoft website en automatisch opstarten
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

function DownloadSQL {
        $url = "https://aka.ms/ssmsfullsetup"
        $output = "C:\Users\Administrator.$env:USERDOMAIN\Desktop\sqltools.exe"
        $start_time = Get-Date
    
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
    Write-Host -ForegroundColor Green "Downloadtijd: $((Get-Date).Subtract($start_time).Seconds) seconden"
    
}

function StartSQL {
    .\sqltools.exe
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal de SQL Server Management Studio downloaden en istalleren."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            DownloadSQL -ErrorAction Stop
            StartSQL -ErrorAction Stop
        }
        catch {
            Write-Host -ForegroundColor Red "Er ging iets mis. Kan SQL Server Management Tools niet downloaden"
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
