<#
.SYNOPSIS
  OU's aanmaken op de server.
.DESCRIPTION
  Dit script zal enkele OU's aanmaken op de server der wijze van voorbeeld.
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

function CreateOU {
    $oulist = Import-csv -Path C:\Users\Administrator\Desktop\oulist.txt
    ForEach($entry in $oulist){
        $ouname = $entry.ouname
        $oupath = $entry.oupath
        New-ADOrganizationalUnit -Name $ouname -Path $oupath
        Write-Host -ForegroundColor Green "OU $ouname werd aangemaakt in $oupath"
    }
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal enkele OU's aanmaken in active directory."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            CreateOU
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

