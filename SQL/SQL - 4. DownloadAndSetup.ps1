<#
.SYNOPSIS
  SQL Server 2017 downloaden en opstarten
.DESCRIPTION
  Dit script zal SQL Server 2017 downloaden van een google drive en automatisch opstarten
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
        $url = "https://drive.google.com/u/0/uc?id=1u8g8RiIOGEg_lUCuoRmWCICBZHl_dmwn&export=download"
        $output = "C:\Users\Administrator.$env:USERDOMAIN\Desktop\sql2017.exe"
        $start_time = Get-Date
    
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Host -ForegroundColor Green "Downloadtijd: $((Get-Date).Subtract($start_time).Seconds) seconden"
    
}

function StartSQL {
    .\sql2017.exe
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal SQL Server 2017 downloaden en opstarten."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            DownloadSQL -ErrorAction Stop
            StartSQL -ErrorAction Stop
        }
        catch {
            Write-Host -ForegroundColor Red "Er ging iets mis. Kan SQL Server 2017 niet downloaden"
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

