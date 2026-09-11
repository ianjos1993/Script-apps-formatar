<#
.SYNOPSIS
    Utilitário Completo de Pós-Formatação para Windows (WPF GUI)
    Desenvolvido por Andyz0x.
    Totalmente em Português (Brasil) com Ícones Oficiais, Pack PC Gamer e Destaque Open Source.
    Executável remotamente via: irm <URL> | iex

.DESCRIPTION
    - 247 Aplicativos organizados com Ícones Oficiais e indicador nítido de Open Source (FOSS).
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

Write-Host ""
Write-Host "  ==================================================================" -ForegroundColor Cyan
Write-Host "    🚀 Setup Pós-Formatação Windows • Igor Anjos (ianjos1993)" -ForegroundColor Cyan
Write-Host "    247 Aplicativos • Pack PC Gamer • Otimizações & Tweaks" -ForegroundColor DarkGray
Write-Host "  ==================================================================" -ForegroundColor Cyan
Write-Host ""

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
[{"Key": "WPFInstall1password", "Id": "AgileBits.1Password", "Name": "1Password", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador seguro de senhas para armazenar credenciais, cartões de crédito e notas confidenciais com proteção de ponta.", "Link": "https://1password.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://1password.com/", "Foss": false}, {"Key": "WPFInstall7zip", "Id": "7zip.7zip", "Name": "7-Zip", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Descompactador de arquivos de código aberto líder em compressão, com suporte avançado a formatos 7z, ZIP, RAR, TAR e outros.", "Link": "https://www.7-zip.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.7-zip.org/", "Foss": true}, {"Key": "WPFInstalladobe", "Id": "Adobe.Acrobat.Reader.64-bit", "Name": "Adobe Acrobat Reader", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Visualizador clássico de arquivos PDF da Adobe com ferramentas essenciais para leitura, impressão e anotações.", "Link": "https://www.adobe.com/acrobat/pdf-reader.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.adobe.com/acrobat/pdf-reader.html", "Foss": false}, {"Key": "WPFInstalladvancedip", "Id": "Famatech.AdvancedIPScanner", "Name": "Advanced IP Scanner", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Scanner de rede local rápido e fácil de usar que localiza todos os dispositivos conectados à rede e analisa portas abertas.", "Link": "https://www.advanced-ip-scanner.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.advanced-ip-scanner.com/", "Foss": false}, {"Key": "WPFInstallaimp", "Id": "AIMP.AIMP", "Name": "AIMP (Music Player)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Reprodutor de áudio de alta qualidade com equalizador avançado de 18 bandas, suporte a múltiplos formatos e visual personalizável.", "Link": "https://www.aimp.ru/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.aimp.ru/", "Foss": false}, {"Key": "WPFInstallangryipscanner", "Id": "angryziber.AngryIPScanner", "Name": "Angry IP Scanner", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Scanner de rede e portas de código aberto, rápido e prático para diagnósticos e auditorias de conectividade IP.", "Link": "https://angryip.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://angryip.org/", "Foss": true}, {"Key": "WPFInstallanydesk", "Id": "AnyDesk.AnyDesk", "Name": "AnyDesk", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Software de acesso remoto e suporte técnico veloz com conexão de baixa latência e controle suave de computadores.", "Link": "https://anydesk.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://anydesk.com/", "Foss": false}, {"Key": "WPFInstallaudacity", "Id": "Audacity.Audacity", "Name": "Audacity", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Editor e gravador de áudio multipista profissional e gratuito de código aberto, ideal para criação de podcasts e edição musical.", "Link": "https://www.audacityteam.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.audacityteam.org/", "Foss": true}, {"Key": "WPFInstallautoruns", "Id": "Microsoft.Sysinternals.Autoruns", "Name": "Autoruns", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Utilitário clássico da SysInternals que lista em detalhes todos os programas, serviços e DLLs configurados para iniciar com o Windows.", "Link": "https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns", "Foss": false}, {"Key": "WPFInstallrdcman", "Id": "Microsoft.Sysinternals.RDCMan", "Name": "RDCMan", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Gerenciador de conexões de Área de Trabalho Remota (RDP) para organizar múltiplos servidores e máquinas em uma só tela.", "Link": "https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman", "Foss": false}, {"Key": "WPFInstallautohotkey", "Id": "AutoHotkey.AutoHotkey", "Name": "AutoHotkey", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Linguagem de automação e scripts para Windows que permite criar atalhos personalizados de teclado, macros e automações de cliques.", "Link": "https://www.autohotkey.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.autohotkey.com/", "Foss": true}, {"Key": "WPFInstallbattlenet", "Id": "Blizzard.BattleNet", "Name": "Battle.net", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Launcher oficial de jogos da Blizzard Entertainment (World of Warcraft, Diablo, Overwatch, Call of Duty e StarCraft).", "Link": "https://battle.net", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://battle.net", "Foss": false}, {"Key": "WPFInstallbitwarden", "Id": "Bitwarden.Bitwarden", "Name": "Bitwarden", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador de senhas de código aberto confiável com cofre criptografado ponta a ponta e sincronização gratuita em todos os dispositivos.", "Link": "https://bitwarden.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://bitwarden.com/", "Foss": true}, {"Key": "WPFInstallblender", "Id": "BlenderFoundation.Blender", "Name": "Blender (3D Graphics)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Suíte profissional e gratuita de criação 3D com suporte a modelagem, escultura digital, animação, simulação física e renderização.", "Link": "https://www.blender.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.blender.org/", "Foss": true}, {"Key": "WPFInstallbrave", "Id": "Brave.Brave", "Name": "Brave", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador focado em privacidade e segurança com bloqueador nativo de anúncios e rastreadores, oferecendo navegação mais rápida e protegida.", "Link": "https://www.brave.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.brave.com", "Foss": true}, {"Key": "WPFInstallbruno", "Id": "Bruno.Bruno", "Name": "Bruno", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Cliente de API moderno e local-first que armazena coleções em arquivos de texto puro para versionamento direto no Git.", "Link": "https://www.usebruno.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.usebruno.com/", "Foss": true}, {"Key": "WPFInstallbulkcrapuninstaller", "Id": "Klocman.BulkCrapUninstaller", "Name": "Bulk Crap Uninstaller", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Desinstalador em massa poderoso de código aberto que remove múltiplos programas simultaneamente e elimina sobras do sistema.", "Link": "https://www.bcuninstaller.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.bcuninstaller.com/", "Foss": true}, {"Key": "WPFInstallblurautoclicker", "Id": "Blur009.BlurAutoClicker", "Name": "BlurAutoClicker", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Autoclicker ágil com recursos inteligentes de intervalo e desempenho superior para tarefas repetitivas e jogos.", "Link": "https://blur009.vercel.app/projects/blur-autoclicker/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://blur009.vercel.app/projects/blur-autoclicker/", "Foss": true}, {"Key": "WPFInstallcalibre", "Id": "calibre.calibre", "Name": "Calibre", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Gerenciador completo de biblioteca de livros digitais (e-books), com recursos para conversão de formatos e sincronização com e-readers.", "Link": "https://calibre-ebook.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://calibre-ebook.com/", "Foss": true}, {"Key": "WPFInstallcemu", "Id": "Cemu.Cemu", "Name": "Cemu", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Emulador conceituado de Nintendo Wii U para PC, com suporte a resolução 4K, 60+ FPS e pacotes gráficos da comunidade.", "Link": "https://cemu.info/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cemu.info/", "Foss": true}, {"Key": "WPFInstallchatgpt", "Id": "msstore:9NT1R1C2HH7J", "Name": "ChatGPT Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Aplicativo oficial de desktop do ChatGPT da OpenAI para Windows, com comandos rápidos e acesso direto à IA.", "Link": "https://openai.com/chatgpt/download/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://openai.com/chatgpt/download/", "Foss": false}, {"Key": "WPFInstallchatterino", "Id": "ChatterinoTeam.Chatterino", "Name": "Chatterino", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Cliente de chat especializado para transmissões na Twitch com interface limpa, rápida, personalizável e suporte a múltiplos canais.", "Link": "https://www.chatterino.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.chatterino.com/", "Foss": true}, {"Key": "WPFInstallchrome", "Id": "Google.Chrome", "Name": "Chrome", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador da Google amplamente utilizado, conhecido pela alta velocidade, simplicidade e integração perfeita com a conta Google.", "Link": "https://www.google.com/chrome/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.google.com/chrome/", "Foss": false}, {"Key": "WPFInstallchromium", "Id": "Hibbiki.Chromium", "Name": "Chromium", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Projeto de código aberto que serve de base para diversos navegadores modernos, incluindo Google Chrome e Microsoft Edge.", "Link": "https://www.chromium.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.chromium.org/", "Foss": true}, {"Key": "WPFInstallcinebenchr23", "Id": "Maxon.CinebenchR23", "Name": "Cinebench R23", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Ferramenta de benchmark renomada mundialmente para testar a potência de renderização e estabilidade do processador (CPU).", "Link": "https://www.maxon.net/en/cinebench", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.maxon.net/en/cinebench", "Foss": false}, {"Key": "WPFInstallclaude", "Id": "Anthropic.Claude", "Name": "Claude Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Aplicativo oficial da Anthropic para conversar com a IA Claude e acelerar fluxos de trabalho e escrita no Windows.", "Link": "https://claude.ai/download", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://claude.ai/download", "Foss": false}, {"Key": "WPFInstallclaude-code", "Id": "Anthropic.ClaudeCode", "Name": "Claude Code", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ferramenta de linha de comando oficial da Anthropic para assistência em codificação e desenvolvimento pelo terminal.", "Link": "https://code.claude.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://code.claude.com/", "Foss": false}, {"Key": "WPFInstallcmake", "Id": "Kitware.CMake", "Name": "CMake", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ferramenta multiplataforma de automação de compilação, geração de projetos e testes para desenvolvimento em C, C++ e outras linguagens.", "Link": "https://cmake.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cmake.org/", "Foss": true}, {"Key": "WPFInstallcodex", "Id": "OpenAI.Codex", "Name": "Codex", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Agente de codificação inteligente para terminal desenvolvido para auxiliar em tarefas de programação diretamente no console.", "Link": "https://developers.openai.com/codex/cli", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://developers.openai.com/codex/cli", "Foss": true}, {"Key": "WPFInstallcpuz", "Id": "CPUID.CPU-Z", "Name": "CPU-Z", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Utilitário clássico para diagnóstico detalhado do hardware: exibe modelo da CPU, frequências, voltagens, placa-mãe e memórias RAM.", "Link": "https://www.cpuid.com/softwares/cpu-z.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.cpuid.com/softwares/cpu-z.html", "Foss": false}, {"Key": "WPFInstallcrystaldiskinfo", "Id": "CrystalDewWorld.CrystalDiskInfo", "Name": "Crystal Disk Info", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Utilitário essencial para monitorar a saúde e temperatura de HDDs e SSDs, exibindo alertas de integridade SMART.", "Link": "https://crystalmark.info/en/software/crystaldiskinfo/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://crystalmark.info/en/software/crystaldiskinfo/", "Foss": true}, {"Key": "WPFInstallcrystaldiskmark", "Id": "CrystalDewWorld.CrystalDiskMark", "Name": "Crystal Disk Mark", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Ferramenta de benchmark para medir com precisão as velocidades de leitura e gravação sequencial e aleatória de SSDs e HDs.", "Link": "https://crystalmark.info/en/software/crystaldiskmark/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://crystalmark.info/en/software/crystaldiskmark/", "Foss": true}, {"Key": "WPFInstallcursor", "Id": "Anysphere.Cursor", "Name": "Cursor", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Editor de código inteligente baseado no VS Code com assistência profunda de IA para geração, depuração e refatoração de código.", "Link": "https://cursor.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cursor.com/", "Foss": false}, {"Key": "WPFInstallddu", "Id": "Wagnardsoft.DisplayDriverUninstaller", "Name": "Display Driver Uninstaller", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Ferramenta indispensável para remover completamente drivers de vídeo NVIDIA, AMD e Intel sem deixar registros residuais no sistema.", "Link": "https://www.wagnardsoft.com/display-driver-uninstaller-DDU-", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wagnardsoft.com/display-driver-uninstaller-DDU-", "Foss": true}, {"Key": "WPFInstalldiscord", "Id": "Discord.Discord", "Name": "Discord", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Principal plataforma de comunicação por voz, vídeo e texto para comunidades, amigos e gamers.", "Link": "https://discord.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://discord.com/", "Foss": false}, {"Key": "WPFInstalldismtools", "Id": "CodingWondersSoftware.DISMTools.Stable", "Name": "DISMTools", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Interface gráfica moderna e avançada para o utilitário DISM, facilitando a customização, reparo e captura de imagens do Windows.", "Link": "https://github.com/CodingWonders/DISMTools", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/CodingWonders/DISMTools", "Foss": true}, {"Key": "WPFInstallntlite", "Id": "Nlitesoft.NTLite", "Name": "NTLite", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Ferramenta para integrar drivers e atualizações, remover componentes indesejados e automatizar instalações personalizadas do Windows.", "Link": "https://ntlite.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ntlite.com", "Foss": false}, {"Key": "WPFInstalldorion", "Id": "SpikeHD.Dorion", "Name": "Dorion", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Cliente alternativo ultraleve para Discord, com inicialização instantânea, baixo consumo de memória, suporte a temas e plugins.", "Link": "https://spikehd.dev/projects/dorion/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://spikehd.dev/projects/dorion/", "Foss": true}, {"Key": "WPFInstalldockerdesktop", "Id": "Docker.DockerDesktop", "Name": "Docker Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ambiente oficial completo para criar, executar, gerenciar e testar contêineres Docker e clusters Kubernetes no Windows.", "Link": "https://www.docker.com/products/docker-desktop/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.docker.com/products/docker-desktop/", "Foss": false}, {"Key": "WPFInstalldotnet6", "Id": "Microsoft.DotNet.DesktopRuntime.6", "Name": ".NET Desktop Runtime 6", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Ambiente de execução necessário para rodar programas e jogos desenvolvidos na plataforma Microsoft .NET 6.", "Link": "https://dotnet.microsoft.com/download/dotnet/6.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/6.0", "Foss": true}, {"Key": "WPFInstalldotnet8", "Id": "Microsoft.DotNet.DesktopRuntime.8", "Name": ".NET Desktop Runtime 8", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Ambiente de execução necessário para rodar programas e jogos desenvolvidos na plataforma Microsoft .NET 8.", "Link": "https://dotnet.microsoft.com/download/dotnet/8.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/8.0", "Foss": true}, {"Key": "WPFInstalldotnet9", "Id": "Microsoft.DotNet.DesktopRuntime.9", "Name": ".NET Desktop Runtime 9", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Ambiente de execução necessário para rodar programas e jogos desenvolvidos na plataforma Microsoft .NET 9.", "Link": "https://dotnet.microsoft.com/download/dotnet/9.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/9.0", "Foss": true}, {"Key": "WPFInstalldotnet10", "Id": "Microsoft.DotNet.DesktopRuntime.10", "Name": ".NET Desktop Runtime 10", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Ambiente de execução necessário para rodar programas e jogos desenvolvidos na plataforma Microsoft .NET 10.", "Link": "https://dotnet.microsoft.com/download/dotnet/10.0", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://dotnet.microsoft.com/download/dotnet/10.0", "Foss": true}, {"Key": "WPFInstalldropbox", "Id": "Dropbox.Dropbox", "Name": "Dropbox", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Cliente de armazenamento em nuvem clássico para sincronização contínua de arquivos, pastas e documentos de trabalho.", "Link": "https://www.dropbox.com/desktop", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.dropbox.com/desktop", "Foss": false}, {"Key": "WPFInstalleaapp", "Id": "ElectronicArts.EADesktop", "Name": "EA App", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Plataforma oficial da Electronic Arts para baixar, gerenciar e jogar títulos da EA no Windows.", "Link": "https://www.ea.com/ea-app", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.ea.com/ea-app", "Foss": false}, {"Key": "WPFInstalleartrumpet", "Id": "File-New-Project.EarTrumpet", "Name": "EarTrumpet (Audio)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Controle de volume aprimorado e independente por aplicativo para a barra de tarefas do Windows, muito superior ao controle nativo.", "Link": "https://eartrumpet.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://eartrumpet.app/", "Foss": true}, {"Key": "WPFInstalledge", "Id": "Microsoft.Edge", "Name": "Edge", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador moderno da Microsoft baseado no Chromium, otimizado para Windows com recursos de produtividade e segurança.", "Link": "https://www.microsoft.com/edge", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.microsoft.com/edge", "Foss": false}, {"Key": "WPFInstalles-de", "Id": "ES-DE.EmulationStation-DE", "Name": "EmulationStation Desktop Edition", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Interface moderna e temática para organizar e iniciar jogos de múltiplas plataformas e emuladores em uma só biblioteca.", "Link": "https://es-de.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://es-de.org/", "Foss": true}, {"Key": "WPFInstallenteauth", "Id": "ente-io.auth-desktop", "Name": "Ente Auth", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Aplicativo de autenticação em dois fatores (2FA) gratuito, de código aberto e com sincronização criptografada ponta a ponta.", "Link": "https://ente.io/auth/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ente.io/auth/", "Foss": true}, {"Key": "WPFInstallepicgames", "Id": "EpicGames.EpicGamesLauncher", "Name": "Epic Games Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Cliente oficial da Epic Games Store com jogos gratuitos semanais, títulos exclusivos e suporte à Unreal Engine.", "Link": "https://www.epicgames.com/store/en-US/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.epicgames.com/store/en-US/", "Foss": false}, {"Key": "WPFInstallfiles", "Id": "FilesCommunity.Files", "Name": "Files", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Explorador de arquivos moderno com design fluent, abas múltiplas, painel duplo e integração com a nuvem.", "Link": "https://files.community", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://files.community", "Foss": true}, {"Key": "WPFInstallfirefox", "Id": "Mozilla.Firefox", "Name": "Firefox", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador de código aberto da Mozilla, reconhecido pela alta personalização, forte proteção de privacidade e vasto suporte a extensões.", "Link": "https://www.mozilla.org/en-US/firefox/new/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.mozilla.org/en-US/firefox/new/", "Foss": true}, {"Key": "WPFInstallfirefoxesr", "Id": "Mozilla.Firefox.ESR", "Name": "Firefox ESR", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Versão corporativa de suporte estendido (ESR) do Firefox, com foco em estabilidade máxima e atualizações de segurança consolidadas.", "Link": "https://www.mozilla.org/en-US/firefox/enterprise/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.mozilla.org/en-US/firefox/enterprise/", "Foss": true}, {"Key": "WPFInstallfloorp", "Id": "Ablaze.Floorp", "Name": "Floorp", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador japonês de código aberto baseado no Firefox, focado em alta velocidade, recursos personalizáveis e total privacidade.", "Link": "https://floorp.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://floorp.app/", "Foss": true}, {"Key": "WPFInstallflux", "Id": "flux.flux", "Name": "F.lux", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Ajusta automaticamente a temperatura de cor do monitor conforme o horário do dia para reduzir a fadiga visual e melhorar o sono.", "Link": "https://justgetflux.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://justgetflux.com/", "Foss": false}, {"Key": "WPFInstallfoobar", "Id": "PeterPawlowski.foobar2000", "Name": "foobar2000 (Music Player)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Reprodutor de música avançado para audiófilos, extremamente leve, modular e com suporte a áudio bit-perfect (ASIO/WASAPI).", "Link": "https://www.foobar2000.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.foobar2000.org/", "Foss": false}, {"Key": "WPFInstallfnm", "Id": "Schniz.fnm", "Name": "Fast Node Manager", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Gerenciador ultrarrápido de versões do Node.js escrito em Rust, permitindo alternar versões instantaneamente no terminal.", "Link": "https://github.com/Schniz/fnm", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/Schniz/fnm", "Foss": true}, {"Key": "WPFInstallfoxpdfreader", "Id": "Foxit.FoxitReader", "Name": "Foxit PDF Reader", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Leitor de PDF ágil e intuitivo com interface moderna em estilo ribbon e ferramentas para leitura e anotações.", "Link": "https://www.foxit.com/pdf-reader/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.foxit.com/pdf-reader/", "Foss": false}, {"Key": "WPFInstallgeforcenow", "Id": "Nvidia.GeForceNow", "Name": "GeForce NOW", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Serviço de jogos em nuvem da NVIDIA para rodar seus jogos de PC em alta resolução e ray tracing mesmo em máquinas modestas.", "Link": "https://www.nvidia.com/en-us/geforce-now/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.nvidia.com/en-us/geforce-now/", "Foss": false}, {"Key": "WPFInstallgimp", "Id": "GIMP.GIMP.3", "Name": "GIMP (Image Editor)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Poderoso editor de imagens e fotos rasterizadas de código aberto, com camadas, filtros avançados e suporte a múltiplos formatos.", "Link": "https://www.gimp.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.gimp.org/", "Foss": true}, {"Key": "WPFInstallgit", "Id": "Git.Git", "Name": "Git", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Sistema de controle de versão distribuído padrão da indústria para rastrear alterações em códigos e projetos de software.", "Link": "https://git-scm.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://git-scm.com/", "Foss": true}, {"Key": "WPFInstallgitextensions", "Id": "GitExtensionsTeam.GitExtensions", "Name": "Git Extensions", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Interface gráfica completa para Git no Windows, com visualização de árvores de commits, diffs e gestão de repositórios.", "Link": "https://gitextensions.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://gitextensions.github.io/", "Foss": true}, {"Key": "WPFInstallgithubcli", "Id": "GitHub.cli", "Name": "GitHub CLI", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ferramenta de terminal oficial do GitHub para gerenciar pull requests, issues, releases e repositórios sem sair do console.", "Link": "https://cli.github.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://cli.github.com/", "Foss": true}, {"Key": "WPFInstallgithubdesktop", "Id": "GitHub.GitHubDesktop", "Name": "GitHub Desktop", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Aplicativo oficial do GitHub com interface amigável para clonar repositórios, criar ramificações e realizar commits com facilidade.", "Link": "https://desktop.github.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://desktop.github.com/", "Foss": true}, {"Key": "WPFInstallgog", "Id": "GOG.Galaxy", "Name": "GOG Galaxy", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Plataforma de jogos da CD Projekt focada em jogos livres de DRM, agregando bibliotecas de várias lojas em um único lugar.", "Link": "https://www.gog.com/galaxy", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.gog.com/galaxy", "Foss": false}, {"Key": "WPFInstallgolang", "Id": "GoLang.Go", "Name": "Go", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Linguagem de programação moderna, compilada e tipada da Google, projetada para simplicidade, alta concorrência e alto desempenho.", "Link": "https://go.dev/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://go.dev/", "Foss": true}, {"Key": "WPFInstallgoogledrive", "Id": "Google.GoogleDrive", "Name": "Google Drive", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Aplicativo desktop do Google Drive para sincronização e espelhamento de arquivos em nuvem com o Windows Explorer.", "Link": "https://www.google.com/drive/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.google.com/drive/", "Foss": false}, {"Key": "WPFInstallgpuz", "Id": "TechPowerUp.GPU-Z", "Name": "GPU-Z", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Utilitário de diagnóstico essencial para placas de vídeo: exibe especificações completas da GPU, temperaturas, clock e consumo de energia.", "Link": "https://www.techpowerup.com/gpuz/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.techpowerup.com/gpuz/", "Foss": false}, {"Key": "WPFInstallgsudo", "Id": "gerardog.gsudo", "Name": "gsudo", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Equivalente ao comando 'sudo' do Linux no Windows, permitindo elevar privilégios diretamente na janela do terminal atual sem abrir novo prompt.", "Link": "https://github.com/gerardog/gsudo", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/gerardog/gsudo", "Foss": true}, {"Key": "WPFInstallhelium", "Id": "ImputNet.Helium", "Name": "Helium", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador leve, rápido e transparente, projetado para navegação fluida sem rastreamento de dados.", "Link": "https://helium.computer", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://helium.computer", "Foss": true}, {"Key": "WPFInstallhugo", "Id": "Hugo.Hugo.Extended", "Name": "Hugo", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerador de sites estáticos mais rápido do mundo, capaz de construir páginas completas em milissegundos.", "Link": "https://gohugo.io", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://gohugo.io", "Foss": true}, {"Key": "WPFInstallhandbrake", "Id": "HandBrake.HandBrake", "Name": "HandBrake", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Transcodificador de vídeo gratuito e de código aberto para converter vídeos para formatos compatíveis com máxima qualidade e menor tamanho.", "Link": "https://handbrake.fr/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://handbrake.fr/", "Foss": true}, {"Key": "WPFInstallheroiclauncher", "Id": "HeroicGamesLauncher.HeroicGamesLauncher", "Name": "Heroic Games Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Launcher de código aberto leve para Epic Games Store, GOG e Amazon Games com suporte nativo e sem propagandas.", "Link": "https://heroicgameslauncher.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://heroicgameslauncher.com/", "Foss": true}, {"Key": "WPFInstallhwinfo", "Id": "REALiX.HWiNFO", "Name": "HWiNFO", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Diagnóstico profissional de hardware com relatórios detalhados de cada componente e telemetria de sensores em tempo real.", "Link": "https://www.hwinfo.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.hwinfo.com/", "Foss": false}, {"Key": "WPFInstallhwmonitor", "Id": "CPUID.HWMonitor", "Name": "HWMonitor", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Programa de monitoramento de hardware que lê sensores de temperatura, rotação de ventoinhas (fans) e voltagens do PC.", "Link": "https://www.cpuid.com/softwares/hwmonitor.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.cpuid.com/softwares/hwmonitor.html", "Foss": false}, {"Key": "WPFInstallimageglass", "Id": "DuongDieuPhap.ImageGlass", "Name": "ImageGlass (Image Viewer)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Visualizador moderno e rápido de imagens com suporte a mais de 80 formatos gráficos (incluindo GIF, SVG, RAW e AVIF).", "Link": "https://imageglass.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://imageglass.org/", "Foss": true}, {"Key": "WPFInstallinternetdownloadmanager", "Id": "Tonec.InternetDownloadManager", "Name": "Internet Download Manager", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Acelerador e gerenciador de downloads para Windows com segmentação dinâmica para atingir velocidades máximas.", "Link": "https://www.internetdownloadmanager.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.internetdownloadmanager.com/", "Foss": false}, {"Key": "WPFInstallirfanview", "Id": "IrfanSkiljan.IrfanView", "Name": "IrfanView", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Visualizador clássico e ultraleve de imagens com ferramentas rápidas de conversão em lote, cortes e suporte a plugins.", "Link": "https://irfanview.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://irfanview.com/", "Foss": false}, {"Key": "WPFInstallitch", "Id": "ItchIo.Itch", "Name": "Itch.io", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Plataforma independente de jogos indie, protótipos criativos e experimentações de desenvolvedores de todo o mundo.", "Link": "https://itch.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://itch.io/", "Foss": true}, {"Key": "WPFInstallitunes", "Id": "Apple.iTunes", "Name": "iTunes", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Reprodutor de mídia e gerenciador oficial de dispositivos iOS (iPhone, iPad) da Apple para sincronização de músicas e backups locais.", "Link": "https://www.apple.com/itunes/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.apple.com/itunes/", "Foss": false}, {"Key": "WPFInstalljava8", "Id": "Amazon.Corretto.8.JDK", "Name": "Amazon Corretto 8 (LTS)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Distribuição corporativa do OpenJDK Java 8 LTS da Amazon para compatibilidade com aplicações legadas.", "Link": "https://aws.amazon.com/corretto", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aws.amazon.com/corretto", "Foss": true}, {"Key": "WPFInstalljava21", "Id": "Amazon.Corretto.21.JDK", "Name": "Amazon Corretto 21 (LTS)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Distribuição corporativa, gratuita e de alta performance do OpenJDK Java 21 LTS com suporte de longo prazo da Amazon.", "Link": "https://aws.amazon.com/corretto", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aws.amazon.com/corretto", "Foss": true}, {"Key": "WPFInstalljava25", "Id": "Amazon.Corretto.25.JDK", "Name": "Amazon Corretto 25 (LTS)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Distribuição corporativa do OpenJDK Java 25 LTS da Amazon, pronta para produção e ambientes corporativos.", "Link": "https://aws.amazon.com/corretto", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aws.amazon.com/corretto", "Foss": true}, {"Key": "WPFInstalljellyfinmediaplayer", "Id": "Jellyfin.JellyfinMediaPlayer", "Name": "Jellyfin Media Player", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Cliente desktop oficial do Jellyfin com aceleração de hardware nativa para reproduzir filmes, séries e músicas do seu servidor pessoal.", "Link": "https://jellyfin.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://jellyfin.org/", "Foss": true}, {"Key": "WPFInstalljellyfinserver", "Id": "Jellyfin.Server", "Name": "Jellyfin Server", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Servidor de mídia 100% livre e de código aberto para organizar e transmitir sua coleção de filmes, fotos e músicas para qualquer aparelho.", "Link": "https://jellyfin.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://jellyfin.org/", "Foss": true}, {"Key": "WPFInstalljetbrains", "Id": "JetBrains.Toolbox", "Name": "Jetbrains Toolbox", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Painel central para instalar, atualizar e gerenciar todas as IDEs da JetBrains (IntelliJ, PyCharm, WebStorm e Rider).", "Link": "https://www.jetbrains.com/toolbox/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.jetbrains.com/toolbox/", "Foss": false}, {"Key": "WPFInstalljpegview", "Id": "sylikc.JPEGView", "Name": "JPEG View", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Visualizador de fotos ultrarrápido e minimalista com suporte a formatos modernos (WEBP, AVIF, HEIC, JXL) e ajustes rápidos.", "Link": "https://github.com/sylikc/jpegview", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/sylikc/jpegview", "Foss": true}, {"Key": "WPFInstalljoplin", "Id": "Joplin.Joplin", "Name": "Joplin", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Aplicativo de anotações e listas de tarefas de código aberto com criptografia de ponta a ponta e sincronização na nuvem.", "Link": "https://joplinapp.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://joplinapp.org/", "Foss": true}, {"Key": "WPFInstallkeepassxc", "Id": "KeePassXCTeam.KeePassXC", "Name": "KeePassXC", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador de senhas de código aberto seguro que armazena suas credenciais em um banco de dados local criptografado sem depender da nuvem.", "Link": "https://keepassxc.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://keepassxc.org/", "Foss": true}, {"Key": "WPFInstallklite", "Id": "CodecGuide.K-LiteCodecPack.Standard", "Name": "K-Lite Codec Standard", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Pacote completo de codecs de áudio e vídeo com o Media Player Classic, garantindo reprodução impecável de qualquer formato de mídia.", "Link": "https://www.codecguide.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.codecguide.com/", "Foss": false}, {"Key": "WPFInstallkodi", "Id": "XBMCFoundation.Kodi", "Name": "Kodi Media Center", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Central multimídia completa de código aberto para gerenciar e reproduzir vídeos, músicas e podcasts na TV ou computador.", "Link": "https://kodi.tv/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://kodi.tv/", "Foss": true}, {"Key": "WPFInstalllazygit", "Id": "JesseDuffield.lazygit", "Name": "Lazygit", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Interface de terminal rápida e interativa para comandos do Git, tornando o versionamento ágil e intuitivo.", "Link": "https://github.com/jesseduffield/lazygit/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/jesseduffield/lazygit/", "Foss": true}, {"Key": "WPFInstalllibreoffice", "Id": "TheDocumentFoundation.LibreOffice", "Name": "LibreOffice", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Pacote de escritório completo, gratuito e de código aberto (editor de texto, planilhas e apresentações) compatível com arquivos do Microsoft Office.", "Link": "https://www.libreoffice.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.libreoffice.org/", "Foss": true}, {"Key": "WPFInstalllibrewolf", "Id": "LibreWolf.LibreWolf", "Name": "LibreWolf", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Versão comunitária independente do Firefox com foco absoluto em privacidade, proteção contra telemetria e segurança reforçada.", "Link": "https://librewolf.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://librewolf.net/", "Foss": true}, {"Key": "WPFInstalllocalsend", "Id": "LocalSend.LocalSend", "Name": "LocalSend", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Alternativa aberta e multiplataforma ao AirDrop para transferir arquivos e mensagens com máxima velocidade na rede local sem internet.", "Link": "https://localsend.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://localsend.org/", "Foss": true}, {"Key": "WPFInstallmpc-qt", "Id": "mpc-qt.mpc-qt", "Name": "mpc-qt", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Clone moderno do Media Player Classic reconstruído com interface em Qt e motor de renderização mpv.", "Link": "https://mpc-qt.github.io", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mpc-qt.github.io", "Foss": true}, {"Key": "WPFInstallmpv", "Id": "shinchiro.mpv", "Name": "mpv", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Reprodutor multimídia minimalista de altíssima performance e qualidade de renderização, controlado por atalhos e scripts.", "Link": "https://mpv.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mpv.io/", "Foss": true}, {"Key": "WPFInstallmatrix", "Id": "Element.Element", "Name": "Element", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Cliente para a rede descentralizada Matrix, oferecendo comunicação segura, criptografia de ponta a ponta e total autonomia.", "Link": "https://element.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://element.io/", "Foss": true}, {"Key": "WPFInstallminitoolpartitionwizard", "Id": "MiniTool.PartitionWizard.Free", "Name": "MiniTool Partition Wizard", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador completo de partições de disco para criar, redimensionar, converter e formatar unidades no Windows.", "Link": "https://www.partitionwizard.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.partitionwizard.com/", "Foss": false}, {"Key": "WPFInstallmodrinth", "Id": "Modrinth.ModrinthApp", "Name": "Modrinth App", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Gerenciador moderno, rápido e de código aberto para mods, pacotes de textura e modpacks do Minecraft.", "Link": "https://modrinth.com/app", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://modrinth.com/app", "Foss": true}, {"Key": "WPFInstallmoonlight", "Id": "MoonlightGameStreamingProject.Moonlight", "Name": "Moonlight/GameStream Client", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Cliente de streaming para jogar seus jogos de PC em outro dispositivo na rede com baixíssima latência e suporte a 4K 120 FPS.", "Link": "https://moonlight-stream.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://moonlight-stream.org/", "Foss": true}, {"Key": "WPFInstallmpchc", "Id": "clsid2.mpc-hc", "Name": "Media Player Classic - Home Cinema", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Reprodutor de vídeo clássico e extremamente leve para Windows, sem anúncios e com reprodução fluida mesmo em PCs modestos.", "Link": "https://mpc-hc.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mpc-hc.org/", "Foss": true}, {"Key": "WPFInstallmsedgeredirect", "Id": "rcmaehl.MSEdgeRedirect", "Name": "MSEdgeRedirect", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Utilitário que redireciona links de notícias, pesquisa do Windows e widgets para o seu navegador padrão em vez do Edge.", "Link": "https://github.com/rcmaehl/MSEdgeRedirect", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/rcmaehl/MSEdgeRedirect", "Foss": true}, {"Key": "WPFInstallmsiafterburner", "Id": "Guru3D.Afterburner", "Name": "MSI Afterburner", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Software mais conceituado do mundo para overclock de placa de vídeo, curvas de ventoinha e monitoramento de FPS e hardware em jogos.", "Link": "https://www.msi.com/Landing/afterburner", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.msi.com/Landing/afterburner", "Foss": false}, {"Key": "WPFInstallmullvadvpn", "Id": "MullvadVPN.MullvadVPN", "Name": "Mullvad VPN", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Cliente oficial do serviço de VPN focado em privacidade estrita, com política auditada de zero registros (no-logs).", "Link": "https://mullvad.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mullvad.net/", "Foss": true}, {"Key": "WPFInstallmullvadbrowser", "Id": "MullvadVPN.MullvadBrowser", "Name": "Mullvad Browser", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador focado em privacidade máxima desenvolvido em parceria com o Tor Project para minimizar rastreamento e impressões digitais na web.", "Link": "https://mullvad.net/browser", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mullvad.net/browser", "Foss": true}, {"Key": "WPFInstallnomacs", "Id": "nomacs.nomacs", "Name": "nomacs", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Visualizador de imagens leve e de código aberto que sincroniza exibições entre instâncias e suporta formatos RAW e PSD.", "Link": "https://nomacs.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nomacs.org/", "Foss": true}, {"Key": "WPFInstallnanazip", "Id": "M2Team.NanaZip", "Name": "NanaZip", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Bifurcação moderna do 7-Zip integrada ao novo menu de contexto do Windows 11 com suporte a algoritmos avançados de compressão.", "Link": "https://nanazip.org", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nanazip.org", "Foss": true}, {"Key": "WPFInstallnetbird", "Id": "Netbird.Netbird", "Name": "NetBird", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Plataforma de código aberto para conectar dispositivos em uma rede privada ponto a ponto baseada em WireGuard com facilidade.", "Link": "https://netbird.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://netbird.io/", "Foss": true}, {"Key": "WPFInstalltailscale", "Id": "Tailscale.Tailscale", "Name": "Tailscale", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Rede privada virtual segura (VPN mesh) baseada em WireGuard que conecta todos os seus dispositivos de forma simples e imediata.", "Link": "https://tailscale.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://tailscale.com/", "Foss": false}, {"Key": "WPFInstallnaps2", "Id": "Cyanfish.NAPS2", "Name": "NAPS2 (Scanner)", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Programa simples e poderoso para digitalização de documentos e fotos com suporte a OCR, exportação em PDF e edição rápida.", "Link": "https://www.naps2.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.naps2.com/", "Foss": true}, {"Key": "WPFInstallneovim", "Id": "Neovim.Neovim", "Name": "Neovim", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Evolução moderna e altamente extensível do lendário editor de texto Vim, com suporte nativo a Lua e plugins assíncronos.", "Link": "https://neovim.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://neovim.io/", "Foss": true}, {"Key": "WPFInstallnextclouddesktop", "Id": "Nextcloud.NextcloudDesktop", "Name": "Nextcloud Desktop", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Cliente desktop de sincronização de arquivos para servidores Nextcloud, fornecendo sua própria nuvem privada de armazenamento.", "Link": "https://nextcloud.com/install/#install-clients", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nextcloud.com/install/#install-clients", "Foss": true}, {"Key": "WPFInstallnmap", "Id": "Insecure.Nmap", "Name": "Nmap", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Lendária ferramenta de segurança de redes para descoberta de hosts, escaneamento de portas e auditoria de vulnerabilidades.", "Link": "https://nmap.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nmap.org/", "Foss": true}, {"Key": "WPFInstallnodejs", "Id": "OpenJS.NodeJS", "Name": "NodeJS", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ambiente de execução JavaScript construído sobre o motor V8 do Google Chrome para desenvolvimento backend e aplicações web.", "Link": "https://nodejs.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nodejs.org/", "Foss": true}, {"Key": "WPFInstallnodejslts", "Id": "OpenJS.NodeJS.LTS", "Name": "NodeJS LTS", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Versão estável com Suporte de Longo Prazo (LTS) do Node.js, recomendada para servidores e projetos em produção.", "Link": "https://nodejs.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nodejs.org/", "Foss": true}, {"Key": "WPFInstallpnpm", "Id": "pnpm.pnpm", "Name": "pnpm", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Gerenciador de pacotes rápido e econômico em disco para JavaScript, utilizando links rígidos para não duplicar módulos.", "Link": "https://pnpm.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://pnpm.io/", "Foss": true}, {"Key": "WPFInstallnotepadplus", "Id": "Notepad++.Notepad++", "Name": "Notepad++", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Editor de texto e código fonte veloz para Windows com destaque de sintaxe para dezenas de linguagens, abas e plugins úteis.", "Link": "https://notepad-plus-plus.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://notepad-plus-plus.org/", "Foss": true}, {"Key": "WPFInstallnuget", "Id": "Microsoft.NuGet", "Name": "NuGet", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Gerenciador oficial de pacotes para o ecossistema .NET, essencial para desenvolvedores compartilharem e consumirem bibliotecas.", "Link": "https://www.nuget.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.nuget.org/", "Foss": true}, {"Key": "WPFInstallnvclean", "Id": "TechPowerUp.NVCleanstall", "Name": "NVCleanstall", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Permite personalizar a instalação dos drivers da NVIDIA, removendo telemetria indesejada e componentes dispensáveis.", "Link": "https://www.techpowerup.com/nvcleanstall/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.techpowerup.com/nvcleanstall/", "Foss": false}, {"Key": "WPFInstallobs", "Id": "OBSProject.OBSStudio", "Name": "OBS Studio", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Software padrão da indústria para gravação de tela e transmissões ao vivo na Twitch, YouTube e Facebook com mixagem de áudio e vídeo.", "Link": "https://obsproject.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://obsproject.com/", "Foss": true}, {"Key": "WPFInstallobsidian", "Id": "Obsidian.Obsidian", "Name": "Obsidian", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Poderoso gerenciador de notas e base de conhecimento pessoal baseado em arquivos Markdown locais com gráficos de conexões mentais.", "Link": "https://obsidian.md/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://obsidian.md/", "Foss": false}, {"Key": "WPFInstallokular", "Id": "KDE.Okular", "Name": "Okular", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Leitor universal de documentos do ecossistema KDE com suporte avançado a PDFs, quadrinhos (CBR/CBZ) e e-books.", "Link": "https://okular.kde.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://okular.kde.org/", "Foss": true}, {"Key": "WPFInstallonedrive", "Id": "Microsoft.OneDrive", "Name": "OneDrive", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Serviço oficial de armazenamento e sincronização em nuvem da Microsoft para backup de fotos, documentos e arquivos pessoais.", "Link": "https://onedrive.live.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://onedrive.live.com/", "Foss": false}, {"Key": "WPFInstallonlyoffice", "Id": "ONLYOFFICE.DesktopEditors", "Name": "ONLYOFFICE Desktop", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Suíte de escritório elegante com compatibilidade total para arquivos DOCX, XLSX e PPTX e colaboração em documentos.", "Link": "https://www.onlyoffice.com/desktop.aspx", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.onlyoffice.com/desktop.aspx", "Foss": true}, {"Key": "WPFInstallOPAutoClicker", "Id": "OPAutoClicker.OPAutoClicker", "Name": "OPAutoClicker", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Autoclicker leve e completo com opções de repetição dinâmica, posição fixa e atalhos de inicialização rápida.", "Link": "https://www.opautoclicker.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.opautoclicker.com", "Foss": false}, {"Key": "WPFInstallopenrgb", "Id": "OpenRGB.OpenRGB", "Name": "OpenRGB", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Software livre para controle de iluminação RGB de componentes e periféricos de múltiplos fabricantes sem precisar de programas pesados.", "Link": "https://openrgb.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://openrgb.org/", "Foss": true}, {"Key": "WPFInstallOpenVPN", "Id": "OpenVPNTechnologies.OpenVPNConnect", "Name": "OpenVPN Connect", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Cliente oficial de conexão segura do protocolo OpenVPN para criar túneis criptografados corporativos ou pessoais.", "Link": "https://openvpn.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://openvpn.net/", "Foss": false}, {"Key": "WPFInstallOVirtualBox", "Id": "Oracle.VirtualBox", "Name": "Oracle VirtualBox", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Plataforma de virtualização poderosa e gratuita para criar e rodar máquinas virtuais com Windows, Linux e outros sistemas.", "Link": "https://www.virtualbox.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.virtualbox.org/", "Foss": true}, {"Key": "WPFInstallpolicyplus", "Id": "Fleex255.PolicyPlus", "Name": "Policy Plus", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Editor de Diretivas de Grupo Local (gpedit) funcional para todas as edições do Windows, incluindo Windows Home.", "Link": "https://github.com/Fleex255/PolicyPlus", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/Fleex255/PolicyPlus", "Foss": true}, {"Key": "WPFInstallprocessexplorer", "Id": "Microsoft.Sysinternals.ProcessExplorer", "Name": "Process Explorer", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Substituto profissional do Gerenciador de Tarefas da SysInternals com detalhes avançados sobre DLLs, identificadores e processos.", "Link": "https://learn.microsoft.com/sysinternals/downloads/process-explorer", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://learn.microsoft.com/sysinternals/downloads/process-explorer", "Foss": false}, {"Key": "WPFInstallPaintdotnet", "Id": "dotPDN.PaintDotNet", "Name": "Paint.NET", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Editor de fotos e imagens intuitivo para Windows com suporte a camadas ilimitadas, efeitos visuais e ferramentas de desenho.", "Link": "https://www.getpaint.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.getpaint.net/", "Foss": false}, {"Key": "WPFInstallparsec", "Id": "Parsec.Parsec", "Name": "Parsec", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Software de desktop remoto e streaming para jogos com baixíssima latência e 60 FPS, perfeito para gameplay cooperativo à distância.", "Link": "https://parsec.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://parsec.app/", "Foss": false}, {"Key": "WPFInstallpeazip", "Id": "Giorgiotani.Peazip", "Name": "PeaZip", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador e descompactador de arquivos de código aberto com suporte a mais de 200 formatos e recursos robustos de criptografia.", "Link": "https://peazip.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://peazip.github.io/", "Foss": true}, {"Key": "WPFInstallpdf-xchange", "Id": "TrackerSoftware.PDF-XChangeEditor", "Name": "PDF-XChange Editor", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Editor avançado de PDF para Windows com recursos completos de edição de texto, anotações, OCR e assinatura digital.", "Link": "https://www.pdf-xchange.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.pdf-xchange.com/", "Foss": false}, {"Key": "WPFInstallpdf24creator", "Id": "geeksoftwareGmbH.PDF24Creator", "Name": "PDF24 Creator", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Conjunto completo e 100% gratuito de ferramentas de PDF: unir, dividir, comprimir, converter e proteger documentos.", "Link": "https://tools.pdf24.org/en/creator", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://tools.pdf24.org/en/creator", "Foss": false}, {"Key": "WPFInstallpdfgear", "Id": "PDFgear.PDFgear", "Name": "PDFgear", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Software moderno e gratuito de gerenciamento de PDF para ler, converter, mesclar, editar e assinar arquivos com recursos integrados de IA.", "Link": "https://www.pdfgear.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.pdfgear.com/", "Foss": false}, {"Key": "WPFInstallpdfsam", "Id": "PDFsam.PDFsam", "Name": "PDFsam Basic", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Utilitário gratuito e de código aberto para dividir, mesclar, girar e extrair páginas de arquivos PDF com facilidade.", "Link": "https://pdfsam.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://pdfsam.org/", "Foss": true}, {"Key": "WPFInstallplaynite", "Id": "Playnite.Playnite", "Name": "Playnite", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Gerenciador de biblioteca de jogos de código aberto que unifica suas contas da Steam, Epic, GOG, Battle.net e emuladores em uma interface fantástica.", "Link": "https://playnite.link/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://playnite.link/", "Foss": true}, {"Key": "WPFInstallplex", "Id": "Plex.PlexMediaServer", "Name": "Plex Media Server", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Servidor de mídia conceituado para organizar e transmitir filmes, séries e coleções pessoais para TVs, smartphones e navegadores.", "Link": "https://www.plex.tv/your-media/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.plex.tv/your-media/", "Foss": false}, {"Key": "WPFInstallplexdesktop", "Id": "Plex.Plex", "Name": "Plex Desktop", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Cliente desktop moderno do Plex projetado para navegar e assistir com máxima qualidade ao catálogo do seu servidor de mídia.", "Link": "https://www.plex.tv", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.plex.tv", "Foss": false}, {"Key": "WPFInstallposh", "Id": "JanDeDobbeleer.OhMyPosh", "Name": "Oh My Posh (Prompt)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Mecanismo completo de customização e temas visuais para terminais no PowerShell, CMD, Bash e WSL.", "Link": "https://ohmyposh.dev/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ohmyposh.dev/", "Foss": true}, {"Key": "WPFInstallpostman", "Id": "Postman.Postman", "Name": "Postman", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Plataforma líder para projetar, depurar, testar, automatizar e documentar requisições e APIs REST, GraphQL e WebSockets.", "Link": "https://www.postman.com/downloads/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.postman.com/downloads/", "Foss": false}, {"Key": "WPFInstallpowershell", "Id": "Microsoft.PowerShell", "Name": "PowerShell", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Console avançado e ambiente de automação multiplataforma moderno da Microsoft com suporte a scripts PowerShell 7+.", "Link": "https://github.com/PowerShell/PowerShell", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/PowerShell/PowerShell", "Foss": true}, {"Key": "WPFInstallpowertoys", "Id": "Microsoft.PowerToys", "Name": "PowerToys", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Pacote oficial de utilitários de produtividade da Microsoft (FancyZones, PowerRename, Color Picker, Awake, Text Extractor e mais).", "Link": "https://github.com/microsoft/PowerToys", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/microsoft/PowerToys", "Foss": true}, {"Key": "WPFInstallprismlauncher", "Id": "PrismLauncher.PrismLauncher", "Name": "Prism Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Launcher avançado e de código aberto para Minecraft com suporte a múltiplas instâncias, modpacks (CurseForge/Modrinth) e gerenciamento de Java.", "Link": "https://prismlauncher.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://prismlauncher.org/", "Foss": true}, {"Key": "WPFInstallprocesslasso", "Id": "BitSum.ProcessLasso", "Name": "Process Lasso", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Otimizador em tempo real de processos que impede travamentos do sistema (ProBalance) e ajusta afinidades e prioridades de CPU.", "Link": "https://bitsum.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://bitsum.com/", "Foss": false}, {"Key": "WPFInstallprotonauth", "Id": "Proton.ProtonAuthenticator", "Name": "Proton Authenticator", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Aplicativo de autenticação em duas etapas seguro da Proton com sincronização criptografada e backup protegido.", "Link": "https://proton.me/authenticator", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/authenticator", "Foss": true}, {"Key": "WPFInstallprotonmail", "Id": "Proton.ProtonMail", "Name": "Proton Mail", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Aplicativo oficial de e-mail seguro da Proton com criptografia ponta a ponta suíça e privacidade de acesso zero.", "Link": "https://proton.me/mail", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/mail", "Foss": true}, {"Key": "WPFInstallprotondrive", "Id": "Proton.ProtonDrive", "Name": "Proton Drive", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Armazenamento em nuvem com criptografia de ponta a ponta suíça para proteger seus arquivos contra acessos indevidos.", "Link": "https://proton.me/drive", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/drive", "Foss": true}, {"Key": "WPFInstallprotonpass", "Id": "Proton.ProtonPass", "Name": "Proton Pass", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador moderno de senhas da Proton com aliases de e-mail integrados para proteger sua identidade online.", "Link": "https://proton.me/pass", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://proton.me/pass", "Foss": true}, {"Key": "WPFInstallprotonvpn", "Id": "Proton.ProtonVPN", "Name": "Proton VPN", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Serviço suíço de VPN com foco em privacidade absoluta, política rigorosa de no-logs e tecnologia de proteção Secure Core.", "Link": "https://protonvpn.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://protonvpn.com/", "Foss": true}, {"Key": "WPFInstallprocessmonitor", "Id": "Microsoft.Sysinternals.ProcessMonitor", "Name": "Process Monitor", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Ferramenta de diagnóstico avançada da SysInternals para monitorar em tempo real atividades de registro, sistema de arquivos e processos.", "Link": "https://docs.microsoft.com/en-us/sysinternals/downloads/procmon", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://docs.microsoft.com/en-us/sysinternals/downloads/procmon", "Foss": false}, {"Key": "WPFInstallputty", "Id": "PuTTY.PuTTY", "Name": "PuTTY", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Cliente clássico e consagrado de SSH, Telnet e emulador de terminal serial para acesso e administração remota de servidores.", "Link": "https://www.chiark.greenend.org.uk/~sgtatham/putty/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.chiark.greenend.org.uk/~sgtatham/putty/", "Foss": true}, {"Key": "WPFInstallpython3", "Id": "Python.Python.3.14", "Name": "Python3", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Linguagem de programação versátil e popular para desenvolvimento web, ciência de dados, inteligência artificial, automação e scripts.", "Link": "https://www.python.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.python.org/", "Foss": true}, {"Key": "WPFInstallqbittorrent", "Id": "qBittorrent.qBittorrent", "Name": "qBittorrent", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Cliente BitTorrent gratuito, de código aberto e sem propagandas, com motor de busca de torrents e controle de banda integrado.", "Link": "https://www.qbittorrent.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.qbittorrent.org/", "Foss": true}, {"Key": "WPFInstallqownnotes", "Id": "pbek.QOwnNotes", "Name": "QOwnNotes", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Bloco de notas de código aberto em Markdown com suporte a integração de tarefas com Nextcloud e ownCloud.", "Link": "https://www.qownnotes.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.qownnotes.org/", "Foss": true}, {"Key": "WPFInstallqtox", "Id": "Tox.qTox", "Name": "QTox", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Aplicativo de mensagens P2P gratuito e de código aberto focado em privacidade, sem servidores centrais e com criptografia forte.", "Link": "https://qtox.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://qtox.github.io/", "Foss": true}, {"Key": "WPFInstallrevo", "Id": "RevoUninstaller.RevoUninstaller", "Name": "Revo Uninstaller", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Desinstalador avançado que força a remoção de programas difíceis e limpa sobras de chaves de registro e pastas residuais.", "Link": "https://www.revouninstaller.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.revouninstaller.com/", "Foss": false}, {"Key": "WPFInstallWiseProgramUninstaller", "Id": "WiseCleaner.WiseProgramUninstaller", "Name": "Wise Program Uninstaller (WiseCleaner)", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Desinstalador rápido e gratuito que remove programas indesejados e força a limpeza de arquivos residuais.", "Link": "https://www.wisecleaner.com/wise-program-uninstaller.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wisecleaner.com/wise-program-uninstaller.html", "Foss": false}, {"Key": "WPFInstallrufus", "Id": "Rufus.Rufus", "Name": "Rufus Imager", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Ferramenta definitiva e rápida para criar pendrives inicializáveis do Windows e Linux com opção de remover exigências do Windows 11.", "Link": "https://rufus.ie/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://rufus.ie/", "Foss": true}, {"Key": "WPFInstallrustlang", "Id": "Rustlang.Rust.MSVC", "Name": "Rust", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Linguagem de sistemas de altíssimo desempenho focada em segurança de memória e velocidade sem coletor de lixo.", "Link": "https://www.rust-lang.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.rust-lang.org/", "Foss": true}, {"Key": "WPFInstallsdio", "Id": "GlennDelahoy.SnappyDriverInstallerOrigin", "Name": "Snappy Driver Installer Origin", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Atualizador de drivers limpo, de código aberto e sem propagandas com imensa base de drivers para computadores Windows.", "Link": "https://www.glenn.delahoy.com/snappy-driver-installer-origin/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.glenn.delahoy.com/snappy-driver-installer-origin/", "Foss": true}, {"Key": "WPFInstallsharex", "Id": "ShareX.ShareX", "Name": "ShareX (Screenshots)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Ferramenta definitiva e gratuita para captura de tela, gravação de GIFs/vídeos, OCR e upload automático com atalhos personalizados.", "Link": "https://getsharex.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://getsharex.com/", "Foss": true}, {"Key": "WPFInstallnilesoftShell", "Id": "Nilesoft.Shell", "Name": "Nilesoft Shell", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Personalizador avançado do menu de contexto do Windows, adicionando novos comandos úteis e restaurando agilidade.", "Link": "https://nilesoft.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://nilesoft.org/", "Foss": false}, {"Key": "WPFInstallsysteminformer", "Id": "WinsiderSS.SystemInformer", "Name": "System Informer", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ferramenta avançada para monitorar processos do sistema, inspecionar uso de recursos, debugar programas e detectar ameaças.", "Link": "https://systeminformer.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://systeminformer.com/", "Foss": true}, {"Key": "WPFInstallsignal", "Id": "OpenWhisperSystems.Signal", "Name": "Signal", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Aplicativo de mensagens líder em privacidade, com criptografia de ponta a ponta inviolável para textos, chamadas e grupos.", "Link": "https://signal.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://signal.org/", "Foss": true}, {"Key": "WPFInstallsignalrgb", "Id": "WhirlwindFX.SignalRgb", "Name": "SignalRGB", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Controle centralizado e sincronizado de iluminação RGB para periféricos e componentes de marcas diferentes em um só painel.", "Link": "https://www.signalrgb.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.signalrgb.com/", "Foss": false}, {"Key": "WPFInstallsimplenote", "Id": "Automattic.Simplenote", "Name": "Simplenote", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Aplicativo minimalista para criar notas e listas rápidas com sincronização instantânea entre todos os seus dispositivos.", "Link": "https://simplenote.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://simplenote.com/", "Foss": true}, {"Key": "WPFInstallsimplewall", "Id": "Henry++.simplewall", "Name": "Simplewall", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Firewall simples e de código aberto para configurar a Filtragem de Plataforma do Windows (WFP) e bloquear tráfego indesejado.", "Link": "https://github.com/henrypp/simplewall", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/henrypp/simplewall", "Foss": true}, {"Key": "WPFInstallslack", "Id": "SlackTechnologies.Slack", "Name": "Slack", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Plataforma de colaboração corporativa e comunicação profissional organizada por canais, mensagens diretas e integração com ferramentas.", "Link": "https://slack.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://slack.com/", "Foss": false}, {"Key": "WPFInstallstartallback", "Id": "StartIsBack.StartAllBack", "Name": "StartAllBack", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Restaura e aprimora a barra de tarefas clássica, o Menu Iniciar e o Explorador de Arquivos no Windows 11 com alta fluidez.", "Link": "https://www.startallback.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.startallback.com/", "Foss": false}, {"Key": "WPFInstallstarship", "Id": "Starship.Starship", "Name": "Starship (Shell Prompt)", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Prompt minimalista, personalizável e ultrarrápido para qualquer terminal e shell do sistema.", "Link": "https://starship.rs/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://starship.rs/", "Foss": true}, {"Key": "WPFInstallsteam", "Id": "Valve.Steam", "Name": "Steam", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "A maior plataforma de distribuição de jogos para PC do mundo, com loja completa, conquistas, jogos online, oficina de mods e comunidade.", "Link": "https://store.steampowered.com/about/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://store.steampowered.com/about/", "Foss": false}, {"Key": "WPFInstallroblox", "Id": "Roblox.Roblox", "Name": "Roblox", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Plataforma global imersiva de jogos e metaverso onde milhões de usuários criam e compartilham mundos virtuais interativos.", "Link": "https://www.roblox.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.roblox.com/", "Foss": false}, {"Key": "WPFInstallsublimetext", "Id": "SublimeHQ.SublimeText.4", "Name": "Sublime Text", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Editor de código leve e sofisticado, famoso pela velocidade de abertura, atalhos de edição múltipla e syntax highlighting.", "Link": "https://www.sublimetext.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.sublimetext.com/", "Foss": false}, {"Key": "WPFInstallsumatra", "Id": "SumatraPDF.SumatraPDF", "Name": "Sumatra PDF", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Leitor de PDF, eBook (ePub, MOBI) e quadrinhos ultraleve e minimalista que abre arquivos instantaneamente sem pesar no PC.", "Link": "https://www.sumatrapdfreader.org/free-pdf-reader.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.sumatrapdfreader.org/free-pdf-reader.html", "Foss": true}, {"Key": "WPFInstallsunshine", "Id": "LizardByte.Sunshine", "Name": "Sunshine/GameStream Server", "Category": "☁️ Ferramentas Self-Hosted", "RawCategory": "Selfhosted Tools", "Description": "Servidor de GameStream de código aberto e baixa latência para transmitir jogos do seu PC para o Moonlight em TVs, celulares ou notebooks.", "Link": "https://app.lizardbyte.dev/Sunshine/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://app.lizardbyte.dev/Sunshine/", "Foss": true}, {"Key": "WPFInstalltcpview", "Id": "Microsoft.Sysinternals.TCPView", "Name": "TCPView", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Ferramenta da SysInternals que exibe a lista completa de conexões ativas de rede TCP e UDP em tempo real com identificação de programas.", "Link": "https://docs.microsoft.com/en-us/sysinternals/downloads/tcpview", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://docs.microsoft.com/en-us/sysinternals/downloads/tcpview", "Foss": false}, {"Key": "WPFInstallteams", "Id": "Microsoft.Teams", "Name": "Teams", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Plataforma oficial da Microsoft para reuniões de vídeo, chamadas corporativas, chat e colaboração integrada ao Office 365.", "Link": "https://www.microsoft.com/en-us/microsoft-teams/group-chat-software", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.microsoft.com/en-us/microsoft-teams/group-chat-software", "Foss": false}, {"Key": "WPFInstallteamviewer", "Id": "TeamViewer.TeamViewer", "Name": "TeamViewer", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Software tradicional para suporte técnico remoto, controle de computadores à distância e reuniões online com conexão segura.", "Link": "https://www.teamviewer.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.teamviewer.com/", "Foss": false}, {"Key": "WPFInstallteamspeak3", "Id": "TeamSpeakSystems.TeamSpeakClient", "Name": "TeamSpeak 3", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Tradicional software de comunicação por voz para equipes e jogos online, com áudio nítido, baixíssima latência e segurança robusta.", "Link": "https://www.teamspeak.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.teamspeak.com/", "Foss": false}, {"Key": "WPFInstallteamspeak6", "Id": "TeamSpeakSystems.TeamSpeakClient.Beta.6", "Name": "TeamSpeak 6", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Nova geração do TeamSpeak com interface moderna, recursos atualizados de chat e a lendária estabilidade de voz em baixa latência.", "Link": "https://www.teamspeak.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.teamspeak.com/", "Foss": false}, {"Key": "WPFInstalltelegram", "Id": "Telegram.TelegramDesktop", "Name": "Telegram", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Mensageiro em nuvem rápido, seguro e versátil, com suporte a grandes canais, grupos, envio de arquivos pesados e chamadas.", "Link": "https://telegram.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://telegram.org/", "Foss": true}, {"Key": "WPFInstallterminal", "Id": "Microsoft.WindowsTerminal", "Name": "Windows Terminal", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Aplicativo de terminal moderno, rápido e com abas para PowerShell, Prompt de Comando e WSL, personalizável com temas e fontes.", "Link": "https://aka.ms/terminal", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://aka.ms/terminal", "Foss": true}, {"Key": "WPFInstallthunderbird", "Id": "Mozilla.Thunderbird", "Name": "Thunderbird", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Gerenciador profissional e gratuito de e-mails, calendários e contatos da Mozilla, seguro e altamente configurável.", "Link": "https://www.thunderbird.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.thunderbird.net/", "Foss": true}, {"Key": "WPFInstallbetterbird", "Id": "Betterbird.Betterbird", "Name": "Betterbird", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Versão aprimorada do Mozilla Thunderbird com recursos exclusivos, correções de bugs antecipadas e melhor desempenho de e-mails.", "Link": "https://www.betterbird.eu/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.betterbird.eu/", "Foss": true}, {"Key": "WPFInstalltor", "Id": "TorProject.TorBrowser", "Name": "Tor Browser", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador desenvolvido para navegação anônima na internet, roteando o tráfego pela rede descentralizada Tor para total sigilo.", "Link": "https://www.torproject.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.torproject.org/", "Foss": true}, {"Key": "WPFInstalltotalcommander", "Id": "Ghisler.TotalCommander", "Name": "Total Commander", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador clássico de arquivos em painel duplo para Windows com comandos rápidos, cliente FTP embutido e busca avançada.", "Link": "https://www.ghisler.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.ghisler.com/", "Foss": false}, {"Key": "WPFInstalltreesize", "Id": "JAMSoftware.TreeSize.Free", "Name": "TreeSize Free", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Analisador rápido de espaço em disco que visualiza pastas e arquivos que mais ocupam memória no seu HD ou SSD.", "Link": "https://www.jam-software.com/treesize_free/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.jam-software.com/treesize_free/", "Foss": false}, {"Key": "WPFInstallttaskbar", "Id": "CharlesMilette.TranslucentTB", "Name": "TranslucentTB", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Utilitário que torna a barra de tarefas do Windows transparente, translúcida ou com efeito acrílico elegante.", "Link": "https://translucenttb.github.io", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://translucenttb.github.io", "Foss": true}, {"Key": "WPFInstallubisoft", "Id": "Ubisoft.Connect", "Name": "Ubisoft Connect", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Ecossistema oficial da Ubisoft para compra, download, recompensas e gerenciamento de jogos das franquias Assassin's Creed, Far Cry e Rainbow Six.", "Link": "https://ubisoftconnect.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://ubisoftconnect.com/", "Foss": false}, {"Key": "WPFInstallungoogled", "Id": "eloston.ungoogled-chromium", "Name": "Ungoogled Chromium", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Variante do Chromium totalmente limpa de serviços, telemetria e dependências da Google para quem busca privacidade e controle total.", "Link": "https://github.com/Eloston/ungoogled-chromium", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/Eloston/ungoogled-chromium", "Foss": true}, {"Key": "WPFInstallunity", "Id": "Unity.UnityHub", "Name": "Unity Game Engine", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Motor líder mundial de desenvolvimento de jogos em 2D, 3D, realidade virtual (VR) e realidade aumentada (AR).", "Link": "https://unity.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://unity.com/", "Foss": false}, {"Key": "WPFInstallvagrant", "Id": "Hashicorp.Vagrant", "Name": "Vagrant", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ferramenta para criar e configurar ambientes virtuais de desenvolvimento reprodutíveis e portáteis de forma declarativa.", "Link": "https://developer.hashicorp.com/vagrant", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://developer.hashicorp.com/vagrant", "Foss": false}, {"Key": "WPFInstalleverything", "Id": "voidtools.Everything", "Name": "Everything", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Motor de busca instantânea para o Windows que localiza qualquer arquivo ou pasta no computador em milissegundos enquanto você digita.", "Link": "https://www.voidtools.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.voidtools.com/", "Foss": false}, {"Key": "WPFInstallvc2015_32", "Id": "Microsoft.VCRedist.2015+.x86", "Name": "Visual C++ 2015-2022 32-bit", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Pacote redistribuível de bibliotecas de tempo de execução da Microsoft essencial para o funcionamento de jogos e aplicativos de 32 bits.", "Link": "https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "Foss": false}, {"Key": "WPFInstallvc2015_64", "Id": "Microsoft.VCRedist.2015+.x64", "Name": "Visual C++ 2015-2022 64-bit", "Category": "🧰 Ferramentas Microsoft", "RawCategory": "Microsoft Tools", "Description": "Pacote redistribuível de bibliotecas de tempo de execução da Microsoft essencial para o funcionamento de jogos e aplicativos de 64 bits.", "Link": "https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads", "Foss": false}, {"Key": "WPFInstallventoy", "Id": "Ventoy.Ventoy", "Name": "Ventoy", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Ferramenta fantástica para criar pendrives inicializáveis multiboot apenas copiando arquivos ISO diretamente para a unidade.", "Link": "https://www.ventoy.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.ventoy.net/", "Foss": true}, {"Key": "WPFInstallvesktop", "Id": "Vencord.Vesktop", "Name": "Vesktop", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Cliente desktop aprimorado para Discord com Vencord pré-instalado, oferecendo maior fluidez e suporte avançado a plugins e temas.", "Link": "https://vesktop.dev", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://vesktop.dev", "Foss": true}, {"Key": "WPFInstallviber", "Id": "Rakuten.Viber", "Name": "Viber", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Aplicativo de mensagens e chamadas de voz e vídeo com criptografia ponta a ponta e recursos para conversas em grupo.", "Link": "https://www.viber.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.viber.com/", "Foss": false}, {"Key": "WPFInstallvisualstudio2022", "Id": "Microsoft.VisualStudio.2022.Community", "Name": "Visual Studio 2022", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "IDE profissional e completa da Microsoft para desenvolvimento empresarial em C#, .NET, C++ e Azure.", "Link": "https://visualstudio.microsoft.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://visualstudio.microsoft.com/", "Foss": false}, {"Key": "WPFInstallvisualstudio2026", "Id": "Microsoft.VisualStudio.Community", "Name": "Visual Studio 2026", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ambiente de desenvolvimento integrado de última geração da Microsoft para criação e implantação de aplicações corporativas.", "Link": "https://visualstudio.microsoft.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://visualstudio.microsoft.com/", "Foss": false}, {"Key": "WPFInstallvivaldi", "Id": "Vivaldi.Vivaldi", "Name": "Vivaldi", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador extremamente personalizável para usuários exigentes, com organização de guias em dois níveis, painéis laterais e ferramentas integradas.", "Link": "https://vivaldi.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://vivaldi.com/", "Foss": false}, {"Key": "WPFInstallvlc", "Id": "VideoLAN.VLC", "Name": "VLC (Video Player)", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Famoso reprodutor de mídia livre e multiplataforma capaz de reproduzir praticamente qualquer arquivo de vídeo, áudio, disco ou streaming sem codecs extras.", "Link": "https://www.videolan.org/vlc/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.videolan.org/vlc/", "Foss": true}, {"Key": "WPFInstallvrdesktopstreamer", "Id": "VirtualDesktop.Streamer", "Name": "Virtual Desktop Streamer", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Aplicativo para transmitir a tela do PC e jogos VR com baixíssima latência e alta fidelidade visual para headsets VR.", "Link": "https://www.vrdesktop.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.vrdesktop.net/", "Foss": false}, {"Key": "WPFInstallvscode", "Id": "Microsoft.VisualStudioCode", "Name": "VS Code", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Editor de código fonte líder de mercado da Microsoft, com ecossistema massivo de extensões, depuração e Git integrado.", "Link": "https://code.visualstudio.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://code.visualstudio.com/", "Foss": true}, {"Key": "WPFInstallvscodium", "Id": "VSCodium.VSCodium", "Name": "VS Codium", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Distribuição 100% livre e de código aberto do VS Code, compilada sem telemetria e sem rastreadores da Microsoft.", "Link": "https://vscodium.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://vscodium.com/", "Foss": true}, {"Key": "WPFInstallwaterfox", "Id": "Waterfox.Waterfox", "Name": "Waterfox", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador rápido e ético baseado no Firefox, projetado para preservar a liberdade de escolha do usuário sem telemetria desnecessária.", "Link": "https://www.waterfox.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.waterfox.net/", "Foss": true}, {"Key": "WPFInstallwhatsapp", "Id": "msstore:9NKSQGP7F2NH", "Name": "WhatsApp Desktop", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Aplicativo oficial para Windows do mensageiro mais popular do mundo, sincronizado com o celular para conversas e chamadas.", "Link": "https://www.whatsapp.com/download", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.whatsapp.com/download", "Foss": false}, {"Key": "WPFInstallwingetui", "Id": "Devolutions.UniGetUI", "Name": "UniGetUI", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Interface gráfica unificada para gerenciar e atualizar programas via WinGet, Chocolatey, Scoop, Pip e outros gerenciadores.", "Link": "https://devolutions.net/unigetui/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://devolutions.net/unigetui/", "Foss": true}, {"Key": "WPFInstallwinrar", "Id": "RARLab.WinRAR", "Name": "WinRAR", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Lendário compactador de arquivos para Windows com suporte nativo à criação e extração de arquivos nos formatos RAR e ZIP.", "Link": "https://www.win-rar.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.win-rar.com/", "Foss": false}, {"Key": "WPFInstallwinscp", "Id": "WinSCP.WinSCP", "Name": "WinSCP", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Cliente gratuito e popular de SFTP, FTP e SCP para Windows, ideal para transferência segura de arquivos para servidores remotos.", "Link": "https://winscp.net/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://winscp.net/", "Foss": true}, {"Key": "WPFInstallwireguard", "Id": "WireGuard.WireGuard", "Name": "WireGuard", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "Protocolo de VPN moderno, extremamente rápido e seguro, com código simplificado e menor consumo de processamento.", "Link": "https://www.wireguard.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wireguard.com/", "Foss": true}, {"Key": "WPFInstallwireshark", "Id": "WiresharkFoundation.Wireshark", "Name": "Wireshark", "Category": "⚡ Ferramentas Pro & Redes", "RawCategory": "Pro Tools", "Description": "O mais importante analisador de protocolos e tráfego de rede do mundo para solução de problemas e auditorias de pacotes.", "Link": "https://www.wireshark.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.wireshark.org/", "Foss": true}, {"Key": "WPFInstallwiztree", "Id": "AntibodySoftware.WizTree", "Name": "WizTree", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "O mais veloz analisador de espaço em disco para Windows, capaz de ler a MFT em segundos para mostrar o uso do drive.", "Link": "https://wiztreefree.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://wiztreefree.com/", "Foss": false}, {"Key": "WPFInstallxeheditor", "Id": "MHNexus.HxD", "Name": "HxD Hex Editor", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Editor hexadecimal gratuito e rápido para visualizar, editar e inspecionar dados binários e memória de processos.", "Link": "https://mh-nexus.de/en/hxd/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://mh-nexus.de/en/hxd/", "Foss": false}, {"Key": "WPFInstallxournal", "Id": "Xournal++.Xournal++", "Name": "Xournal++", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Software de código aberto para escrita à mão, anotações manuscritas e preenchimento de documentos PDF com suporte a mesas digitalizadoras.", "Link": "https://xournalpp.github.io/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://xournalpp.github.io/", "Foss": true}, {"Key": "WPFInstallyarn", "Id": "Yarn.Yarn", "Name": "Yarn", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Gerenciador de pacotes confiável e veloz para ecossistemas JavaScript e Node.js com cache eficiente e resolução de dependências.", "Link": "https://yarnpkg.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://yarnpkg.com/", "Foss": true}, {"Key": "WPFInstallzoom", "Id": "Zoom.Zoom", "Name": "Zoom", "Category": "💬 Comunicação", "RawCategory": "Communications", "Description": "Solução completa e conceituada para reuniões virtuais, videoconferências corporativas, aulas e webinars online.", "Link": "https://zoom.us/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://zoom.us/", "Foss": false}, {"Key": "WPFInstalluv", "Id": "astral-sh.uv", "Name": "uv", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Gerenciador ultrarrápido de pacotes e projetos Python escrito em Rust, substituindo pip e virtualenv com velocidade até 100x maior.", "Link": "https://docs.astral.sh/uv/getting-started/installation/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://docs.astral.sh/uv/getting-started/installation/", "Foss": true}, {"Key": "WPFInstalltightvnc", "Id": "GlavSoft.TightVNC", "Name": "TightVNC", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Software livre de controle remoto VNC para visualizar e comandar a área de trabalho de outros computadores na rede.", "Link": "https://www.tightvnc.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.tightvnc.com/", "Foss": true}, {"Key": "WPFInstallglazewm", "Id": "glzr-io.glazewm", "Name": "GlazeWM", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Gerenciador de janelas lado a lado (tiling window manager) para Windows inspirado no i3 e Polybar para máxima produtividade.", "Link": "https://github.com/glzr-io/glazewm", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/glzr-io/glazewm", "Foss": true}, {"Key": "WPFInstallOverwolf", "Id": "Overwolf.CurseForge", "Name": "Overwolf", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Plataforma para overlays em tempo real, gravadores de jogadas e aplicativos complementares (mod managers, estatísticas e guias) durante partidas.", "Link": "https://www.overwolf.com/app/overwolf-curseforge", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.overwolf.com/app/overwolf-curseforge", "Foss": false}, {"Key": "WPFInstallOFGB", "Id": "xM4ddy.OFGB", "Name": "OFGB (Oh Frick Go Back)", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Ferramenta gráfica simples e direta para remover anúncios e propagandas embutidas em diversos pontos do Windows 11.", "Link": "https://github.com/xM4ddy/OFGB", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/xM4ddy/OFGB", "Foss": true}, {"Key": "WPFInstallZenBrowser", "Id": "Zen-Team.Zen-Browser", "Name": "Zen Browser", "Category": "🌐 Navegadores", "RawCategory": "Browsers", "Description": "Navegador moderno, minimalista e ultrarrápido baseado no Firefox, com abas verticais, espaços de trabalho e design elegante.", "Link": "https://zen-browser.app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://zen-browser.app/", "Foss": true}, {"Key": "WPFInstallZed", "Id": "ZedIndustries.Zed", "Name": "Zed", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Editor de código de alta performance escrito em Rust com renderização acelerada por GPU e colaboração em tempo real.", "Link": "https://zed.dev/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://zed.dev/", "Foss": true}, {"Key": "WPFInstallzotero", "Id": "DigitalScholar.Zotero", "Name": "Zotero", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Ferramenta gratuita para coleta, organização, citação bibliográfica e compartilhamento de fontes de pesquisas acadêmicas.", "Link": "https://www.zotero.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.zotero.org/", "Foss": true}, {"Key": "WPFInstalldeskflow", "Id": "Deskflow.Deskflow", "Name": "Deskflow", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Software KVM livre que permite controlar múltiplos computadores utilizando apenas um teclado e mouse compartilhados pela rede.", "Link": "https://github.com/deskflow/deskflow", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/deskflow/deskflow", "Foss": true}, {"Key": "WPFInstallRuby", "Id": "RubyInstallerTeam.Ruby.4.0", "Name": "Ruby", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ambiente de execução completo da linguagem Ruby com ferramentas de desenvolvimento MSYS2 no Windows.", "Link": "https://rubyinstaller.org/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://rubyinstaller.org/", "Foss": true}, {"Key": "WPFInstallLua", "Id": "rjpcomputing.luaforwindows", "Name": "Lua", "Category": "💻 Desenvolvimento", "RawCategory": "Development", "Description": "Ambiente de execução completo para a linguagem de script Lua no Windows, incluindo binários essenciais e bibliotecas.", "Link": "https://github.com/rjpcomputing/luaforwindows", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/rjpcomputing/luaforwindows", "Foss": true}, {"Key": "WPFInstallCloudflareWARP", "Id": "Cloudflare.Warp", "Name": "Cloudflare WARP", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Serviço de navegação otimizada e segura da Cloudflare que criptografa conexões DNS e melhora o roteamento de internet (1.1.1.1).", "Link": "https://one.one.one.one", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://one.one.one.one", "Foss": false}, {"Key": "WPFInstallExitLag", "Id": "ExitLag.Installer", "Name": "ExitLag", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Otimizador de rotas e conexões de rede para jogos online. Reduz ping, packet loss e elimina congelamentos.", "Link": "https://www.exitlag.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.exitlag.com/", "DownloadUrl": "https://cdn.exitlag.com/SetupExitLag-5.23.1-x64.exe", "InstallArgs": "/SILENT /VERYSILENT /NORESTART", "Foss": false}, {"Key": "WPFInstallNvidiaApp", "Id": "Nvidia.App", "Name": "NVIDIA App", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Software oficial moderno da NVIDIA que substitui o GeForce Experience e Painel de Controle. Gerencia drivers Game Ready/Studio, otimiza jogos e recursos gráficos.", "Link": "https://www.nvidia.com/pt-br/software/nvidia-app/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.nvidia.com", "DownloadUrl": "https://us.download.nvidia.com/nvapp/client/11.0.9.251/NVIDIA_app_v11.0.9.251.exe", "InstallArgs": "-s", "Foss": false}, {"Key": "WPFInstallAmdSoftware", "Id": "AMD.Software.Adrenalin", "Name": "AMD Software: Adrenalin Edition", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Software e driver oficial da AMD para placas de vídeo Radeon. Gerencia atualizações de drivers, métricas de FPS, Radeon Anti-Lag, RSR e ajustes de desempenho.", "Link": "https://www.amd.com/pt/products/software/adrenalin.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.amd.com", "DownloadUrl": "https://drivers.amd.com/drivers/installer/26.10/whql/amd-software-adrenalin-edition-26.8.1-minimalsetup-260818_web.exe", "InstallArgs": "/install /quiet /noreboot", "Foss": false}, {"Key": "WPFInstallHydraLauncher", "Id": "HydraLauncher.Hydra", "Name": "Hydra Launcher", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Launcher de jogos open-source com cliente BitTorrent embutido, biblioteca unificada, metadados HowLongToBeat e suporte a emuladores.", "Link": "https://github.com/hydralauncher/hydra", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://github.com/hydralauncher/hydra", "Foss": true}, {"Key": "WPFInstallMalwarebytes", "Id": "Malwarebytes.Malwarebytes", "Name": "Malwarebytes Anti-Malware", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Líder mundial na detecção e eliminação de vírus resistentes, trojans, ransomwares, spyware e malwares ocultos.", "Link": "https://www.malwarebytes.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.malwarebytes.com", "Foss": false}, {"Key": "WPFInstallAdwCleaner", "Id": "Malwarebytes.AdwCleaner", "Name": "Malwarebytes AdwCleaner", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Ferramenta gratuita essencial pós-formatação para eliminar adwares, sequestradores de navegador, barras invasivas e PUPs indesejados.", "Link": "https://www.malwarebytes.com/adwcleaner", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.malwarebytes.com", "Foss": false}, {"Key": "WPFInstallBitdefender", "Id": "Bitdefender.Bitdefender", "Name": "Bitdefender Antivirus Agent", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Solução de ponta em cibersegurança com proteção multicamadas em tempo real contra malwares, ransomware e ameaças de rede.", "Link": "https://www.bitdefender.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.bitdefender.com", "Foss": false}, {"Key": "WPFInstallKaspersky", "Id": "Kaspersky.Security", "Name": "Kaspersky Free / Standard", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Antivírus consagrado da Kaspersky com proteção em tempo real, monitor comportamental Inspetor do Sistema e proteção web.", "Link": "https://www.kaspersky.com.br/free-antivirus", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.kaspersky.com.br", "DownloadUrl": "https://devbuilds.s.kaspersky-labs.com/fast/smartinstaller/windows/kasperskyinstaller.exe", "InstallArgs": "/s", "Foss": false}, {"Key": "WPFInstallKvrt", "Id": "Kaspersky.KVRT", "Name": "Kaspersky Virus Removal Tool (KVRT)", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Scanner portátil oficial gratuito da Kaspersky para desinfecção rápida e remoção completa de vírus e rootkits sem necessidade de instalação.", "Link": "https://www.kaspersky.com.br/downloads/free-virus-removal-tool", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.kaspersky.com.br", "DownloadUrl": "https://devbuilds.s.kaspersky-labs.com/kvrt/latest/full/kvrt.exe", "InstallArgs": "-dontinstall", "Foss": false}, {"Key": "WPFInstallspotify", "Id": "Spotify.Spotify", "Name": "Spotify Music", "Category": "🎨 Multimídia & Design", "RawCategory": "Multimedia Tools", "Description": "Plataforma oficial de streaming com milhões de músicas, playlists personalizadas e podcasts sob demanda.", "Link": "https://www.spotify.com", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.spotify.com", "Foss": false}, {"Key": "WPFInstallEset", "Id": "ESET.Nod32", "Name": "ESET NOD32 Antivirus", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Antivírus ultraleve de alta precisão com motor LiveGrid. Bloqueia ameaças avançadas mantendo máxima velocidade no computador.", "Link": "https://www.eset.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.eset.com", "Foss": false}, {"Key": "WPFInstallDefenderUI", "Id": "VoodooSoft.DefenderUI", "Name": "DefenderUI (Controle Windows Defender)", "Category": "🛡️ Segurança & Antivírus", "RawCategory": "Security", "Description": "Interface moderna para o Windows Defender nativo. Desbloqueia perfis de proteção avançados e recursos ocultos de segurança.", "Link": "https://www.cyberlock.tech/defenderui.html", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.cyberlock.tech", "Foss": false}, {"Key": "WPFInstallSignalRgb", "Id": "WhirlwindFX.SignalRgb", "Name": "SignalRGB", "Category": "🛠️ Utilitários do Sistema", "RawCategory": "Utilities", "Description": "Controle e sincronização avançada de iluminação RGB para periféricos, placas-mãe, placas de vídeo e coolers.", "Link": "https://www.signalrgb.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://www.signalrgb.com", "Foss": false}, {"Key": "WPFInstallGoogleDrive", "Id": "Google.GoogleDrive", "Name": "Google Drive", "Category": "📄 Documentos & Escritório", "RawCategory": "Document", "Description": "Aplicativo oficial de desktop do Google Drive para sincronização na nuvem e acesso a arquivos locais.", "Link": "https://www.google.com/drive/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://drive.google.com", "Foss": false}, {"Key": "WPFInstallamazongames", "Id": "Amazon.Games", "Name": "Amazon Games", "Category": "🎮 Jogos & Launchers", "RawCategory": "Games", "Description": "Launcher oficial de jogos da Amazon para PC. Permite resgatar, baixar e jogar títulos mensais e conteúdos exclusivos do Prime Gaming.", "Link": "https://gaming.amazon.com/", "IconUrl": "https://www.google.com/s2/favicons?sz=64&domain_url=https://gaming.amazon.com", "Foss": false}]
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
# 3.1 CARREGAMENTO DO LOGO DA APLICAÇÃO (OFFLINE/REMOTO)
# -------------------------------------------------------------------------
$Global:AppLogoBitmap = $null
$Global:AppLogoBase64 = "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"

try {
    $logoBytes = $null
    $localLogoPng = if ($PSScriptRoot) { Join-Path $PSScriptRoot "assets\logo.png" } else { "assets\logo.png" }
    $localLogoJpg = if ($PSScriptRoot) { Join-Path $PSScriptRoot "assets\logo.jpg" } else { "assets\logo.jpg" }

    if (Test-Path $localLogoPng) {
        $logoBytes = [System.IO.File]::ReadAllBytes($localLogoPng)
    } elseif (Test-Path $localLogoJpg) {
        $logoBytes = [System.IO.File]::ReadAllBytes($localLogoJpg)
    } elseif (-not [string]::IsNullOrWhiteSpace($Global:AppLogoBase64)) {
        $logoBytes = [System.Convert]::FromBase64String($Global:AppLogoBase64.Trim())
    }

    if ($logoBytes -and $logoBytes.Length -gt 0) {
        $ms = New-Object System.IO.MemoryStream(,$logoBytes)
        $bmp = New-Object System.Windows.Media.Imaging.BitmapImage
        $bmp.BeginInit()
        $bmp.StreamSource = $ms
        $bmp.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $bmp.EndInit()
        $bmp.Freeze()
        $Global:AppLogoBitmap = $bmp
    }
} catch {
    # Carregamento resiliente da logo sem interromper execução
}

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
        <!-- Cores e Pincéis Dinâmicos do Sistema de Temas (5 Temas Suportados - Padrão: ☀️ Claro) -->
        <SolidColorBrush x:Key="BgWindow" Color="#F1F5F9" />
        <SolidColorBrush x:Key="BgCard" Color="#FFFFFF" />
        <SolidColorBrush x:Key="BgCardHover" Color="#F8FAFC" />
        <SolidColorBrush x:Key="BorderCard" Color="#CBD5E1" />
        <SolidColorBrush x:Key="AccentColor" Color="#4F46E5" />
        <SolidColorBrush x:Key="AccentHover" Color="#4338CA" />
        <SolidColorBrush x:Key="AccentGreen" Color="#059669" />
        <SolidColorBrush x:Key="AccentAmber" Color="#D97706" />
        <SolidColorBrush x:Key="TextPrimary" Color="#0F172A" />
        <SolidColorBrush x:Key="TextSecondary" Color="#475569" />
        <SolidColorBrush x:Key="TextSelected" Color="#0F172A" />
        <SolidColorBrush x:Key="ChkCardBg" Color="#FFFFFF" />
        <SolidColorBrush x:Key="ChkCardBorder" Color="#CBD5E1" />
        <SolidColorBrush x:Key="ChkBoxBg" Color="#F8FAFC" />
        <SolidColorBrush x:Key="ChkBoxBorder" Color="#94A3B8" />
        <SolidColorBrush x:Key="ChkSelectedCardBg" Color="#EEF2FF" />
        <SolidColorBrush x:Key="ChkSelectedCardBorder" Color="#6366F1" />
        <SolidColorBrush x:Key="ChkSelectedBoxBg" Color="#4F46E5" />
        <SolidColorBrush x:Key="ChkSelectedBoxBorder" Color="#312E81" />
        <SolidColorBrush x:Key="ChkActivePill" Color="#4F46E5" />
        <SolidColorBrush x:Key="BtnSecondaryBg" Color="#E2E8F0" />
        <SolidColorBrush x:Key="BtnSecondaryFg" Color="#1E293B" />
        <SolidColorBrush x:Key="BtnSecondaryBorder" Color="#CBD5E1" />
        <SolidColorBrush x:Key="SearchBg" Color="#FFFFFF" />
        <SolidColorBrush x:Key="SearchText" Color="#0F172A" />
        <SolidColorBrush x:Key="SearchBorder" Color="#CBD5E1" />
        <SolidColorBrush x:Key="TerminalBg" Color="#0F172A" />
        <SolidColorBrush x:Key="TerminalText" Color="#38BDF8" />
        <SolidColorBrush x:Key="ProgressBg" Color="#E2E8F0" />
        <SolidColorBrush x:Key="BadgeBg" Color="#EEF2FF" />
        <SolidColorBrush x:Key="BadgeBorder" Color="#6366F1" />
        <SolidColorBrush x:Key="BadgeText" Color="#4338CA" />
        <SolidColorBrush x:Key="AccentTitle1" Color="#4F46E5" />
        <SolidColorBrush x:Key="AccentTitle2" Color="#0284C7" />
        <SolidColorBrush x:Key="AccentTitle3" Color="#D97706" />

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

        <!-- Botão Buy Me a Coffee (Apoiar Projeto) -->
        <Style x:Key="BtnCoffee" TargetType="Button">
            <Setter Property="Background" Value="#FFDD00" />
            <Setter Property="Foreground" Value="#000000" />
            <Setter Property="BorderBrush" Value="#E5C700" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="FontWeight" Value="Bold" />
            <Setter Property="Padding" Value="12,6" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="FontSize" Value="12" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="BrdCoffee" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="BrdCoffee" Property="Background" Value="#FFE853" />
                                <Setter TargetName="BrdCoffee" Property="BorderBrush" Value="#CCA900" />
                            </Trigger>
                        </ControlTemplate.Triggers>
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
                <ColumnDefinition Width="Auto" />
                <ColumnDefinition Width="*" />
            </Grid.ColumnDefinitions>

            <StackPanel Grid.Column="0" Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,16,0">
                <Border Name="BdrAppLogo" Width="52" Height="52" CornerRadius="12" Margin="0,0,14,0" Background="#060810" BorderBrush="{DynamicResource AccentColor}" BorderThickness="1.5" Cursor="Hand" ToolTip="Igor Anjos (ianjos1993) • Clique para abrir no GitHub">
                    <Border.OpacityMask>
                        <VisualBrush>
                            <VisualBrush.Visual>
                                <Border Width="52" Height="52" CornerRadius="12" Background="Black" />
                            </VisualBrush.Visual>
                        </VisualBrush>
                    </Border.OpacityMask>
                    <Image Name="ImgAppLogo" Width="52" Height="52" Stretch="Uniform" RenderOptions.BitmapScalingMode="HighQuality" />
                </Border>
                <StackPanel VerticalAlignment="Center">
                    <TextBlock Text="🚀 Setup Pós-Formatação Windows" FontSize="20" FontWeight="Bold" Foreground="{DynamicResource TextPrimary}" />
                    <TextBlock Text="247 Aplicativos com Ícones Oficiais • Pack PC Gamer • Otimizações &amp; Tweaks" FontSize="12.5" Foreground="{DynamicResource TextSecondary}" Margin="0,3,0,0" />
                </StackPanel>
            </StackPanel>

            <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center" HorizontalAlignment="Right">
                <!-- Seletor de Temas (5 Temas: Escuro, Claro, Cyberpunk, Nord, Esmeralda) -->
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,8,0">
                    <TextBlock Text="🎨 Tema:" FontSize="12" FontWeight="SemiBold" Foreground="{DynamicResource TextSecondary}" VerticalAlignment="Center" Margin="0,0,6,0" />
                    <ComboBox Name="CmbThemeSelector" Width="120" Height="30" FontSize="12" VerticalContentAlignment="Center" ToolTip="Selecione o tema visual da interface">
                        <ComboBoxItem Content="☀️ Claro" IsSelected="True" />
                        <ComboBoxItem Content="🌙 Escuro" />
                        <ComboBoxItem Content="🌌 Cyberpunk" />
                        <ComboBoxItem Content="❄️ Nord Ártico" />
                        <ComboBoxItem Content="🌲 Esmeralda" />
                    </ComboBox>
                </StackPanel>

                <!-- Botão Apoiar o Projeto (Buy Me a Coffee) -->
                <Button Name="BtnBuyMeACoffee" Content="☕ Apoiar Projeto" Style="{StaticResource BtnCoffee}" Margin="0,0,8,0" ToolTip="Considere apoiar o nosso projeto no Buy Me a Coffee: https://buymeacoffee.com/ianjos1993" />

                <!-- Botão Enviar Sugestões / Discord -->
                <Button Name="BtnDiscordFeedback" Content="💬 Discord" Style="{StaticResource BtnDiscord}" Margin="0,0,8,0" ToolTip="Participe do nosso servidor no Discord e envie sugestões: discord.gg/unbk" />

                <!-- Badge Andyz0x Modo Administrador -->
                <Border Background="{DynamicResource BadgeBg}" BorderBrush="{DynamicResource BadgeBorder}" BorderThickness="1" CornerRadius="8" Padding="10,5" VerticalAlignment="Center">
                    <TextBlock Text="⚡ Andyz0x (Admin)" FontSize="11.5" FontWeight="Bold" Foreground="{DynamicResource BadgeText}" />
                </Border>
            </StackPanel>
        </Grid>

        <!-- CORPO PRINCIPAL (ABAS) -->
        <TabControl Grid.Row="1" Background="Transparent" BorderThickness="0" Name="MainTabControl">
            
            <!-- ABA 1: APLICATIVOS -->
            <TabItem Name="TabItemApps" Header="📦 Aplicativos (247 Softwares)">
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
                        <TextBlock Name="TxtAppSummary" Grid.Column="2" VerticalAlignment="Center" Foreground="{DynamicResource TextSecondary}" FontSize="12" Text="Exibindo 247 de 247 aplicativos | 0 selecionados" />
                    </Grid>

                    <!-- Presets Rápidos de Apps -->
                    <WrapPanel Grid.Row="1" Margin="0,0,0,10">
                        <TextBlock Text="Presets Rápidos:" VerticalAlignment="Center" Margin="0,0,10,6" Foreground="{DynamicResource TextSecondary}" FontSize="12" />
                        <Button Name="BtnPresetKitAndyz0x" Content="👑 Kit Andyz0x (Completo)" Style="{StaticResource BtnKitAndyz0x}" Margin="0,0,8,6" />
                        <Button Name="BtnPresetPackGamer" Content="🎮 Pack PC Gamer (Essenciais)" Style="{StaticResource BtnGamerPack}" Margin="0,0,8,6" />
                        <Button Name="BtnPresetEssenciais" Content="⭐ Essenciais" Style="{StaticResource BtnSecondary}" Margin="0,0,8,6" />
                        <Button Name="BtnPresetDev" Content="💻 Desenvolvedor" Style="{StaticResource BtnSecondary}" Margin="0,0,8,6" />
                        <Button Name="BtnPresetGamer" Content="🕹️ Apenas Jogos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,6" />
                        <Button Name="BtnToggleFossOnly" Content="🍃 Apenas Open Source" Style="{StaticResource BtnFossFilter}" Margin="0,0,8,6" />
                        <Button Name="BtnToggleSelectedOnly" Content="🎯 Apenas Selecionados" Style="{StaticResource BtnSecondary}" Margin="0,0,8,6" />
                        <Button Name="BtnSelectAllVisibleApps" Content="Marcar Visíveis" Style="{StaticResource BtnSecondary}" Margin="0,0,8,6" />
                        <Button Name="BtnDeselectAllApps" Content="Desmarcar Todos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,6" />
                        <Button Name="BtnUninstallAppsTab" Content="🗑️ Desinstalar Selecionados" Style="{StaticResource BtnDanger}" Margin="0,0,8,6" ToolTip="Desinstala os aplicativos selecionados via WinGet" />
                        <Button Name="BtnRepairWinGetTab" Content="🛠️ Reparar WinGet" Style="{StaticResource BtnSecondary}" Margin="0,0,8,6" ToolTip="Diagnostica, re-registra e reinstala o WinGet (App Installer) da Microsoft caso downloads falhem" />
                    </WrapPanel>

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
                                    <Button Name="BtnActionRepairWinGet" Content="📦 Reinstalar / Reparar WinGet (App Installer)" Style="{StaticResource BtnSecondary}" Margin="0,0,10,10" ToolTip="Re-registra o App Installer e baixa o pacote oficial mais recente do WinGet da Microsoft" />
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
                            <Button Name="BtnCoffeeConsole" Content="☕ Considere Apoiar" Style="{StaticResource BtnCoffee}" Margin="0,0,8,0" ToolTip="Considere apoiar o nosso projeto no Buy Me a Coffee: https://buymeacoffee.com/ianjos1993" />
                            <Button Name="BtnDiscordConsole" Content="💬 Sugestões (Discord)" Style="{StaticResource BtnDiscord}" Margin="0,0,8,0" ToolTip="Envie dúvidas e sugestões no Discord: discord.gg/unbk" />
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
                    <Button Name="BtnCoffeeFooter" Content="☕ Considere Apoiar" Style="{StaticResource BtnCoffee}" Margin="0,0,10,0" ToolTip="Considere apoiar o nosso projeto no Buy Me a Coffee: https://buymeacoffee.com/ianjos1993" />
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
# Configurar Logo Oficial na Barra Superior e Ícone do Aplicativo
$ImgAppLogo = $Global:Window.FindName("ImgAppLogo")
$BdrAppLogo = $Global:Window.FindName("BdrAppLogo")

if ($Global:AppLogoBitmap) {
    if ($ImgAppLogo) { $ImgAppLogo.Source = $Global:AppLogoBitmap }
}

if ($BdrAppLogo) {
    $BdrAppLogo.Add_MouseLeftButtonUp({
        Start-Process "https://github.com/ianjos1993/Script-apps-formatar"
    })
}

# Configurar Ícone Oficial da Janela (.ico nativo de alta resolução ou Bitmap)
try {
    $localLogoIco = if ($PSScriptRoot) { Join-Path $PSScriptRoot "assets\logo.ico" } else { "assets\logo.ico" }
    if (Test-Path $localLogoIco) {
        $Global:Window.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create([System.Uri]::new((Resolve-Path $localLogoIco).Path))
    } elseif ($Global:AppLogoBitmap) {
        $Global:Window.Icon = $Global:AppLogoBitmap
    }
} catch {
    if ($Global:AppLogoBitmap) { $Global:Window.Icon = $Global:AppLogoBitmap }
}

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

# Botões de Suporte / Buy Me a Coffee e Discord
$BtnBuyMeACoffee = $Global:Window.FindName("BtnBuyMeACoffee")
$BtnCoffeeConsole = $Global:Window.FindName("BtnCoffeeConsole")
$BtnCoffeeFooter = $Global:Window.FindName("BtnCoffeeFooter")
$BtnDiscordFeedback = $Global:Window.FindName("BtnDiscordFeedback")
$BtnDiscordConsole = $Global:Window.FindName("BtnDiscordConsole")

if ($BtnBuyMeACoffee) {
    $BtnBuyMeACoffee.Add_Click({
        Start-Process "https://buymeacoffee.com/ianjos1993"
    })
}
if ($BtnCoffeeConsole) {
    $BtnCoffeeConsole.Add_Click({
        Start-Process "https://buymeacoffee.com/ianjos1993"
    })
}
if ($BtnCoffeeFooter) {
    $BtnCoffeeFooter.Add_Click({
        Start-Process "https://buymeacoffee.com/ianjos1993"
    })
}
if ($BtnDiscordFeedback) {
    $BtnDiscordFeedback.Add_Click({
        Start-Process "https://discord.gg/unbk"
    })
}
if ($BtnDiscordConsole) {
    $BtnDiscordConsole.Add_Click({
        Start-Process "https://discord.gg/unbk"
    })
}

# Botões de Ação Global e Abas
$BtnUninstallApps = $Global:Window.FindName("BtnUninstallApps")
$BtnRevertTweaks = $Global:Window.FindName("BtnRevertTweaks")
$BtnUninstallAppsTab = $Global:Window.FindName("BtnUninstallAppsTab")
$BtnRepairWinGetTab = $Global:Window.FindName("BtnRepairWinGetTab")
$BtnActionRepairWinGet = $Global:Window.FindName("BtnActionRepairWinGet")
$BtnRevertTweaksTab = $Global:Window.FindName("BtnRevertTweaksTab")
$BtnSelectAllTweaks = $Global:Window.FindName("BtnSelectAllTweaks")

# Presets de Apps
$BtnPresetKitAndyz0x = $Global:Window.FindName("BtnPresetKitAndyz0x")
$BtnPresetPackGamer = $Global:Window.FindName("BtnPresetPackGamer")
$BtnPresetEssenciais = $Global:Window.FindName("BtnPresetEssenciais")
$BtnPresetDev = $Global:Window.FindName("BtnPresetDev")
$BtnPresetGamer = $Global:Window.FindName("BtnPresetGamer")
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

    $key = "Claro"
    if ($ThemeName -match "Escuro") { $key = "Escuro" }
    elseif ($ThemeName -match "Claro") { $key = "Claro" }
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
$appCategories = $Global:AppCatalog | Group-Object Category | Sort-Object { [regex]::Replace($_.Name, '^[^\p{L}\p{Nd}]+\s*', '') }

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

            if ($catMatches -and $appMatches -and $fossMatches -and $selectedMatches) {
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
        $TabItemApps.Header = if ($appCount -gt 0) { "📦 Aplicativos ($appCount selecionados)" } else { "📦 Aplicativos (247 Softwares)" }
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

function Show-GpuSelectionDialog {
    [CmdletBinding()]
    param(
        [System.Windows.Window]$OwnerWindow,
        [string]$PresetName = "Pack PC Gamer",
        [string]$PresetIcon = "🎮"
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
        Title="Seleção de GPU • $PresetName"
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
                    <TextBlock Text="$PresetIcon" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/>
                    <StackPanel>
                        <TextBlock Text="$PresetName • Seleção de GPU" FontSize="16" FontWeight="Bold" Foreground="#F8FAFC"/>
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
                                    <TextBlock Text="Marca: NVIDIA App (Drivers Game Ready/Studio &amp; Painel Oficial) + Softwares do Preset" FontSize="11" Foreground="#A7F3D0" Margin="0,3,0,0" TextWrapping="Wrap"/>
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
                                    <TextBlock Text="Marca: AMD Software: Adrenalin Edition (Drivers &amp; Painel Oficial) + Softwares do Preset" FontSize="11" Foreground="#FECACA" Margin="0,3,0,0" TextWrapping="Wrap"/>
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
                                    <TextBlock Text="Marca apenas os softwares e utilitários do preset (sem drivers de GPU dedicados)" FontSize="10.5" Foreground="#94A3B8" Margin="0,2,0,0" TextWrapping="Wrap"/>
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
    if ($Global:Window.Icon) {
        $dialog.Icon = $Global:Window.Icon
    } elseif ($Global:AppLogoBitmap) {
        $dialog.Icon = $Global:AppLogoBitmap
    }

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

$BtnPresetKitAndyz0x.Add_Click({
    # 1. Abre diálogo de seleção da fabricante da GPU (NVIDIA ou AMD)
    $gpuChoice = Show-GpuSelectionDialog -OwnerWindow $Global:Window -PresetName "Kit Andyz0x" -PresetIcon "👑"
    if ($gpuChoice -eq "CANCEL") {
        Write-GuiLog "Seleção do Kit Andyz0x cancelada pelo usuário." "INFO"
        return
    }

    # 2. Limpa seleções anteriores de aplicativos
    foreach ($item in $Global:AppCheckBoxes.Values) { $item.CheckBox.IsChecked = $false }

    # 3. Marca a lista completa de softwares do Kit Andyz0x
    $andyz0xApps = @(
        "WPFInstallbrave",
        "WPFInstallvlc",
        "WPFInstallsharex",
        "WPFInstallnotepadplus",
        "WPFInstallvscode",
        "WPFInstalldiscord",
        "WPFInstallsteam",
        "WPFInstallepicgames",
        "WPFInstallHydraLauncher",
        "WPFInstallwhatsapp",
        "WPFInstallGoogleDrive",
        "WPFInstallSignalRgb",
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
        "WPFInstalldotnet6",
        "WPFInstalldotnet8",
        "WPFInstalldotnet9",
        "WPFInstalldotnet10",
        "WPFInstallautoruns",
        "WPFInstallvc2015_64",
        "WPFInstallvc2015_32"
    )

    foreach ($k in $andyz0xApps) {
        if ($Global:AppCheckBoxes.ContainsKey($k)) {
            $Global:AppCheckBoxes[$k].CheckBox.IsChecked = $true
        }
    }

    # 4. Configura drivers conforme perfil de GPU selecionado
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
        Write-GuiLog "👑 Kit Andyz0x ativado com perfil NVIDIA! (30 softwares selecionados)" "SUCCESS"
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
        Write-GuiLog "👑 Kit Andyz0x ativado com perfil AMD! (30 softwares selecionados)" "SUCCESS"
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
        Write-GuiLog "👑 Kit Andyz0x ativado com sucesso! (29 softwares selecionados)" "SUCCESS"
    }

    Update-SelectionSummary
    Write-GuiLog "Softwares selecionados: Brave, VLC, ShareX, Notepad++, VS Code, Discord, Steam, Epic Games, Hydra Launcher, WhatsApp, Google Drive, SignalRGB, NodeJS LTS, Git, Python 3, PDF24, NanaZip, IDM, Nilesoft Shell, Proton Pass, Parsec, Snappy Driver, .NET Runtimes (6, 8, 9 e 10), AutoRuns e Visual C++ (32 e 64 bits)." "INFO"
})

$BtnPresetPackGamer.Add_Click({
    # 1. Abre diálogo de seleção da fabricante da GPU (NVIDIA ou AMD)
    $gpuChoice = Show-GpuSelectionDialog -OwnerWindow $Global:Window -PresetName "Pack PC Gamer" -PresetIcon "🎮"
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

if ($BtnRepairWinGetTab) {
    $BtnRepairWinGetTab.Add_Click({
        $MainTabControl.SelectedIndex = 3
        $BtnRepairWinGetTab.IsEnabled = $false
        try {
            $res = Repair-WinGet
            if ($res) {
                [System.Windows.MessageBox]::Show("O WinGet foi diagnosticado, reparado e está pronto para uso!", "WinGet Reparado", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
            } else {
                [System.Windows.MessageBox]::Show("A rotina de reparo foi concluída com avisos.`n`nCaso ainda tenha dificuldades para baixar pacotes, abra a Microsoft Store e atualize o 'Instalador de Aplicativos'.", "Diagnóstico Concluído", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
            }
        } finally {
            $BtnRepairWinGetTab.IsEnabled = $true
        }
    })
}

if ($BtnActionRepairWinGet) {
    $BtnActionRepairWinGet.Add_Click({
        $MainTabControl.SelectedIndex = 3
        $BtnActionRepairWinGet.IsEnabled = $false
        try {
            $res = Repair-WinGet
            if ($res) {
                [System.Windows.MessageBox]::Show("O WinGet foi diagnosticado, reparado e está pronto para uso!", "WinGet Reparado", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
            } else {
                [System.Windows.MessageBox]::Show("A rotina de reparo foi concluída com avisos.`n`nCaso ainda tenha dificuldades para baixar pacotes, abra a Microsoft Store e atualize o 'Instalador de Aplicativos'.", "Diagnóstico Concluído", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
            }
        } finally {
            $BtnActionRepairWinGet.IsEnabled = $true
        }
    })
}

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

function Test-WinGetFunctional {
    $winAppsPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
    if (Test-Path "$winAppsPath\winget.exe") {
        if ($env:Path -notlike "*$winAppsPath*") {
            $env:Path = "$winAppsPath;$env:Path"
        }
    }

    $cmd = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $cmd) { return $false }

    try {
        $p = Start-Process winget -ArgumentList "--version" -NoNewWindow -PassThru -Wait
        return ($p.ExitCode -eq 0)
    } catch {
        return $false
    }
}

function Repair-WinGet {
    [CmdletBinding()]
    param()

    Write-GuiLog "=================================================" "INFO"
    Write-GuiLog "INICIANDO ROTINA DE REPARO E REINSTALAÇÃO DO WINGET..." "INFO"
    Write-GuiLog "=================================================" "INFO"
    Set-GuiStatus "Reparando WinGet..." 15
    Pump-GuiEvents

    # Passo 1: Ajustar variáveis de ambiente PATH
    $winAppsPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
    if ($env:Path -notlike "*$winAppsPath*") {
        $env:Path = "$winAppsPath;$env:Path"
    }

    # Passo 2: Re-registrar DesktopAppInstaller nativo
    Write-GuiLog "[1/4] Re-registrando pacote DesktopAppInstaller no Windows..." "INFO"
    Set-GuiStatus "Re-registrando pacotes do Windows..." 30
    Pump-GuiEvents
    try {
        $pkgs = Get-AppxPackage -AllUsers *DesktopAppInstaller* -ErrorAction SilentlyContinue
        if ($pkgs) {
            foreach ($pkg in $pkgs) {
                $manifest = "$($pkg.InstallLocation)\AppXManifest.xml"
                if (Test-Path $manifest) {
                    Add-AppxPackage -DisableDevelopmentMode -Register $manifest -ErrorAction SilentlyContinue
                }
            }
        } else {
            Add-AppxPackage -RegisterByFamilyName -MainPackage "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" -ErrorAction SilentlyContinue
        }
    } catch {
        Write-GuiLog "Aviso ao registrar pacote nativo: $_" "WARN"
    }

    if (Test-WinGetFunctional) {
        try { Start-Process winget -ArgumentList "source reset --force" -NoNewWindow -Wait -ErrorAction SilentlyContinue } catch {}
        Write-GuiLog "✔️ WinGet re-registrado e pronto para uso!" "SUCCESS"
        Set-GuiStatus "WinGet Operacional" 100
        return $true
    }

    # Passo 3: Baixar e registrar dependências essenciais (VCLibs e UI.Xaml)
    Write-GuiLog "[2/4] Verificando dependências oficiais (VCLibs e Microsoft.UI.Xaml)..." "INFO"
    Set-GuiStatus "Baixando dependências..." 50
    Pump-GuiEvents
    $tempDir = "$env:TEMP\WinGetRepair"
    if (-not (Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir -Force | Out-Null }

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
        $vclibsUrl = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
        $vclibsFile = "$tempDir\VCLibs.appx"
        if (-not (Test-Path $vclibsFile)) {
            Invoke-WebRequest -Uri $vclibsUrl -OutFile $vclibsFile -UseBasicParsing -TimeoutSec 30
        }
        Add-AppxPackage -Path $vclibsFile -ErrorAction SilentlyContinue
    } catch {}

    try {
        $xamlUrl = "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx"
        $xamlFile = "$tempDir\UI.Xaml.appx"
        if (-not (Test-Path $xamlFile)) {
            Invoke-WebRequest -Uri $xamlUrl -OutFile $xamlFile -UseBasicParsing -TimeoutSec 30
        }
        Add-AppxPackage -Path $xamlFile -ErrorAction SilentlyContinue
    } catch {}

    # Passo 4: Baixar e Instalar o pacote oficial DesktopAppInstaller (.msixbundle)
    Write-GuiLog "[3/4] Baixando instalador oficial mais recente do WinGet (aka.ms/getwinget)..." "INFO"
    Set-GuiStatus "Baixando WinGet Bundle..." 75
    Pump-GuiEvents
    $bundleFile = "$tempDir\Microsoft.DesktopAppInstaller.msixbundle"

    $downloadSuccess = $false
    try {
        Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile $bundleFile -UseBasicParsing -TimeoutSec 60
        $downloadSuccess = (Test-Path $bundleFile) -and ((Get-Item $bundleFile).Length -gt 1000000)
    } catch {
        Write-GuiLog "Aviso no download direto aka.ms: $_" "WARN"
    }

    if (-not $downloadSuccess) {
        try {
            Write-GuiLog "Tentando download alternativo via GitHub Releases oficial..." "INFO"
            $gitRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest" -UseBasicParsing -TimeoutSec 15
            $asset = $gitRelease.assets | Where-Object { $_.name -like "*.msixbundle" } | Select-Object -First 1
            if ($asset -and $asset.browser_download_url) {
                Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $bundleFile -UseBasicParsing -TimeoutSec 60
                $downloadSuccess = $true
            }
        } catch {
            Write-GuiLog "Aviso no fallback GitHub: $_" "WARN"
        }
    }

    if ($downloadSuccess) {
        Write-GuiLog "[4/4] Instalando pacote msixbundle do WinGet..." "INFO"
        Set-GuiStatus "Instalando pacote WinGet..." 90
        Pump-GuiEvents
        try {
            Add-AppxPackage -Path $bundleFile -ForceApplicationShutdown -ErrorAction Stop
        } catch {
            Write-GuiLog "Erro ao instalar msixbundle: $_" "WARN"
        }
    }

    # Atualiza PATH
    $env:Path = "$winAppsPath;$env:Path"

    # Reset de fontes
    try {
        Start-Process winget -ArgumentList "source reset --force" -NoNewWindow -Wait -ErrorAction SilentlyContinue
    } catch {}

    # Validação final
    if (Test-WinGetFunctional) {
        Write-GuiLog "=================================================" "SUCCESS"
        Write-GuiLog "✔️ WINGET REPARADO COM SUCESSO E PRONTO PARA USO!" "SUCCESS"
        Write-GuiLog "=================================================" "SUCCESS"
        Set-GuiStatus "WinGet Reparado com Sucesso" 100
        return $true
    } else {
        Write-GuiLog "⚠️ Reparo finalizado, mas o WinGet ainda não respondeu ao comando." "WARN"
        Write-GuiLog "Dica: Você pode abrir a Microsoft Store e atualizar o 'Instalador de Aplicativos'." "INFO"
        Set-GuiStatus "Reparo Concluído com Avisos" 0
        return $false
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

    # Verificação inteligente de integridade do WinGet
    $requiresWinget = ($selectedApps | Where-Object { -not $_.DownloadUrl }).Count -gt 0
    if ($requiresWinget) {
        if (-not (Test-WinGetFunctional)) {
            Write-GuiLog "⚠️ WinGet não detectado ou inoperante. Iniciando rotina de reparo automático..." "WARN"
            $repaired = Repair-WinGet
            if (-not $repaired) {
                Write-GuiLog "ERRO CRÍTICO: Não foi possível inicializar o WinGet automaticamente." "ERROR"
                Write-GuiLog "Dica: Atualize o 'Instalador de Aplicativos' na Microsoft Store ou clique em '🛠️ Reparar WinGet'." "WARN"
                [System.Windows.MessageBox]::Show("O WinGet (Gerenciador de Pacotes do Windows) está ausente ou corrompido e não pôde ser reparado automaticamente.`n`nPor favor, atualize o 'Instalador de Aplicativos' na Microsoft Store e tente novamente.", "WinGet Necessário", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
                return
            }
        }
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

    if (-not (Test-WinGetFunctional)) {
        Write-GuiLog "⚠️ WinGet inoperante para desinstalação. Acionando reparo automático..." "WARN"
        $repaired = Repair-WinGet
        if (-not $repaired) {
            Write-GuiLog "ERRO CRÍTICO: Não foi possível inicializar o WinGet para desinstalar os aplicativos." "ERROR"
            return
        }
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
Set-AppTheme -ThemeName "Claro"
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
