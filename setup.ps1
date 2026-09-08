<#
.SYNOPSIS
    Utilitário Completo de Pós-Formatação para Windows (WPF GUI)
    Desenvolvido por Andyz0x.
    Totalmente em Português (Brasil) com Ícones Oficiais, Pack PC Gamer e Destaque Open Source.
    Executável remotamente via: irm <URL> | iex

.DESCRIPTION
    - 236 Aplicativos organizados com Ícones Oficiais e indicador nítido de Open Source (FOSS).
    - Pack PC Gamer de 1 clique (Steam, Epic Games, Discord, ExitLag, AutoRuns, Afterburner, etc.).
    - 66 Otimizações e Tweaks de Sistema com nomes e descrições explicativas em Português.
    - Presets Rápidos Andyz0x (Recomendado, Mínimo, Avançado Debloat, Pack Gamer, Dev).
    - Filtro rápido para exibir 'Apenas Aplicativos Open Source' e 'Apenas Selecionados'.
    - Recursos Opcionais do Windows (WSL, Hyper-V, Sandbox, .NET 3.5, DirectPlay).
    - Ferramentas de Manutenção e Reparação (SFC & DISM Scan, Reset de Rede, Redefinir Windows Update).
    - Atalhos rápidos para Painéis de Controle Clássicos.
    - Console de logs em tempo real e auto-elevação para Administrador.
#>

[CmdletBinding()]
param()

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# -------------------------------------------------------------------------
# 1. VERIFICAÇÃO E AUTO-ELEVAÇÃO DE ADMINISTRADOR
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[*] Solicitando privilégios de Administrador..." -ForegroundColor Yellow
    try {
        $targetScript = if ($PSCommandPath) { $PSCommandPath } else { "$PSScriptRoot\setup.ps1" }
        if (Test-Path $targetScript) {
            Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$targetScript`""
            Write-Host "[*] O utilitário foi aberto com privilégios de Administrador em uma nova janela." -ForegroundColor Green
            return
        } else {
            $tempScript = "$env:TEMP\setup_formatar_$([Guid]::NewGuid().ToString('N')).ps1"
            $scriptContent = $MyInvocation.MyCommand.ScriptBlock.ToString()
            [System.IO.File]::WriteAllText($tempScript, $scriptContent, [System.Text.Encoding]::UTF8)
            Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tempScript`""
            Write-Host "[*] O utilitário foi aberto com privilégios de Administrador em uma nova janela." -ForegroundColor Green
            return
        }
    } catch {
        Write-Host "[!] Não foi possível elevar automaticamente para Administrador: $_" -ForegroundColor Yellow
        Write-Host "[!] Por favor, execute o terminal como Administrador para prosseguir." -ForegroundColor Yellow
        return
    }
}

# -------------------------------------------------------------------------
# 2. CARREGAMENTO DOS ASSEMBLIES WPF & FORMS
# -------------------------------------------------------------------------
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
Add-Type -AssemblyName WindowsFormsIntegration -ErrorAction SilentlyContinue

# -------------------------------------------------------------------------
# 3. BASE DE DADOS DE SOFTWARES & TWEAKS (233 APPS & 66 TWEAKS)
# -------------------------------------------------------------------------
$appsRawJson = @'
[{"Key": "WPFInstall1password", "Id": "AgileBits.1Password", "Name": "1Password", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "1Password is a password manager that allows you to store and manage your passwords securely.", "Link": "https://1password.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://1password.com/", "Foss": false}, {"Key": "WPFInstall7zip", "Id": "7zip.7zip", "Name": "7-Zip", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "7-Zip is a free and open-source file archiver utility. It supports several compression formats and provides a high compression ratio, making it a popular choice for file compression.", "Link": "https://www.7-zip.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.7-zip.org/", "Foss": true}, {"Key": "WPFInstalladobe", "Id": "Adobe.Acrobat.Reader.64-bit", "Name": "Adobe Acrobat Reader", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Adobe Acrobat Reader is a free PDF viewer with essential features for viewing, printing, and annotating PDF documents.", "Link": "https://www.adobe.com/acrobat/pdf-reader.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.adobe.com/acrobat/pdf-reader.html", "Foss": false}, {"Key": "WPFInstalladvancedip", "Id": "Famatech.AdvancedIPScanner", "Name": "Advanced IP Scanner", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Advanced IP Scanner is a fast and easy-to-use network scanner. It is designed to analyze LAN networks and provides information about connected devices.", "Link": "https://www.advanced-ip-scanner.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.advanced-ip-scanner.com/", "Foss": false}, {"Key": "WPFInstallaimp", "Id": "AIMP.AIMP", "Name": "AIMP (Music Player)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "AIMP is a feature-rich music player with support for various audio formats, playlists, and customizable user interface.", "Link": "https://www.aimp.ru/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.aimp.ru/", "Foss": false}, {"Key": "WPFInstallangryipscanner", "Id": "angryziber.AngryIPScanner", "Name": "Angry IP Scanner", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Angry IP Scanner is an open-source and cross-platform network scanner. It is used to scan IP addresses and ports, providing information about network connectivity.", "Link": "https://angryip.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://angryip.org/", "Foss": true}, {"Key": "WPFInstallanydesk", "Id": "AnyDesk.AnyDesk", "Name": "AnyDesk", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "AnyDesk is a remote desktop software that enables users to access and control computers remotely. It is known for its fast connection and low latency.", "Link": "https://anydesk.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://anydesk.com/", "Foss": false}, {"Key": "WPFInstallaudacity", "Id": "Audacity.Audacity", "Name": "Audacity", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Audacity is a free and open-source audio editing software known for its powerful recording and editing capabilities.", "Link": "https://www.audacityteam.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.audacityteam.org/", "Foss": true}, {"Key": "WPFInstallautoruns", "Id": "Microsoft.Sysinternals.Autoruns", "Name": "Autoruns", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "This utility shows you what programs are configured to run during system bootup or login.", "Link": "https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns", "Foss": false}, {"Key": "WPFInstallrdcman", "Id": "Microsoft.Sysinternals.RDCMan", "Name": "RDCMan", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "RDCMan manages multiple remote desktop connections. It is useful for managing server labs where you need regular access to each machine such as automated checkin systems and data centers.", "Link": "https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman", "Foss": false}, {"Key": "WPFInstallautohotkey", "Id": "AutoHotkey.AutoHotkey", "Name": "AutoHotkey", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "AutoHotkey is a scripting language for Windows that allows users to create custom automation scripts and macros. It is often used for automating repetitive tasks and customizing keyboard shortcuts.", "Link": "https://www.autohotkey.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.autohotkey.com/", "Foss": true}, {"Key": "WPFInstallbattlenet", "Id": "Blizzard.BattleNet", "Name": "Battle.net", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Battle.net is a launcher for games created and developed by Activision Blizzard", "Link": "https://battle.net", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://battle.net", "Foss": false}, {"Key": "WPFInstallbitwarden", "Id": "Bitwarden.Bitwarden", "Name": "Bitwarden", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Bitwarden is an open-source password management solution. It allows users to store and manage their passwords in a secure and encrypted vault, accessible across multiple devices.", "Link": "https://bitwarden.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://bitwarden.com/", "Foss": true}, {"Key": "WPFInstallblender", "Id": "BlenderFoundation.Blender", "Name": "Blender (3D Graphics)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Blender is a powerful open-source 3D creation suite, offering modeling, sculpting, animation, and rendering tools.", "Link": "https://www.blender.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.blender.org/", "Foss": true}, {"Key": "WPFInstallbrave", "Id": "Brave.Brave", "Name": "Brave", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Brave is a privacy-focused web browser that blocks ads and trackers, offering a faster and safer browsing experience.", "Link": "https://www.brave.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.brave.com", "Foss": true}, {"Key": "WPFInstallbruno", "Id": "Bruno.Bruno", "Name": "Bruno", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Bruno is a local-first API client that stores collections as plain text files for version control and collaboration.", "Link": "https://www.usebruno.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.usebruno.com/", "Foss": true}, {"Key": "WPFInstallbulkcrapuninstaller", "Id": "Klocman.BulkCrapUninstaller", "Name": "Bulk Crap Uninstaller", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Bulk Crap Uninstaller is a free and open-source uninstaller utility for Windows. It helps users remove unwanted programs and clean up their system by uninstalling multiple applications at once.", "Link": "https://www.bcuninstaller.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.bcuninstaller.com/", "Foss": true}, {"Key": "WPFInstallblurautoclicker", "Id": "Blur009.BlurAutoClicker", "Name": "BlurAutoClicker", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "An Auto-clicker with a few advanced features and generally better performance than popular alternatives.", "Link": "https://blur009.vercel.app/projects/blur-autoclicker/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://blur009.vercel.app/projects/blur-autoclicker/", "Foss": true}, {"Key": "WPFInstallcalibre", "Id": "calibre.calibre", "Name": "Calibre", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Calibre is a powerful and easy-to-use e-book manager, viewer, and converter.", "Link": "https://calibre-ebook.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://calibre-ebook.com/", "Foss": true}, {"Key": "WPFInstallcemu", "Id": "Cemu.Cemu", "Name": "Cemu", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Cemu is a highly experimental software to emulate Wii U applications on PC.", "Link": "https://cemu.info/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cemu.info/", "Foss": true}, {"Key": "WPFInstallchatgpt", "Id": "msstore:9NT1R1C2HH7J", "Name": "ChatGPT Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "The official ChatGPT desktop app for Windows, distributed through the Microsoft Store.", "Link": "https://openai.com/chatgpt/download/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://openai.com/chatgpt/download/", "Foss": false}, {"Key": "WPFInstallchatterino", "Id": "ChatterinoTeam.Chatterino", "Name": "Chatterino", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Chatterino is a chat client for Twitch chat that offers a clean and customizable interface for a better streaming experience.", "Link": "https://www.chatterino.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.chatterino.com/", "Foss": true}, {"Key": "WPFInstallchrome", "Id": "Google.Chrome", "Name": "Chrome", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Google Chrome is a widely used web browser known for its speed, simplicity, and seamless integration with Google services.", "Link": "https://www.google.com/chrome/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.google.com/chrome/", "Foss": false}, {"Key": "WPFInstallchromium", "Id": "Hibbiki.Chromium", "Name": "Chromium", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Chromium is the open-source project that serves as the foundation for various web browsers, including Chrome.", "Link": "https://www.chromium.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.chromium.org/", "Foss": true}, {"Key": "WPFInstallcinebenchr23", "Id": "Maxon.CinebenchR23", "Name": "Cinebench R23", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Cinebench R23 is a benchmark tool for comparing CPU rendering performance across systems.", "Link": "https://www.maxon.net/en/cinebench", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.maxon.net/en/cinebench", "Foss": false}, {"Key": "WPFInstallclaude", "Id": "Anthropic.Claude", "Name": "Claude Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Anthropic's Claude desktop application for focused AI-assisted work and chat.", "Link": "https://claude.ai/download", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://claude.ai/download", "Foss": false}, {"Key": "WPFInstallclaude-code", "Id": "Anthropic.ClaudeCode", "Name": "Claude Code", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Anthropic's agentic coding tool for terminal and IDE development workflows.", "Link": "https://code.claude.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://code.claude.com/", "Foss": false}, {"Key": "WPFInstallcmake", "Id": "Kitware.CMake", "Name": "CMake", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "CMake is an open-source, cross-platform family of tools designed to build, test and package software.", "Link": "https://cmake.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cmake.org/", "Foss": true}, {"Key": "WPFInstallcodex", "Id": "OpenAI.Codex", "Name": "Codex", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Codex CLI is an OpenAI coding agent that runs locally in your terminal.", "Link": "https://developers.openai.com/codex/cli", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://developers.openai.com/codex/cli", "Foss": true}, {"Key": "WPFInstallcpuz", "Id": "CPUID.CPU-Z", "Name": "CPU-Z", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "CPU-Z is a system monitoring and diagnostic tool for Windows. It provides detailed information about the computer's hardware components, including the CPU, memory, and motherboard.", "Link": "https://www.cpuid.com/softwares/cpu-z.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.cpuid.com/softwares/cpu-z.html", "Foss": false}, {"Key": "WPFInstallcrystaldiskinfo", "Id": "CrystalDewWorld.CrystalDiskInfo", "Name": "Crystal Disk Info", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Crystal Disk Info is a disk health monitoring tool that provides information about the status and performance of hard drives. It helps users anticipate potential issues and monitor drive health.", "Link": "https://crystalmark.info/en/software/crystaldiskinfo/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://crystalmark.info/en/software/crystaldiskinfo/", "Foss": true}, {"Key": "WPFInstallcrystaldiskmark", "Id": "CrystalDewWorld.CrystalDiskMark", "Name": "Crystal Disk Mark", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Crystal Disk Mark is a disk benchmarking tool that measures the read and write speeds of storage devices. It helps users assess the performance of their hard drives and SSDs.", "Link": "https://crystalmark.info/en/software/crystaldiskmark/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://crystalmark.info/en/software/crystaldiskmark/", "Foss": true}, {"Key": "WPFInstallcursor", "Id": "Anysphere.Cursor", "Name": "Cursor", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "AI-powered code editor (VS Code-based) with agentic coding features and integrated AI assistance for development workflows.", "Link": "https://cursor.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cursor.com/", "Foss": false}, {"Key": "WPFInstallddu", "Id": "Wagnardsoft.DisplayDriverUninstaller", "Name": "Display Driver Uninstaller", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Display Driver Uninstaller (DDU) is a tool for completely uninstalling graphics drivers from NVIDIA, AMD, and Intel. It is useful for troubleshooting graphics driver-related issues.", "Link": "https://www.wagnardsoft.com/display-driver-uninstaller-DDU-", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wagnardsoft.com/display-driver-uninstaller-DDU-", "Foss": true}, {"Key": "WPFInstalldiscord", "Id": "Discord.Discord", "Name": "Discord", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Discord is a popular communication platform with voice, video, and text chat, designed for gamers but used by a wide range of communities.", "Link": "https://discord.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://discord.com/", "Foss": false}, {"Key": "WPFInstalldismtools", "Id": "CodingWondersSoftware.DISMTools.Stable", "Name": "DISMTools", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "DISMTools is a fast, customizable GUI for the DISM utility, supporting Windows images from Windows 7 onward. It handles installations on any drive, offers project support, and lets users tweak settings like color modes, language, and DISM versions; powered by both native DISM and a managed DISM API.", "Link": "https://github.com/CodingWonders/DISMTools", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/CodingWonders/DISMTools", "Foss": true}, {"Key": "WPFInstallntlite", "Id": "Nlitesoft.NTLite", "Name": "NTLite", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Integrate updates, drivers, automate Windows and application setup, speedup Windows deployment process and have it all set for the next time.", "Link": "https://ntlite.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ntlite.com", "Foss": false}, {"Key": "WPFInstalldorion", "Id": "SpikeHD.Dorion", "Name": "Dorion", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Tiny alternative Discord client with a smaller footprint, snappier startup, themes, plugins and more!", "Link": "https://spikehd.dev/projects/dorion/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://spikehd.dev/projects/dorion/", "Foss": true}, {"Key": "WPFInstalldockerdesktop", "Id": "Docker.DockerDesktop", "Name": "Docker Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Docker Desktop provides a local environment for building, running, and testing containerized applications on Windows.", "Link": "https://www.docker.com/products/docker-desktop/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.docker.com/products/docker-desktop/", "Foss": false}, {"Key": "WPFInstalldotnet6", "Id": "Microsoft.DotNet.DesktopRuntime.6", "Name": ".NET Desktop Runtime 6", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": ".NET Desktop Runtime 6 is a runtime environment required for running applications developed with .NET 6.", "Link": "https://dotnet.microsoft.com/download/dotnet/6.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/6.0", "Foss": true}, {"Key": "WPFInstalldotnet8", "Id": "Microsoft.DotNet.DesktopRuntime.8", "Name": ".NET Desktop Runtime 8", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": ".NET Desktop Runtime 8 is a runtime environment required for running applications developed with .NET 8.", "Link": "https://dotnet.microsoft.com/download/dotnet/8.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/8.0", "Foss": true}, {"Key": "WPFInstalldotnet9", "Id": "Microsoft.DotNet.DesktopRuntime.9", "Name": ".NET Desktop Runtime 9", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": ".NET Desktop Runtime 9 is a runtime environment required for running applications developed with .NET 9.", "Link": "https://dotnet.microsoft.com/download/dotnet/9.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/9.0", "Foss": true}, {"Key": "WPFInstalldotnet10", "Id": "Microsoft.DotNet.DesktopRuntime.10", "Name": ".NET Desktop Runtime 10", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": ".NET Desktop Runtime 10 is a runtime environment required for running applications developed with .NET 10.", "Link": "https://dotnet.microsoft.com/download/dotnet/10.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/10.0", "Foss": true}, {"Key": "WPFInstalldropbox", "Id": "Dropbox.Dropbox", "Name": "Dropbox", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Dropbox is a cloud storage client for syncing files, sharing content, and keeping documents available across devices.", "Link": "https://www.dropbox.com/desktop", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.dropbox.com/desktop", "Foss": false}, {"Key": "WPFInstalleaapp", "Id": "ElectronicArts.EADesktop", "Name": "EA App", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "EA App is a platform for accessing and playing Electronic Arts games.", "Link": "https://www.ea.com/ea-app", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.ea.com/ea-app", "Foss": false}, {"Key": "WPFInstalleartrumpet", "Id": "File-New-Project.EarTrumpet", "Name": "EarTrumpet (Audio)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "EarTrumpet is an audio control app for Windows, providing a simple and intuitive interface for managing sound settings.", "Link": "https://eartrumpet.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://eartrumpet.app/", "Foss": true}, {"Key": "WPFInstalledge", "Id": "Microsoft.Edge", "Name": "Edge", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Microsoft Edge is a modern web browser built on Chromium, offering performance, security, and integration with Microsoft services.", "Link": "https://www.microsoft.com/edge", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.microsoft.com/edge", "Foss": false}, {"Key": "WPFInstalles-de", "Id": "ES-DE.EmulationStation-DE", "Name": "EmulationStation Desktop Edition", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "EmulationStation Desktop Edition is a frontend for browsing and launching games from your multi-platform game collection.", "Link": "https://es-de.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://es-de.org/", "Foss": true}, {"Key": "WPFInstallenteauth", "Id": "ente-io.auth-desktop", "Name": "Ente Auth", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Ente Auth is a free, cross-platform, end-to-end encrypted authenticator app.", "Link": "https://ente.io/auth/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ente.io/auth/", "Foss": true}, {"Key": "WPFInstallepicgames", "Id": "EpicGames.EpicGamesLauncher", "Name": "Epic Games Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Epic Games Launcher is the client for accessing and playing games from the Epic Games Store.", "Link": "https://www.epicgames.com/store/en-US/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.epicgames.com/store/en-US/", "Foss": false}, {"Key": "WPFInstallfiles", "Id": "FilesCommunity.Files", "Name": "Files", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Alternative file explorer.", "Link": "https://files.community", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://files.community", "Foss": true}, {"Key": "WPFInstallfirefox", "Id": "Mozilla.Firefox", "Name": "Firefox", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Mozilla Firefox is an open-source web browser known for its customization options, privacy features, and extensions.", "Link": "https://www.mozilla.org/en-US/firefox/new/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.mozilla.org/en-US/firefox/new/", "Foss": true}, {"Key": "WPFInstallfirefoxesr", "Id": "Mozilla.Firefox.ESR", "Name": "Firefox ESR", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Mozilla Firefox is an open-source web browser known for its customization options, privacy features, and extensions. Firefox ESR (Extended Support Release) receives major updates every 42 weeks with minor updates such as crash fixes, security fixes and policy updates as needed, but at least every four weeks.", "Link": "https://www.mozilla.org/en-US/firefox/enterprise/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.mozilla.org/en-US/firefox/enterprise/", "Foss": true}, {"Key": "WPFInstallfloorp", "Id": "Ablaze.Floorp", "Name": "Floorp", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Floorp is an open-source web browser project that aims to provide a simple and fast browsing experience.", "Link": "https://floorp.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://floorp.app/", "Foss": true}, {"Key": "WPFInstallflux", "Id": "flux.flux", "Name": "F.lux", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "f.lux adjusts the color temperature of your screen to reduce eye strain during nighttime use.", "Link": "https://justgetflux.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://justgetflux.com/", "Foss": false}, {"Key": "WPFInstallfoobar", "Id": "PeterPawlowski.foobar2000", "Name": "foobar2000 (Music Player)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "foobar2000 is a highly customizable and extensible music player for Windows, known for its modular design and advanced features.", "Link": "https://www.foobar2000.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.foobar2000.org/", "Foss": false}, {"Key": "WPFInstallfnm", "Id": "Schniz.fnm", "Name": "Fast Node Manager", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Fast Node Manager (fnm) is a fast, cross-platform tool for installing and switching between Node.js versions.", "Link": "https://github.com/Schniz/fnm", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/Schniz/fnm", "Foss": true}, {"Key": "WPFInstallfoxpdfreader", "Id": "Foxit.FoxitReader", "Name": "Foxit PDF Reader", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Foxit PDF Reader is a free PDF viewer with a familiar ribbon-style interface.", "Link": "https://www.foxit.com/pdf-reader/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.foxit.com/pdf-reader/", "Foss": false}, {"Key": "WPFInstallgeforcenow", "Id": "Nvidia.GeForceNow", "Name": "GeForce NOW", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "GeForce NOW is a cloud gaming service that allows you to play high-quality PC games on your device.", "Link": "https://www.nvidia.com/en-us/geforce-now/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.nvidia.com/en-us/geforce-now/", "Foss": false}, {"Key": "WPFInstallgimp", "Id": "GIMP.GIMP.3", "Name": "GIMP (Image Editor)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "GIMP is a versatile open-source raster graphics editor used for tasks such as photo retouching, image editing, and image composition.", "Link": "https://www.gimp.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.gimp.org/", "Foss": true}, {"Key": "WPFInstallgit", "Id": "Git.Git", "Name": "Git", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Git is a distributed version control system widely used for tracking changes in source code during software development.", "Link": "https://git-scm.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://git-scm.com/", "Foss": true}, {"Key": "WPFInstallgitextensions", "Id": "GitExtensionsTeam.GitExtensions", "Name": "Git Extensions", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Git Extensions is a graphical Git client for Windows with repository, history, and commit management tools.", "Link": "https://gitextensions.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://gitextensions.github.io/", "Foss": true}, {"Key": "WPFInstallgithubcli", "Id": "GitHub.cli", "Name": "GitHub CLI", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "GitHub CLI brings pull requests, issues, releases, and other GitHub workflows to the terminal.", "Link": "https://cli.github.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cli.github.com/", "Foss": true}, {"Key": "WPFInstallgithubdesktop", "Id": "GitHub.GitHubDesktop", "Name": "GitHub Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "GitHub Desktop is a visual Git client that simplifies collaboration on GitHub repositories with an easy-to-use interface.", "Link": "https://desktop.github.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://desktop.github.com/", "Foss": true}, {"Key": "WPFInstallgog", "Id": "GOG.Galaxy", "Name": "GOG Galaxy", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "GOG Galaxy is a gaming client that offers DRM-free games, additional content, and more.", "Link": "https://www.gog.com/galaxy", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.gog.com/galaxy", "Foss": false}, {"Key": "WPFInstallgolang", "Id": "GoLang.Go", "Name": "Go", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Go (or Golang) is a statically typed, compiled programming language designed for simplicity, reliability, and efficiency.", "Link": "https://go.dev/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://go.dev/", "Foss": true}, {"Key": "WPFInstallgoogledrive", "Id": "Google.GoogleDrive", "Name": "Google Drive", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "File syncing across devices all tied to your Google account.", "Link": "https://www.google.com/drive/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.google.com/drive/", "Foss": false}, {"Key": "WPFInstallgpuz", "Id": "TechPowerUp.GPU-Z", "Name": "GPU-Z", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "GPU-Z provides detailed information about your graphics card and GPU.", "Link": "https://www.techpowerup.com/gpuz/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.techpowerup.com/gpuz/", "Foss": false}, {"Key": "WPFInstallgsudo", "Id": "gerardog.gsudo", "Name": "gsudo", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "gsudo is a sudo equivalent for Windows. It allows you to run commands with elevated administrative privileges directly within the current console window.", "Link": "https://github.com/gerardog/gsudo", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/gerardog/gsudo", "Foss": true}, {"Key": "WPFInstallhelium", "Id": "ImputNet.Helium", "Name": "Helium", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Private, fast, and honest web browser.", "Link": "https://helium.computer", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://helium.computer", "Foss": true}, {"Key": "WPFInstallhugo", "Id": "Hugo.Hugo.Extended", "Name": "Hugo", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "The world's fastest framework for building websites.", "Link": "https://gohugo.io", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://gohugo.io", "Foss": true}, {"Key": "WPFInstallhandbrake", "Id": "HandBrake.HandBrake", "Name": "HandBrake", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "HandBrake is an open-source video transcoder, allowing you to convert video from nearly any format to a selection of widely supported codecs.", "Link": "https://handbrake.fr/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://handbrake.fr/", "Foss": true}, {"Key": "WPFInstallheroiclauncher", "Id": "HeroicGamesLauncher.HeroicGamesLauncher", "Name": "Heroic Games Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Heroic Games Launcher is an open-source alternative game launcher for Epic Games Store.", "Link": "https://heroicgameslauncher.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://heroicgameslauncher.com/", "Foss": true}, {"Key": "WPFInstallhwinfo", "Id": "REALiX.HWiNFO", "Name": "HWiNFO", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "HWiNFO provides comprehensive hardware information and diagnostics for Windows.", "Link": "https://www.hwinfo.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.hwinfo.com/", "Foss": false}, {"Key": "WPFInstallhwmonitor", "Id": "CPUID.HWMonitor", "Name": "HWMonitor", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "HWMonitor is a hardware monitoring program that reads PC systems main health sensors.", "Link": "https://www.cpuid.com/softwares/hwmonitor.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.cpuid.com/softwares/hwmonitor.html", "Foss": false}, {"Key": "WPFInstallimageglass", "Id": "DuongDieuPhap.ImageGlass", "Name": "ImageGlass (Image Viewer)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "ImageGlass is a versatile image viewer with support for various image formats and a focus on simplicity and speed.", "Link": "https://imageglass.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://imageglass.org/", "Foss": true}, {"Key": "WPFInstallinternetdownloadmanager", "Id": "Tonec.InternetDownloadManager", "Name": "Internet Download Manager", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Internet Download Manager is a download manager for accelerating, resuming, and scheduling file downloads.", "Link": "https://www.internetdownloadmanager.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.internetdownloadmanager.com/", "Foss": false}, {"Key": "WPFInstallirfanview", "Id": "IrfanSkiljan.IrfanView", "Name": "IrfanView", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "IrfanView is a lightweight, fast, and free image viewer and editor. Supports multiple formats, batch processing, and powerful plugins.", "Link": "https://irfanview.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://irfanview.com/", "Foss": false}, {"Key": "WPFInstallitch", "Id": "ItchIo.Itch", "Name": "Itch.io", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Itch.io is a digital distribution platform for indie games and creative projects.", "Link": "https://itch.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://itch.io/", "Foss": true}, {"Key": "WPFInstallitunes", "Id": "Apple.iTunes", "Name": "iTunes", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "iTunes is a media player, media library, and online radio broadcaster application developed by Apple Inc.", "Link": "https://www.apple.com/itunes/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.apple.com/itunes/", "Foss": false}, {"Key": "WPFInstalljava8", "Id": "Amazon.Corretto.8.JDK", "Name": "Amazon Corretto 8 (LTS)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK).", "Link": "https://aws.amazon.com/corretto", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aws.amazon.com/corretto", "Foss": true}, {"Key": "WPFInstalljava21", "Id": "Amazon.Corretto.21.JDK", "Name": "Amazon Corretto 21 (LTS)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK).", "Link": "https://aws.amazon.com/corretto", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aws.amazon.com/corretto", "Foss": true}, {"Key": "WPFInstalljava25", "Id": "Amazon.Corretto.25.JDK", "Name": "Amazon Corretto 25 (LTS)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK).", "Link": "https://aws.amazon.com/corretto", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aws.amazon.com/corretto", "Foss": true}, {"Key": "WPFInstalljellyfinmediaplayer", "Id": "Jellyfin.JellyfinMediaPlayer", "Name": "Jellyfin Media Player", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Jellyfin Media Player is a client application for the Jellyfin media server, providing access to your media library.", "Link": "https://jellyfin.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://jellyfin.org/", "Foss": true}, {"Key": "WPFInstalljellyfinserver", "Id": "Jellyfin.Server", "Name": "Jellyfin Server", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Jellyfin Server is an open-source media server software, allowing you to organize and stream your media library.", "Link": "https://jellyfin.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://jellyfin.org/", "Foss": true}, {"Key": "WPFInstalljetbrains", "Id": "JetBrains.Toolbox", "Name": "Jetbrains Toolbox", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Jetbrains Toolbox is a platform for easy installation and management of JetBrains developer tools.", "Link": "https://www.jetbrains.com/toolbox/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.jetbrains.com/toolbox/", "Foss": false}, {"Key": "WPFInstalljpegview", "Id": "sylikc.JPEGView", "Name": "JPEG View", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "JPEGView is a lean, fast and highly configurable viewer/editor for JPEG, BMP, PNG, WEBP, TGA, GIF, JXL, HEIC, HEIF, AVIF, and TIFF images with a minimal GUI.", "Link": "https://github.com/sylikc/jpegview", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/sylikc/jpegview", "Foss": true}, {"Key": "WPFInstalljoplin", "Id": "Joplin.Joplin", "Name": "Joplin", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Joplin is an open-source note-taking and to-do application with synchronization capabilities.", "Link": "https://joplinapp.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://joplinapp.org/", "Foss": true}, {"Key": "WPFInstallkeepassxc", "Id": "KeePassXCTeam.KeePassXC", "Name": "KeePassXC", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "KeePassXC is a modern, secure, and open-source password manager that stores and manages your most sensitive information. You can run KeePassXC on Windows, macOS, and Linux systems. KeePassXC is for people with extremely high demands of secure personal data management. It saves many different types of information, such as usernames, passwords, URLs, attachments, and notes in an offline, encrypted file that can be stored in any location, including private and public cloud solutions. For easy identification and management, user-defined titles and icons can be specified for entries. In addition, entries are sorted into customizable groups. An integrated search function allows you to use advanced patterns to easily find any entry in your database. A customizable, fast, and easy-to-use password generator utility allows you to create passwords with any combination of characters or easy to remember passphrases.", "Link": "https://keepassxc.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://keepassxc.org/", "Foss": true}, {"Key": "WPFInstallklite", "Id": "CodecGuide.K-LiteCodecPack.Standard", "Name": "K-Lite Codec Standard", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "K-Lite Codec Pack Standard is a collection of audio and video codecs and related tools, providing essential components for media playback.", "Link": "https://www.codecguide.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.codecguide.com/", "Foss": false}, {"Key": "WPFInstallkodi", "Id": "XBMCFoundation.Kodi", "Name": "Kodi Media Center", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Kodi is an open-source media center application that allows you to play and view most videos, music, podcasts, and other digital media files.", "Link": "https://kodi.tv/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://kodi.tv/", "Foss": true}, {"Key": "WPFInstalllazygit", "Id": "JesseDuffield.lazygit", "Name": "Lazygit", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Simple terminal UI for git commands.", "Link": "https://github.com/jesseduffield/lazygit/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/jesseduffield/lazygit/", "Foss": true}, {"Key": "WPFInstalllibreoffice", "Id": "TheDocumentFoundation.LibreOffice", "Name": "LibreOffice", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "LibreOffice is a powerful and free office suite, compatible with other major office suites.", "Link": "https://www.libreoffice.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.libreoffice.org/", "Foss": true}, {"Key": "WPFInstalllibrewolf", "Id": "LibreWolf.LibreWolf", "Name": "LibreWolf", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "LibreWolf is a privacy-focused web browser based on Firefox, with additional privacy and security enhancements.", "Link": "https://librewolf.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://librewolf.net/", "Foss": true}, {"Key": "WPFInstalllocalsend", "Id": "LocalSend.LocalSend", "Name": "LocalSend", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "An open-source cross-platform alternative to AirDrop.", "Link": "https://localsend.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://localsend.org/", "Foss": true}, {"Key": "WPFInstallmpc-qt", "Id": "mpc-qt.mpc-qt", "Name": "mpc-qt", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Media Player Classic Qute Theater", "Link": "https://mpc-qt.github.io", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mpc-qt.github.io", "Foss": true}, {"Key": "WPFInstallmpv", "Id": "shinchiro.mpv", "Name": "mpv", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "mpv is a free, open source, and cross-platform media player supporting a wide variety of media formats, codecs, and subtitle types.", "Link": "https://mpv.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mpv.io/", "Foss": true}, {"Key": "WPFInstallmatrix", "Id": "Element.Element", "Name": "Element", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Element is a client for Matrix; an open network for secure, decentralized communication.", "Link": "https://element.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://element.io/", "Foss": true}, {"Key": "WPFInstallminitoolpartitionwizard", "Id": "MiniTool.PartitionWizard.Free", "Name": "MiniTool Partition Wizard", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Comprehensive free partition manager that performs advanced operations Windows natively cannot, such as merging partitions, converting file systems, and organizing disk capacity.", "Link": "https://www.partitionwizard.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.partitionwizard.com/", "Foss": false}, {"Key": "WPFInstallmodrinth", "Id": "Modrinth.ModrinthApp", "Name": "Modrinth App", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Modrinth App is a desktop application for managing Minecraft mods and modpacks.", "Link": "https://modrinth.com/app", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://modrinth.com/app", "Foss": true}, {"Key": "WPFInstallmoonlight", "Id": "MoonlightGameStreamingProject.Moonlight", "Name": "Moonlight/GameStream Client", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Moonlight/GameStream Client allows you to stream PC games to other devices over your local network.", "Link": "https://moonlight-stream.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://moonlight-stream.org/", "Foss": true}, {"Key": "WPFInstallmpchc", "Id": "clsid2.mpc-hc", "Name": "Media Player Classic - Home Cinema", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Media Player Classic - Home Cinema (MPC-HC) is a free and open-source video and audio player for Windows. MPC-HC is based on the original Guliverkli project and contains many additional features and bug fixes.", "Link": "https://mpc-hc.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mpc-hc.org/", "Foss": true}, {"Key": "WPFInstallmsedgeredirect", "Id": "rcmaehl.MSEdgeRedirect", "Name": "MSEdgeRedirect", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "A Tool to Redirect News, Search, Widgets, Weather, and More to your default browser.", "Link": "https://github.com/rcmaehl/MSEdgeRedirect", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/rcmaehl/MSEdgeRedirect", "Foss": true}, {"Key": "WPFInstallmsiafterburner", "Id": "Guru3D.Afterburner", "Name": "MSI Afterburner", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "MSI Afterburner is a graphics card overclocking utility with advanced features.", "Link": "https://www.msi.com/Landing/afterburner", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.msi.com/Landing/afterburner", "Foss": false}, {"Key": "WPFInstallmullvadvpn", "Id": "MullvadVPN.MullvadVPN", "Name": "Mullvad VPN", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "This is the VPN client software for the Mullvad VPN service.", "Link": "https://mullvad.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mullvad.net/", "Foss": true}, {"Key": "WPFInstallmullvadbrowser", "Id": "MullvadVPN.MullvadBrowser", "Name": "Mullvad Browser", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Mullvad Browser is a privacy-focused web browser, developed in partnership with the Tor Project.", "Link": "https://mullvad.net/browser", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mullvad.net/browser", "Foss": true}, {"Key": "WPFInstallnomacs", "Id": "nomacs.nomacs", "Name": "nomacs", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "nomacs is a free, open-source image viewer, which supports multiple platforms. You can use it for viewing all common image formats, including RAW and .psd images.", "Link": "https://nomacs.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nomacs.org/", "Foss": true}, {"Key": "WPFInstallnanazip", "Id": "M2Team.NanaZip", "Name": "NanaZip", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "NanaZip is a fast and efficient file compression and decompression tool.", "Link": "https://nanazip.org", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nanazip.org", "Foss": true}, {"Key": "WPFInstallnetbird", "Id": "Netbird.Netbird", "Name": "NetBird", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "NetBird is an open-source alternative comparable to TailScale that can be connected to a self-hosted server.", "Link": "https://netbird.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://netbird.io/", "Foss": true}, {"Key": "WPFInstalltailscale", "Id": "Tailscale.Tailscale", "Name": "Tailscale", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "The Tailscale client allows you to connect all your devices using WireGuardÂ®, without the hassle. Tailscale makes it as easy as installing an app and signing in.", "Link": "https://tailscale.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://tailscale.com/", "Foss": false}, {"Key": "WPFInstallnaps2", "Id": "Cyanfish.NAPS2", "Name": "NAPS2 (Scanner)", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "NAPS2 is a document scanning application that simplifies the process of creating electronic documents.", "Link": "https://www.naps2.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.naps2.com/", "Foss": true}, {"Key": "WPFInstallneovim", "Id": "Neovim.Neovim", "Name": "Neovim", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Neovim is a highly extensible text editor and an improvement over the original Vim editor.", "Link": "https://neovim.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://neovim.io/", "Foss": true}, {"Key": "WPFInstallnextclouddesktop", "Id": "Nextcloud.NextcloudDesktop", "Name": "Nextcloud Desktop", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Nextcloud Desktop is the official desktop client for the Nextcloud file synchronization and sharing platform.", "Link": "https://nextcloud.com/install/#install-clients", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nextcloud.com/install/#install-clients", "Foss": true}, {"Key": "WPFInstallnmap", "Id": "Insecure.Nmap", "Name": "Nmap", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Nmap (Network Mapper) is an open-source tool for network exploration and security auditing. It discovers devices on a network and provides information about their ports and services.", "Link": "https://nmap.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nmap.org/", "Foss": true}, {"Key": "WPFInstallnodejs", "Id": "OpenJS.NodeJS", "Name": "NodeJS", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "NodeJS is a JavaScript runtime built on Chrome's V8 JavaScript engine for building server-side and networking applications.", "Link": "https://nodejs.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nodejs.org/", "Foss": true}, {"Key": "WPFInstallnodejslts", "Id": "OpenJS.NodeJS.LTS", "Name": "NodeJS LTS", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "NodeJS LTS provides Long-Term Support releases for stable and reliable server-side JavaScript development.", "Link": "https://nodejs.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nodejs.org/", "Foss": true}, {"Key": "WPFInstallpnpm", "Id": "pnpm.pnpm", "Name": "pnpm", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "pnpm is a fast and disk space efficient package manager for JavaScript and Node.js applications.", "Link": "https://pnpm.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://pnpm.io/", "Foss": true}, {"Key": "WPFInstallnotepadplus", "Id": "Notepad++.Notepad++", "Name": "Notepad++", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Notepad++ is a free, open-source code editor and Notepad replacement with support for multiple languages.", "Link": "https://notepad-plus-plus.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://notepad-plus-plus.org/", "Foss": true}, {"Key": "WPFInstallnuget", "Id": "Microsoft.NuGet", "Name": "NuGet", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "NuGet is a package manager for the .NET framework, enabling developers to manage and share libraries in their .NET applications.", "Link": "https://www.nuget.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.nuget.org/", "Foss": true}, {"Key": "WPFInstallnvclean", "Id": "TechPowerUp.NVCleanstall", "Name": "NVCleanstall", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "NVCleanstall is a tool designed to customize NVIDIA driver installations, allowing advanced users to control more aspects of the installation process.", "Link": "https://www.techpowerup.com/nvcleanstall/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.techpowerup.com/nvcleanstall/", "Foss": false}, {"Key": "WPFInstallobs", "Id": "OBSProject.OBSStudio", "Name": "OBS Studio", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "OBS Studio is a free and open-source software for video recording and live streaming. It supports real-time video/audio capturing and mixing, making it popular among content creators.", "Link": "https://obsproject.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://obsproject.com/", "Foss": true}, {"Key": "WPFInstallobsidian", "Id": "Obsidian.Obsidian", "Name": "Obsidian", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Obsidian is a powerful note-taking and knowledge management application.", "Link": "https://obsidian.md/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://obsidian.md/", "Foss": false}, {"Key": "WPFInstallokular", "Id": "KDE.Okular", "Name": "Okular", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Okular is a versatile document viewer with advanced features.", "Link": "https://okular.kde.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://okular.kde.org/", "Foss": true}, {"Key": "WPFInstallonedrive", "Id": "Microsoft.OneDrive", "Name": "OneDrive", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "OneDrive is a cloud storage service provided by Microsoft, allowing users to store and share files securely across devices.", "Link": "https://onedrive.live.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://onedrive.live.com/", "Foss": false}, {"Key": "WPFInstallonlyoffice", "Id": "ONLYOFFICE.DesktopEditors", "Name": "ONLYOFFICE Desktop", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "ONLYOFFICE Desktop is a comprehensive office suite for document editing and collaboration.", "Link": "https://www.onlyoffice.com/desktop.aspx", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.onlyoffice.com/desktop.aspx", "Foss": true}, {"Key": "WPFInstallOPAutoClicker", "Id": "OPAutoClicker.OPAutoClicker", "Name": "OPAutoClicker", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "A full-fledged autoclicker with two modes of autoclicking, at your dynamic cursor location or at a prespecified location.", "Link": "https://www.opautoclicker.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.opautoclicker.com", "Foss": false}, {"Key": "WPFInstallopenrgb", "Id": "OpenRGB.OpenRGB", "Name": "OpenRGB", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "OpenRGB is an open-source RGB lighting control software designed to manage and control RGB lighting for various components and peripherals.", "Link": "https://openrgb.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://openrgb.org/", "Foss": true}, {"Key": "WPFInstallOpenVPN", "Id": "OpenVPNTechnologies.OpenVPNConnect", "Name": "OpenVPN Connect", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "OpenVPN Connect is a VPN client that allows you to connect securely to a VPN server. It provides a secure and encrypted connection for protecting your online privacy.", "Link": "https://openvpn.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://openvpn.net/", "Foss": false}, {"Key": "WPFInstallOVirtualBox", "Id": "Oracle.VirtualBox", "Name": "Oracle VirtualBox", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Oracle VirtualBox is a powerful and free open-source virtualization tool for x86 and AMD64/Intel64 architectures.", "Link": "https://www.virtualbox.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.virtualbox.org/", "Foss": true}, {"Key": "WPFInstallpolicyplus", "Id": "Fleex255.PolicyPlus", "Name": "Policy Plus", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Local Group Policy Editor plus more, for all Windows editions.", "Link": "https://github.com/Fleex255/PolicyPlus", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/Fleex255/PolicyPlus", "Foss": true}, {"Key": "WPFInstallprocessexplorer", "Id": "Microsoft.Sysinternals.ProcessExplorer", "Name": "Process Explorer", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Process Explorer is a task manager and system monitor.", "Link": "https://learn.microsoft.com/sysinternals/downloads/process-explorer", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://learn.microsoft.com/sysinternals/downloads/process-explorer", "Foss": false}, {"Key": "WPFInstallPaintdotnet", "Id": "dotPDN.PaintDotNet", "Name": "Paint.NET", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Paint.NET is a free image and photo editing software for Windows. It features an intuitive user interface and supports a wide range of powerful editing tools.", "Link": "https://www.getpaint.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.getpaint.net/", "Foss": false}, {"Key": "WPFInstallparsec", "Id": "Parsec.Parsec", "Name": "Parsec", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Parsec is a low-latency, high-quality remote desktop sharing application for collaborating and gaming across devices.", "Link": "https://parsec.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://parsec.app/", "Foss": false}, {"Key": "WPFInstallpeazip", "Id": "Giorgiotani.Peazip", "Name": "PeaZip", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "PeaZip is a free, open-source file archiver utility that supports multiple archive formats and provides encryption features.", "Link": "https://peazip.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://peazip.github.io/", "Foss": true}, {"Key": "WPFInstallpdf-xchange", "Id": "TrackerSoftware.PDF-XChangeEditor", "Name": "PDF-XChange Editor", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "A comprehensive Windows-based software suite and editor for creating, viewing, editing, annotating, and signing PDF files.", "Link": "https://www.pdf-xchange.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.pdf-xchange.com/", "Foss": false}, {"Key": "WPFInstallpdf24creator", "Id": "geeksoftwareGmbH.PDF24Creator", "Name": "PDF24 Creator", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Free and easy-to-use online/desktop PDF tools that make you more productive", "Link": "https://tools.pdf24.org/en/creator", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://tools.pdf24.org/en/creator", "Foss": false}, {"Key": "WPFInstallpdfgear", "Id": "PDFgear.PDFgear", "Name": "PDFgear", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "PDFgear is a piece of full-featured PDF management software for Windows, macOS, and mobile, and it's completely free to use.", "Link": "https://www.pdfgear.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.pdfgear.com/", "Foss": false}, {"Key": "WPFInstallpdfsam", "Id": "PDFsam.PDFsam", "Name": "PDFsam Basic", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "PDFsam Basic is a free and open-source tool for splitting, merging, and rotating PDF files.", "Link": "https://pdfsam.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://pdfsam.org/", "Foss": true}, {"Key": "WPFInstallplaynite", "Id": "Playnite.Playnite", "Name": "Playnite", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Playnite is an open-source video game library manager with one simple goal: To provide a unified interface for all of your games.", "Link": "https://playnite.link/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://playnite.link/", "Foss": true}, {"Key": "WPFInstallplex", "Id": "Plex.PlexMediaServer", "Name": "Plex Media Server", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Plex Media Server is a media server software that allows you to organize and stream your media library. It supports various media formats and offers a wide range of features.", "Link": "https://www.plex.tv/your-media/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.plex.tv/your-media/", "Foss": false}, {"Key": "WPFInstallplexdesktop", "Id": "Plex.Plex", "Name": "Plex Desktop", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Plex Desktop for Windows is the front end for Plex Media Server.", "Link": "https://www.plex.tv", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.plex.tv", "Foss": false}, {"Key": "WPFInstallposh", "Id": "JanDeDobbeleer.OhMyPosh", "Name": "Oh My Posh (Prompt)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Oh My Posh is a cross-platform prompt theme engine for any shell.", "Link": "https://ohmyposh.dev/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ohmyposh.dev/", "Foss": true}, {"Key": "WPFInstallpostman", "Id": "Postman.Postman", "Name": "Postman", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Postman is an API platform and desktop client for designing, testing, documenting, and collaborating on APIs.", "Link": "https://www.postman.com/downloads/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.postman.com/downloads/", "Foss": false}, {"Key": "WPFInstallpowershell", "Id": "Microsoft.PowerShell", "Name": "PowerShell", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "PowerShell is a task automation framework and scripting language designed for system administrators, offering powerful command-line capabilities.", "Link": "https://github.com/PowerShell/PowerShell", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/PowerShell/PowerShell", "Foss": true}, {"Key": "WPFInstallpowertoys", "Id": "Microsoft.PowerToys", "Name": "PowerToys", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "PowerToys is a set of utilities for power users to enhance productivity, featuring tools like FancyZones, PowerRename, and more.", "Link": "https://github.com/microsoft/PowerToys", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/microsoft/PowerToys", "Foss": true}, {"Key": "WPFInstallprismlauncher", "Id": "PrismLauncher.PrismLauncher", "Name": "Prism Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Prism Launcher is an open-source Minecraft launcher with the ability to manage multiple instances, accounts, and mods.", "Link": "https://prismlauncher.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://prismlauncher.org/", "Foss": true}, {"Key": "WPFInstallprocesslasso", "Id": "BitSum.ProcessLasso", "Name": "Process Lasso", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Process Lasso is a system optimization and automation tool that improves system responsiveness and stability by adjusting process priorities and CPU affinities.", "Link": "https://bitsum.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://bitsum.com/", "Foss": false}, {"Key": "WPFInstallprotonauth", "Id": "Proton.ProtonAuthenticator", "Name": "Proton Authenticator", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "2FA app from Proton to securely sync and backup 2FA codes.", "Link": "https://proton.me/authenticator", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/authenticator", "Foss": true}, {"Key": "WPFInstallprotonmail", "Id": "Proton.ProtonMail", "Name": "Proton Mail", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Proton Mail is an end-to-end encrypted email service by Proton, protecting your privacy with zero-access encryption.", "Link": "https://proton.me/mail", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/mail", "Foss": true}, {"Key": "WPFInstallprotondrive", "Id": "Proton.ProtonDrive", "Name": "Proton Drive", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Proton Drive is an end-to-end encrypted Swiss vault for your files that protects your data.", "Link": "https://proton.me/drive", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/drive", "Foss": true}, {"Key": "WPFInstallprotonpass", "Id": "Proton.ProtonPass", "Name": "Proton Pass", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Proton Pass is a cloud-based password manager with end-to-end encryption and unique email aliases.", "Link": "https://proton.me/pass", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/pass", "Foss": true}, {"Key": "WPFInstallprotonvpn", "Id": "Proton.ProtonVPN", "Name": "Proton VPN", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Proton VPN is a no-logs VPN service that protects your privacy online with features like Secure Core and Tor over VPN.", "Link": "https://protonvpn.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://protonvpn.com/", "Foss": true}, {"Key": "WPFInstallprocessmonitor", "Id": "Microsoft.Sysinternals.ProcessMonitor", "Name": "Process Monitor", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "SysInternals Process Monitor is an advanced monitoring tool that shows real-time file system, registry, and process/thread activity.", "Link": "https://docs.microsoft.com/en-us/sysinternals/downloads/procmon", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://docs.microsoft.com/en-us/sysinternals/downloads/procmon", "Foss": false}, {"Key": "WPFInstallputty", "Id": "PuTTY.PuTTY", "Name": "PuTTY", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "PuTTY is a free and open-source terminal emulator, serial console, and network file transfer application. It supports various network protocols such as SSH, Telnet, and SCP.", "Link": "https://www.chiark.greenend.org.uk/~sgtatham/putty/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.chiark.greenend.org.uk/~sgtatham/putty/", "Foss": true}, {"Key": "WPFInstallpython3", "Id": "Python.Python.3.14", "Name": "Python3", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Python is a versatile programming language used for web development, data analysis, artificial intelligence, and more.", "Link": "https://www.python.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.python.org/", "Foss": true}, {"Key": "WPFInstallqbittorrent", "Id": "qBittorrent.qBittorrent", "Name": "qBittorrent", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "qBittorrent is a free and open-source BitTorrent client that aims to provide a feature-rich and lightweight alternative to other torrent clients.", "Link": "https://www.qbittorrent.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.qbittorrent.org/", "Foss": true}, {"Key": "WPFInstallqownnotes", "Id": "pbek.QOwnNotes", "Name": "QOwnNotes", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "QOwnNotes is a free open-source note taking app with Nextcloud/ownCloud integration.", "Link": "https://www.qownnotes.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.qownnotes.org/", "Foss": true}, {"Key": "WPFInstallqtox", "Id": "Tox.qTox", "Name": "QTox", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "QTox is a free and open-source messaging app that prioritizes user privacy and security in its design.", "Link": "https://qtox.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://qtox.github.io/", "Foss": true}, {"Key": "WPFInstallrevo", "Id": "RevoUninstaller.RevoUninstaller", "Name": "Revo Uninstaller", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Revo Uninstaller is an advanced uninstaller tool that helps you remove unwanted software and clean up your system.", "Link": "https://www.revouninstaller.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.revouninstaller.com/", "Foss": false}, {"Key": "WPFInstallWiseProgramUninstaller", "Id": "WiseCleaner.WiseProgramUninstaller", "Name": "Wise Program Uninstaller (WiseCleaner)", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Wise Program Uninstaller is the perfect solution for uninstalling Windows programs, allowing you to uninstall applications quickly and completely using its simple and user-friendly interface.", "Link": "https://www.wisecleaner.com/wise-program-uninstaller.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wisecleaner.com/wise-program-uninstaller.html", "Foss": false}, {"Key": "WPFInstallrufus", "Id": "Rufus.Rufus", "Name": "Rufus Imager", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Rufus is a utility that helps format and create bootable USB drives, such as USB keys or pen drives.", "Link": "https://rufus.ie/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://rufus.ie/", "Foss": true}, {"Key": "WPFInstallrustlang", "Id": "Rustlang.Rust.MSVC", "Name": "Rust", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Rust is a programming language designed for safety and performance, particularly focused on systems programming.", "Link": "https://www.rust-lang.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.rust-lang.org/", "Foss": true}, {"Key": "WPFInstallsdio", "Id": "GlennDelahoy.SnappyDriverInstallerOrigin", "Name": "Snappy Driver Installer Origin", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Snappy Driver Installer Origin is a free and open-source driver updater with a vast driver database for Windows.", "Link": "https://www.glenn.delahoy.com/snappy-driver-installer-origin/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.glenn.delahoy.com/snappy-driver-installer-origin/", "Foss": true}, {"Key": "WPFInstallsharex", "Id": "ShareX.ShareX", "Name": "ShareX (Screenshots)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "ShareX is a free and open-source screen capture and file sharing tool. It supports various capture methods and offers advanced features for editing and sharing screenshots.", "Link": "https://getsharex.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://getsharex.com/", "Foss": true}, {"Key": "WPFInstallnilesoftShell", "Id": "Nilesoft.Shell", "Name": "Nilesoft Shell", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Shell is an expanded context menu tool that adds extra functionality and customization options to the Windows context menu.", "Link": "https://nilesoft.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nilesoft.org/", "Foss": false}, {"Key": "WPFInstallsysteminformer", "Id": "WinsiderSS.SystemInformer", "Name": "System Informer", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "A free, powerful, multi-purpose tool that helps you monitor system resources, debug software and detect malware.", "Link": "https://systeminformer.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://systeminformer.com/", "Foss": true}, {"Key": "WPFInstallsignal", "Id": "OpenWhisperSystems.Signal", "Name": "Signal", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Signal is a privacy-focused messaging app that offers end-to-end encryption for secure and private communication.", "Link": "https://signal.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://signal.org/", "Foss": true}, {"Key": "WPFInstallsignalrgb", "Id": "WhirlwindFX.SignalRgb", "Name": "SignalRGB", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "SignalRGB lets you control and sync your favorite RGB devices with one free application.", "Link": "https://www.signalrgb.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.signalrgb.com/", "Foss": false}, {"Key": "WPFInstallsimplenote", "Id": "Automattic.Simplenote", "Name": "Simplenote", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Simplenote is an easy way to keep notes, lists, ideas and more.", "Link": "https://simplenote.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://simplenote.com/", "Foss": true}, {"Key": "WPFInstallsimplewall", "Id": "Henry++.simplewall", "Name": "Simplewall", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Simplewall is a free and open-source firewall application for Windows. It allows users to control and manage the inbound and outbound network traffic of applications.", "Link": "https://github.com/henrypp/simplewall", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/henrypp/simplewall", "Foss": true}, {"Key": "WPFInstallslack", "Id": "SlackTechnologies.Slack", "Name": "Slack", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Slack is a collaboration hub that connects teams and facilitates communication through channels, messaging, and file sharing.", "Link": "https://slack.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://slack.com/", "Foss": false}, {"Key": "WPFInstallstartallback", "Id": "StartIsBack.StartAllBack", "Name": "StartAllBack", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "StartAllBack restores and improves Windows taskbar, Start menu, File Explorer, and shell UI behavior.", "Link": "https://www.startallback.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.startallback.com/", "Foss": false}, {"Key": "WPFInstallstarship", "Id": "Starship.Starship", "Name": "Starship (Shell Prompt)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Starship is a fast, customizable, cross-platform prompt for PowerShell and other shells.", "Link": "https://starship.rs/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://starship.rs/", "Foss": true}, {"Key": "WPFInstallsteam", "Id": "Valve.Steam", "Name": "Steam", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Steam is a digital distribution platform for purchasing and playing video games, offering multiplayer gaming, video streaming, and more.", "Link": "https://store.steampowered.com/about/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://store.steampowered.com/about/", "Foss": false}, {"Key": "WPFInstallroblox", "Id": "Roblox.Roblox", "Name": "Roblox", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Roblox is a platform and game creation system that allows users to create and play games developed by the community.", "Link": "https://www.roblox.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.roblox.com/", "Foss": false}, {"Key": "WPFInstallsublimetext", "Id": "SublimeHQ.SublimeText.4", "Name": "Sublime Text", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Sublime Text is a sophisticated text editor for code, markup, and prose.", "Link": "https://www.sublimetext.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.sublimetext.com/", "Foss": false}, {"Key": "WPFInstallsumatra", "Id": "SumatraPDF.SumatraPDF", "Name": "Sumatra PDF", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Sumatra PDF is a lightweight and fast PDF viewer with minimalistic design.", "Link": "https://www.sumatrapdfreader.org/free-pdf-reader.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.sumatrapdfreader.org/free-pdf-reader.html", "Foss": true}, {"Key": "WPFInstallsunshine", "Id": "LizardByte.Sunshine", "Name": "Sunshine/GameStream Server", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Sunshine is a GameStream server that allows you to remotely play PC games on Android devices, offering low-latency streaming.", "Link": "https://app.lizardbyte.dev/Sunshine/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://app.lizardbyte.dev/Sunshine/", "Foss": true}, {"Key": "WPFInstalltcpview", "Id": "Microsoft.Sysinternals.TCPView", "Name": "TCPView", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "SysInternals TCPView is a network monitoring tool that displays a detailed list of all TCP and UDP endpoints on your system.", "Link": "https://docs.microsoft.com/en-us/sysinternals/downloads/tcpview", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://docs.microsoft.com/en-us/sysinternals/downloads/tcpview", "Foss": false}, {"Key": "WPFInstallteams", "Id": "Microsoft.Teams", "Name": "Teams", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Microsoft Teams is a collaboration platform that integrates with Office 365 and offers chat, video conferencing, file sharing, and more.", "Link": "https://www.microsoft.com/en-us/microsoft-teams/group-chat-software", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.microsoft.com/en-us/microsoft-teams/group-chat-software", "Foss": false}, {"Key": "WPFInstallteamviewer", "Id": "TeamViewer.TeamViewer", "Name": "TeamViewer", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "TeamViewer is a popular remote access and support software that allows you to connect to and control remote devices.", "Link": "https://www.teamviewer.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.teamviewer.com/", "Foss": false}, {"Key": "WPFInstallteamspeak3", "Id": "TeamSpeakSystems.TeamSpeakClient", "Name": "TeamSpeak 3", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "TEAMSPEAK. YOUR TEAM. YOUR RULES. Use crystal clear sound to communicate with your teammates cross-platform with military-grade security, lag-free performance & unparalleled reliability and uptime.", "Link": "https://www.teamspeak.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.teamspeak.com/", "Foss": false}, {"Key": "WPFInstallteamspeak6", "Id": "TeamSpeakSystems.TeamSpeakClient.Beta.6", "Name": "TeamSpeak 6", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "TEAMSPEAK. YOUR TEAM. YOUR RULES. Use crystal clear sound to communicate with your teammates cross-platform with military-grade security, lag-free performance & unparalleled reliability and uptime.", "Link": "https://www.teamspeak.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.teamspeak.com/", "Foss": false}, {"Key": "WPFInstalltelegram", "Id": "Telegram.TelegramDesktop", "Name": "Telegram", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Telegram is a cloud-based instant messaging app known for its security features, speed, and simplicity.", "Link": "https://telegram.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://telegram.org/", "Foss": true}, {"Key": "WPFInstallterminal", "Id": "Microsoft.WindowsTerminal", "Name": "Windows Terminal", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Windows Terminal is a modern, fast, and efficient terminal application for command-line users, supporting multiple tabs, panes, and more.", "Link": "https://aka.ms/terminal", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aka.ms/terminal", "Foss": true}, {"Key": "WPFInstallthunderbird", "Id": "Mozilla.Thunderbird", "Name": "Thunderbird", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Mozilla Thunderbird is a free and open-source email client, news client, and chat client with advanced features.", "Link": "https://www.thunderbird.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.thunderbird.net/", "Foss": true}, {"Key": "WPFInstallbetterbird", "Id": "Betterbird.Betterbird", "Name": "Betterbird", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Betterbird is a fork of Mozilla Thunderbird with additional features and bugfixes.", "Link": "https://www.betterbird.eu/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.betterbird.eu/", "Foss": true}, {"Key": "WPFInstalltor", "Id": "TorProject.TorBrowser", "Name": "Tor Browser", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Tor Browser is designed for anonymous web browsing, utilizing the Tor network to protect user privacy and security.", "Link": "https://www.torproject.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.torproject.org/", "Foss": true}, {"Key": "WPFInstalltotalcommander", "Id": "Ghisler.TotalCommander", "Name": "Total Commander", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Total Commander is a file manager for Windows that provides a powerful and intuitive interface for file management.", "Link": "https://www.ghisler.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.ghisler.com/", "Foss": false}, {"Key": "WPFInstalltreesize", "Id": "JAMSoftware.TreeSize.Free", "Name": "TreeSize Free", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "TreeSize Free is a disk space manager that helps you analyze and visualize the space usage on your drives.", "Link": "https://www.jam-software.com/treesize_free/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.jam-software.com/treesize_free/", "Foss": false}, {"Key": "WPFInstallttaskbar", "Id": "CharlesMilette.TranslucentTB", "Name": "TranslucentTB", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "TranslucentTB is a tool that allows you to customize the transparency of the Windows Taskbar.", "Link": "https://translucenttb.github.io", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://translucenttb.github.io", "Foss": true}, {"Key": "WPFInstallubisoft", "Id": "Ubisoft.Connect", "Name": "Ubisoft Connect", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Ubisoft Connect is Ubisoft's digital distribution and online gaming service, providing access to Ubisoft's games and services.", "Link": "https://ubisoftconnect.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ubisoftconnect.com/", "Foss": false}, {"Key": "WPFInstallungoogled", "Id": "eloston.ungoogled-chromium", "Name": "Ungoogled Chromium", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Ungoogled Chromium is a version of Chromium without Google's integration for enhanced privacy and control.", "Link": "https://github.com/Eloston/ungoogled-chromium", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/Eloston/ungoogled-chromium", "Foss": true}, {"Key": "WPFInstallunity", "Id": "Unity.UnityHub", "Name": "Unity Game Engine", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Unity is a powerful game development platform for creating 2D, 3D, augmented reality, and virtual reality games.", "Link": "https://unity.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://unity.com/", "Foss": false}, {"Key": "WPFInstallvagrant", "Id": "Hashicorp.Vagrant", "Name": "Vagrant", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Vagrant builds and manages reproducible virtual machine development environments from declarative configuration.", "Link": "https://developer.hashicorp.com/vagrant", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://developer.hashicorp.com/vagrant", "Foss": false}, {"Key": "WPFInstalleverything", "Id": "voidtools.Everything", "Name": "Everything", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Everything is a search engine that locates files and folders by filename instantly for Windows. Unlike Windows search Everything initially displays every file and folder on your computer (hence the name Everything). You type in a search filter to limit what files and folders are displayed.", "Link": "https://www.voidtools.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.voidtools.com/", "Foss": false}, {"Key": "WPFInstallvc2015_32", "Id": "Microsoft.VCRedist.2015+.x86", "Name": "Visual C++ 2015-2022 32-bit", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Visual C++ 2015-2022 32-bit redistributable package installs runtime components of Visual C++ libraries required to run 32-bit applications.", "Link": "https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "Foss": false}, {"Key": "WPFInstallvc2015_64", "Id": "Microsoft.VCRedist.2015+.x64", "Name": "Visual C++ 2015-2022 64-bit", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Visual C++ 2015-2022 64-bit redistributable package installs runtime components of Visual C++ libraries required to run 64-bit applications.", "Link": "https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "Foss": false}, {"Key": "WPFInstallventoy", "Id": "Ventoy.Ventoy", "Name": "Ventoy", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Ventoy is an open-source tool for creating bootable USB drives. It supports multiple ISO files on a single USB drive, making it a versatile solution for installing operating systems.", "Link": "https://www.ventoy.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.ventoy.net/", "Foss": true}, {"Key": "WPFInstallvesktop", "Id": "Vencord.Vesktop", "Name": "Vesktop", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "A cross platform electron-based desktop app aiming to give you a snappier Discord experience with Vencord pre-installed.", "Link": "https://vesktop.dev", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://vesktop.dev", "Foss": true}, {"Key": "WPFInstallviber", "Id": "Rakuten.Viber", "Name": "Viber", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Viber is a free messaging and calling app with features like group chats, video calls, and more.", "Link": "https://www.viber.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.viber.com/", "Foss": false}, {"Key": "WPFInstallvisualstudio2022", "Id": "Microsoft.VisualStudio.2022.Community", "Name": "Visual Studio 2022", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Visual Studio 2022 is an integrated development environment (IDE) for building, debugging, and deploying applications.", "Link": "https://visualstudio.microsoft.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://visualstudio.microsoft.com/", "Foss": false}, {"Key": "WPFInstallvisualstudio2026", "Id": "Microsoft.VisualStudio.Community", "Name": "Visual Studio 2026", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Visual Studio 2026 is an integrated development environment (IDE) for building, debugging, and deploying applications.", "Link": "https://visualstudio.microsoft.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://visualstudio.microsoft.com/", "Foss": false}, {"Key": "WPFInstallvivaldi", "Id": "Vivaldi.Vivaldi", "Name": "Vivaldi", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Vivaldi is a highly customizable web browser with a focus on user personalization and productivity features.", "Link": "https://vivaldi.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://vivaldi.com/", "Foss": false}, {"Key": "WPFInstallvlc", "Id": "VideoLAN.VLC", "Name": "VLC (Video Player)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "VLC Media Player is a free and open-source multimedia player that supports a wide range of audio and video formats. It is known for its versatility and cross-platform compatibility.", "Link": "https://www.videolan.org/vlc/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.videolan.org/vlc/", "Foss": true}, {"Key": "WPFInstallvrdesktopstreamer", "Id": "VirtualDesktop.Streamer", "Name": "Virtual Desktop Streamer", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Virtual Desktop Streamer is a tool that allows you to stream your desktop screen to VR devices.", "Link": "https://www.vrdesktop.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.vrdesktop.net/", "Foss": false}, {"Key": "WPFInstallvscode", "Id": "Microsoft.VisualStudioCode", "Name": "VS Code", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Visual Studio Code is a free, open-source code editor with support for multiple programming languages.", "Link": "https://code.visualstudio.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://code.visualstudio.com/", "Foss": true}, {"Key": "WPFInstallvscodium", "Id": "VSCodium.VSCodium", "Name": "VS Codium", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "VSCodium is a community-driven, freely-licensed binary distribution of Microsoft's VS Code.", "Link": "https://vscodium.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://vscodium.com/", "Foss": true}, {"Key": "WPFInstallwaterfox", "Id": "Waterfox.Waterfox", "Name": "Waterfox", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Waterfox is a fast, privacy-focused web browser based on Firefox, designed to preserve user choice and privacy.", "Link": "https://www.waterfox.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.waterfox.net/", "Foss": true}, {"Key": "WPFInstallwhatsapp", "Id": "msstore:9NKSQGP7F2NH", "Name": "WhatsApp Desktop", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "WhatsApp Desktop is the official Windows desktop messaging app from Meta, distributed through the Microsoft Store.", "Link": "https://www.whatsapp.com/download", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.whatsapp.com/download", "Foss": false}, {"Key": "WPFInstallwingetui", "Id": "Devolutions.UniGetUI", "Name": "UniGetUI", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "UniGetUI is a GUI for WinGet, Chocolatey, and other Windows CLI package managers.", "Link": "https://devolutions.net/unigetui/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://devolutions.net/unigetui/", "Foss": true}, {"Key": "WPFInstallwinrar", "Id": "RARLab.WinRAR", "Name": "WinRAR", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "WinRAR is a powerful archive manager that allows you to create, manage, and extract compressed files.", "Link": "https://www.win-rar.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.win-rar.com/", "Foss": false}, {"Key": "WPFInstallwinscp", "Id": "WinSCP.WinSCP", "Name": "WinSCP", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "WinSCP is a popular open-source SFTP, FTP, and SCP client for Windows. It allows secure file transfers between a local and a remote computer.", "Link": "https://winscp.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://winscp.net/", "Foss": true}, {"Key": "WPFInstallwireguard", "Id": "WireGuard.WireGuard", "Name": "WireGuard", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "WireGuard is a fast and modern VPN (Virtual Private Network) protocol. It aims to be simpler and more efficient than other VPN protocols, providing secure and reliable connections.", "Link": "https://www.wireguard.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wireguard.com/", "Foss": true}, {"Key": "WPFInstallwireshark", "Id": "WiresharkFoundation.Wireshark", "Name": "Wireshark", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Wireshark is a widely-used open-source network protocol analyzer. It allows users to capture and analyze network traffic in real-time, providing detailed insights into network activities.", "Link": "https://www.wireshark.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wireshark.org/", "Foss": true}, {"Key": "WPFInstallwiztree", "Id": "AntibodySoftware.WizTree", "Name": "WizTree", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "WizTree is a fast disk space analyzer that helps you quickly find the files and folders consuming the most space on your hard drive.", "Link": "https://wiztreefree.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://wiztreefree.com/", "Foss": false}, {"Key": "WPFInstallxeheditor", "Id": "MHNexus.HxD", "Name": "HxD Hex Editor", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "HxD is a free hex editor that allows you to edit, view, search, and analyze binary files.", "Link": "https://mh-nexus.de/en/hxd/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mh-nexus.de/en/hxd/", "Foss": false}, {"Key": "WPFInstallxournal", "Id": "Xournal++.Xournal++", "Name": "Xournal++", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Xournal++ is an open-source handwriting notetaking software with PDF annotation capabilities.", "Link": "https://xournalpp.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://xournalpp.github.io/", "Foss": true}, {"Key": "WPFInstallyarn", "Id": "Yarn.Yarn", "Name": "Yarn", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Yarn is a fast, reliable, and secure dependency management tool for JavaScript projects.", "Link": "https://yarnpkg.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://yarnpkg.com/", "Foss": true}, {"Key": "WPFInstallzoom", "Id": "Zoom.Zoom", "Name": "Zoom", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Zoom is a popular video conferencing and web conferencing service for online meetings, webinars, and collaborative projects.", "Link": "https://zoom.us/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://zoom.us/", "Foss": false}, {"Key": "WPFInstalluv", "Id": "astral-sh.uv", "Name": "uv", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "uv is a fast Python package and project manager written in Rust.", "Link": "https://docs.astral.sh/uv/getting-started/installation/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://docs.astral.sh/uv/getting-started/installation/", "Foss": true}, {"Key": "WPFInstalltightvnc", "Id": "GlavSoft.TightVNC", "Name": "TightVNC", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "TightVNC is a free and open-source remote desktop software that lets you access and control a computer over the network. With its intuitive interface, you can interact with the remote screen as if you were sitting in front of it. You can open files, launch applications, and perform other actions on the remote desktop almost as if you were physically there.", "Link": "https://www.tightvnc.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.tightvnc.com/", "Foss": true}, {"Key": "WPFInstallglazewm", "Id": "glzr-io.glazewm", "Name": "GlazeWM", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "GlazeWM is a tiling window manager for Windows inspired by i3 and Polybar.", "Link": "https://github.com/glzr-io/glazewm", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/glzr-io/glazewm", "Foss": true}, {"Key": "WPFInstallOverwolf", "Id": "Overwolf.CurseForge", "Name": "Overwolf", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Popular platform for game overlays and companion apps (mod managers, trackers, etc.), widely used by gamers.", "Link": "https://www.overwolf.com/app/overwolf-curseforge", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.overwolf.com/app/overwolf-curseforge", "Foss": false}, {"Key": "WPFInstallOFGB", "Id": "xM4ddy.OFGB", "Name": "OFGB (Oh Frick Go Back)", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "GUI Tool to remove ads from various places around Windows 11", "Link": "https://github.com/xM4ddy/OFGB", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/xM4ddy/OFGB", "Foss": true}, {"Key": "WPFInstallZenBrowser", "Id": "Zen-Team.Zen-Browser", "Name": "Zen Browser", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "The modern, privacy-focused, performance-driven browser built on Firefox.", "Link": "https://zen-browser.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://zen-browser.app/", "Foss": true}, {"Key": "WPFInstallZed", "Id": "ZedIndustries.Zed", "Name": "Zed", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Zed is a modern, high-performance code editor designed from the ground up for speed and collaboration.", "Link": "https://zed.dev/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://zed.dev/", "Foss": true}, {"Key": "WPFInstallzotero", "Id": "DigitalScholar.Zotero", "Name": "Zotero", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Zotero is a free, easy-to-use tool to help you collect, organize, cite, and share your research materials.", "Link": "https://www.zotero.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.zotero.org/", "Foss": true}, {"Key": "WPFInstalldeskflow", "Id": "Deskflow.Deskflow", "Name": "Deskflow", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Deskflow is a free and open-source software KVM that lets you share a single keyboard and mouse across multiple computers.", "Link": "https://github.com/deskflow/deskflow", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/deskflow/deskflow", "Foss": true}, {"Key": "WPFInstallRuby", "Id": "RubyInstallerTeam.Ruby.4.0", "Name": "Ruby", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "A Ruby language execution environment with a MSYS2 installation.", "Link": "https://rubyinstaller.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://rubyinstaller.org/", "Foss": true}, {"Key": "WPFInstallLua", "Id": "rjpcomputing.luaforwindows", "Name": "Lua", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "A 'batteries included environment' for the Lua scripting language on Windows.", "Link": "https://github.com/rjpcomputing/luaforwindows", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/rjpcomputing/luaforwindows", "Foss": true}, {"Key": "WPFInstallCloudflareWARP", "Id": "Cloudflare.Warp", "Name": "Cloudflare WARP", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "WARP is a freemium VPN service provided by Cloudflare. Includes usage of Cloudflare's DNS", "Link": "https://one.one.one.one", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://one.one.one.one", "Foss": false}, {"Key": "WPFInstallExitLag", "Id": "ExitLag.Installer", "Name": "ExitLag", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Otimizador de rotas e conexões de rede para jogos online. Reduz ping, packet loss e elimina congelamentos.", "Link": "https://www.exitlag.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.exitlag.com/", "DownloadUrl": "https://cdn.exitlag.com/SetupExitLag-5.23.1-x64.exe", "InstallArgs": "/SILENT /VERYSILENT /NORESTART", "Foss": false}, {"Key": "WPFInstallNvidiaApp", "Id": "Nvidia.App", "Name": "NVIDIA App", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Software oficial moderno da NVIDIA que substitui o GeForce Experience e Painel de Controle. Gerencia drivers Game Ready/Studio, otimiza jogos e recursos gráficos.", "Link": "https://www.nvidia.com/pt-br/software/nvidia-app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.nvidia.com", "DownloadUrl": "https://us.download.nvidia.com/nvapp/client/11.0.9.251/NVIDIA_app_v11.0.9.251.exe", "InstallArgs": "-s", "Foss": false}, {"Key": "WPFInstallAmdSoftware", "Id": "AMD.Software.Adrenalin", "Name": "AMD Software: Adrenalin Edition", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Software e driver oficial da AMD para placas de vídeo Radeon. Gerencia atualizações de drivers, métricas de FPS, Radeon Anti-Lag, RSR e ajustes de desempenho.", "Link": "https://www.amd.com/pt/products/software/adrenalin.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.amd.com", "DownloadUrl": "https://drivers.amd.com/drivers/installer/26.10/whql/amd-software-adrenalin-edition-26.8.1-minimalsetup-260818_web.exe", "InstallArgs": "/install /quiet /noreboot", "Foss": false}, {"Key": "WPFInstallHydraLauncher", "Id": "HydraLauncher.Hydra", "Name": "Hydra Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Launcher de jogos open-source com cliente BitTorrent embutido, biblioteca unificada, metadados HowLongToBeat e suporte a emuladores.", "Link": "https://github.com/hydralauncher/hydra", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/hydralauncher/hydra", "Foss": true}, {"Key": "WPFInstallMalwarebytes", "Id": "Malwarebytes.Malwarebytes", "Name": "Malwarebytes Anti-Malware", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Líder mundial na detecção e eliminação de vírus resistentes, trojans, ransomwares, spyware e malwares ocultos.", "Link": "https://www.malwarebytes.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.malwarebytes.com", "Foss": false}, {"Key": "WPFInstallAdwCleaner", "Id": "Malwarebytes.AdwCleaner", "Name": "Malwarebytes AdwCleaner", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Ferramenta gratuita essencial pós-formatação para eliminar adwares, sequestradores de navegador, barras invasivas e PUPs indesejados.", "Link": "https://www.malwarebytes.com/adwcleaner", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.malwarebytes.com", "Foss": false}, {"Key": "WPFInstallBitdefender", "Id": "Bitdefender.Bitdefender", "Name": "Bitdefender Antivirus Agent", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Solução de ponta em cibersegurança com proteção multicamadas em tempo real contra malwares, ransomware e ameaças de rede.", "Link": "https://www.bitdefender.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.bitdefender.com", "Foss": false}, {"Key": "WPFInstallKaspersky", "Id": "Kaspersky.Security", "Name": "Kaspersky Free / Standard", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Antivírus consagrado da Kaspersky com proteção em tempo real, monitor comportamental Inspetor do Sistema e proteção web.", "Link": "https://www.kaspersky.com.br/free-antivirus", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.kaspersky.com.br", "DownloadUrl": "https://devbuilds.s.kaspersky-labs.com/fast/smartinstaller/windows/kasperskyinstaller.exe", "InstallArgs": "/s", "Foss": false}, {"Key": "WPFInstallKvrt", "Id": "Kaspersky.KVRT", "Name": "Kaspersky Virus Removal Tool (KVRT)", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Scanner portátil oficial gratuito da Kaspersky para desinfecção rápida e remoção completa de vírus e rootkits sem necessidade de instalação.", "Link": "https://www.kaspersky.com.br/downloads/free-virus-removal-tool", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.kaspersky.com.br", "DownloadUrl": "https://devbuilds.s.kaspersky-labs.com/kvrt/latest/full/kvrt.exe", "InstallArgs": "-dontinstall", "Foss": false}, {"Key": "WPFInstallspotify", "Id": "Spotify.Spotify", "Name": "Spotify Music", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Plataforma oficial de streaming com milhões de músicas, playlists personalizadas e podcasts sob demanda.", "Link": "https://www.spotify.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.spotify.com", "Foss": false}, {"Key": "WPFInstallEset", "Id": "ESET.Nod32", "Name": "ESET NOD32 Antivirus", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Antivírus ultraleve de alta precisão com motor LiveGrid. Bloqueia ameaças avançadas mantendo máxima velocidade no computador.", "Link": "https://www.eset.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.eset.com", "Foss": false}, {"Key": "WPFInstallDefenderUI", "Id": "VoodooSoft.DefenderUI", "Name": "DefenderUI (Controle Windows Defender)", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Interface moderna para o Windows Defender nativo. Desbloqueia perfis de proteção avançados e recursos ocultos de segurança.", "Link": "https://www.cyberlock.tech/defenderui.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.cyberlock.tech", "Foss": false}]
'@

$tweaksRawJson = @'
[{"Key": "WPFTweaksActivity", "Name": "Histórico de Atividades - Desativar", "OriginalName": "Activity History - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Desativa o registro e sincronização de documentos recentes, área de transferência e histórico com a Microsoft.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "EnableActivityFeed", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "PublishUserActivities", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "UploadUserActivities", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksHiber", "Name": "Hibernação - Desativar (Libera Espaço no SSD)", "OriginalName": "Hibernation - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Desativa a hibernação (powercfg /h off), liberando de 8 a 32 GB de espaço em disco do arquivo hiberfil.sys.", "Registry": [{"Path": "HKLM:\\System\\CurrentControlSet\\Control\\Session Manager\\Power", "Name": "HibernateEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FlyoutMenuSettings", "Name": "ShowHibernateOption", "Value": "0", "Type": "DWord", "OriginalValue": "1"}], "InvokeScript": "powercfg.exe /hibernate off", "UndoScript": "powercfg.exe /hibernate on"}, {"Key": "WPFTweaksWidget", "Name": "Widgets e Notícias da Barra de Tarefas - Remover", "OriginalName": "Widgets - Remove", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Remove o painel de widgets e notícias MSN da barra de tarefas do Windows 11.", "Registry": [], "InvokeScript": "\r\n      # Sometimes if you dont stop the Widgets process the removal may fail\r\n\r\n      Get-Process *Widget* | Stop-Process\r\n      Get-AppxPackage Microsoft.WidgetsPlatformRuntime -AllUsers | Remove-AppxPackage -AllUsers\r\n      Get-AppxPackage MicrosoftWindows.Client.WebExperience -AllUsers | Remove-AppxPackage -AllUsers\r\n\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      Write-Host \"Removed widgets\"\r\n      ", "UndoScript": ""}, {"Key": "WPFTweaksRevertStartMenu", "Name": "Layout Anterior do Menu Iniciar - Restaurar", "OriginalName": "Start Menu Previous Layout - Enable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Restaura o layout clássico do Menu Iniciar antes das alterações recentes do Windows 11.", "Registry": [{"Path": "HKLM:\\SYSTEM\\ControlSet001\\Control\\FeatureManagement\\Overrides\\8\\3036241548", "Name": "EnabledState", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksDisableStoreSearch", "Name": "Anúncios da Microsoft Store na Busca - Desativar", "OriginalName": "Microsoft Store Recommended Search Results - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Impede a exibição de aplicativos patrocinados da Microsoft Store ao pesquisar no Menu Iniciar.", "Registry": [], "InvokeScript": "icacls \"$Env:LocalAppData\\Packages\\Microsoft.WindowsStore_8wekyb3d8bbwe\\LocalState\\store.db\" /deny Everyone:F", "UndoScript": "icacls \"$Env:LocalAppData\\Packages\\Microsoft.WindowsStore_8wekyb3d8bbwe\\LocalState\\store.db\" /grant Everyone:F"}, {"Key": "WPFTweaksLocation", "Name": "Rastreamento de Localização - Desativar", "OriginalName": "Location Tracking - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Desativa o rastreamento geográfico do Windows para maior privacidade e menor uso de bateria.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\location", "Name": "Value", "Value": "Deny", "Type": "String", "OriginalValue": "Allow"}, {"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Sensor\\Overrides\\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}", "Name": "SensorPermissionState", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKLM:\\SYSTEM\\Maps", "Name": "AutoUpdateEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "1"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksServices", "Name": "Serviços Desnecessários - Definir para Inicialização Manual", "OriginalName": "Services - Set to Manual", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Define serviços secundários do Windows para iniciar apenas sob demanda, economizando memória RAM e CPU.", "Registry": [], "InvokeScript": "\r\n      $Memory = (Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1KB\r\n      Set-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\Control\" -Name SvcHostSplitThresholdInKB -Value $Memory\r\n      ", "UndoScript": ""}, {"Key": "WPFTweaksBraveDebloat", "Name": "Brave Browser - Debloat (Desativar Cripto e Recompensas)", "OriginalName": "Brave Browser - Debloat", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desativa recursos pesados do Brave como Brave Rewards, Carteira Crypto e assistente de IA Leo.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveRewardsDisabled", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveWalletDisabled", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveVPNDisabled", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveAIChatEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveStatsPingEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveNewsDisabled", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveTalkDisabled", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "TorDisabled", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "BraveP3AEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "UrlKeyedAnonymizedDataCollectionEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "SafeBrowsingExtendedReportingEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave", "Name": "MetricsReportingEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksDisableWarningForUnsignedRdp", "Name": "Avisos de RDP não Assinado - Desativar", "OriginalName": "RDP Unsigned File Warnings - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Remove o aviso de confirmação repetitivo ao iniciar arquivos de conexão de Área de Trabalho Remota (.rdp).", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services\\Client", "Name": "RedirectionWarningDialogVersion", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\SOFTWARE\\Microsoft\\Terminal Server Client", "Name": "RdpLaunchConsentAccepted", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksEdgeDebloat", "Name": "Microsoft Edge - Debloat (Desativar Telemetria e Pop-ups)", "OriginalName": "Microsoft Edge - Debloat", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desativa telemetria, anúncios de compras e barras laterais invasivas no navegador Microsoft Edge.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\EdgeUpdate", "Name": "CreateDesktopShortcutDefault", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "PersonalizationReportingEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\ExtensionInstallBlocklist", "Name": "1", "Value": "ofefcgjbeghpigppfmkologfjadafddi", "Type": "String", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "ShowRecommendationsEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "HideFirstRunExperience", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "UserFeedbackAllowed", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "ConfigureDoNotTrack", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "AlternateErrorPagesEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "EdgeCollectionsEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "EdgeShoppingAssistantEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "MicrosoftEdgeInsiderPromotionEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "ShowMicrosoftRewards", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "WebWidgetAllowed", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "DiagnosticData", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "EdgeAssetDeliveryServiceEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "WalletDonationEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge", "Name": "DefaultBrowserSettingsCampaignEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksConsumerFeatures", "Name": "Recursos de Consumidor (Promoções e Bloatwares) - Desativar", "OriginalName": "ConsumerFeatures - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Bloqueia a instalação automática de aplicativos promovidos (ex: Candy Crush, TikTok) em novas contas.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent", "Name": "DisableWindowsConsumerFeatures", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksTelemetry", "Name": "Telemetria e Diagnósticos da Microsoft - Desativar", "OriginalName": "Telemetry - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Desativa serviços de telemetria (DiagTrack, WER, envio de amostras) que monitoram o uso do sistema.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\AdvertisingInfo", "Name": "Enabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Privacy", "Name": "TailoredExperiencesWithDiagnosticDataEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Speech_OneCore\\Settings\\OnlineSpeechPrivacy", "Name": "HasAccepted", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Input\\TIPC", "Name": "Enabled", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\InputPersonalization", "Name": "RestrictImplicitInkCollection", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\InputPersonalization", "Name": "RestrictImplicitTextCollection", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\InputPersonalization\\TrainedDataStore", "Name": "HarvestContacts", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Personalization\\Settings", "Name": "AcceptedPrivacyPolicy", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\DataCollection", "Name": "AllowTelemetry", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "Start_TrackProgs", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "PublishUserActivities", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Siuf\\Rules", "Name": "NumberOfSIUFInPeriod", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "\r\n      # Disable Defender Auto Sample Submission\r\n      Set-MpPreference -SubmitSamplesConsent 2\r\n\r\n      # Disable (Connected User Experiences and Telemetry) Service\r\n      Set-Service -Name diagtrack -StartupType Disabled\r\n\r\n      # Disable (Windows Error Reporting Manager) Service\r\n      Set-Service -Name wermgr -StartupType Disabled\r\n\r\n      # Disable PowerShell 7 telemetry\r\n      [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '1', 'Machine')\r\n\r\n      Remove-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Siuf\\Rules\" -Name PeriodInNanoSeconds\r\n      ", "UndoScript": "\r\n      # Enable Defender Auto Sample Submission\r\n      Set-MpPreference -SubmitSamplesConsent 1\r\n\r\n      # Enable (Connected User Experiences and Telemetry) Service\r\n      Set-Service -Name diagtrack -StartupType Automatic\r\n\r\n      # Enable (Windows Error Reporting Manager) Service\r\n      Set-Service -Name wermgr -StartupType Automatic\r\n\r\n      # Enable PowerShell 7 telemetry\r\n      [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '', 'Machine')\r\n      "}, {"Key": "WPFTweaksDeliveryOptimization", "Name": "Otimização de Entrega (Upload P2P de Updates) - Desativar", "OriginalName": "Delivery Optimization - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Impede que o Windows use sua internet para fazer upload de atualizações para outros computadores.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DeliveryOptimization", "Name": "DODownloadMode", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksRemoveEdge", "Name": "Microsoft Edge - Remover do Sistema", "OriginalName": "Microsoft Edge - Remove", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desinstala e remove completamente o navegador Microsoft Edge do Windows.", "Registry": [], "InvokeScript": "\r\n      $Path = Resolve-Path -Path \"$Env:ProgramFiles (x86)\\Microsoft\\Edge\\Application\\*\\Installer\\setup.exe\" | Select-Object -Last 1\r\n\r\n      if (Test-Path $Path) {\r\n          New-Item -Path \"$Env:SystemRoot\\SystemApps\\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\\MicrosoftEdge.exe\" -Force\r\n          Start-Process -FilePath $Path -ArgumentList \"--uninstall --system-level --force-uninstall --delete-profile\" -Wait\r\n          Write-Host \"Microsoft Edge was removed\"\r\n      } else {\r\n          Write-Host \"Microsoft Edge is not installed\"\r\n      }\r\n      ", "UndoScript": "\r\n      Write-Host \"Installing Microsoft Edge...\"\r\n      winget install Microsoft.Edge --source winget\r\n      "}, {"Key": "WPFTweaksDisableBitLocker", "Name": "Criptografia BitLocker Automática - Desativar", "OriginalName": "BitLocker - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Impede que o Windows criptografe novas unidades automaticamente com BitLocker.", "Registry": [], "InvokeScript": "Disable-BitLocker -MountPoint $Env:SystemDrive", "UndoScript": "Enable-BitLocker -MountPoint $Env:SystemDrive"}, {"Key": "WPFTweaksUTC", "Name": "Relógio de Hardware em UTC (Essencial para Dual-Boot Linux)", "OriginalName": "Date & Time - Set Time to UTC", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Sincroniza o relógio da BIOS em UTC, resolvendo o erro de horas trocadas ao alternar entre Windows e Linux.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\TimeZoneInformation", "Name": "RealTimeIsUniversal", "Value": "1", "Type": "QWord", "OriginalValue": "0"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksRemoveOneDrive", "Name": "Microsoft OneDrive - Remover do Sistema", "OriginalName": "Microsoft OneDrive - Remove", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desinstala o OneDrive e remove as pastas de sincronização automática do Explorador de Arquivos.", "Registry": [], "InvokeScript": "\r\n      # Deny permission to remove OneDrive folder\r\n      icacls $Env:OneDrive /deny \"Administrators:(D,DC)\"\r\n\r\n      Write-Host \"Uninstalling OneDrive...\"\r\n      Start-Process -FilePath (Join-Path $Env:SystemRoot \"System32\\OneDriveSetup.exe\") -ArgumentList '/uninstall' -Wait\r\n\r\n      # Some of OneDrive files use explorer, and OneDrive uses FileCoAuth\r\n      Write-Host \"Removing leftover OneDrive Files...\"\r\n\r\n      Stop-Process -Name FileCoAuth,Explorer\r\n\r\n      Remove-Item \"$Env:LocalAppData\\Microsoft\\OneDrive\" -Recurse -Force\r\n      Remove-Item \"$Env:ProgramData\\Microsoft OneDrive\" -Recurse -Force\r\n\r\n      # Grant back permission to access OneDrive folder\r\n      icacls $Env:OneDrive /grant \"Administrators:(D,DC)\"\r\n\r\n      if (-not (Get-ChildItem -Path $Env:OneDrive)) {\r\n          Remove-Item -Path $Env:OneDrive -Recurse\r\n          [Environment]::SetEnvironmentVariable('OneDrive', $null, 'User')\r\n      }\r\n\r\n      # Disable OneSyncSvc\r\n      Set-Service -Name OneSyncSvc -StartupType Disabled\r\n      ", "UndoScript": "\r\n      Write-Host \"Installing OneDrive\"\r\n      winget install Microsoft.Onedrive --source winget\r\n\r\n      # Enabled OneSyncSvc\r\n      Set-Service -Name OneSyncSvc -StartupType Automatic\r\n      "}, {"Key": "WPFTweaksRemoveHomeAndGallery", "Name": "Página Inicial e Galeria do Explorador - Ocultar", "OriginalName": "File Explorer Home and Gallery - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Remove as guias 'Página Inicial' e 'Galeria' do Explorador e abre 'Este Computador' como padrão.", "Registry": [{"Path": "HKCU:\\Software\\Classes\\CLSID\\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}", "Name": "System.IsPinnedToNameSpaceTree", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Classes\\CLSID\\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}", "Name": "System.IsPinnedToNameSpaceTree", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "LaunchTo", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksDisplay", "Name": "Efeitos Visuais - Ajustar para Melhor Desempenho", "OriginalName": "Visual Effects - Set to Best Performance", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desativa animações e sombras pesadas do sistema para obter máxima fluidez e menor latência.", "Registry": [{"Path": "HKCU:\\Control Panel\\Desktop", "Name": "DragFullWindows", "Value": "0", "Type": "String", "OriginalValue": "1"}, {"Path": "HKCU:\\Control Panel\\Desktop", "Name": "MenuShowDelay", "Value": "200", "Type": "String", "OriginalValue": "400"}, {"Path": "HKCU:\\Control Panel\\Desktop\\WindowMetrics", "Name": "MinAnimate", "Value": "0", "Type": "String", "OriginalValue": "1"}, {"Path": "HKCU:\\Control Panel\\Keyboard", "Name": "KeyboardDelay", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "ListviewAlphaSelect", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "ListviewShadow", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "TaskbarAnimations", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects", "Name": "VisualFXSetting", "Value": "3", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\DWM", "Name": "EnableAeroPeek", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "TaskbarMn", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "ShowTaskViewButton", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search", "Name": "SearchboxTaskbarMode", "Value": "0", "Type": "DWord", "OriginalValue": "1"}], "InvokeScript": "Set-ItemProperty -Path \"HKCU:\\Control Panel\\Desktop\" -Name \"UserPreferencesMask\" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))", "UndoScript": "Remove-ItemProperty -Path \"HKCU:\\Control Panel\\Desktop\" -Name \"UserPreferencesMask\""}, {"Key": "WPFTweaksReservedStorage", "Name": "Armazenamento Reservado do Windows - Desativar", "OriginalName": "Disable Reserved Storage", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Libera de 7 a 10 GB de espaço em disco retidos pelo Windows para arquivos temporários de atualização.", "Registry": [], "InvokeScript": "DISM /Online /Set-ReservedStorageState /State:Disabled", "UndoScript": "DISM /Online /Set-ReservedStorageState /State:Enabled"}, {"Key": "WPFTweaksRestorePoint", "Name": "Ponto de Restauração do Sistema - Criar Agora", "OriginalName": "Restore Point - Create", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Cria um Ponto de Restauração antes de aplicar alterações, permitindo desfazer ajustes facilmente se desejar.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore", "Name": "SystemRestorePointCreationFrequency", "Value": "0", "Type": "DWord", "OriginalValue": "1440"}], "InvokeScript": "\r\n      if (-not (Get-ComputerRestorePoint)) {\r\n          Enable-ComputerRestore -Drive $Env:SystemDrive\r\n      }\r\n\r\n      Checkpoint-Computer -Description \"Ponto de Restauracao criado pelo Setup Andyz0x\" -RestorePointType MODIFY_SETTINGS\r\n      Write-Host \"System Restore Point Created Successfully\" -ForegroundColor Green\r\n      ", "UndoScript": ""}, {"Key": "WPFTweaksEndTaskOnTaskbar", "Name": "Finalizar Tarefa com Botão Direito na Barra - Ativar", "OriginalName": "End Task With Right Click - Enable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Habilita a opção 'Finalizar Tarefa' ao clicar com o botão direito em programas na barra de tarefas (Win 11).", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\TaskbarDeveloperSettings", "Name": "TaskbarEndTask", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksStorage", "Name": "Sensor de Armazenamento Automático - Desativar", "OriginalName": "Storage Sense - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desativa a exclusão periódica automática de arquivos temporários e lixeira pelo sistema.", "Registry": [{"Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy", "Name": "01", "Value": "0", "Type": "DWord", "OriginalValue": "1"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksWindowsAI", "Name": "Recursos de IA do Windows e Copilot - Desativar e Remover", "OriginalName": "Windows AI - Disable And Remove", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Remove o Copilot, Recall e desativa serviços de inteligência artificial de fundo do Windows 11.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer", "Name": "SettingsPageVisibility", "Value": "hide:aicomponents", "Type": "String", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\WindowsNotepad", "Name": "DisableAIFeatures", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "\r\n      $Appx = (Get-AppxPackage MicrosoftWindows.Client.CoreAI).PackageFullName\r\n      $Sid = (Get-LocalUser $Env:UserName).Sid.Value\r\n\r\n      New-Item \"HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Appx\\AppxAllUserStore\\EndOfLife\\$Sid\\$Appx\" -Force\r\n\r\n      Get-AppxPackage -AllUsers \"*Copilot*\" | Remove-AppxPackage -AllUsers\r\n      winget uninstall -e --name \"Copilot\" --silent --force --accept-source-agreements 2>$null\r\n      Get-AppxPackage -AllUsers Microsoft.MicrosoftOfficeHub | Remove-AppxPackage -AllUsers\r\n\r\n      if ($Appx) {\r\n          Remove-AppxPackage $Appx\r\n      }\r\n\r\n      Set-Service -Name WSAIFabricSvc -StartupType Disabled\r\n      Disable-WindowsOptionalFeature -FeatureName Recall -Online -NoRestart\r\n\r\n      Write-Host \"Windows AI Disabled\"\r\n      ", "UndoScript": ""}, {"Key": "WPFTweaksWPBT", "Name": "WPBT (Injeção de Softwares da Placa-Mãe) - Desativar", "OriginalName": "Windows Platform Binary Table (WPBT) - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Bloqueia a execução e instalação forçada de softwares proprietários da BIOS pelo fabricante da placa-mãe.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager", "Name": "DisableWpbtExecution", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksPreventDeviceMetadataFromNetwork", "Name": "Instalação Automática de Softwares de Periféricos - Bloquear", "OriginalName": "Prevent Device Companion Apps", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Impede o download automático de programas de suporte pesados de terceiros ao plugar novos periféricos.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Device Metadata", "Name": "PreventDeviceMetadataFromNetwork", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksRazerBlock", "Name": "Instalação Automática do Razer Synapse - Bloquear", "OriginalName": "Razer Software Auto-Install - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Impede o download automático do pesado Razer Synapse ao plugar periféricos Razer.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DriverSearching", "Name": "SearchOrderConfig", "Value": "0", "Type": "DWord", "OriginalValue": "1"}, {"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Device Installer", "Name": "DisableCoInstallers", "Value": "1", "Type": "DWord", "OriginalValue": "0"}], "InvokeScript": "\r\n      $RazerPath = \"$Env:SystemRoot\\Installer\\Razer\"\r\n\r\n      if (Test-Path $RazerPath) {\r\n        Remove-Item $RazerPath\\* -Recurse -Force\r\n      } else {\r\n        New-Item -Path $RazerPath -ItemType Directory\r\n      }\r\n\r\n      icacls $RazerPath /deny \"Everyone:(W)\"\r\n      ", "UndoScript": "\r\n      icacls \"$Env:SystemRoot\\Installer\\Razer\" /remove:d Everyone\r\n      "}, {"Key": "WPFTweaksDisableNotifications", "Name": "Notificações do Sistema e Pop-up de Calendário - Desativar", "OriginalName": "System Tray Notifications & Calendar - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desativa todas as notificações na área de trabalho e o pop-up de calendário da bandeja do sistema.", "Registry": [{"Path": "HKCU:\\Software\\Policies\\Microsoft\\Windows\\Explorer", "Name": "DisableNotificationCenter", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}, {"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications", "Name": "ToastEnabled", "Value": "0", "Type": "DWord", "OriginalValue": "1"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksBlockAdobeNet", "Name": "Conexões de Telemetria da Adobe - Bloquear", "OriginalName": "Adobe URL Block List - Enable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Bloqueia conexões de telemetria e avisos invasivos nos softwares da Adobe via arquivo hosts.", "Registry": [], "InvokeScript": "\r\n      $hostsUrl = Invoke-RestMethod -Uri https://github.com/Ruddernation-Designs/Adobe-URL-Block-List/raw/refs/heads/master/hosts\r\n      Add-Content -Path \"$Env:SystemRoot\\System32\\drivers\\etc\\hosts\" -Value $hostsUrl\r\n\r\n      ipconfig /flushdns\r\n      Write-Host 'Added Adobe url block list from host file'\r\n      ", "UndoScript": "\r\n      Set-Content \"$Env:SystemRoot\\System32\\drivers\\etc\\hosts\" (\r\n          (Get-Content \"$Env:SystemRoot\\System32\\drivers\\etc\\hosts\") -join \"`n\" -replace '(?s)#New Ver.*', ''\r\n      )\r\n\r\n      ipconfig /flushdns\r\n      Write-Host 'Removed Adobe url block list from host file'\r\n      "}, {"Key": "WPFTweaksRightClickMenu", "Name": "Menu de Contexto Clássico do Windows 10 no Windows 11 - Restaurar", "OriginalName": "Right-Click Menu Previous Layout - Enable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Restaura o menu de clique direito completo tradicional sem o atalho 'Mostrar mais opções'.", "Registry": [], "InvokeScript": "\r\n      New-Item -Path \"HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\" -Name InprocServer32 -Value \"\" -Force\r\n      Stop-Process -Name explorer\r\n      ", "UndoScript": "Remove-Item -Path \"HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\" -Recurse"}, {"Key": "WPFTweaksDiskCleanup", "Name": "Limpeza de Disco Avançada - Executar", "OriginalName": "Disk Cleanup - Run", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Executa a limpeza na unidade C:, removendo arquivos residuais de atualizações antigas do Windows.", "Registry": [], "InvokeScript": "\r\n      cleanmgr.exe /d C: /VERYLOWDISK\r\n      Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase\r\n      ", "UndoScript": ""}, {"Key": "WPFTweaksDeleteTempFiles", "Name": "Arquivos Temporários (%TEMP%) - Remover", "OriginalName": "Temporary Files - Remove", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Exclui arquivos temporários acumulados nas pastas do usuário e do sistema operacional.", "Registry": [], "InvokeScript": "\r\n      Remove-Item -Path \"$Env:Temp\\*\" -Recurse -Force\r\n      Remove-Item -Path \"$Env:SystemRoot\\Temp\\*\" -Recurse -Force\r\n      ", "UndoScript": ""}, {"Key": "WPFTweaksIPv46", "Name": "Preferência de Rede - Priorizar IPv4 sobre IPv6", "OriginalName": "IPv6 - Set IPv4 as Preferred", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Prioriza conexões IPv4, reduzindo ping em jogos online e resolvendo instabilidades em alguns roteadores.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters", "Name": "DisabledComponents", "Value": "32", "Type": "DWord", "OriginalValue": "0"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksTeredo", "Name": "Tunelamento de Rede Teredo - Desativar", "OriginalName": "Teredo - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desativa o protocolo de tunelamento Teredo para fechar potenciais brechas de segurança de rede.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters", "Name": "DisabledComponents", "Value": "1", "Type": "DWord", "OriginalValue": "0"}], "InvokeScript": "netsh interface teredo set state disabled", "UndoScript": "netsh interface teredo set state default"}, {"Key": "WPFTweaksDisableIPv6", "Name": "Protocolo IPv6 - Desativar Completamente", "OriginalName": "IPv6 - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Desativa adaptadores IPv6, mantendo apenas a rede IPv4 ativa no computador.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters", "Name": "DisabledComponents", "Value": "255", "Type": "DWord", "OriginalValue": "0"}], "InvokeScript": "Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6", "UndoScript": "Enable-NetAdapterBinding -Name * -ComponentID ms_tcpip6"}, {"Key": "WPFTweaksDisableBGapps", "Name": "Aplicativos em Segundo Plano da Loja - Desativar", "OriginalName": "Background Apps - Disable", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Impede que aplicativos da Microsoft Store continuem executando e gastando bateria/RAM em segundo plano.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\BackgroundAccessApplications", "Name": "GlobalUserDisabled", "Value": "1", "Type": "DWord", "OriginalValue": "0"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksDisableExplorerAutoDiscovery", "Name": "Detecção Automática de Tipo de Pasta no Explorador - Desativar", "OriginalName": "File Explorer Automatic Folder Discovery - Disable", "Category": "🛡️ Tweaks Essenciais Recomendados", "RawCategory": "Essential Tweaks", "Description": "Impede que o Windows Explorer adivinhe o tipo de pasta (música, fotos), acelerando a abertura de diretórios.", "Registry": [], "InvokeScript": "\r\n      # Previously detected folders\r\n      $bags = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\"\r\n\r\n      # Folder types lookup table\r\n      $bagMRU = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\BagMRU\"\r\n\r\n      # Flush Explorer view database\r\n      Remove-Item -Path $bags -Recurse -Force\r\n      Write-Host \"Removed $bags\"\r\n\r\n      Remove-Item -Path $bagMRU -Recurse -Force\r\n      Write-Host \"Removed $bagMRU\"\r\n\r\n      # Every folder\r\n      $allFolders = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\\AllFolders\\Shell\"\r\n\r\n      if (!(Test-Path $allFolders)) {\r\n        New-Item -Path $allFolders -Force\r\n        Write-Host \"Created $allFolders\"\r\n      }\r\n\r\n      # Generic view\r\n      New-ItemProperty -Path $allFolders -Name \"FolderType\" -Value \"NotSpecified\" -PropertyType String -Force\r\n      Write-Host \"Set FolderType to NotSpecified\"\r\n\r\n      Write-Host Please sign out and back in, or restart your computer to apply the changes!\r\n      ", "UndoScript": "\r\n      # Previously detected folders\r\n      $bags = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\"\r\n\r\n      # Folder types lookup table\r\n      $bagMRU = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\BagMRU\"\r\n\r\n      # Flush Explorer view database\r\n      Remove-Item -Path $bags -Recurse -Force\r\n      Write-Host \"Removed $bags\"\r\n\r\n      Remove-Item -Path $bagMRU -Recurse -Force\r\n      Write-Host \"Removed $bagMRU\"\r\n\r\n      Write-Host Please sign out and back in, or restart your computer to apply the changes!\r\n      "}, {"Key": "WPFToggleDetailedBSoD", "Name": "Tela Azul (BSoD) com Detalhes Técnicos - Ativar", "OriginalName": "BSoD Verbose Mode", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Exibe informações técnicas completas sobre a falha na tela azul em vez de um QR code genérico.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\CrashControl", "Name": "DisplayParameters", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "false"}, {"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\CrashControl", "Name": "DisableEmoticon", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "false"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleBatteryPercentage", "Name": "Porcentagem Numérica de Bateria na Bandeja - Exibir", "OriginalName": "System Tray Battery Percentage", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Exibe a porcentagem exata da bateria numericamente ao lado do ícone na barra de tarefas.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "IsBatteryPercentageEnabled", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>", "DefaultState": "false"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleDarkMode", "Name": "Tema Escuro (Dark Mode) no Sistema e Aplicativos - Ativar", "OriginalName": "Dark Theme for Windows", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Aplica o modo escuro tanto na barra de tarefas/sistema quanto nos aplicativos compatíveis.", "Registry": [{"Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize", "Name": "AppsUseLightTheme", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "false"}, {"Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize", "Name": "SystemUsesLightTheme", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "false"}], "InvokeScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      if ($sync.ThemeButton.Content -eq [char]0xF08C) {\r\n        # Theme applied\r\n      }\r\n      ", "UndoScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      if ($sync.ThemeButton.Content -eq [char]0xF08C) {\r\n        # Theme reverted\r\n      }\r\n      "}, {"Key": "WPFToggleShowExt", "Name": "Extensões de Arquivos (.exe, .txt, .pdf) - Sempre Exibir", "OriginalName": "File Explorer File Extensions", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Configura o Windows Explorer para nunca ocultar extensões conhecidas de arquivos.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "HideFileExt", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "false"}], "InvokeScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      ", "UndoScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      "}, {"Key": "WPFToggleHiddenFiles", "Name": "Pastas e Arquivos Ocultos - Sempre Exibir", "OriginalName": "File Explorer Hidden Files", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Torna pastas e arquivos ocultos do sistema visíveis no Explorador de Arquivos.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "Hidden", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "false"}], "InvokeScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      ", "UndoScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      "}, {"Key": "WPFToggleVerboseLogon", "Name": "Mensagens Detalhadas na Inicialização e Desligamento - Ativar", "OriginalName": "Logon Verbose Mode", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Exibe mensagens de progresso detalhadas ao ligar, reiniciar ou desligar o computador.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System", "Name": "VerboseStatus", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "false"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleNewOutlook", "Name": "Outlook Clássico - Manter como Padrão", "OriginalName": "Microsoft Outlook New Version", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Garante a utilização da versão clássica e completa do Microsoft Outlook.", "Registry": [{"Path": "HKCU:\\SOFTWARE\\Microsoft\\Office\\16.0\\Outlook\\Preferences", "Name": "UseNewOutlook", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}, {"Path": "HKCU:\\Software\\Microsoft\\Office\\16.0\\Outlook\\Options\\General", "Name": "HideNewOutlookToggle", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "true"}, {"Path": "HKCU:\\Software\\Policies\\Microsoft\\Office\\16.0\\Outlook\\Options\\General", "Name": "DoNewOutlookAutoMigration", "Value": "0", "Type": "DWord", "OriginalValue": "0", "DefaultState": "false"}, {"Path": "HKCU:\\Software\\Policies\\Microsoft\\Office\\16.0\\Outlook\\Preferences", "Name": "NewOutlookMigrationUserSetting", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleScrollbars", "Name": "Barras de Rolagem Sempre Visíveis - Ativar", "OriginalName": "Scrollbars Always Visible", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Evita que as barras de rolagem sumam automaticamente quando o ponteiro do mouse não está sobre elas.", "Registry": [{"Path": "HKCU:\\Control Panel\\Accessibility", "Name": "DynamicScrollbars", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "false"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFMultiplaneOverlay", "Name": "MPO (Multiplane Overlay) - Desativar (Corrige Stuttering em Jogos)", "OriginalName": "Multiplane Overlay", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Desativa o Multiplane Overlay para eliminar piscadas de tela e micro-travamentos em placas NVIDIA/AMD.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\Dwm", "Name": "OverlayTestMode", "Type": "DWord", "DefaultValue": "0", "Values": {"Enabled": "<RemoveEntry>", "Disabled (Compatibility)": "5", "Fully Disabled": "5"}}, {"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers", "Name": "DisableOverlays", "Type": "DWord", "DefaultValue": "0", "Values": {"Enabled": "<RemoveEntry>", "Disabled (Compatibility)": "<RemoveEntry>", "Fully Disabled": "1"}}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleMouseAcceleration", "Name": "Aceleração do Ponteiro do Mouse - Desativar (Precisão 1:1)", "OriginalName": "Mouse Acceleration", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Desativa 'Aprimorar precisão do ponteiro', garantindo movimento 1:1 de mouse essencial para mira em jogos.", "Registry": [{"Path": "HKCU:\\Control Panel\\Mouse", "Name": "MouseSpeed", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}, {"Path": "HKCU:\\Control Panel\\Mouse", "Name": "MouseThreshold1", "Value": "6", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}, {"Path": "HKCU:\\Control Panel\\Mouse", "Name": "MouseThreshold2", "Value": "10", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleNumLock", "Name": "Tecla Num Lock - Ativar Automaticamente na Inicialização", "OriginalName": "Num Lock on Startup", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Mantém o teclado numérico ativado assim que o Windows inicializa.", "Registry": [{"Path": "HKU:\\.Default\\Control Panel\\Keyboard", "Name": "InitialKeyboardIndicators", "Value": "2", "Type": "String", "OriginalValue": "0", "DefaultState": "false"}, {"Path": "HKCU:\\Control Panel\\Keyboard", "Name": "InitialKeyboardIndicators", "Value": "2", "Type": "String", "OriginalValue": "0", "DefaultState": "false"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleWindowSnapping", "Name": "Organização Automática de Janelas (Snap) - Alternar", "OriginalName": "Window Snapping", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Ativa ou desativa o ajuste inteligente ao arrastar janelas para as bordas da tela.", "Registry": [{"Path": "HKCU:\\Control Panel\\Desktop", "Name": "WindowArrangementActive", "Value": "1", "Type": "String", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleStandbyFix", "Name": "Conexão de Rede durante o Modo de Espera (S0) - Desativar", "OriginalName": "S0 Sleep Network Connectivity", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Evita que notebooks continuem gastando bateria e esquentando durante a suspensão na mochila.", "Registry": [{"Path": "HKCU:\\SOFTWARE\\Policies\\Microsoft\\Power\\PowerSettings\\f15576e8-98b7-4186-b944-eafa664402d9", "Name": "ACSettingIndex", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleS3Sleep", "Name": "Modo de Suspensão S3 Tradicional - Forçar", "OriginalName": "S3 Sleep", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Força a suspensão tradicional que corta totalmente a energia da maioria dos componentes.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Power", "Name": "PlatformAoAcOverride", "Value": "0", "Type": "DWord", "OriginalValue": "<RemoveEntry>", "DefaultState": "false"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleHideSettingsHome", "Name": "Página Inicial 'Home' nas Configurações - Ocultar", "OriginalName": "Settings Home Page", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Abre o aplicativo de Configurações do Windows diretamente na lista de seções sem a tela inicial de destaques.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer", "Name": "SettingsPageVisibility", "Value": "show:home", "Type": "String", "OriginalValue": "hide:home", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleBingSearch", "Name": "Resultados Web do Bing na Busca do Iniciar - Desativar", "OriginalName": "Start Menu Bing Search", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Faz a pesquisa do Menu Iniciar procurar apenas programas e arquivos locais sem consultar o Bing.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search", "Name": "BingSearchEnabled", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleLoginBlur", "Name": "Desfoque Acrílico na Tela de Login - Desativar", "OriginalName": "Logon Screen Acrylic Blur", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Mostra o papel de parede na tela de bloqueio e login com imagem limpa e nítida sem desfoque.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "DisableAcrylicBackgroundOnLogon", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFTweaksDisableLockscreen", "Name": "Tela de Bloqueio (Slide) - Pular e Ir Direto para Senha", "OriginalName": "Lock Screen - Disable", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Vai direto para o campo de digitação de senha/PIN ao ligar o PC sem precisar arrastar a imagem inicial.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Personalization", "Name": "NoLockScreen", "Value": "1", "Type": "DWord", "OriginalValue": "<RemoveEntry>"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleStartMenuRecommendations", "Name": "Recomendações e Sugestões do Menu Iniciar - Desativar", "OriginalName": "Start Menu Recommendations", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Oculta a área de 'Recomendações' no Menu Iniciar do Windows 11.", "Registry": [{"Path": "HKLM:\\SOFTWARE\\Microsoft\\PolicyManager\\current\\device\\Start", "Name": "HideRecommendedSection", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "true"}, {"Path": "HKLM:\\SOFTWARE\\Microsoft\\PolicyManager\\current\\device\\Education", "Name": "IsEducationEnvironment", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "true"}, {"Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer", "Name": "HideRecommendedSection", "Value": "0", "Type": "DWord", "OriginalValue": "1", "DefaultState": "true"}], "InvokeScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      ", "UndoScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      "}, {"Key": "WPFToggleStickyKeys", "Name": "Atalho das Teclas de Aderência (Shift 5x) - Desativar", "OriginalName": "Sticky Keys", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Impede a abertura da janela de Teclas de Aderência ao pressionar Shift rapidamente em jogos.", "Registry": [{"Path": "HKCU:\\Control Panel\\Accessibility\\StickyKeys", "Name": "Flags", "Value": "506", "Type": "DWord", "OriginalValue": "58", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleTaskbarAlignment", "Name": "Ícones da Barra de Tarefas - Alinhar à Esquerda (Estilo Win 10)", "OriginalName": "Taskbar Centered Icons", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Move os ícones e o botão Iniciar para o canto esquerdo da barra de tarefas no Windows 11.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "TaskbarAl", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      ", "UndoScript": "\r\n      Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue\r\n      "}, {"Key": "WPFToggleTaskbarSearch", "Name": "Caixa de Pesquisa na Barra de Tarefas - Ocultar", "OriginalName": "Taskbar Search Icon", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Remove a caixa de pesquisa volumosa da barra de tarefas para liberar espaço.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search", "Name": "SearchboxTaskbarMode", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleTaskView", "Name": "Botão Visão de Tarefas (Desktops Virtuais) - Ocultar", "OriginalName": "Taskbar Task View Icon", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Remove o ícone de Visão de Tarefas ao lado do botão Iniciar.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "ShowTaskViewButton", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleGameMode", "Name": "Modo de Jogo do Windows (Game Mode) - Ativar", "OriginalName": "Game Mode", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Otimiza a alocação de recursos da GPU e CPU exclusivamente para o jogo em execução.", "Registry": [{"Path": "HKCU:\\Software\\Microsoft\\GameBar", "Name": "AllowAutoGameMode", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}, {"Path": "HKCU:\\Software\\Microsoft\\GameBar", "Name": "AutoGameModeEnabled", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "true"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFToggleLongPaths", "Name": "Caminhos de Arquivos Longos (>260 Caracteres) - Permitir", "OriginalName": "Enable Long Paths", "Category": "🎨 Customizações & Interface", "RawCategory": "Customize Preferences", "Description": "Remove a restrição histórica de 260 caracteres para caminhos de arquivos e pastas no Windows.", "Registry": [{"Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem", "Name": "LongPathsEnabled", "Value": "1", "Type": "DWord", "OriginalValue": "0", "DefaultState": "false"}], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFOOSUbutton", "Name": "O&O ShutUp10++ - Executar Ferramenta Especializada", "OriginalName": "O&O ShutUp10++ - Run", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Inicia a conceituada ferramenta O&O ShutUp10++ para ajustes finos e avançados de privacidade.", "Registry": [], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFchangedns", "Name": "Configurar Servidores DNS Seguros (Cloudflare / Google)", "OriginalName": "DNS - Set to:", "Category": "⚠️ Tweaks Avançados & Desbloqueios", "RawCategory": "z__Advanced Tweaks - CAUTION", "Description": "Abre o assistente para configurar servidores DNS de alta velocidade e criptografia.", "Registry": [], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFAddUltPerf", "Name": "Plano de Energia: Desempenho Máximo (Ultimate Performance) - Ativar", "OriginalName": "Ultimate Performance Profile - Enable", "Category": "⚡ Planos de Desempenho", "RawCategory": "Performance Plans - NOT FOR LAPTOPS", "Description": "Ativa o plano de energia de altíssimo desempenho da Microsoft, eliminando micro-latências de clock de CPU.", "Registry": [], "InvokeScript": "", "UndoScript": ""}, {"Key": "WPFRemoveUltPerf", "Name": "Plano de Energia: Restaurar para Modo Equilibrado", "OriginalName": "Ultimate Performance Profile - Disable", "Category": "⚡ Planos de Desempenho", "RawCategory": "Performance Plans - NOT FOR LAPTOPS", "Description": "Restaura o plano de energia padrão do Windows.", "Registry": [], "InvokeScript": "", "UndoScript": ""}]
'@

$Global:AppCatalog = $appsRawJson | ConvertFrom-Json
$Global:TweakCatalog = $tweaksRawJson | ConvertFrom-Json

# Presets Andyz0x WinSetup
$Global:StandardPreset = @(
    "WPFTweaksActivity", "WPFTweaksConsumerFeatures", "WPFTweaksDisableExplorerAutoDiscovery",
    "WPFTweaksWPBT", "WPFTweaksLocation", "WPFTweaksServices", "WPFTweaksTelemetry",
    "WPFTweaksDeliveryOptimization", "WPFTweaksDiskCleanup", "WPFTweaksDeleteTempFiles",
    "WPFTweaksEndTaskOnTaskbar", "WPFTweaksRestorePoint"
)

$Global:MinimalPreset = @(
    "WPFTweaksConsumerFeatures", "WPFTweaksWPBT", "WPFTweaksServices", "WPFTweaksTelemetry"
)

$Global:AdvancedPreset = @(
    "WPFTweaksRestorePoint", "WPFTweaksActivity", "WPFTweaksConsumerFeatures",
    "WPFTweaksDisableExplorerAutoDiscovery", "WPFTweaksWPBT", "WPFTweaksLocation",
    "WPFTweaksServices", "WPFTweaksTelemetry", "WPFTweaksDeliveryOptimization",
    "WPFTweaksDeleteTempFiles", "WPFTweaksEndTaskOnTaskbar", "WPFTweaksDisableStoreSearch",
    "WPFTweaksRevertStartMenu", "WPFTweaksWidget", "WPFTweaksRemoveOneDrive",
    "WPFTweaksWindowsAI", "WPFTweaksRightClickMenu"
)

# -------------------------------------------------------------------------
# 4. INTERFACE GRÁFICA MODERNA (WPF / XAML)
# -------------------------------------------------------------------------
[xml]$xaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Setup Pós-Formatação Windows | Andyz0x"
    Height="830" Width="1180"
    MinHeight="720" MinWidth="980"
    WindowState="Maximized"
    WindowStartupLocation="CenterScreen"
    Background="{DynamicResource BgWindow}"
    Foreground="{DynamicResource TextPrimary}"
    FontFamily="Segoe UI, Segoe UI Variable, Arial"
    FontSize="13">

    <Window.Resources>
        <!-- Cores e Pincéis Dinâmicos do Sistema de Temas (5 Temas Suportados) -->
        <SolidColorBrush x:Key="BgWindow" Color="#0B0D13" />
        <SolidColorBrush x:Key="BgCard" Color="#161922" />
        <SolidColorBrush x:Key="BgCardHover" Color="#1E2330" />
        <SolidColorBrush x:Key="BorderCard" Color="#282E3E" />
        <SolidColorBrush x:Key="AccentColor" Color="#6366F1" />
        <SolidColorBrush x:Key="AccentHover" Color="#4F46E5" />
        <SolidColorBrush x:Key="AccentGreen" Color="#10B981" />
        <SolidColorBrush x:Key="AccentAmber" Color="#F59E0B" />
        <SolidColorBrush x:Key="TextPrimary" Color="#F8FAFC" />
        <SolidColorBrush x:Key="TextSecondary" Color="#94A3B8" />
        <SolidColorBrush x:Key="TextSelected" Color="#FFFFFF" />
        <SolidColorBrush x:Key="ChkCardBg" Color="#151823" />
        <SolidColorBrush x:Key="ChkCardBorder" Color="#232938" />
        <SolidColorBrush x:Key="ChkBoxBg" Color="#0F121A" />
        <SolidColorBrush x:Key="ChkBoxBorder" Color="#3B445B" />
        <SolidColorBrush x:Key="ChkSelectedCardBg" Color="#1E1B4B" />
        <SolidColorBrush x:Key="ChkSelectedCardBorder" Color="#818CF8" />
        <SolidColorBrush x:Key="ChkSelectedBoxBg" Color="#6366F1" />
        <SolidColorBrush x:Key="ChkSelectedBoxBorder" Color="#C7D2FE" />
        <SolidColorBrush x:Key="ChkActivePill" Color="#818CF8" />
        <SolidColorBrush x:Key="BtnSecondaryBg" Color="#1E2330" />
        <SolidColorBrush x:Key="BtnSecondaryFg" Color="#E2E8F0" />
        <SolidColorBrush x:Key="BtnSecondaryBorder" Color="#2E374D" />
        <SolidColorBrush x:Key="SearchBg" Color="#161922" />
        <SolidColorBrush x:Key="SearchText" Color="#F8FAFC" />
        <SolidColorBrush x:Key="SearchBorder" Color="#282E3E" />
        <SolidColorBrush x:Key="TerminalBg" Color="#090B0F" />
        <SolidColorBrush x:Key="TerminalText" Color="#38BDF8" />
        <SolidColorBrush x:Key="ProgressBg" Color="#1E2332" />
        <SolidColorBrush x:Key="BadgeBg" Color="#1E1B4B" />
        <SolidColorBrush x:Key="BadgeBorder" Color="#6366F1" />
        <SolidColorBrush x:Key="BadgeText" Color="#A5B4FC" />
        <SolidColorBrush x:Key="AccentTitle1" Color="#818CF8" />
        <SolidColorBrush x:Key="AccentTitle2" Color="#38BDF8" />
        <SolidColorBrush x:Key="AccentTitle3" Color="#F59E0B" />

        <!-- ControlTemplate para o ToggleButton do ComboBox (Totalmente Integrado aos Temas) -->
        <ControlTemplate x:Key="ComboBoxToggleButton" TargetType="ToggleButton">
            <Border x:Name="ToggleBorder"
                    Background="{TemplateBinding Background}"
                    BorderBrush="{TemplateBinding BorderBrush}"
                    BorderThickness="{TemplateBinding BorderThickness}"
                    CornerRadius="6">
                <Grid>
                    <Path x:Name="Arrow"
                          HorizontalAlignment="Right"
                          VerticalAlignment="Center"
                          Margin="0,0,10,0"
                          Fill="{DynamicResource TextSecondary}"
                          Data="M 0 0 L 4 4 L 8 0 Z" />
                </Grid>
            </Border>
            <ControlTemplate.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter TargetName="ToggleBorder" Property="Background" Value="{DynamicResource BgCardHover}" />
                </Trigger>
            </ControlTemplate.Triggers>
        </ControlTemplate>

        <!-- Style do ComboBoxItem -->
        <Style TargetType="ComboBoxItem">
            <Setter Property="SnapsToDevicePixels" Value="True" />
            <Setter Property="OverridesDefaultStyle" Value="True" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBoxItem">
                        <Border x:Name="ItemBorder"
                                Padding="8,6"
                                Margin="2,1"
                                CornerRadius="4"
                                Background="Transparent">
                            <ContentPresenter x:Name="ItemContent"
                                              TextBlock.Foreground="{DynamicResource TextPrimary}"
                                              TextBlock.FontSize="12" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsHighlighted" Value="True">
                                <Setter TargetName="ItemBorder" Property="Background" Value="{DynamicResource BgCardHover}" />
                            </Trigger>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="ItemBorder" Property="Background" Value="{DynamicResource AccentColor}" />
                                <Setter TargetName="ItemContent" Property="TextBlock.Foreground" Value="#FFFFFF" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Style Geral do ComboBox Customizado (Sem caixas brancas nativas do Windows) -->
        <Style TargetType="ComboBox">
            <Setter Property="SnapsToDevicePixels" Value="True" />
            <Setter Property="OverridesDefaultStyle" Value="True" />
            <Setter Property="ScrollViewer.HorizontalScrollBarVisibility" Value="Auto" />
            <Setter Property="ScrollViewer.VerticalScrollBarVisibility" Value="Auto" />
            <Setter Property="ScrollViewer.CanContentScroll" Value="True" />
            <Setter Property="Background" Value="{DynamicResource SearchBg}" />
            <Setter Property="Foreground" Value="{DynamicResource SearchText}" />
            <Setter Property="BorderBrush" Value="{DynamicResource SearchBorder}" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBox">
                        <Grid>
                            <ToggleButton Name="ToggleButton"
                                          Template="{StaticResource ComboBoxToggleButton}"
                                          Focusable="false"
                                          IsChecked="{Binding Path=IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}"
                                          ClickMode="Press"
                                          Background="{TemplateBinding Background}"
                                          BorderBrush="{TemplateBinding BorderBrush}"
                                          BorderThickness="{TemplateBinding BorderThickness}" />
                            <ContentPresenter Name="ContentSite"
                                              IsHitTestVisible="False"
                                              Content="{TemplateBinding SelectionBoxItem}"
                                              ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"
                                              ContentTemplateSelector="{TemplateBinding ItemTemplateSelector}"
                                              Margin="10,3,26,3"
                                              VerticalAlignment="Center"
                                              HorizontalAlignment="Left"
                                              TextBlock.Foreground="{DynamicResource SearchText}"
                                              TextBlock.FontSize="{TemplateBinding FontSize}" />
                            <Popup Name="Popup"
                                   Placement="Bottom"
                                   IsOpen="{TemplateBinding IsDropDownOpen}"
                                   AllowsTransparency="True"
                                   Focusable="False"
                                   PopupAnimation="Slide">
                                <Grid Name="DropDown"
                                      SnapsToDevicePixels="True"
                                      MinWidth="{TemplateBinding ActualWidth}"
                                      MaxHeight="{TemplateBinding MaxDropDownHeight}">
                                    <Border x:Name="DropDownBorder"
                                            Background="{DynamicResource SearchBg}"
                                            BorderThickness="1"
                                            BorderBrush="{DynamicResource SearchBorder}"
                                            CornerRadius="6"
                                            Margin="0,2,0,0">
                                        <ScrollViewer Margin="4,4,4,4" SnapsToDevicePixels="True">
                                            <StackPanel IsItemsHost="True" KeyboardNavigation.DirectionalNavigation="Contained" />
                                        </ScrollViewer>
                                    </Border>
                                </Grid>
                            </Popup>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Estilo CheckBox Ultramoderno e Super Evidente -->
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="{DynamicResource TextSecondary}" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="13" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="CheckBox">
                        <Border Name="ChkCard" Background="{DynamicResource ChkCardBg}" BorderBrush="{DynamicResource ChkCardBorder}" BorderThickness="1.2" CornerRadius="8" Padding="10,7" Margin="0,3,8,3">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="Auto" />
                                    <ColumnDefinition Width="*" />
                                    <ColumnDefinition Width="Auto" />
                                </Grid.ColumnDefinitions>
                                <!-- Caixa da Marcação -->
                                <Border Name="CheckMarkBox" Grid.Column="0" Width="22" Height="22" CornerRadius="6" Background="{DynamicResource ChkBoxBg}" BorderBrush="{DynamicResource ChkBoxBorder}" BorderThickness="1.5" VerticalAlignment="Center" Margin="0,0,10,0">
                                    <Path Name="CheckGlyph" Data="M 4,11 L 8.5,15.5 L 17.5,6" Stroke="White" StrokeThickness="2.5" Visibility="Collapsed" VerticalAlignment="Center" HorizontalAlignment="Center" />
                                </Border>
                                <!-- Conteúdo (Ícone, Nome, Badges) -->
                                <ContentPresenter Grid.Column="1" VerticalAlignment="Center" />
                                <!-- Barra Indicadora Lateral de Seleção Ativa -->
                                <Border Name="ActivePill" Grid.Column="2" Background="{DynamicResource ChkActivePill}" CornerRadius="3" Width="4" Height="18" Margin="8,0,2,0" VerticalAlignment="Center" Visibility="Collapsed" />
                            </Grid>
                        </Border>
                        <ControlTemplate.Triggers>
                            <!-- ESTADO SELECIONADO / ATIVO (SUPER DESTACADO) -->
                            <Trigger Property="IsChecked" Value="True">
                                <Setter TargetName="ChkCard" Property="Background" Value="{DynamicResource ChkSelectedCardBg}" />
                                <Setter TargetName="ChkCard" Property="BorderBrush" Value="{DynamicResource ChkSelectedCardBorder}" />
                                <Setter TargetName="ChkCard" Property="BorderThickness" Value="1.8" />
                                <Setter TargetName="CheckMarkBox" Property="Background" Value="{DynamicResource ChkSelectedBoxBg}" />
                                <Setter TargetName="CheckMarkBox" Property="BorderBrush" Value="{DynamicResource ChkSelectedBoxBorder}" />
                                <Setter TargetName="CheckGlyph" Property="Visibility" Value="Visible" />
                                <Setter TargetName="ActivePill" Property="Visibility" Value="Visible" />
                                <Setter Property="Foreground" Value="{DynamicResource TextSelected}" />
                                <Setter Property="FontWeight" Value="Bold" />
                            </Trigger>
                            <!-- ESTADO HOVER -->
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="ChkCard" Property="BorderBrush" Value="{DynamicResource AccentColor}" />
                                <Setter TargetName="CheckMarkBox" Property="BorderBrush" Value="{DynamicResource AccentHover}" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Principal -->
        <Style x:Key="BtnPrimary" TargetType="Button">
            <Setter Property="Background" Value="{DynamicResource AccentColor}" />
            <Setter Property="Foreground" Value="White" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="20,10" />
            <Setter Property="BorderThickness" Value="0" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="14" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Secundário / Presets -->
        <Style x:Key="BtnSecondary" TargetType="Button">
            <Setter Property="Background" Value="{DynamicResource BtnSecondaryBg}" />
            <Setter Property="Foreground" Value="{DynamicResource BtnSecondaryFg}" />
            <Setter Property="BorderBrush" Value="{DynamicResource BtnSecondaryBorder}" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="FontWeight" Value="Medium" />
            <Setter Property="Padding" Value="12,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="BrdSecondary" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" TextBlock.Foreground="{TemplateBinding Foreground}" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="BrdSecondary" Property="Background" Value="{DynamicResource BgCardHover}" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Destaque Kit Andyz0x -->
        <Style x:Key="BtnKitAndyz0x" TargetType="Button">
            <Setter Property="Background" Value="#0369A1" />
            <Setter Property="Foreground" Value="#F0F9FF" />
            <Setter Property="BorderBrush" Value="#38BDF8" />
            <Setter Property="BorderThickness" Value="1.5" />
            <Setter Property="FontWeight" Value="Bold" />
            <Setter Property="Padding" Value="14,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Destaque Gamer Pack -->
        <Style x:Key="BtnGamerPack" TargetType="Button">
            <Setter Property="Background" Value="#4C1D95" />
            <Setter Property="Foreground" Value="#F3E8FF" />
            <Setter Property="BorderBrush" Value="#7C3AED" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="FontWeight" Value="Bold" />
            <Setter Property="Padding" Value="14,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Destaque (Presets Recomendados) -->
        <Style x:Key="BtnHighlight" TargetType="Button">
            <Setter Property="Background" Value="#312E81" />
            <Setter Property="Foreground" Value="#C7D2FE" />
            <Setter Property="BorderBrush" Value="#4F46E5" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="12,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Danger (Desinstalar) -->
        <Style x:Key="BtnDanger" TargetType="Button">
            <Setter Property="Background" Value="#450A0A" />
            <Setter Property="Foreground" Value="#FECACA" />
            <Setter Property="BorderBrush" Value="#EF4444" />
            <Setter Property="BorderThickness" Value="1.5" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="14,8" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="13" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="BrdDanger" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="BrdDanger" Property="Background" Value="#7F1D1D" />
                                <Setter TargetName="BrdDanger" Property="BorderBrush" Value="#F87171" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Warning / Revert (Reverter Tweaks) -->
        <Style x:Key="BtnWarning" TargetType="Button">
            <Setter Property="Background" Value="#451A03" />
            <Setter Property="Foreground" Value="#FEF3C7" />
            <Setter Property="BorderBrush" Value="#F59E0B" />
            <Setter Property="BorderThickness" Value="1.5" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="14,8" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="13" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="BrdWarn" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="BrdWarn" Property="Background" Value="#78350F" />
                                <Setter TargetName="BrdWarn" Property="BorderBrush" Value="#FBBF24" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Discord Sugestões -->
        <Style x:Key="BtnDiscord" TargetType="Button">
            <Setter Property="Background" Value="#5865F2" />
            <Setter Property="Foreground" Value="#FFFFFF" />
            <Setter Property="BorderBrush" Value="#4752C4" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="12,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="BrdDiscord" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="BrdDiscord" Property="Background" Value="#4752C4" />
                                <Setter TargetName="BrdDiscord" Property="BorderBrush" Value="#3C45A5" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Popular Filter -->
        <Style x:Key="BtnPopularFilter" TargetType="Button">
            <Setter Property="Background" Value="#451A03" />
            <Setter Property="Foreground" Value="#FDE68A" />
            <Setter Property="BorderBrush" Value="#D97706" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="12,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Botão Open Source Filter -->
        <Style x:Key="BtnFossFilter" TargetType="Button">
            <Setter Property="Background" Value="#064E3B" />
            <Setter Property="Foreground" Value="#A7F3D0" />
            <Setter Property="BorderBrush" Value="#059669" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="12,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Estilo de Abas -->
        <Style TargetType="TabItem">
            <Setter Property="Foreground" Value="{DynamicResource TextSecondary}" />
            <Setter Property="FontSize" Value="14" />
            <Setter Property="FontWeight" Value="SemiBold" />
            <Setter Property="Padding" Value="20,10" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border Name="TabBorder" Background="Transparent" BorderThickness="0,0,0,2" BorderBrush="Transparent" Padding="{TemplateBinding Padding}">
                            <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="TabBorder" Property="BorderBrush" Value="{DynamicResource AccentColor}" />
                                <Setter Property="Foreground" Value="{DynamicResource TextPrimary}" />
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Foreground" Value="{DynamicResource TextPrimary}" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="20">
        <Grid.RowDefinitions>
            <!-- Cabeçalho -->
            <RowDefinition Height="Auto" />
            <!-- Abas Principais -->
            <RowDefinition Height="*" />
            <!-- Rodapé e Barra de Ações -->
            <RowDefinition Height="Auto" />
        </Grid.RowDefinitions>

        <!-- CABEÇALHO COM SELETOR DE TEMAS & BADGE ANDYZ0X -->
        <Grid Grid.Row="0" Margin="0,0,0,16">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="Auto" />
            </Grid.ColumnDefinitions>

            <StackPanel Grid.Column="0">
                <TextBlock Text="🚀 Setup Pós-Formatação Windows" FontSize="22" FontWeight="Bold" Foreground="{DynamicResource TextPrimary}" />
                <TextBlock Text="236 Aplicativos com Ícones Oficiais • Pack PC Gamer • Otimizações &amp; Tweaks do Sistema" FontSize="13" Foreground="{DynamicResource TextSecondary}" Margin="0,4,0,0" />
            </StackPanel>

            <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                <!-- Seletor de Temas (5 Temas: Escuro, Claro, Cyberpunk, Nord, Esmeralda) -->
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,12,0">
                    <TextBlock Text="🎨 Tema:" FontSize="12" FontWeight="SemiBold" Foreground="{DynamicResource TextSecondary}" VerticalAlignment="Center" Margin="0,0,6,0" />
                    <ComboBox Name="CmbThemeSelector" Width="145" Height="30" FontSize="12" VerticalContentAlignment="Center" ToolTip="Selecione o tema visual da interface">
                        <ComboBoxItem Content="🌙 Escuro" IsSelected="True" />
                        <ComboBoxItem Content="☀️ Claro" />
                        <ComboBoxItem Content="🌌 Cyberpunk" />
                        <ComboBoxItem Content="❄️ Nord Ártico" />
                        <ComboBoxItem Content="🌲 Esmeralda" />
                    </ComboBox>
                </StackPanel>

                <!-- Botão Enviar Sugestões / Discord -->
                <Button Name="BtnDiscordFeedback" Content="💬 Sugestões (Discord)" Style="{StaticResource BtnDiscord}" Margin="0,0,10,0" ToolTip="Participe do nosso servidor no Discord e envie sugestões: discord.gg/ubnk" />

                <!-- Badge Andyz0x Modo Administrador -->
                <Border Background="{DynamicResource BadgeBg}" BorderBrush="{DynamicResource BadgeBorder}" BorderThickness="1" CornerRadius="8" Padding="12,6" VerticalAlignment="Center">
                    <TextBlock Text="⚡ Andyz0x | Modo Administrador" FontSize="12" FontWeight="Bold" Foreground="{DynamicResource BadgeText}" />
                </Border>
            </StackPanel>
        </Grid>

        <!-- CORPO PRINCIPAL (ABAS) -->
        <TabControl Grid.Row="1" Background="Transparent" BorderThickness="0" Name="MainTabControl">
            
            <!-- ABA 1: APLICATIVOS -->
            <TabItem Name="TabItemApps" Header="📦 Aplicativos (236 Softwares)">
                <Grid Margin="0,16,0,0">
                    <Grid.RowDefinitions>
                        <!-- Barra de Busca e Filtros -->
                        <RowDefinition Height="Auto" />
                        <!-- Presets de Apps -->
                        <RowDefinition Height="Auto" />
                        <!-- Lista de Aplicativos com Scroll -->
                        <RowDefinition Height="*" />
                    </Grid.RowDefinitions>

                    <!-- Barra de Busca Rápida e Categoria -->
                    <Grid Grid.Row="0" Margin="0,0,0,12">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="340" />
                            <ColumnDefinition Width="260" />
                            <ColumnDefinition Width="*" />
                        </Grid.ColumnDefinitions>

                        <!-- Input de Pesquisa -->
                        <Border Grid.Column="0" Background="{DynamicResource SearchBg}" BorderBrush="{DynamicResource SearchBorder}" BorderThickness="1" CornerRadius="6" Padding="8,4" Margin="0,0,12,0">
                            <Grid>
                                <TextBox Name="TxtAppSearch" Background="Transparent" Foreground="{DynamicResource SearchText}" BorderThickness="0" FontSize="13" VerticalContentAlignment="Center" />
                                <TextBlock Name="TxtSearchPlaceholder" Text="🔍 Pesquisar aplicativo por nome ou ID..." Foreground="{DynamicResource TextSecondary}" IsHitTestVisible="False" VerticalAlignment="Center" Margin="2,0,0,0" />
                            </Grid>
                        </Border>

                        <!-- ComboBox de Filtro de Categoria -->
                        <ComboBox Name="CmbCategoryFilter" Grid.Column="1" Height="34" FontSize="13" VerticalContentAlignment="Center" Margin="0,0,12,0" ToolTip="Filtrar aplicativos por categoria" />

                        <!-- Resumo Contador -->
                        <TextBlock Name="TxtAppSummary" Grid.Column="2" VerticalAlignment="Center" Foreground="{DynamicResource TextSecondary}" FontSize="12" Text="Exibindo 236 de 236 aplicativos | 0 selecionados" />
                    </Grid>

                    <!-- Presets Rápidos de Apps -->
                    <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="0,0,0,14">
                        <TextBlock Text="Presets Rápidos:" VerticalAlignment="Center" Margin="0,0,10,0" Foreground="{DynamicResource TextSecondary}" FontSize="12" />
                        <Button Name="BtnPresetKitAndyz0x" Content="👑 Kit Andyz0x (Completo)" Style="{StaticResource BtnKitAndyz0x}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetPackGamer" Content="🎮 Pack PC Gamer (Essenciais)" Style="{StaticResource BtnGamerPack}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetEssenciais" Content="⭐ Essenciais" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetDev" Content="💻 Desenvolvedor" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetGamer" Content="🕹️ Apenas Jogos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnTogglePopularOnly" Content="⭐ Mais Populares" Style="{StaticResource BtnPopularFilter}" Margin="0,0,8,0" />
                        <Button Name="BtnToggleFossOnly" Content="🍃 Apenas Open Source" Style="{StaticResource BtnFossFilter}" Margin="0,0,8,0" />
                        <Button Name="BtnToggleSelectedOnly" Content="🎯 Apenas Selecionados" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnSelectAllVisibleApps" Content="Marcar Visíveis" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnDeselectAllApps" Content="Desmarcar Todos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnUninstallAppsTab" Content="🗑️ Desinstalar Selecionados" Style="{StaticResource BtnDanger}" />
                    </StackPanel>

                    <!-- Conteúdo com Scroll -->
                    <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
                        <StackPanel Name="AppsContainer" Margin="0,0,10,0">
                            <!-- Injetado dinamicamente no PowerShell com Ícones e Badges FOSS -->
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </TabItem>

            <!-- ABA 2: AJUSTES & OTIMIZAÇÕES (TWEAKS TRADUZIDOS) -->
            <TabItem Name="TabItemTweaks" Header="⚙️ Ajustes do Windows (66 Tweaks)">
                <Grid Margin="0,16,0,0">
                    <Grid.RowDefinitions>
                        <!-- Presets Andyz0x -->
                        <RowDefinition Height="Auto" />
                        <!-- Lista de Tweaks -->
                        <RowDefinition Height="*" />
                    </Grid.RowDefinitions>

                    <!-- Presets de Tweaks -->
                    <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="0,0,0,14">
                        <TextBlock Text="Presets de Ajustes:" VerticalAlignment="Center" Margin="0,0,10,0" Foreground="{DynamicResource TextSecondary}" FontSize="12" />
                        <Button Name="BtnPresetStandard" Content="⭐ Recomendado (Padrão)" Style="{StaticResource BtnHighlight}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetMinimal" Content="⚡ Mínimo" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetAdvanced" Content="🚀 Avançado (Debloat Completo)" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnSelectAllTweaks" Content="Marcar Todos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnDeselectAllTweaks" Content="Desmarcar Todos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnRevertTweaksTab" Content="↩️ Reverter Selecionados" Style="{StaticResource BtnWarning}" />
                    </StackPanel>

                    <!-- Scroll dos Tweaks em Cartões Traduzidos -->
                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                        <StackPanel Name="TweaksContainer" Margin="0,0,10,0">
                            <!-- Injetado dinamicamente em 4 categorias oficiais -->
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </TabItem>

            <!-- ABA 3: RECURSOS & CORREÇÕES (FEATURES & FIXES) -->
            <TabItem Name="TabItemFeatures" Header="🛠️ Recursos &amp; Correções">
                <ScrollViewer Margin="0,16,0,0" VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="0,0,10,0">

                        <!-- Card de Recursos Opcionais (DISM) -->
                        <Border Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,14">
                            <StackPanel>
                                <TextBlock Text="📦 Recursos Nativos do Windows (DISM)" FontSize="15" FontWeight="Bold" Foreground="{DynamicResource AccentTitle1}" Margin="0,0,0,4" />
                                <TextBlock Text="Ativação de componentes avançados da Microsoft diretamente no sistema operacional:" FontSize="12" Foreground="{DynamicResource TextSecondary}" Margin="0,0,0,10" />

                                <WrapPanel Margin="0,0,0,10">
                                    <CheckBox Name="ChkFeatWsl" Content="WSL (Windows Subsystem for Linux)" Width="340" ToolTip="Permite rodar distribuições completas do Linux nativamente no Windows" />
                                    <CheckBox Name="ChkFeatHyperV" Content="Hyper-V (Virtualização da Microsoft)" Width="340" ToolTip="Plataforma nativa de máquinas virtuais para Windows Pro/Enterprise" />
                                    <CheckBox Name="ChkFeatSandbox" Content="Windows Sandbox (Área Restrita Segura)" Width="340" ToolTip="Ambiente isolado temporário e descartável para testar programas suspeitos" />
                                    <CheckBox Name="ChkFeatDotNet" Content=".NET Framework 3.5 (Inclui 2.0 e 3.0)" Width="340" ToolTip="Necessário para executar aplicativos e jogos clássicos do Windows" />
                                    <CheckBox Name="ChkFeatDirectPlay" Content="DirectPlay (Componentes de Jogos Clássicos)" Width="340" ToolTip="Necessário para inicialização de jogos de gerações anteriores" />
                                </WrapPanel>
                            </StackPanel>
                        </Border>

                        <!-- Card de Ferramentas de Correção & Reparação -->
                        <Border Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,14">
                            <StackPanel>
                                <TextBlock Text="🔧 Ferramentas de Manutenção e Reparação" FontSize="15" FontWeight="Bold" Foreground="{DynamicResource AccentTitle2}" Margin="0,0,0,4" />
                                <TextBlock Text="Execução de rotinas recomendadas para resolver instabilidades no sistema:" FontSize="12" Foreground="{DynamicResource TextSecondary}" Margin="0,0,0,10" />

                                <WrapPanel>
                                    <Button Name="BtnActionSfcDism" Content="🔍 Verificação SFC &amp; DISM (Corrigir Erros de Sistema)" Style="{StaticResource BtnSecondary}" Margin="0,0,10,10" />
                                    <Button Name="BtnActionResetNetwork" Content="🌐 Redefinir Rede &amp; Limpar DNS" Style="{StaticResource BtnSecondary}" Margin="0,0,10,10" />
                                    <Button Name="BtnActionResetWindowsUpdate" Content="🔄 Redefinir Componentes do Windows Update" Style="{StaticResource BtnSecondary}" Margin="0,0,10,10" />
                                    <Button Name="BtnActionCleanDisk" Content="⚡ Limpeza de Disco Avançada (Cleanmgr)" Style="{StaticResource BtnSecondary}" Margin="0,0,10,10" />
                                </WrapPanel>
                            </StackPanel>
                        </Border>

                        <!-- Card de Acesso Rápido a Painéis Clássicos -->
                        <Border Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,14">
                            <StackPanel>
                                <TextBlock Text="⚙️ Acesso Rápido a Painéis Clássicos do Windows" FontSize="15" FontWeight="Bold" Foreground="{DynamicResource AccentTitle3}" Margin="0,0,0,4" />
                                <TextBlock Text="Abra rapidamente as ferramentas de administração tradicionais:" FontSize="12" Foreground="{DynamicResource TextSecondary}" Margin="0,0,0,10" />

                                <WrapPanel>
                                    <Button Name="BtnLaunchControl" Content="Painel de Controle" Style="{StaticResource BtnSecondary}" Margin="0,0,8,8" />
                                    <Button Name="BtnLaunchNcpa" Content="Conexões de Rede (ncpa.cpl)" Style="{StaticResource BtnSecondary}" Margin="0,0,8,8" />
                                    <Button Name="BtnLaunchSysdm" Content="Propriedades do Sistema (sysdm.cpl)" Style="{StaticResource BtnSecondary}" Margin="0,0,8,8" />
                                    <Button Name="BtnLaunchCompmgmt" Content="Gerenciamento do Computador" Style="{StaticResource BtnSecondary}" Margin="0,0,8,8" />
                                    <Button Name="BtnLaunchAppwiz" Content="Programas e Recursos (appwiz.cpl)" Style="{StaticResource BtnSecondary}" Margin="0,0,8,8" />
                                    <Button Name="BtnLaunchSound" Content="Configurações de Som (mmsys.cpl)" Style="{StaticResource BtnSecondary}" Margin="0,0,8,8" />
                                    <Button Name="BtnLaunchFirewall" Content="Firewall do Windows" Style="{StaticResource BtnSecondary}" Margin="0,0,8,8" />
                                </WrapPanel>
                            </StackPanel>
                        </Border>

                    </StackPanel>
                </ScrollViewer>
            </TabItem>

            <!-- ABA 4: CONSOLE / LOGS -->
            <TabItem Header="📋 Console de Instalação">
                <Grid Margin="0,16,0,0">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto" />
                        <RowDefinition Height="*" />
                    </Grid.RowDefinitions>

                    <Grid Grid.Row="0" Margin="0,0,0,8">
                        <TextBlock Text="Terminal em tempo real da execução:" FontSize="13" Foreground="{DynamicResource TextSecondary}" VerticalAlignment="Center" />
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                            <Button Name="BtnDiscordConsole" Content="💬 Sugestões (Discord)" Style="{StaticResource BtnDiscord}" Margin="0,0,8,0" ToolTip="Envie dúvidas e sugestões no Discord: discord.gg/ubnk" />
                            <Button Name="BtnClearLogs" Content="Limpar Logs" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                            <Button Name="BtnCopyLogs" Content="Copiar Logs" Style="{StaticResource BtnSecondary}" />
                        </StackPanel>
                    </Grid>

                    <Border Grid.Row="1" Background="{DynamicResource TerminalBg}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="12">
                        <TextBox Name="TxtLogs" Background="Transparent" Foreground="{DynamicResource TerminalText}" FontFamily="Consolas, Cascadia Code, Courier New" FontSize="13" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" BorderThickness="0" Text="Aguardando início do processo... Selecione os itens desejados e clique em 'Executar Selecionados'.&#x0a;" />
                    </Border>
                </Grid>
            </TabItem>

        </TabControl>

        <!-- RODAPÉ (BARRA DE PROGRESSO + RESUMO + BOTÃO DE EXECUÇÃO) -->
        <Border Grid.Row="2" Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="10" Padding="16" Margin="0,14,0,0">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*" />
                    <ColumnDefinition Width="Auto" />
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0" VerticalAlignment="Center" Margin="0,0,20,0">
                    <TextBlock Name="TxtSelectionSummary" Text="0 aplicativos e 0 tweaks selecionados." Foreground="{DynamicResource TextSecondary}" FontSize="13" Margin="0,0,0,6" />
                    <ProgressBar Name="ProgressBar" Height="10" Background="{DynamicResource ProgressBg}" Foreground="{DynamicResource AccentColor}" BorderThickness="0" Value="0" Maximum="100" />
                </StackPanel>

                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                    <Button Name="BtnUninstallApps" Content="🗑️ Desinstalar Apps" Style="{StaticResource BtnDanger}" Margin="0,0,10,0" ToolTip="Desinstala os aplicativos selecionados via WinGet" />
                    <Button Name="BtnRevertTweaks" Content="↩️ Reverter Tweaks" Style="{StaticResource BtnWarning}" Margin="0,0,10,0" ToolTip="Restaura os ajustes selecionados para os padrões originais do Windows" />
                    <Button Name="BtnRun" Content="🚀 Instalar / Aplicar" Style="{StaticResource BtnPrimary}" ToolTip="Instala os aplicativos e aplica os tweaks selecionados" />
                </StackPanel>
            </Grid>
        </Border>
    </Grid>
</Window>
'@

# -------------------------------------------------------------------------
# 5. INICIALIZAÇÃO DA JANELA WPF
# -------------------------------------------------------------------------
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Global:Window = [System.Windows.Markup.XamlReader]::Load($reader)

# Controles Principais
$MainTabControl = $Global:Window.FindName("MainTabControl")
$TabItemApps = $Global:Window.FindName("TabItemApps")
$TabItemTweaks = $Global:Window.FindName("TabItemTweaks")
$TabItemFeatures = $Global:Window.FindName("TabItemFeatures")
$AppsContainer = $Global:Window.FindName("AppsContainer")
$TweaksContainer = $Global:Window.FindName("TweaksContainer")
$TxtAppSearch = $Global:Window.FindName("TxtAppSearch")
$TxtSearchPlaceholder = $Global:Window.FindName("TxtSearchPlaceholder")
$CmbCategoryFilter = $Global:Window.FindName("CmbCategoryFilter")
$TxtAppSummary = $Global:Window.FindName("TxtAppSummary")
$TxtSelectionSummary = $Global:Window.FindName("TxtSelectionSummary")
$TxtLogs = $Global:Window.FindName("TxtLogs")
$ProgressBar = $Global:Window.FindName("ProgressBar")
$BtnRun = $Global:Window.FindName("BtnRun")
$BtnClearLogs = $Global:Window.FindName("BtnClearLogs")
$BtnCopyLogs = $Global:Window.FindName("BtnCopyLogs")
$CmbThemeSelector = $Global:Window.FindName("CmbThemeSelector")

# Botão de Sugestões / Discord
$BtnDiscordFeedback = $Global:Window.FindName("BtnDiscordFeedback")
$BtnDiscordConsole = $Global:Window.FindName("BtnDiscordConsole")

if ($BtnDiscordFeedback) {
    $BtnDiscordFeedback.Add_Click({
        Start-Process "https://discord.gg/ubnk"
    })
}
if ($BtnDiscordConsole) {
    $BtnDiscordConsole.Add_Click({
        Start-Process "https://discord.gg/ubnk"
    })
}

# Botões de Ação Global e Abas
$BtnUninstallApps = $Global:Window.FindName("BtnUninstallApps")
$BtnRevertTweaks = $Global:Window.FindName("BtnRevertTweaks")
$BtnUninstallAppsTab = $Global:Window.FindName("BtnUninstallAppsTab")
$BtnRevertTweaksTab = $Global:Window.FindName("BtnRevertTweaksTab")
$BtnSelectAllTweaks = $Global:Window.FindName("BtnSelectAllTweaks")

# Presets de Apps
$BtnPresetKitAndyz0x = $Global:Window.FindName("BtnPresetKitAndyz0x")
$BtnPresetPackGamer = $Global:Window.FindName("BtnPresetPackGamer")
$BtnPresetEssenciais = $Global:Window.FindName("BtnPresetEssenciais")
$BtnPresetDev = $Global:Window.FindName("BtnPresetDev")
$BtnPresetGamer = $Global:Window.FindName("BtnPresetGamer")
$BtnTogglePopularOnly = $Global:Window.FindName("BtnTogglePopularOnly")
$BtnToggleFossOnly = $Global:Window.FindName("BtnToggleFossOnly")
$BtnToggleSelectedOnly = $Global:Window.FindName("BtnToggleSelectedOnly")
$BtnSelectAllVisibleApps = $Global:Window.FindName("BtnSelectAllVisibleApps")
$BtnDeselectAllApps = $Global:Window.FindName("BtnDeselectAllApps")

# Presets de Tweaks
$BtnPresetStandard = $Global:Window.FindName("BtnPresetStandard")
$BtnPresetMinimal = $Global:Window.FindName("BtnPresetMinimal")
$BtnPresetAdvanced = $Global:Window.FindName("BtnPresetAdvanced")
$BtnDeselectAllTweaks = $Global:Window.FindName("BtnDeselectAllTweaks")

# Recursos Opcionais (DISM)
$ChkFeatWsl = $Global:Window.FindName("ChkFeatWsl")
$ChkFeatHyperV = $Global:Window.FindName("ChkFeatHyperV")
$ChkFeatSandbox = $Global:Window.FindName("ChkFeatSandbox")
$ChkFeatDotNet = $Global:Window.FindName("ChkFeatDotNet")
$ChkFeatDirectPlay = $Global:Window.FindName("ChkFeatDirectPlay")

# Ferramentas de Manutenção
$BtnActionSfcDism = $Global:Window.FindName("BtnActionSfcDism")
$BtnActionResetNetwork = $Global:Window.FindName("BtnActionResetNetwork")
$BtnActionResetWindowsUpdate = $Global:Window.FindName("BtnActionResetWindowsUpdate")
$BtnActionCleanDisk = $Global:Window.FindName("BtnActionCleanDisk")

# Atalhos de Painéis
$BtnLaunchControl = $Global:Window.FindName("BtnLaunchControl")
$BtnLaunchNcpa = $Global:Window.FindName("BtnLaunchNcpa")
$BtnLaunchSysdm = $Global:Window.FindName("BtnLaunchSysdm")
$BtnLaunchCompmgmt = $Global:Window.FindName("BtnLaunchCompmgmt")
$BtnLaunchAppwiz = $Global:Window.FindName("BtnLaunchAppwiz")
$BtnLaunchSound = $Global:Window.FindName("BtnLaunchSound")
$BtnLaunchFirewall = $Global:Window.FindName("BtnLaunchFirewall")

# Dicionários de Referência
$Global:AppCheckBoxes = @{}
$Global:TweakCheckBoxes = @{}
$Global:AppCategoryCards = [System.Collections.Generic.List[PSCustomObject]]::new()
$Global:IsSyncingSelection = $false
$Global:FossOnlyActive = $false
$Global:SelectedOnlyActive = $false
$Global:PopularOnlyActive = $false

# Lista padrão de mais populares pós-formatação (fallback instantâneo)
$Global:DefaultPopularKeys = @(
    "WPFInstallchrome", "WPFInstallbrave", "WPFInstall7zip", "WPFInstallnanazip", "WPFInstallwinrar",
    "WPFInstalldiscord", "WPFInstallwhatsapp", "WPFInstallspotify", "WPFInstallvlc",
    "WPFInstallsteam", "WPFInstallepicgames", "WPFInstallHydraLauncher", "WPFInstallNvidiaApp",
    "WPFInstallExitLag", "WPFInstallmsiafterburner", "WPFInstallnotepadplus", "WPFInstallanydesk",
    "WPFInstallpdf24creator", "WPFInstallvc2015_64", "WPFInstallvc2015_32",
    "WPFInstallKaspersky", "WPFInstallMalwarebytes", "WPFInstallAdwCleaner", "WPFInstallBitdefender"
)
$Global:PopularKeys = $Global:DefaultPopularKeys

# Tenta carregar lista de popularidade remota via nuvem unbk.com.br (timeout de 1s para fluidez instantânea)
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $remotePop = Invoke-RestMethod -Uri "https://unbk.com.br/api/popular.json" -TimeoutSec 1 -ErrorAction SilentlyContinue
    if ($remotePop) {
        $validKeys = @($remotePop | Where-Object { $_ -is [string] -and $_ -like "WPFInstall*" })
        if ($validKeys.Count -ge 5) {
            $Global:PopularKeys = $validKeys
        }
    }
} catch {}

# -------------------------------------------------------------------------
# 5.1 SISTEMA DE TEMAS VISUAIS DINÂMICOS (5 TEMAS)
# -------------------------------------------------------------------------
$Global:ThemeDefinitions = @{
    "Escuro" = @{
        "BgWindow" = "#0B0D13"
        "BgCard" = "#161922"
        "BgCardHover" = "#1E2330"
        "BorderCard" = "#282E3E"
        "AccentColor" = "#6366F1"
        "AccentHover" = "#4F46E5"
        "AccentGreen" = "#10B981"
        "AccentAmber" = "#F59E0B"
        "TextPrimary" = "#F8FAFC"
        "TextSecondary" = "#94A3B8"
        "TextSelected" = "#FFFFFF"
        "ChkCardBg" = "#151823"
        "ChkCardBorder" = "#232938"
        "ChkBoxBg" = "#0F121A"
        "ChkBoxBorder" = "#3B445B"
        "ChkSelectedCardBg" = "#1E1B4B"
        "ChkSelectedCardBorder" = "#818CF8"
        "ChkSelectedBoxBg" = "#6366F1"
        "ChkSelectedBoxBorder" = "#C7D2FE"
        "ChkActivePill" = "#818CF8"
        "BtnSecondaryBg" = "#1E2330"
        "BtnSecondaryFg" = "#E2E8F0"
        "BtnSecondaryBorder" = "#2E374D"
        "SearchBg" = "#161922"
        "SearchText" = "#F8FAFC"
        "SearchBorder" = "#282E3E"
        "TerminalBg" = "#090B0F"
        "TerminalText" = "#38BDF8"
        "ProgressBg" = "#1E2332"
        "BadgeBg" = "#1E1B4B"
        "BadgeBorder" = "#6366F1"
        "BadgeText" = "#A5B4FC"
        "AccentTitle1" = "#818CF8"
        "AccentTitle2" = "#38BDF8"
        "AccentTitle3" = "#F59E0B"
    }
    "Claro" = @{
        "BgWindow" = "#F1F5F9"
        "BgCard" = "#FFFFFF"
        "BgCardHover" = "#F8FAFC"
        "BorderCard" = "#CBD5E1"
        "AccentColor" = "#4F46E5"
        "AccentHover" = "#4338CA"
        "AccentGreen" = "#059669"
        "AccentAmber" = "#D97706"
        "TextPrimary" = "#0F172A"
        "TextSecondary" = "#475569"
        "TextSelected" = "#0F172A"
        "ChkCardBg" = "#FFFFFF"
        "ChkCardBorder" = "#CBD5E1"
        "ChkBoxBg" = "#F8FAFC"
        "ChkBoxBorder" = "#94A3B8"
        "ChkSelectedCardBg" = "#EEF2FF"
        "ChkSelectedCardBorder" = "#6366F1"
        "ChkSelectedBoxBg" = "#4F46E5"
        "ChkSelectedBoxBorder" = "#312E81"
        "ChkActivePill" = "#4F46E5"
        "BtnSecondaryBg" = "#E2E8F0"
        "BtnSecondaryFg" = "#1E293B"
        "BtnSecondaryBorder" = "#CBD5E1"
        "SearchBg" = "#FFFFFF"
        "SearchText" = "#0F172A"
        "SearchBorder" = "#CBD5E1"
        "TerminalBg" = "#0F172A"
        "TerminalText" = "#38BDF8"
        "ProgressBg" = "#E2E8F0"
        "BadgeBg" = "#EEF2FF"
        "BadgeBorder" = "#6366F1"
        "BadgeText" = "#4338CA"
        "AccentTitle1" = "#4F46E5"
        "AccentTitle2" = "#0284C7"
        "AccentTitle3" = "#D97706"
    }
    "Cyberpunk" = @{
        "BgWindow" = "#0B0813"
        "BgCard" = "#171026"
        "BgCardHover" = "#24183D"
        "BorderCard" = "#4A154B"
        "AccentColor" = "#D946EF"
        "AccentHover" = "#C026D3"
        "AccentGreen" = "#06B6D4"
        "AccentAmber" = "#F59E0B"
        "TextPrimary" = "#FDF4FF"
        "TextSecondary" = "#C084FC"
        "TextSelected" = "#FFFFFF"
        "ChkCardBg" = "#150F24"
        "ChkCardBorder" = "#3B1D54"
        "ChkBoxBg" = "#110B1E"
        "ChkBoxBorder" = "#701A75"
        "ChkSelectedCardBg" = "#380E42"
        "ChkSelectedCardBorder" = "#D946EF"
        "ChkSelectedBoxBg" = "#C026D3"
        "ChkSelectedBoxBorder" = "#F5D0FE"
        "ChkActivePill" = "#D946EF"
        "BtnSecondaryBg" = "#221838"
        "BtnSecondaryFg" = "#F5D0FE"
        "BtnSecondaryBorder" = "#4A154B"
        "SearchBg" = "#171026"
        "SearchText" = "#FDF4FF"
        "SearchBorder" = "#4A154B"
        "TerminalBg" = "#07040D"
        "TerminalText" = "#F472B6"
        "ProgressBg" = "#250E33"
        "BadgeBg" = "#4A044E"
        "BadgeBorder" = "#D946EF"
        "BadgeText" = "#F5D0FE"
        "AccentTitle1" = "#D946EF"
        "AccentTitle2" = "#38BDF8"
        "AccentTitle3" = "#F472B6"
    }
    "Nord" = @{
        "BgWindow" = "#0F1724"
        "BgCard" = "#182234"
        "BgCardHover" = "#202D45"
        "BorderCard" = "#2D3E5B"
        "AccentColor" = "#38BDF8"
        "AccentHover" = "#0284C7"
        "AccentGreen" = "#34D399"
        "AccentAmber" = "#FBBF24"
        "TextPrimary" = "#F0F9FF"
        "TextSecondary" = "#94A3B8"
        "TextSelected" = "#FFFFFF"
        "ChkCardBg" = "#162030"
        "ChkCardBorder" = "#26364F"
        "ChkBoxBg" = "#101724"
        "ChkBoxBorder" = "#3B5278"
        "ChkSelectedCardBg" = "#133654"
        "ChkSelectedCardBorder" = "#38BDF8"
        "ChkSelectedBoxBg" = "#0284C7"
        "ChkSelectedBoxBorder" = "#BAE6FD"
        "ChkActivePill" = "#38BDF8"
        "BtnSecondaryBg" = "#202D45"
        "BtnSecondaryFg" = "#E2E8F0"
        "BtnSecondaryBorder" = "#2D3E5B"
        "SearchBg" = "#182234"
        "SearchText" = "#F0F9FF"
        "SearchBorder" = "#2D3E5B"
        "TerminalBg" = "#0A0F1A"
        "TerminalText" = "#7DD3FC"
        "ProgressBg" = "#1A2638"
        "BadgeBg" = "#0C2D48"
        "BadgeBorder" = "#38BDF8"
        "BadgeText" = "#BAE6FD"
        "AccentTitle1" = "#38BDF8"
        "AccentTitle2" = "#818CF8"
        "AccentTitle3" = "#34D399"
    }
    "Esmeralda" = @{
        "BgWindow" = "#06120C"
        "BgCard" = "#0E2118"
        "BgCardHover" = "#152F22"
        "BorderCard" = "#1B4332"
        "AccentColor" = "#10B981"
        "AccentHover" = "#047857"
        "AccentGreen" = "#10B981"
        "AccentAmber" = "#F59E0B"
        "TextPrimary" = "#ECFDF5"
        "TextSecondary" = "#6EE7B7"
        "TextSelected" = "#FFFFFF"
        "ChkCardBg" = "#0C1D15"
        "ChkCardBorder" = "#183B2B"
        "ChkBoxBg" = "#08140E"
        "ChkBoxBorder" = "#2D6A4F"
        "ChkSelectedCardBg" = "#0D3823"
        "ChkSelectedCardBorder" = "#10B981"
        "ChkSelectedBoxBg" = "#059669"
        "ChkSelectedBoxBorder" = "#A7F3D0"
        "ChkActivePill" = "#10B981"
        "BtnSecondaryBg" = "#152F22"
        "BtnSecondaryFg" = "#D1FAE5"
        "BtnSecondaryBorder" = "#1B4332"
        "SearchBg" = "#0E2118"
        "SearchText" = "#ECFDF5"
        "SearchBorder" = "#1B4332"
        "TerminalBg" = "#030A06"
        "TerminalText" = "#34D399"
        "ProgressBg" = "#11261C"
        "BadgeBg" = "#064E3B"
        "BadgeBorder" = "#10B981"
        "BadgeText" = "#A7F3D0"
        "AccentTitle1" = "#10B981"
        "AccentTitle2" = "#34D399"
        "AccentTitle3" = "#F59E0B"
    }
}

function Set-AppTheme {
    param([string]$ThemeName)

    $key = "Escuro"
    if ($ThemeName -match "Claro") { $key = "Claro" }
    elseif ($ThemeName -match "Cyberpunk") { $key = "Cyberpunk" }
    elseif ($ThemeName -match "Nord") { $key = "Nord" }
    elseif ($ThemeName -match "Esmeralda") { $key = "Esmeralda" }

    $theme = $Global:ThemeDefinitions[$key]
    if (-not $theme) { return }

    $bc = New-Object System.Windows.Media.BrushConverter

    foreach ($k in $theme.Keys) {
        $colorHex = $theme[$k]
        $brush = $bc.ConvertFromString($colorHex)
        $Global:Window.Resources[$k] = $brush
    }

    $Global:Window.Background = $Global:Window.Resources["BgWindow"]
    $Global:Window.Foreground = $Global:Window.Resources["TextPrimary"]

    # Atualização imediata dos cartões da Aba de Aplicativos
    if ($Global:AppCategoryCards) {
        foreach ($catGroup in $Global:AppCategoryCards) {
            if ($catGroup.Border) {
                $catGroup.Border.Background = $Global:Window.Resources["BgCard"]
                $catGroup.Border.BorderBrush = $Global:Window.Resources["BorderCard"]
            }
            if ($catGroup.TitleBlock) {
                $catGroup.TitleBlock.Foreground = $Global:Window.Resources["AccentTitle1"]
            }
        }
    }

    # Atualização imediata dos cartões da Aba de Tweaks
    if ($TweaksContainer) {
        foreach ($tcard in $TweaksContainer.Children) {
            if ($tcard -is [System.Windows.Controls.Border]) {
                $tcard.Background = $Global:Window.Resources["BgCard"]
                $tcard.BorderBrush = $Global:Window.Resources["BorderCard"]
                if ($tcard.Child -is [System.Windows.Controls.Panel] -and $tcard.Child.Children.Count -gt 0) {
                    $tTitle = $tcard.Child.Children[0]
                    if ($tTitle -is [System.Windows.Controls.TextBlock]) {
                        $tTitle.Foreground = $Global:Window.Resources["AccentTitle2"]
                    }
                }
            }
        }
    }

    # Atualização do resumo de rodapé com o novo tema
    if (Get-Command Update-SelectionSummary -ErrorAction SilentlyContinue) {
        Update-SelectionSummary
    }

    if (Get-Command Write-Log -ErrorAction SilentlyContinue) {
        Write-Log "Tema visual alterado para: $ThemeName" "INFO"
    }
}

if ($CmbThemeSelector) {
    $CmbThemeSelector.Add_SelectionChanged({
        if ($CmbThemeSelector.SelectedItem) {
            $selectedTheme = $CmbThemeSelector.SelectedItem.Content
            Set-AppTheme -ThemeName $selectedTheme
        }
    })
}

# -------------------------------------------------------------------------
# 6. MONTAGEM DINÂMICA DA ABA DE APLICATIVOS COM ÍCONES E BADGE OPEN SOURCE
# -------------------------------------------------------------------------
$appCategories = $Global:AppCatalog | Group-Object Category | Sort-Object Name

# Preencher ComboBox de Categorias
$CmbCategoryFilter.Items.Add("[Todas as Categorias]") | Out-Null
foreach ($cat in $appCategories) {
    $CmbCategoryFilter.Items.Add($cat.Name) | Out-Null
}
$CmbCategoryFilter.SelectedIndex = 0

foreach ($cat in $appCategories) {
    $card = New-Object System.Windows.Controls.Border
    $card.SetResourceReference([System.Windows.Controls.Border]::BackgroundProperty, "BgCard")
    $card.SetResourceReference([System.Windows.Controls.Border]::BorderBrushProperty, "BorderCard")
    $card.BorderThickness = [System.Windows.Thickness]::new(1)
    $card.CornerRadius = [System.Windows.CornerRadius]::new(8)
    $card.Padding = [System.Windows.Thickness]::new(14)
    $card.Margin = [System.Windows.Thickness]::new(0, 0, 0, 14)

    $stack = New-Object System.Windows.Controls.StackPanel

    # Cabeçalho da Categoria com Título e Contador
    $catTitle = New-Object System.Windows.Controls.TextBlock
    $catTitle.Text = "$($cat.Name) ($($cat.Group.Count))"
    $catTitle.FontSize = 14
    $catTitle.FontWeight = [System.Windows.FontWeights]::Bold
    $catTitle.SetResourceReference([System.Windows.Controls.TextBlock]::ForegroundProperty, "AccentTitle1")
    $catTitle.Margin = [System.Windows.Thickness]::new(0, 0, 0, 10)
    $stack.Children.Add($catTitle) | Out-Null

    # WrapPanel com 3 colunas de Checkboxes
    $wrap = New-Object System.Windows.Controls.WrapPanel

    $cardAppEntries = [System.Collections.Generic.List[PSCustomObject]]::new()

    foreach ($app in ($cat.Group | Sort-Object Name)) {
        $chk = New-Object System.Windows.Controls.CheckBox
        $chk.Width = 330
        $chk.Margin = [System.Windows.Thickness]::new(0, 4, 10, 6)

        # Montagem do Conteúdo Interno do Checkbox (Ícone + Nome + Badge FOSS)
        $hPanel = New-Object System.Windows.Controls.StackPanel
        $hPanel.Orientation = [System.Windows.Controls.Orientation]::Horizontal
        $hPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center

        # 1. Ícone Favicon
        if ($app.IconUrl) {
            $img = New-Object System.Windows.Controls.Image
            $img.Width = 16
            $img.Height = 16
            $img.Margin = [System.Windows.Thickness]::new(0, 0, 6, 0)
            $img.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
            $img.Source = $app.IconUrl
            $hPanel.Children.Add($img) | Out-Null
        }

        # 2. Nome do Aplicativo
        $nameBlock = New-Object System.Windows.Controls.TextBlock
        $nameBlock.Text = $app.Name
        $nameBlock.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        $hPanel.Children.Add($nameBlock) | Out-Null

        # 3. Badge Nítido de Open Source (FOSS)
        if ($app.Foss) {
            $badge = New-Object System.Windows.Controls.Border
            $badge.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#064E3B") # Verde Esmeralda
            $badge.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#059669")
            $badge.BorderThickness = [System.Windows.Thickness]::new(1)
            $badge.CornerRadius = [System.Windows.CornerRadius]::new(4)
            $badge.Padding = [System.Windows.Thickness]::new(5, 1, 5, 1)
            $badge.Margin = [System.Windows.Thickness]::new(6, 0, 0, 0)
            $badge.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
            $badge.ToolTip = "Software Livre e de Código Aberto (Open Source / FOSS)"

            $badgeText = New-Object System.Windows.Controls.TextBlock
            $badgeText.Text = "🍃 Open Source"
            $badgeText.FontSize = 10
            $badgeText.FontWeight = [System.Windows.FontWeights]::SemiBold
            $badgeText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#34D399")
            $badge.Child = $badgeText

            $hPanel.Children.Add($badge) | Out-Null
        }

        $chk.Content = $hPanel

        # Tooltip Rico em Português
        $licenseType = if ($app.Foss) { "🍃 Código Aberto (Open Source / FOSS)" } else { "🔒 Código Fechado (Proprietário)" }
        $tooltipText = "$($app.Name)`n$($app.Description)`n`n• Licença: $licenseType`n• ID WinGet: $($app.Id)"
        if ($app.Link) { $tooltipText += "`n• Site: $($app.Link)" }
        $chk.ToolTip = $tooltipText

        # Atualiza resumo ao clicar
        $chk.Add_Checked({ Update-SelectionSummary })
        $chk.Add_Unchecked({ Update-SelectionSummary })

        $Global:AppCheckBoxes[$app.Key] = @{
            CheckBox = $chk
            App = $app
        }

        $cardAppEntries.Add([PSCustomObject]@{
            CheckBox = $chk
            Name = $app.Name
            Id = $app.Id
            Key = $app.Key
            Foss = $app.Foss
            Description = $app.Description
        })

        $wrap.Children.Add($chk) | Out-Null
    }

    $stack.Children.Add($wrap) | Out-Null
    $card.Child = $stack
    $AppsContainer.Children.Add($card) | Out-Null

    $Global:AppCategoryCards.Add([PSCustomObject]@{
        Border = $card
        TitleBlock = $catTitle
        CategoryName = $cat.Name
        AppEntries = $cardAppEntries
    })
}

# -------------------------------------------------------------------------
# 7. MONTAGEM DINÂMICA DA ABA DE TWEAKS TOTALMENTE TRADUZIDA (66 TWEAKS)
# -------------------------------------------------------------------------
$tweakCategories = $Global:TweakCatalog | Group-Object Category

foreach ($tcat in $tweakCategories) {
    $tcard = New-Object System.Windows.Controls.Border
    $tcard.SetResourceReference([System.Windows.Controls.Border]::BackgroundProperty, "BgCard")
    $tcard.SetResourceReference([System.Windows.Controls.Border]::BorderBrushProperty, "BorderCard")
    $tcard.BorderThickness = [System.Windows.Thickness]::new(1)
    $tcard.CornerRadius = [System.Windows.CornerRadius]::new(8)
    $tcard.Padding = [System.Windows.Thickness]::new(14)
    $tcard.Margin = [System.Windows.Thickness]::new(0, 0, 0, 14)

    $tstack = New-Object System.Windows.Controls.StackPanel

    # Título da Categoria de Tweaks
    $tTitle = New-Object System.Windows.Controls.TextBlock
    $tTitle.Text = "$($tcat.Name) ($($tcat.Group.Count))"
    $tTitle.FontSize = 14
    $tTitle.FontWeight = [System.Windows.FontWeights]::Bold
    $tTitle.SetResourceReference([System.Windows.Controls.TextBlock]::ForegroundProperty, "AccentTitle2")
    $tTitle.Margin = [System.Windows.Thickness]::new(0, 0, 0, 10)
    $tstack.Children.Add($tTitle) | Out-Null

    # WrapPanel com 2 colunas largas
    $twrap = New-Object System.Windows.Controls.WrapPanel

    foreach ($tweak in ($tcat.Group | Sort-Object Name)) {
        $tchk = New-Object System.Windows.Controls.CheckBox
        $tchk.Content = "$($tweak.Name)"
        $tchk.ToolTip = "$($tweak.Description)`n[Código: $($tweak.Key)]"
        $tchk.Width = 510
        $tchk.Margin = [System.Windows.Thickness]::new(0, 4, 16, 6)

        # Atualiza resumo ao clicar
        $tchk.Add_Checked({ Update-SelectionSummary })
        $tchk.Add_Unchecked({ Update-SelectionSummary })

        $Global:TweakCheckBoxes[$tweak.Key] = @{
            CheckBox = $tchk
            Tweak = $tweak
        }

        $twrap.Children.Add($tchk) | Out-Null
    }

    $tstack.Children.Add($twrap) | Out-Null
    $tcard.Child = $tstack
    $TweaksContainer.Children.Add($tcard) | Out-Null
}

# -------------------------------------------------------------------------
# 8. FILTRO EM TEMPO REAL E BUSCA RÁPIDA DE APLICATIVOS
# -------------------------------------------------------------------------
function Filter-Applications {
    $searchTerm = $TxtAppSearch.Text.Trim().ToLower()
    $selectedCategory = $CmbCategoryFilter.SelectedItem

    if ($searchTerm.Length -gt 0) {
        $TxtSearchPlaceholder.Visibility = [System.Windows.Visibility]::Collapsed
    } else {
        $TxtSearchPlaceholder.Visibility = [System.Windows.Visibility]::Visible
    }

    $visibleCount = 0

    foreach ($catGroup in $Global:AppCategoryCards) {
        $catMatches = ($selectedCategory -eq "[Todas as Categorias]") -or ($catGroup.CategoryName -eq $selectedCategory)
        $hasVisibleAppsInCat = $false

        foreach ($entry in $catGroup.AppEntries) {
            $appMatches = ($searchTerm -eq "") -or 
                          ($entry.Name.ToLower() -like "*$searchTerm*") -or 
                          ($entry.Id.ToLower() -like "*$searchTerm*") -or 
                          ($entry.Description.ToLower() -like "*$searchTerm*")

            $fossMatches = (-not $Global:FossOnlyActive) -or ($entry.Foss -eq $true)
            $selectedMatches = (-not $Global:SelectedOnlyActive) -or ($entry.CheckBox.IsChecked -eq $true)
            $popularMatches = (-not $Global:PopularOnlyActive) -or ($Global:PopularKeys -contains $entry.Key)

            if ($catMatches -and $appMatches -and $fossMatches -and $selectedMatches -and $popularMatches) {
                $entry.CheckBox.Visibility = [System.Windows.Visibility]::Visible
                $hasVisibleAppsInCat = $true
                $visibleCount++
            } else {
                $entry.CheckBox.Visibility = [System.Windows.Visibility]::Collapsed
            }
        }

        if ($hasVisibleAppsInCat) {
            $catGroup.Border.Visibility = [System.Windows.Visibility]::Visible
        } else {
            $catGroup.Border.Visibility = [System.Windows.Visibility]::Collapsed
        }
    }

    $selectedApps = ($Global:AppCheckBoxes.Values | Where-Object { $_.CheckBox.IsChecked -eq $true }).Count
    $TxtAppSummary.Text = "Exibindo $visibleCount de $($Global:AppCatalog.Count) aplicativos | ✨ $selectedApps selecionados"
}

$TxtAppSearch.Add_TextChanged({ Filter-Applications })
$CmbCategoryFilter.Add_SelectionChanged({ Filter-Applications })

# Botão Filtro Rápido Mais Populares
$BtnTogglePopularOnly.Add_Click({
    $Global:PopularOnlyActive = -not $Global:PopularOnlyActive
    if ($Global:PopularOnlyActive) {
        $BtnTogglePopularOnly.Content = "✔️ Exibindo Mais Populares"
        $BtnTogglePopularOnly.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#B45309")
    } else {
        $BtnTogglePopularOnly.Content = "⭐ Mais Populares"
        $BtnTogglePopularOnly.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#451A03")
    }
    Filter-Applications
})

# Botão Filtro Rápido Open Source
$BtnToggleFossOnly.Add_Click({
    $Global:FossOnlyActive = -not $Global:FossOnlyActive
    if ($Global:FossOnlyActive) {
        $BtnToggleFossOnly.Content = "✔️ Exibindo Apenas Open Source"
        $BtnToggleFossOnly.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#047857")
    } else {
        $BtnToggleFossOnly.Content = "🍃 Apenas Open Source"
        $BtnToggleFossOnly.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#064E3B")
    }
    Filter-Applications
})

# Botão Filtro Rápido Apenas Selecionados
$BtnToggleSelectedOnly.Add_Click({
    $Global:SelectedOnlyActive = -not $Global:SelectedOnlyActive
    if ($Global:SelectedOnlyActive) {
        $BtnToggleSelectedOnly.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#4338CA")
    } else {
        $BtnToggleSelectedOnly.Background = $Global:Window.Resources["BtnSecondaryBg"]
    }
    Update-SelectionSummary
    Filter-Applications
})

# Atualizador de Resumo no Rodapé e Destaques
function Update-SelectionSummary {
    $appCount = ($Global:AppCheckBoxes.Values | Where-Object { $_.CheckBox.IsChecked -eq $true }).Count
    $tweakCount = ($Global:TweakCheckBoxes.Values | Where-Object { $_.CheckBox.IsChecked -eq $true }).Count
    $featCount = 0
    if ($ChkFeatWsl.IsChecked) { $featCount++ }
    if ($ChkFeatHyperV.IsChecked) { $featCount++ }
    if ($ChkFeatSandbox.IsChecked) { $featCount++ }
    if ($ChkFeatDotNet.IsChecked) { $featCount++ }
    if ($ChkFeatDirectPlay.IsChecked) { $featCount++ }

    if ($appCount -gt 0 -or $tweakCount -gt 0 -or $featCount -gt 0) {
        $TxtSelectionSummary.Text = "✨ $appCount aplicativo(s), $tweakCount ajuste(s) e $featCount recurso(s) selecionados."
        $TxtSelectionSummary.Foreground = $Global:Window.Resources["AccentTitle2"]
    } else {
        $TxtSelectionSummary.Text = "0 aplicativos e 0 ajustes selecionados. Escolha um preset ou marque manualmente os itens."
        $TxtSelectionSummary.Foreground = $Global:Window.Resources["TextSecondary"]
    }

    $visibleCount = ($Global:AppCheckBoxes.Values | Where-Object { $_.CheckBox.Visibility -eq [System.Windows.Visibility]::Visible }).Count
    $TxtAppSummary.Text = "Exibindo $visibleCount de $($Global:AppCatalog.Count) aplicativos | ✨ $appCount selecionados"

    # Atualiza cabeçalho das Abas em tempo real
    if ($TabItemApps) {
        $TabItemApps.Header = if ($appCount -gt 0) { "📦 Aplicativos ($appCount selecionados)" } else { "📦 Aplicativos (236 Softwares)" }
    }
    if ($TabItemTweaks) {
        $TabItemTweaks.Header = if ($tweakCount -gt 0) { "⚙️ Ajustes do Windows ($tweakCount selecionados)" } else { "⚙️ Ajustes do Windows (66 Tweaks)" }
    }
    if ($TabItemFeatures) {
        $TabItemFeatures.Header = if ($featCount -gt 0) { "🛠️ Recursos & Correções ($featCount selecionados)" } else { "🛠️ Recursos & Correções" }
    }

    if ($BtnToggleSelectedOnly) {
        $BtnToggleSelectedOnly.Content = if ($Global:SelectedOnlyActive) { "✔️ Exibindo Selecionados ($appCount)" } else { "🎯 Apenas Selecionados ($appCount)" }
    }
}

# -------------------------------------------------------------------------
# 9. SISTEMA DE LOGS E ATUALIZAÇÃO DA GUI
# -------------------------------------------------------------------------
function Write-GuiLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = (Get-Date).ToString("HH:mm:ss")
    $prefix = switch ($Level) {
        "SUCCESS" { "[OK]" }
        "WARN"    { "[!]" }
        "ERROR"   { "[ERRO]" }
        Default   { "[*]" }
    }
    $logLine = "$timestamp $prefix $Message`r`n"

    $TxtLogs.Dispatcher.Invoke([Action]{
        $TxtLogs.AppendText($logLine)
        $TxtLogs.ScrollToEnd()
    })
    Pump-GuiEvents
}

function Pump-GuiEvents {
    try {
        [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Background)
    } catch {
        try {
            Pump-GuiEvents
        } catch {}
    }
}

function Set-GuiStatus {
    param(
        [string]$Status,
        [double]$ProgressPercent = -1
    )
    $TxtSelectionSummary.Dispatcher.Invoke([Action]{
        $TxtSelectionSummary.Text = $Status
        if ($ProgressPercent -ge 0) {
            $ProgressBar.Value = $ProgressPercent
        }
    })
    Pump-GuiEvents
}

$BtnClearLogs.Add_Click({
    $TxtLogs.Text = ""
})

$BtnCopyLogs.Add_Click({
    try {
        if ($TxtLogs.Text) {
            [System.Windows.Clipboard]::SetText($TxtLogs.Text)
            Write-GuiLog "Logs copiados para a Área de Transferência com sucesso." "SUCCESS"
        }
    } catch {
        Write-GuiLog "Aviso ao copiar logs para a Área de Transferência: $_" "WARN"
    }
})

# -------------------------------------------------------------------------
# 10. PRESETS DE SELEÇÃO RÁPIDA
# -------------------------------------------------------------------------
$BtnDeselectAllApps.Add_Click({
    foreach ($item in $Global:AppCheckBoxes.Values) {
        $item.CheckBox.IsChecked = $false
    }
    Update-SelectionSummary
})

$BtnSelectAllVisibleApps.Add_Click({
    foreach ($item in $Global:AppCheckBoxes.Values) {
        if ($item.CheckBox.Visibility -eq [System.Windows.Visibility]::Visible) {
            $item.CheckBox.IsChecked = $true
        }
    }
    Update-SelectionSummary
})

$BtnPresetKitAndyz0x.Add_Click({
    # 1. Limpa seleções anteriores de aplicativos
    foreach ($item in $Global:AppCheckBoxes.Values) { $item.CheckBox.IsChecked = $false }

    # 2. Marca a lista completa do Kit Andyz0x
    $andyz0xApps = @(
        "WPFInstallbrave",
        "WPFInstallvlc",
        "WPFInstallsharex",
        "WPFInstallnotepadplus",
        "WPFInstallvscode",
        "WPFInstalldiscord",
        "WPFInstallsteam",
        "WPFInstallepicgames",
        "WPFInstallwhatsapp",
        "WPFInstallnodejslts",
        "WPFInstallgit",
        "WPFInstallpython3",
        "WPFInstallpdf24creator",
        "WPFInstallnanazip",
        "WPFInstallinternetdownloadmanager",
        "WPFInstallnilesoftShell",
        "WPFInstallprotonpass",
        "WPFInstallparsec",
        "WPFInstallsdio",
        "WPFInstalldotnet8",
        "WPFInstalldotnet9",
        "WPFInstalldotnet6",
        "WPFInstallautoruns",
        "WPFInstallvc2015_64",
        "WPFInstallvc2015_32"
    )

    foreach ($k in $andyz0xApps) {
        if ($Global:AppCheckBoxes.ContainsKey($k)) {
            $Global:AppCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }

    Update-SelectionSummary
    Write-GuiLog "👑 Kit Andyz0x ativado com sucesso! (25 softwares essenciais selecionados)" "SUCCESS"
    Write-GuiLog "Selecionados: Brave, VLC, ShareX, Notepad++, VS Code, Discord, Steam, Epic Games, WhatsApp, NodeJS LTS, Git, Python 3, PDF24, NanaZip, IDM, Nilesoft Shell, Proton Pass, Parsec, Snappy Driver, .NET Runtimes (6, 8 e 9), AutoRuns e Visual C++ (32 e 64 bits)." "INFO"
})

function Show-GpuSelectionDialog {
    [CmdletBinding()]
    param(
        [System.Windows.Window]$OwnerWindow
    )

    $detectedName = "Não identificada"
    $isNvidiaDetected = $false
    $isAmdDetected = $false

    try {
        $gpus = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue
        if ($gpus) {
            $names = @()
            foreach ($g in $gpus) {
                if ($g.Name -and $g.Name -notlike "*Basic*" -and $g.Name -notlike "*Virtual*") {
                    $names += $g.Name
                } elseif ($g.Name) {
                    $names += $g.Name
                }
            }
            if ($names.Count -gt 0) {
                $detectedName = ($names | Select-Object -Unique) -join " + "
                if ($detectedName -like "*NVIDIA*") { $isNvidiaDetected = $true }
                if ($detectedName -like "*AMD*" -or $detectedName -like "*Radeon*") { $isAmdDetected = $true }
            }
        }
    } catch {}

    $nvidiaBadge = if ($isNvidiaDetected) { "  ★ DETECTADA NO SISTEMA" } else { "" }
    $amdBadge = if ($isAmdDetected) { "  ★ DETECTADA NO SISTEMA" } else { "" }

    $dialogXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Seleção de GPU • Pack PC Gamer"
        Width="520" Height="430"
        WindowStartupLocation="CenterOwner"
        ResizeMode="NoResize"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent">
    <Border Background="#0F1117" BorderBrush="#282E3E" BorderThickness="1.5" CornerRadius="12">
        <Grid Margin="22">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <!-- Cabeçalho com Fechar -->
            <Grid Grid.Row="0" Margin="0,0,0,14">
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                    <TextBlock Text="🎮" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/>
                    <StackPanel>
                        <TextBlock Text="Pack PC Gamer • Seleção de GPU" FontSize="16" FontWeight="Bold" Foreground="#F8FAFC"/>
                        <TextBlock Text="Escolha o perfil da sua placa de vídeo para configurar drivers e softwares:" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                    </StackPanel>
                </StackPanel>
                <Button Name="BtnDialogClose" Content="✕" HorizontalAlignment="Right" VerticalAlignment="Top" Background="Transparent" Foreground="#64748B" BorderThickness="0" FontSize="15" FontWeight="Bold" Cursor="Hand" Padding="8,2"/>
            </Grid>

            <!-- Info GPU Detectada -->
            <Border Grid.Row="1" Background="#161922" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="8" Padding="12,8" Margin="0,0,0,14">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <TextBlock Text="🔍 Hardware Detectado: " FontSize="11" FontWeight="SemiBold" Foreground="#38BDF8" VerticalAlignment="Center"/>
                    <TextBlock Name="TxtDetectedGpu" Text="$detectedName" Grid.Column="1" FontSize="11" Foreground="#E2E8F0" TextTrimming="CharacterEllipsis" VerticalAlignment="Center"/>
                </Grid>
            </Border>

            <!-- Opções Principais -->
            <StackPanel Grid.Row="2" VerticalAlignment="Center">
                <!-- Opção NVIDIA -->
                <Button Name="BtnSelectNvidia" Margin="0,0,0,10" Cursor="Hand" Background="#062817" BorderBrush="#10B981" BorderThickness="1.5" Padding="14,10">
                    <Button.Template>
                        <ControlTemplate TargetType="Button">
                            <Border Name="Brd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                                <StackPanel>
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="🟢 NVIDIA GeForce" FontSize="14" FontWeight="Bold" Foreground="#34D399"/>
                                        <TextBlock Text="$nvidiaBadge" FontSize="10" FontWeight="Bold" Foreground="#6EE7B7" VerticalAlignment="Center" Margin="8,0,0,0"/>
                                    </StackPanel>
                                    <TextBlock Text="Marca: NVIDIA App (Drivers Game Ready/Studio &amp; Painel Oficial) + Softwares Gamer" FontSize="11" Foreground="#A7F3D0" Margin="0,3,0,0" TextWrapping="Wrap"/>
                                </StackPanel>
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="Brd" Property="Background" Value="#0D3822"/>
                                    <Setter TargetName="Brd" Property="BorderBrush" Value="#34D399"/>
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Button.Template>
                </Button>

                <!-- Opção AMD -->
                <Button Name="BtnSelectAmd" Margin="0,0,0,10" Cursor="Hand" Background="#2B0E11" BorderBrush="#EF4444" BorderThickness="1.5" Padding="14,10">
                    <Button.Template>
                        <ControlTemplate TargetType="Button">
                            <Border Name="Brd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                                <StackPanel>
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="🔴 AMD Radeon" FontSize="14" FontWeight="Bold" Foreground="#F87171"/>
                                        <TextBlock Text="$amdBadge" FontSize="10" FontWeight="Bold" Foreground="#FCA5A5" VerticalAlignment="Center" Margin="8,0,0,0"/>
                                    </StackPanel>
                                    <TextBlock Text="Marca: AMD Software: Adrenalin Edition (Drivers &amp; Otimização) + Utilitários Gamer" FontSize="11" Foreground="#FECACA" Margin="0,3,0,0" TextWrapping="Wrap"/>
                                </StackPanel>
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="Brd" Property="Background" Value="#451216"/>
                                    <Setter TargetName="Brd" Property="BorderBrush" Value="#F87171"/>
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Button.Template>
                </Button>

                <!-- Opção Outro / Pular Drivers -->
                <Button Name="BtnSelectNone" Margin="0,0,0,4" Cursor="Hand" Background="#161922" BorderBrush="#334155" BorderThickness="1" Padding="14,8">
                    <Button.Template>
                        <ControlTemplate TargetType="Button">
                            <Border Name="Brd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                                <StackPanel>
                                    <TextBlock Text="⚪ Outra GPU / Pular Drivers de Vídeo" FontSize="12" FontWeight="SemiBold" Foreground="#CBD5E1"/>
                                    <TextBlock Text="Marca apenas jogos, launchers e utilitários de sistema (sem drivers de GPU)" FontSize="10.5" Foreground="#94A3B8" Margin="0,2,0,0" TextWrapping="Wrap"/>
                                </StackPanel>
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="Brd" Property="Background" Value="#252C3D"/>
                                    <Setter TargetName="Brd" Property="BorderBrush" Value="#64748B"/>
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Button.Template>
                </Button>
            </StackPanel>

            <!-- Rodapé com Botão Cancelar -->
            <Grid Grid.Row="3" Margin="0,10,0,0">
                <Button Name="BtnDialogCancel" Content="Cancelar" HorizontalAlignment="Right" Background="#161922" Foreground="#94A3B8" BorderBrush="#2E374D" BorderThickness="1" Padding="16,6" FontSize="12" Cursor="Hand">
                    <Button.Template>
                        <ControlTemplate TargetType="Button">
                            <Border Name="Brd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="Brd" Property="Background" Value="#252C3D"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Button.Template>
                </Button>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

    $stringReader = New-Object System.IO.StringReader($dialogXaml)
    $xmlReader = [System.Xml.XmlReader]::Create($stringReader)
    $dialog = [System.Windows.Markup.XamlReader]::Load($xmlReader)

    if ($OwnerWindow) {
        $dialog.Owner = $OwnerWindow
        $dialog.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterOwner
    }

    $dialog.Add_MouseLeftButtonDown({
        if ($_.ButtonState -eq [System.Windows.Input.MouseButtonState]::Pressed) {
            $dialog.DragMove()
        }
    })

    $dialog.Add_KeyDown({
        if ($_.Key -eq [System.Windows.Input.Key]::Escape) {
            $dialog.Close()
        }
    })

    $BtnDialogClose = $dialog.FindName("BtnDialogClose")
    $BtnDialogCancel = $dialog.FindName("BtnDialogCancel")
    $BtnSelectNvidia = $dialog.FindName("BtnSelectNvidia")
    $BtnSelectAmd = $dialog.FindName("BtnSelectAmd")
    $BtnSelectNone = $dialog.FindName("BtnSelectNone")

    $result = [PSCustomObject]@{ Choice = "CANCEL" }

    $BtnDialogClose.Add_Click({
        $result.Choice = "CANCEL"
        $dialog.Close()
    })

    $BtnDialogCancel.Add_Click({
        $result.Choice = "CANCEL"
        $dialog.Close()
    })

    $BtnSelectNvidia.Add_Click({
        $result.Choice = "NVIDIA"
        $dialog.Close()
    })

    $BtnSelectAmd.Add_Click({
        $result.Choice = "AMD"
        $dialog.Close()
    })

    $BtnSelectNone.Add_Click({
        $result.Choice = "NONE"
        $dialog.Close()
    })

    $dialog.ShowDialog() | Out-Null
    return $result.Choice
}

$BtnPresetPackGamer.Add_Click({
    # 1. Abre diálogo de seleção da fabricante da GPU (NVIDIA ou AMD)
    $gpuChoice = Show-GpuSelectionDialog -OwnerWindow $Global:Window
    if ($gpuChoice -eq "CANCEL") {
        Write-GuiLog "Seleção do Pack PC Gamer cancelada pelo usuário." "INFO"
        return
    }

    # 2. Limpa seleções anteriores de aplicativos
    foreach ($item in $Global:AppCheckBoxes.Values) { $item.CheckBox.IsChecked = $false }

    # 3. Marca Softwares Essenciais Comuns para PC Gamer
    $gamerApps = @(
        "WPFInstallsteam",
        "WPFInstallepicgames",
        "WPFInstalldiscord",
        "WPFInstallHydraLauncher",
        "WPFInstallExitLag",
        "WPFInstallautoruns",
        "WPFInstallmsiafterburner",
        "WPFInstallvc2015_64",
        "WPFInstallvc2015_32",
        "WPFInstallnanazip",
        "WPFInstallbrave"
    )

    foreach ($k in $gamerApps) {
        if ($Global:AppCheckBoxes.ContainsKey($k)) {
            $Global:AppCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }

    # 3.1 Configura drivers conforme perfil de GPU selecionado
    if ($gpuChoice -eq "NVIDIA") {
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallNvidiaApp")) {
            $Global:AppCheckBoxes["WPFInstallNvidiaApp"].CheckBox.IsChecked = $true
        }
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallnvclean")) {
            $Global:AppCheckBoxes["WPFInstallnvclean"].CheckBox.IsChecked = $false
        }
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallAmdSoftware")) {
            $Global:AppCheckBoxes["WPFInstallAmdSoftware"].CheckBox.IsChecked = $false
        }
        Write-GuiLog "🔥 Pack PC Gamer ativado com perfil NVIDIA! (NVIDIA App selecionado)" "SUCCESS"
    } elseif ($gpuChoice -eq "AMD") {
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallAmdSoftware")) {
            $Global:AppCheckBoxes["WPFInstallAmdSoftware"].CheckBox.IsChecked = $true
        }
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallNvidiaApp")) {
            $Global:AppCheckBoxes["WPFInstallNvidiaApp"].CheckBox.IsChecked = $false
        }
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallnvclean")) {
            $Global:AppCheckBoxes["WPFInstallnvclean"].CheckBox.IsChecked = $false
        }
        Write-GuiLog "🔥 Pack PC Gamer ativado com perfil AMD! (AMD Software: Adrenalin selecionado)" "SUCCESS"
    } else {
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallNvidiaApp")) {
            $Global:AppCheckBoxes["WPFInstallNvidiaApp"].CheckBox.IsChecked = $false
        }
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallnvclean")) {
            $Global:AppCheckBoxes["WPFInstallnvclean"].CheckBox.IsChecked = $false
        }
        if ($Global:AppCheckBoxes.ContainsKey("WPFInstallAmdSoftware")) {
            $Global:AppCheckBoxes["WPFInstallAmdSoftware"].CheckBox.IsChecked = $false
        }
        Write-GuiLog "🔥 Pack PC Gamer ativado sem drivers específicos de vídeo!" "SUCCESS"
    }

    # 4. Marca Tweaks Recomendados para Máximo Desempenho em Jogos
    $gamerTweaks = @(
        "WPFTweaksRestorePoint",
        "WPFToggleGameMode",
        "WPFToggleMouseAcceleration",
        "WPFMultiplaneOverlay",
        "WPFAddUltPerf",
        "WPFTweaksDisableBGapps",
        "WPFTweaksIPv46",
        "WPFTweaksTelemetry",
        "WPFTweaksWidget",
        "WPFTweaksDeliveryOptimization",
        "WPFTweaksEndTaskOnTaskbar",
        "WPFTweaksDisplay"
    )

    foreach ($k in $gamerTweaks) {
        if ($Global:TweakCheckBoxes.ContainsKey($k)) {
            $Global:TweakCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }

    # 5. Ativa componente de compatibilidade DirectPlay para jogos clássicos
    $ChkFeatDirectPlay.IsChecked = $true

    Update-SelectionSummary
    Write-GuiLog "Otimizações de Jogos ativadas: Game Mode, Precisão 1:1 Mouse, MPO desativado, Ultimate Performance, IPv4 e DirectPlay." "INFO"
})

$BtnPresetEssenciais.Add_Click({
    foreach ($item in $Global:AppCheckBoxes.Values) { $item.CheckBox.IsChecked = $false }
    $essentials = @("WPFInstallchrome", "WPFInstall7zip", "WPFInstallnotepadplusplus", "WPFInstallvlc", "WPFInstallsharex", "WPFInstallanydesk")
    foreach ($k in $essentials) {
        if ($Global:AppCheckBoxes.ContainsKey($k)) {
            $Global:AppCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }
    Update-SelectionSummary
})

$BtnPresetDev.Add_Click({
    foreach ($item in $Global:AppCheckBoxes.Values) { $item.CheckBox.IsChecked = $false }
    $devs = @("WPFInstallchrome", "WPFInstall7zip", "WPFInstallvscode", "WPFInstallgit", "WPFInstalldocker-desktop", "WPFInstallnodejs-lts", "WPFInstallpython3", "WPFInstallwindowsterminal")
    foreach ($k in $devs) {
        if ($Global:AppCheckBoxes.ContainsKey($k)) {
            $Global:AppCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }
    Update-SelectionSummary
})

$BtnPresetGamer.Add_Click({
    foreach ($item in $Global:AppCheckBoxes.Values) { $item.CheckBox.IsChecked = $false }
    $gamers = @("WPFInstallchrome", "WPFInstall7zip", "WPFInstalldiscord", "WPFInstallspotify", "WPFInstallsteam", "WPFInstallepicgameslauncher", "WPFInstallHydraLauncher", "WPFInstallNvidiaApp")
    foreach ($k in $gamers) {
        if ($Global:AppCheckBoxes.ContainsKey($k)) {
            $Global:AppCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }
    Update-SelectionSummary
})

# Presets Andyz0x Tweaks
$BtnSelectAllTweaks.Add_Click({
    foreach ($t in $Global:TweakCheckBoxes.Values) {
        $t.CheckBox.IsChecked = $true
    }
    Update-SelectionSummary
    Write-GuiLog "Todos os 66 ajustes foram marcados." "INFO"
})

$BtnDeselectAllTweaks.Add_Click({
    foreach ($t in $Global:TweakCheckBoxes.Values) {
        $t.CheckBox.IsChecked = $false
    }
    Update-SelectionSummary
})

$BtnPresetStandard.Add_Click({
    foreach ($t in $Global:TweakCheckBoxes.Values) { $t.CheckBox.IsChecked = $false }
    foreach ($k in $Global:StandardPreset) {
        if ($Global:TweakCheckBoxes.ContainsKey($k)) {
            $Global:TweakCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }
    Update-SelectionSummary
    Write-GuiLog "Preset Recomendado selecionado!" "SUCCESS"
})

$BtnPresetMinimal.Add_Click({
    foreach ($t in $Global:TweakCheckBoxes.Values) { $t.CheckBox.IsChecked = $false }
    foreach ($k in $Global:MinimalPreset) {
        if ($Global:TweakCheckBoxes.ContainsKey($k)) {
            $Global:TweakCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }
    Update-SelectionSummary
    Write-GuiLog "Preset Mínimo selecionado!" "SUCCESS"
})

$BtnPresetAdvanced.Add_Click({
    foreach ($t in $Global:TweakCheckBoxes.Values) { $t.CheckBox.IsChecked = $false }
    foreach ($k in $Global:AdvancedPreset) {
        if ($Global:TweakCheckBoxes.ContainsKey($k)) {
            $Global:TweakCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }
    Update-SelectionSummary
    Write-GuiLog "Preset Avançado (Debloat Completo) selecionado!" "SUCCESS"
})

# -------------------------------------------------------------------------
# 11. ATALHOS DE PAINÉIS CLÁSSICOS & FERRAMENTAS DE REPARAÇÃO
# -------------------------------------------------------------------------
$BtnLaunchControl.Add_Click({ Start-Process "control.exe" })
$BtnLaunchNcpa.Add_Click({ Start-Process "ncpa.cpl" })
$BtnLaunchSysdm.Add_Click({ Start-Process "sysdm.cpl" })
$BtnLaunchCompmgmt.Add_Click({ Start-Process "compmgmt.msc" })
$BtnLaunchAppwiz.Add_Click({ Start-Process "appwiz.cpl" })
$BtnLaunchSound.Add_Click({ Start-Process "mmsys.cpl" })
$BtnLaunchFirewall.Add_Click({ Start-Process "firewall.cpl" })

# Ações de Reparação
$BtnActionSfcDism.Add_Click({
    $MainTabControl.SelectedIndex = 3
    Write-GuiLog "Iniciando verificação de integridade do sistema (SFC & DISM)..." "INFO"
    Start-Process powershell.exe -ArgumentList "-NoProfile -Command `"Write-Host 'Executando SFC Scan...' -ForegroundColor Cyan; sfc /scannow; Write-Host 'Executando DISM Health Restore...' -ForegroundColor Cyan; DISM /Online /Cleanup-Image /RestoreHealth; Write-Host 'Concluído! Pressione Enter para fechar.' -ForegroundColor Green; Read-Host`""
})

$BtnActionResetNetwork.Add_Click({
    $MainTabControl.SelectedIndex = 3
    Write-GuiLog "Redefinindo pilha de rede e liberando cache DNS..." "INFO"
    try {
        netsh int ip reset | Out-Null
        ipconfig /flushdns | Out-Null
        Write-GuiLog "Pilha de rede e DNS redefinidos com sucesso!" "SUCCESS"
    } catch {
        Write-GuiLog "Aviso ao redefinir rede: $_" "WARN"
    }
})

$BtnActionResetWindowsUpdate.Add_Click({
    $MainTabControl.SelectedIndex = 3
    Write-GuiLog "Redefinindo serviços do Windows Update..." "INFO"
    try {
        Stop-Service -Name wuauserv,bits,cryptsvc -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
        Start-Service -Name wuauserv,bits,cryptsvc -ErrorAction SilentlyContinue
        Write-GuiLog "Serviços e cache do Windows Update redefinidos." "SUCCESS"
    } catch {
        Write-GuiLog "Aviso ao redefinir Windows Update: $_" "WARN"
    }
})

$BtnActionCleanDisk.Add_Click({
    Write-GuiLog "Abrindo Limpeza de Disco Avançada..." "INFO"
    Start-Process "cleanmgr.exe" -ArgumentList "/d C:"
})

# -------------------------------------------------------------------------
# 12. MOTOR DE EXECUÇÃO: TWEAKS, RECURSOS E WINGET
# -------------------------------------------------------------------------
function Apply-SelectedTweaks {
    $selectedTweaks = @()
    foreach ($item in $Global:TweakCheckBoxes.Values) {
        if ($item.CheckBox.IsChecked) {
            $selectedTweaks += $item.Tweak
        }
    }

    if ($selectedTweaks.Count -eq 0) { return }

    Write-GuiLog "=================================================" "INFO"
    Write-GuiLog "INICIANDO APLICAÇÃO DE TWEAKS ($($selectedTweaks.Count) SELECIONADOS)" "INFO"
    Write-GuiLog "=================================================" "INFO"

    $tIndex = 0
    $needsExplorerRestart = $false

    foreach ($tweak in $selectedTweaks) {
        $tIndex++
        Set-GuiStatus "Aplicando tweak [$tIndex de $($selectedTweaks.Count)]: $($tweak.Name)..."
        Write-GuiLog "Aplicando: $($tweak.Name)..." "INFO"

        # 1. Aplicar Entradas de Registro
        if ($tweak.Registry -and $tweak.Registry.Count -gt 0) {
            foreach ($reg in $tweak.Registry) {
                try {
                    $path = $reg.Path
                    $name = $reg.Name
                    $val = $reg.Value
                    $type = $reg.Type

                    if ($val -eq "<RemoveEntry>") {
                        if (Test-Path $path) {
                            Remove-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
                        }
                    } else {
                        if (-not (Test-Path $path)) {
                            New-Item -Path $path -Force | Out-Null
                        }
                        if ($type -eq "DWord") {
                            Set-ItemProperty -Path $path -Name $name -Value ([int]$val) -Type DWord -Force
                        } elseif ($type -eq "QWord") {
                            Set-ItemProperty -Path $path -Name $name -Value ([long]$val) -Type QWord -Force
                        } else {
                            Set-ItemProperty -Path $path -Name $name -Value $val -Force
                        }
                    }
                } catch {
                    Write-GuiLog "Aviso ao ajustar registro ($($reg.Name)): $_" "WARN"
                }
            }
        }

        # 2. Executar InvokeScript se existir
        if ($tweak.InvokeScript -and $tweak.InvokeScript.Trim().Length -gt 0) {
            try {
                $sb = [scriptblock]::Create($tweak.InvokeScript)
                & $sb 2>&1 | Out-Null
            } catch {
                Write-GuiLog "Aviso ao executar script para $($tweak.Name): $_" "WARN"
            }
        }

        if ($tweak.Key -match "Explorer|Taskbar|Menu|DarkMode|ShowExt|HiddenFiles") {
            $needsExplorerRestart = $true
        }
    }

    if ($needsExplorerRestart) {
        Write-GuiLog "Atualizando o Windows Explorer para refletir as alterações..." "INFO"
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 600
        if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) {
            Start-Process explorer.exe -ErrorAction SilentlyContinue
        }
    }

    Write-GuiLog "Todos os tweaks selecionados foram aplicados com sucesso!" "SUCCESS"
}

function Apply-SelectedFeatures {
    $featuresToEnable = @()
    if ($ChkFeatWsl.IsChecked) { $featuresToEnable += "Microsoft-Windows-Subsystem-Linux" }
    if ($ChkFeatHyperV.IsChecked) { $featuresToEnable += "Microsoft-Hyper-V-All" }
    if ($ChkFeatSandbox.IsChecked) { $featuresToEnable += "Containers-DisposableClientVM" }
    if ($ChkFeatDotNet.IsChecked) { $featuresToEnable += "NetFx3" }
    if ($ChkFeatDirectPlay.IsChecked) { $featuresToEnable += "DirectPlay" }

    if ($featuresToEnable.Count -eq 0) { return }

    Write-GuiLog "=================================================" "INFO"
    Write-GuiLog "HABILITANDO RECURSOS DO WINDOWS ($($featuresToEnable.Count) SELECIONADOS)" "INFO"
    Write-GuiLog "=================================================" "INFO"

    foreach ($feat in $featuresToEnable) {
        Write-GuiLog "Habilitando recurso do Windows: $($feat)..." "INFO"
        try {
            Enable-WindowsOptionalFeature -Online -FeatureName $feat -NoRestart -ErrorAction SilentlyContinue | Out-Null
            Write-GuiLog "Recurso $($feat) habilitado." "SUCCESS"
        } catch {
            Write-GuiLog "Aviso ao habilitar $($feat): $_" "WARN"
        }
    }
}

function Install-SelectedApps {
    $windowsAppsPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
    if (Test-Path $windowsAppsPath) {
        if ($env:PATH -notlike "*$windowsAppsPath*") {
            $env:PATH = "$windowsAppsPath;$env:PATH"
        }
    }

    $selectedApps = @()
    foreach ($item in $Global:AppCheckBoxes.Values) {
        if ($item.CheckBox.IsChecked) {
            $selectedApps += $item.App
        }
    }

    if ($selectedApps.Count -eq 0) { return }

    # Telemetria assíncrona anônima para computar popularidade coletiva (segundo plano, 0ms de bloqueio)
    try {
        $selectedKeysToReport = @($selectedApps | ForEach-Object { $_.Key })
        if ($selectedKeysToReport.Count -gt 0) {
            Start-Job -ScriptBlock {
                param($keys)
                try {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    $payload = @{ apps = $keys } | ConvertTo-Json
                    Invoke-RestMethod -Uri "https://unbk.com.br/api/vote.php" -Method Post -Body $payload -ContentType "application/json" -TimeoutSec 3 -ErrorAction SilentlyContinue | Out-Null
                } catch {}
            } -ArgumentList (,$selectedKeysToReport) | Out-Null
        }
    } catch {}

    $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wingetCmd) {
        Write-GuiLog "ERRO CRÍTICO: WinGet não foi detectado no sistema." "ERROR"
        Write-GuiLog "Atualize o 'Instalador de Aplicativos' na Microsoft Store e tente novamente." "WARN"
        return
    }

    $total = $selectedApps.Count
    Write-GuiLog "=================================================" "INFO"
    Write-GuiLog "INICIANDO DOWNLOAD & INSTALAÇÃO DE $total APLICATIVO(S)" "INFO"
    Write-GuiLog "=================================================" "INFO"

    $curr = 0
    foreach ($app in $selectedApps) {
        $curr++
        $percent = [math]::Round(($curr / $total) * 100)
        Set-GuiStatus "Instalando [$curr de $total]: $($app.Name)..." $percent

        # Tratamento especial para aplicativos com instalador direto oficial (ExitLag, NVIDIA App, AMD Software)
        if ($app.DownloadUrl) {
            Write-GuiLog "[$curr/$total] Baixando instalador oficial de $($app.Name)..." "INFO"
            $installerPath = "$env:TEMP\setup_$($app.Key).exe"

            try {
                if (-not (Test-Path $installerPath)) {
                    $headers = @{
                        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                    }
                    if ($app.DownloadUrl -like "*amd.com*") {
                        $headers["Referer"] = "https://www.amd.com/"
                    }
                    Invoke-WebRequest -Uri $app.DownloadUrl -OutFile $installerPath -Headers $headers -UseBasicParsing
                }
                Write-GuiLog "Executando instalador de $($app.Name)..." "INFO"
                $args = if ($app.InstallArgs) { $app.InstallArgs } else { "/SILENT /VERYSILENT /NORESTART" }
                $process = Start-Process -FilePath $installerPath -ArgumentList $args -PassThru -Wait
                Write-GuiLog "$($app.Name) instalado com sucesso!" "SUCCESS"
            } catch {
                Write-GuiLog "Aviso ao instalar $($app.Name): $_" "WARN"
            }
            Pump-GuiEvents
            continue
        }

        # Instalação padrão via WinGet
        Write-GuiLog "[$curr/$total] Baixando e instalando $($app.Name) (ID: $($app.Id))..." "INFO"

        try {
            $process = Start-Process winget -ArgumentList "install --id `"$($app.Id)`" -e --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -PassThru -Wait

            if ($process.ExitCode -eq 0) {
                Write-GuiLog "$($app.Name) instalado com sucesso!" "SUCCESS"
            } elseif ($process.ExitCode -eq -1978335189 -or $process.ExitCode -eq 2316632107) {
                Write-GuiLog "$($app.Name) já se encontra na versão mais recente." "SUCCESS"
            } else {
                Write-GuiLog "Aviso ao instalar $($app.Name) (ExitCode: $($process.ExitCode))." "WARN"
            }
        } catch {
            Write-GuiLog "Falha na execução do WinGet para $($app.Name): $_" "ERROR"
        }

        Pump-GuiEvents
    }

    Write-GuiLog "Instalação de aplicativos finalizada!" "SUCCESS"
}

# -------------------------------------------------------------------------
# 13. BOTÃO PRINCIPAL DE EXECUÇÃO
# -------------------------------------------------------------------------
function Uninstall-SelectedApps {
    $selectedApps = @()
    foreach ($item in $Global:AppCheckBoxes.Values) {
        if ($item.CheckBox.IsChecked) {
            $selectedApps += $item.App
        }
    }

    if ($selectedApps.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Nenhum aplicativo foi selecionado para desinstalação.`nPor favor, marque os aplicativos que deseja desinstalar na aba 'Aplicativos'.", "Nenhuma Seleção", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $appNames = ($selectedApps | ForEach-Object { " • " + $_.Name }) -join "`n"
    $confirm = [System.Windows.MessageBox]::Show("Deseja realmente DESINSTALAR os $($selectedApps.Count) aplicativo(s) selecionado(s) do sistema?`n`n$appNames", "Confirmar Desinstalação", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)

    if ($confirm -ne [System.Windows.MessageBoxResult]::Yes) {
        Write-GuiLog "Desinstalação de aplicativos cancelada pelo usuário." "INFO"
        return
    }

    # Desativa botões durante execução
    $BtnRun.IsEnabled = $false
    if ($BtnUninstallApps) { $BtnUninstallApps.IsEnabled = $false }
    if ($BtnRevertTweaks) { $BtnRevertTweaks.IsEnabled = $false }
    if ($BtnUninstallAppsTab) { $BtnUninstallAppsTab.IsEnabled = $false }
    if ($BtnRevertTweaksTab) { $BtnRevertTweaksTab.IsEnabled = $false }

    $MainTabControl.SelectedIndex = 3
    $total = $selectedApps.Count
    Set-GuiStatus "Iniciando desinstalação de $total aplicativo(s)..." 0

    Write-GuiLog "=================================================" "WARN"
    Write-GuiLog "INICIANDO DESINSTALAÇÃO DE $total APLICATIVO(S)" "WARN"
    Write-GuiLog "=================================================" "WARN"

    $curr = 0
    foreach ($app in $selectedApps) {
        $curr++
        $percent = [math]::Round(($curr / $total) * 100)
        Set-GuiStatus "Desinstalando [$curr de $total]: $($app.Name)..." $percent
        Write-GuiLog "[$curr/$total] Tentando desinstalar $($app.Name) (ID: $($app.Id))..." "INFO"

        try {
            $process = Start-Process winget -ArgumentList "uninstall --id `"$($app.Id)`" -e --silent --accept-source-agreements" -NoNewWindow -PassThru -Wait

            if ($process.ExitCode -eq 0) {
                Write-GuiLog "$($app.Name) desinstalado com sucesso via WinGet!" "SUCCESS"
            } elseif ($process.ExitCode -eq -1978335212 -or $process.ExitCode -eq 2316632084) {
                # Pacote não encontrado por ID, tenta por nome
                Write-GuiLog "ID não encontrado, tentando desinstalar por nome: $($app.Name)..." "INFO"
                $process2 = Start-Process winget -ArgumentList "uninstall --name `"$($app.Name)`" -e --silent --accept-source-agreements" -NoNewWindow -PassThru -Wait
                if ($process2.ExitCode -eq 0) {
                    Write-GuiLog "$($app.Name) desinstalado com sucesso por nome!" "SUCCESS"
                } else {
                    Write-GuiLog "Aviso: $($app.Name) não parece estar instalado no sistema." "WARN"
                }
            } else {
                Write-GuiLog "Aviso na desinstalação de $($app.Name) (ExitCode: $($process.ExitCode))." "WARN"
            }
        } catch {
            Write-GuiLog "Falha ao desinstalar $($app.Name): $_" "ERROR"
        }

        Pump-GuiEvents
    }

    Set-GuiStatus "Desinstalação de aplicativos finalizada!" 100
    Write-GuiLog "=================================================" "SUCCESS"
    Write-GuiLog "PROCESSO DE DESINSTALAÇÃO CONCLUÍDO!" "SUCCESS"
    Write-GuiLog "=================================================" "SUCCESS"

    $BtnRun.IsEnabled = $true
    if ($BtnUninstallApps) { $BtnUninstallApps.IsEnabled = $true }
    if ($BtnRevertTweaks) { $BtnRevertTweaks.IsEnabled = $true }
    if ($BtnUninstallAppsTab) { $BtnUninstallAppsTab.IsEnabled = $true }
    if ($BtnRevertTweaksTab) { $BtnRevertTweaksTab.IsEnabled = $true }

    [System.Windows.MessageBox]::Show("Processo de desinstalação concluído!", "Desinstalação Finalizada", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

function Revert-SelectedTweaks {
    $selectedTweaks = @()
    foreach ($item in $Global:TweakCheckBoxes.Values) {
        if ($item.CheckBox.IsChecked) {
            $selectedTweaks += $item.Tweak
        }
    }

    if ($selectedTweaks.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Nenhum ajuste foi selecionado para reversão.`nPor favor, marque os ajustes que deseja restaurar na aba 'Ajustes do Windows'.", "Nenhuma Seleção", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $tweakNames = ($selectedTweaks | ForEach-Object { " • " + $_.Name }) -join "`n"
    $confirm = [System.Windows.MessageBox]::Show("Deseja realmente REVERTER os $($selectedTweaks.Count) ajuste(s) selecionado(s) para os valores padrão do Windows?`n`n$tweakNames", "Confirmar Reversão de Tweaks", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)

    if ($confirm -ne [System.Windows.MessageBoxResult]::Yes) {
        Write-GuiLog "Reversão de ajustes cancelada pelo usuário." "INFO"
        return
    }

    $BtnRun.IsEnabled = $false
    if ($BtnUninstallApps) { $BtnUninstallApps.IsEnabled = $false }
    if ($BtnRevertTweaks) { $BtnRevertTweaks.IsEnabled = $false }
    if ($BtnUninstallAppsTab) { $BtnUninstallAppsTab.IsEnabled = $false }
    if ($BtnRevertTweaksTab) { $BtnRevertTweaksTab.IsEnabled = $false }

    $MainTabControl.SelectedIndex = 3
    $total = $selectedTweaks.Count
    Set-GuiStatus "Iniciando reversão de $total ajuste(s)..." 0

    Write-GuiLog "=================================================" "WARN"
    Write-GuiLog "REVERTENDO $total TWEAK(S) PARA PADRÕES DO WINDOWS" "WARN"
    Write-GuiLog "=================================================" "WARN"

    $needsExplorerRestart = $false
    $tIndex = 0

    foreach ($tweak in $selectedTweaks) {
        $tIndex++
        $percent = [math]::Round(($tIndex / $total) * 100)
        Set-GuiStatus "Revertendo [$tIndex de $total]: $($tweak.Name)..." $percent
        Write-GuiLog "Revertendo tweak: $($tweak.Name)..." "INFO"

        # 1. Reverter Registro para OriginalValue / DefaultValue
        if ($tweak.Registry -and $tweak.Registry.Count -gt 0) {
            foreach ($reg in $tweak.Registry) {
                try {
                    $path = $reg.Path
                    $name = $reg.Name
                    $origVal = if ($reg.OriginalValue) { $reg.OriginalValue } elseif ($reg.DefaultValue) { $reg.DefaultValue } else { $null }
                    $type = $reg.Type

                    if ($origVal -eq "<RemoveEntry>") {
                        if (Test-Path $path) {
                            Remove-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
                        }
                    } elseif ($origVal -ne $null) {
                        if (-not (Test-Path $path)) {
                            New-Item -Path $path -Force | Out-Null
                        }
                        if ($type -eq "DWord") {
                            Set-ItemProperty -Path $path -Name $name -Value ([int]$origVal) -Type DWord -Force
                        } elseif ($type -eq "QWord") {
                            Set-ItemProperty -Path $path -Name $name -Value ([long]$origVal) -Type QWord -Force
                        } else {
                            Set-ItemProperty -Path $path -Name $name -Value $origVal -Force
                        }
                    }
                } catch {
                    Write-GuiLog "Aviso ao restaurar registro ($($reg.Name)): $_" "WARN"
                }
            }
        }

        # 2. Executar UndoScript se existir
        if ($tweak.UndoScript -and $tweak.UndoScript.Trim().Length -gt 0) {
            try {
                $sb = [scriptblock]::Create($tweak.UndoScript)
                & $sb 2>&1 | Out-Null
                Write-GuiLog "Script de reversão executado para $($tweak.Name)." "INFO"
            } catch {
                Write-GuiLog "Aviso ao executar script de reversão para $($tweak.Name): $_" "WARN"
            }
        }

        if ($tweak.Key -match "Explorer|Taskbar|Menu|DarkMode|ShowExt|HiddenFiles") {
            $needsExplorerRestart = $true
        }

        Pump-GuiEvents
    }

    if ($needsExplorerRestart) {
        Write-GuiLog "Reiniciando o Windows Explorer para aplicar restauração de interface..." "INFO"
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 600
        if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) {
            Start-Process explorer.exe -ErrorAction SilentlyContinue
        }
    }

    Set-GuiStatus "Todos os ajustes selecionados foram revertidos com sucesso!" 100
    Write-GuiLog "=================================================" "SUCCESS"
    Write-GuiLog "REVERSÃO DE TWEAKS FINALIZADA COM SUCESSO!" "SUCCESS"
    Write-GuiLog "=================================================" "SUCCESS"

    $BtnRun.IsEnabled = $true
    if ($BtnUninstallApps) { $BtnUninstallApps.IsEnabled = $true }
    if ($BtnRevertTweaks) { $BtnRevertTweaks.IsEnabled = $true }
    if ($BtnUninstallAppsTab) { $BtnUninstallAppsTab.IsEnabled = $true }
    if ($BtnRevertTweaksTab) { $BtnRevertTweaksTab.IsEnabled = $true }

    [System.Windows.MessageBox]::Show("Reversão concluída! Os ajustes selecionados foram restaurados para os valores padrão do Windows.", "Reversão Finalizada", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Conectar cliques dos botões de Desinstalar e Reverter
$BtnUninstallApps.Add_Click({ Uninstall-SelectedApps })
$BtnRevertTweaks.Add_Click({ Revert-SelectedTweaks })
$BtnUninstallAppsTab.Add_Click({ Uninstall-SelectedApps })
$BtnRevertTweaksTab.Add_Click({ Revert-SelectedTweaks })

$BtnRun.Add_Click({
    $appCount = ($Global:AppCheckBoxes.Values | Where-Object { $_.CheckBox.IsChecked -eq $true }).Count
    $tweakCount = ($Global:TweakCheckBoxes.Values | Where-Object { $_.CheckBox.IsChecked -eq $true }).Count
    $featCount = 0
    if ($ChkFeatWsl.IsChecked) { $featCount++ }
    if ($ChkFeatHyperV.IsChecked) { $featCount++ }
    if ($ChkFeatSandbox.IsChecked) { $featCount++ }
    if ($ChkFeatDotNet.IsChecked) { $featCount++ }
    if ($ChkFeatDirectPlay.IsChecked) { $featCount++ }

    if ($appCount -eq 0 -and $tweakCount -eq 0 -and $featCount -eq 0) {
        [System.Windows.MessageBox]::Show("Nenhum aplicativo, tweak ou recurso foi selecionado.`nPor favor, marque os itens desejados ou escolha um Preset antes de iniciar.", "Nenhuma Seleção", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $BtnRun.IsEnabled = $false
    $BtnRun.Content = "⏳ Processando..."

    # Muda para a aba de Console
    $MainTabControl.SelectedIndex = 3

    Set-GuiStatus "Iniciando processamento das seleções..." 0

    # 1. Aplicar Tweaks de Sistema
    Apply-SelectedTweaks

    # 2. Habilitar Recursos do Windows
    Apply-SelectedFeatures

    # 3. Instalar Aplicativos via WinGet
    Install-SelectedApps

    Set-GuiStatus "Todas as operações foram finalizadas com sucesso!" 100
    Write-GuiLog "=================================================" "SUCCESS"
    Write-GuiLog "CONFIGURAÇÃO PÓS-FORMATAÇÃO FINALIZADA COM SUCESSO!" "SUCCESS"
    Write-GuiLog "=================================================" "SUCCESS"

    $BtnRun.IsEnabled = $true
    $BtnRun.Content = "✔️ Concluído"
    [System.Windows.MessageBox]::Show("Processo finalizado com sucesso! Todos os softwares e ajustes selecionados foram aplicados no seu computador.", "Setup Concluído", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
})

# -------------------------------------------------------------------------
# 14. INICIALIZAÇÃO VISUAL (INÍCIO LIMPO - NENHUM AJUSTE PRÉ-MARCADO)
# -------------------------------------------------------------------------
Update-SelectionSummary

# Exibir Janela com tratamento seguro de saída
try {
    $Global:Window.ShowDialog() | Out-Null
} catch {
    Write-Host "[ERRO CRÍTICO NA INTERFACE]: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Yellow
} finally {
    $global:LASTEXITCODE = 0
}
