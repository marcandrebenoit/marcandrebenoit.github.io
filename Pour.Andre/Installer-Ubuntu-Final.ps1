# ==============================================================================
# Script : Installation Automatisee VirtualBox + Ubuntu 24.04.4
# Cible : Windows 10/11 - Version Finale pour Utilisateur
# ==============================================================================

# 1. Elevation de privileges (Admin)
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-ExecutionPolicy Bypass -File `"$($myinvocation.mycommand.definition)`""
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    break
}

Set-ExecutionPolicy Bypass -Scope Process -Force
Clear-Host

# --- CONFIGURATION ---
$verMajor = "24.04"
$isoUrl = "https://savoirfairelinux.net"
$vmBaseName = "Ubuntu2404"
$vboxDefaultPath = "$env:USERPROFILE\VirtualBox VMs"
$isoPath = "$vboxDefaultPath\ubuntu-24.04.4-desktop-amd64.iso"
$vboxPath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
Write-Host "   INSTALLATEUR AUTOMATIQUE UBUNTU $verMajor             " -ForegroundColor Cyan
Write-Host "----------------------------------------------------------" -ForegroundColor Cyan

# --- ETAPE 1 : VERIFICATION WINGET ---
Write-Host "[1/7] Verification des outils Windows..." -ForegroundColor Yellow
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Installation de l'outil Winget en cours..." -ForegroundColor Cyan
    $wingetUrl = "https://github.com"
    $wingetPath = "$env:TEMP\winget.msixbundle"
    Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetPath
    Add-AppxPackage -Path $wingetPath
    Remove-Item $wingetPath
}
Write-Host "OK." -ForegroundColor Green

# --- ETAPE 2 : VIRTUALISATION ---
Write-Host "[2/7] Verification du processeur..." -ForegroundColor Yellow
$cpu = Get-WmiObject -Class Win32_Processor
if ($cpu.VirtualizationFirmwareEnabled -eq $false) {
    Write-Host "!! La virtualisation n'est pas activee dans le BIOS !!" -ForegroundColor Red
    $choix = Read-Host "Voulez-vous redemarrer dans le BIOS pour corriger ? (O/N)"
    if ($choix -eq "O" -or $choix -eq "o") { shutdown.exe /r /fw /t 0 }
    exit
}
Write-Host "OK." -ForegroundColor Green

# --- ETAPE 3 : INSTALLATION VIRTUALBOX ---
Write-Host "[3/7] Verification de VirtualBox..." -ForegroundColor Yellow
if (-not (Test-Path $vboxPath)) {
    Write-Host "Installation de VirtualBox (veuillez patienter)..." -ForegroundColor Cyan
    winget install --id Oracle.VirtualBox --accept-source-agreements --accept-package-agreements --silent --force
    Start-Sleep -Seconds 10
}
if (-not (Test-Path $vboxPath)) { Write-Host "Erreur : Echec de l'installation." -ForegroundColor Red ; Pause ; exit }
Write-Host "OK." -ForegroundColor Green

# --- ETAPE 4 : TELECHARGEMENT ISO (AVEC PROGRESSION) ---
if (-not (Test-Path $vboxDefaultPath)) { New-Item -Path $vboxDefaultPath -ItemType Directory | Out-Null }
Write-Host "[4/7] Preparation de l'image Ubuntu..." -ForegroundColor Yellow

$needsDownload = $true
if (Test-Path $isoPath) {
    if ((Get-Item $isoPath).Length / 1GB -gt 2) { $needsDownload = $false }
    else { Remove-Item $isoPath -Force }
}

if ($needsDownload) {
    Write-Host "Telechargement (5 Go) - Observez la barre de progression en haut..." -ForegroundColor Cyan
    $oldProgress = $ProgressPreference ; $ProgressPreference = 'Continue'
    Invoke-WebRequest -Uri $isoUrl -OutFile $isoPath
    $ProgressPreference = $oldProgress
}
Write-Host "OK." -ForegroundColor Green

# --- ETAPE 5 : CONFIGURATION VM ---
$count = 1 ; $vmName = "$vmBaseName"
while (& $vboxPath list vms | Select-String "$vmName") { $count++ ; $vmName = "$vmBaseName`_$count" }

Write-Host "[5/7] Creation de la machine $vmName..." -ForegroundColor Yellow
$vmDir = "$vboxDefaultPath\$vmName"
$sharePath = "$env:USERPROFILE\Desktop\Bureau_$vmName"
if (-not (Test-Path $sharePath)) { New-Item -Path $sharePath -ItemType Directory | Out-Null }

& $vboxPath createvm --name $vmName --ostype "Ubuntu_64" --register | Out-Null
& $vboxPath modifyvm $vmName --memory 4096 --cpus 2 --vram 128 --nic1 nat --clipboard-mode bidirectional | Out-Null
& $vboxPath createhd --filename "$vmDir\$vmName.vdi" --size 25000 --variant Standard | Out-Null
& $vboxPath storagectl $vmName --name "SATA" --add sata --controller IntelAhci | Out-Null
& $vboxPath storageattach $vmName --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$vmDir\$vmName.vdi" | Out-Null
& $vboxPath storageattach $vmName --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium $isoPath | Out-Null

# --- ETAPE 6 : INSTALLATION AUTOMATIQUE ---
Write-Host "[6/7] Programmation de l'installation..." -ForegroundColor Yellow

# On augmente la memoire video a 128Mo et on active l'acceleration 3D pour stabiliser l'installeur
& $vboxPath modifyvm $vmName --vram 128 --graphicscontroller vmsvga

# Commande Unattended simplifiee pour eviter les erreurs de "bootstrap"
& $vboxPath unattended install $vmName `
    --iso=$isoPath `
    --user="user" --password="user" `
    --full-user-name="Utilisateur" `
    --install-additions `
    --time-zone="America/Montreal" `
    --post-install-command "sudo dpkg-reconfigure -plow unattended-upgrades" | Out-Null

& $vboxPath sharedfolder add $vmName --name "Bureau_Partage" --hostpath $sharePath --automount | Out-Null


# --- ETAPE 7 : RACCOURCIS ---
Write-Host "[7/7] Creation du raccourci sur le bureau..." -ForegroundColor Yellow
$wshShell = New-Object -ComObject WScript.Shell
$desktopLnk = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "Demarrer $vmName.lnk")
$shortcut = $wshShell.CreateShortcut($desktopLnk)
$shortcut.TargetPath = $vboxPath
$shortcut.Arguments = "startvm `"$vmName`""
$shortcut.IconLocation = "$vboxPath,0"
$shortcut.Save()

Write-Host ""
Write-Host "----------------------------------------------------------" -ForegroundColor Green
Write-Host "   TERMINE AVEC SUCCES !                                  " -ForegroundColor Green
Write-Host "   Double-clique sur 'Demarrer $vmName' sur ton bureau.   " -ForegroundColor Green
Write-Host "----------------------------------------------------------" -ForegroundColor Green
Pause

