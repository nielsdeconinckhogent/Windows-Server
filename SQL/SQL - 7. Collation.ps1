<#
.SYNOPSIS
  SQL Server Collation instellen
.DESCRIPTION
  Dit script zal SQL Server collation instellen zodat deze kan samenwerken met de Deployment server.
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

function SetCollation {
    C:\SQLServer2017Media\Developer_ENU\SETUP.EXE /QUIET /ACTION=REBUILDDATABASE /INSTANCENAME=MSSQLSERVER /SQLSYSADMINACCOUNTS="NIELS\Administrator" /SQLCOLLATION=SQL_latin1_general_CP1_CI_AS
    
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal de collation van de SQL Server instellen op SQL_latin1_general_CP1_CI_AS"
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            SetCollation -ErrorAction Stop
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
