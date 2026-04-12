# ==============================================================================
# Script : Installation 100% Automatisée VirtualBox + Ubuntu LTS
# Cible : Utilisateur Windows 11 Débutant/intermédiaire - Supporte Ubuntu LTS 24.04, 26.04+
# Auteur : Marc-André Benoit
# ==============================================================================

# 1. Élévation de privilèges (Demande la permission Administrateur à l'usager)
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    break
}

# Autorise l'exécution pour cette session seulement
Set-ExecutionPolicy Bypass -Scope Process -Force
Clear-Host

# --- CONFIGURATION DYNAMIQUE DE LA VERSION LTS (pour supporter 26.04 quand disponible)---
$currentYear = (Get-Date).Year
$ltsYear = if ($currentYear % 2 -eq 0) { $currentYear } else { $currentYear - 1 }
$verMajor = "$ltsYear.04"
$vmBaseName = "Ubuntu.$($verMajor.Replace('.',''))"
$isoUrl = "https://ubuntu.com"

$vboxDefaultPath = "$env:USERPROFILE\VirtualBox VMs"
$isoPath = "$vboxDefaultPath\ubuntu-$verMajor-desktop-amd64.iso"
$vboxPath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
Write-Host "   INSTALLATEUR AUTOMATIQUE DE VM UBUNTU $verMajor        " -ForegroundColor Cyan
Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# --- ÉTAPE 1 : VÉRIFICATION DE LA VIRTUALISATION ACTIVÉE DANS LE BIOS  ---
Write-Host "[Étape 1 de 6] Vérification du processeur..." -ForegroundColor Yellow
$cpu = Get-WmiObject -Class Win32_Processor
if ($cpu.VirtualizationFirmwareEnabled -eq $false) {
    Write-Host "⚠️ La virtualisation n'est pas activée sur cet ordinateur." -ForegroundColor Red
    Write-Host "C'est obligatoire pour faire fonctionner une VM."
    Write-Host ""
    $choix = Read-Host "Veux-tu que le script t'aide à redémarrer l'ordi dans le BIOS pour l'activer ? (O/N)"
    if ($choix -eq "O" -or $choix -eq "o") {
        Write-Host "Ok! Une fois dans le BIOS ASUS (F7 pour mode Avancé)," -ForegroundColor Magenta
        Write-Host "cherches 'SVM Mode' sous 'Advanced' > 'CPU Configuration' et mets-le à 'Enabled'." -ForegroundColor Magenta
	Write-Host "À la fin du tutoriel,il y a une section dépannage pour suivre sur web mobile quand tu es dans le BIOS" -ForegroundColor Magenta
        Start-Sleep -Seconds 8
        shutdown.exe /r /fw /t 0
    }
    exit
}
Write-Host "✅ Virtualisation active ! Bonne nouvelle!!" -ForegroundColor Green

# --- ÉTAPE 2 : INSTALLATION DE VIRTUALBOX ---
Write-Host ""
Write-Host "[Étape 2 de 6] Installation de VirtualBox via Winget..." -ForegroundColor Yellow
winget install --id Oracle.VirtualBox --shortcut --accept-source-agreements --accept-package-agreements --silent

# --- ÉTAPE 3 : PRÉPARATION DE L'IMAGE ISO ---
if (-not (Test-Path $vboxDefaultPath)) { New-Item -Path $vboxDefaultPath -ItemType Directory | Out-Null }
Write-Host ""
Write-Host "[Étape 3 de 6] Vérification de l'image Ubuntu $verMajor..." -ForegroundColor Yellow
if (Test-Path $isoPath) {
    Write-Host "✅ Image déjà présente sur l'ordi. On saute le téléchargement." -ForegroundColor Green
} else {
    Write-Host "Téléchargement d'Ubuntu (environ 5 Go)..." -ForegroundColor Cyan
    Write-Host "Ceci peut prendre quelques minutes selon la connexion internet."
    Invoke-WebRequest -Uri $isoUrl -OutFile $isoPath -ProgressAction SilentlyContinue
}

# --- ÉTAPE 4 : CALCUL DU NOM DE L'INSTANCE (UNIQUE) ---
$count = 1
$vmName = "$vmBaseName"
while (& $vboxPath list vms | Select-String "$vmName") {
    $count++
    $vmName = "$vmBaseName`_$count"
}

# --- ÉTAPE 5 : CRÉATION DE LA VM ET DU DOSSIER PARTAGÉ ---
Write-Host ""
Write-Host "[Étape 4 de 6] Configuration de la machine $vmName..." -ForegroundColor Yellow
$vmDir = "$vboxDefaultPath\$vmName"
$sharePath = "$env:USERPROFILE\Desktop\Bureau_$vmName"

# Créer le dossier unique sur le bureau Windows
if (-not (Test-Path $sharePath)) { New-Item -Path $sharePath -ItemType Directory | Out-Null }

# Création technique
& $vboxPath createvm --name $vmName --ostype "Ubuntu_64" --register
& $vboxPath modifyvm $vmName --memory 4096 --cpus 2 --vram 128 --nic1 nat --clipboard-mode bidirectional
& $vboxPath createhd --filename "$vmDir\$vmName.vdi" --size 25000 --variant Standard
& $vboxPath storagectl $vmName --name "SATA" --add sata --controller IntelAhci
& $vboxPath storageattach $vmName --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$vmDir\$vmName.vdi"

# Installation Automatisée (Unattended)
Write-Host "[Étape 5 de 6] Programmation de l'installation silencieuse..." -ForegroundColor Yellow
& $vboxPath unattended install $vmName `
    --iso=$isoPath `
    --user="user" --password="user" `
    --full-user-name="Utilisateur" `
    --install-guest-additions `
    --country="CA" --time-zone="EST" `
    --language="fr-CA" `
    --post-install-command "sudo dpkg-reconfigure -plow unattended-upgrades"

# Lien pour le dossier partagé
& $vboxPath sharedfolder add $vmName --name "Bureau_Partage" --hostpath $sharePath --automount

# --- ÉTAPE 6 : RACCOURCIS ---
Write-Host ""
Write-Host "[Étape 6 de 6] Création des raccourcis..." -ForegroundColor Yellow
$wshShell = New-Object -ComObject WScript.Shell
$desktopLnk = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "Démarrer $vmName.lnk")
$shortcut = $wshShell.CreateShortcut($desktopLnk)
$shortcut.TargetPath = $vboxPath
$shortcut.Arguments = "startvm `"$vmName`""
$shortcut.IconLocation = "$vboxPath,0"
$shortcut.Save()

Write-Host ""
Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
Write-Host "   TOUT EST PRÊT !                                               " -ForegroundColor Green
Write-Host "   1. Clique sur l'icône '$vmName' sur ton bureau.               " -ForegroundColor Green
Write-Host "   2. L'installation va se faire TOUTE SEULE.                    " -ForegroundColor Green
Write-Host "   3. Ne touche à rien jusqu'à ce que tu voies le bureau Ubuntu. " -ForegroundColor Green
Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
Write-Host "--------Appuie sur une touche pour fermer cette fenêtre.---------"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

