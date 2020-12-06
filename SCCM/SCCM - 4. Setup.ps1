<#
.SYNOPSIS
  Packages installeren voor SCCM en achteraf SCCM installeren.
.DESCRIPTION
  Dit script zal de de benodigde packages installeren om later de installatie van SCCM te voltooien. 
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

function InstallADK {
   Start-Process "C:\Users\Administrator.NIELS\Desktop\adksetup.exe" -ArgumentList "/features OptionId.DeploymentTools OptionId.UserStateMigrationTool /quiet /ceip off" -Wait

    Start-Process "C:\Users\Administrator.NIELS\Desktop\adkwinpesetup.exe" -ArgumentList "/features OptionId.WindowsPreinstallationEnvironment /norestart /quiet /ceip off" -Wait

}


function InstallFeatures {
    Install-WindowsFeature Net-Framework-Core, RDC
    Install-WindowsFeature -name Web-Server, Web-WebServer, Web-Common-Http, Web-Default-Doc, Web-Static-Content, Web-Metabase, Web-App-Dev, Web-Asp-Net, Web-Http-Logging, Web-Log-Libraries, Web-Request-Monitor, web-health, Web-Http-Tracing, Web-Performance, Web-Stat-Compression, Web-Security, Web-Filtering, Web-Windows-Auth, Web-Mgmt-Tools, Web-Lgcy-Scripting, Net-Framework-Core, Web-WMI, NET-HTTP-Activation, NET-Non-HTTP-Activ, NET-WCF-HTTP-Activation45, NET-WCF-MSMQ-Activation45, NET-WCF-Pipe-Activation45, NET-WCF-TCP-Activation45, BITS, BITS-IIS-Ext, BITS-Compact-Server, RDC,Web-Asp-Net45, Web-Net-Ext45, Web-Lgcy-Mgmt-Console
}

function InstallMDT {
    C:\Users\Administrator.NIELS\Desktop\MicrosoftDeploymentToolkit_x64.msi /passive
}


function InstallSCCM {
    Start-Process SC_Configmgr_SCEP_1606.exe -Wait
    Start-Process "C:\SC_Configmgr_SCEP_1606\SMSSETUP\BIN\X64\setup.exe" -ArgumentList "/script C:\Users\Administrator.NIELS\Desktop\ConfigMgrAutoSave.ini" -Wait
    
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

while($go -eq 1) {
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Dit script zal de benodigde packages voor SCCM installeren. Daarna zal de installatie van SCCM opstarten."
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wilt u verdergaan met de installatie? y/n"
$choice = Read-Host

    if ($choice.Equals("y") -or $choice.Equals("Y")) {
        try {
            $go = 0
            Write-Host -ForegroundColor Green "Installing ADK..."
            InstallADK -ErrorAction Stop
            Write-Host -ForegroundColor Green "Installing features..."
            InstallFeatures -ErrorAction Stop
            Write-Host -ForegroundColor Green "Installing MDT..."
            InstallMDT - ErroAction Stop
            Write-Host -ForegroundColor Green "Installing SCCM..."
            InstallSCCM -ErrorAction Stop
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

