<#
.SYNOPSIS
  SQL Server 2017 installeren
.DESCRIPTION
  Dit script zal SQL Server 2017 installeren d.m.v. een bijgeleverd configuratiebestand.
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

function InstallSQL {
    C:\SQLServer2017Media\Developer_ENU\SETUP.EXE /QS /IACCEPTSQLSERVERLICENSETERMS /ACTION="install" /FEATURES=SQL,AS,IS,Tools /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT="NIELS\Administrator" /SQLSVCPASSWORD="NielsCorona123" /SQLSYSADMINACCOUNTS="NIELS\Administrator" /AGTSVCACCOUNT="NIELS\Administrator" /AGTSVCPASSWORD="NielsCorona123" /ASSVCACCOUNT="NIELS\Administrator" /ASSVCPASSWORD="NielsCorona123" /ISSVCAccount="NIELS\Administrator" /ISSVCPASSWORD="NielsCorona123" /ASSYSADMINACCOUNTS="NIELS\Administrator" /TCPENABLED=1 /NPENABLED=1 
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal SQL Server 2017 configureren. INSTANCE=MSSQLSERVER, Credentials= NIELS\Administrator en NielsCorona123"
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            InstallSQL -ErrorAction Stop
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

