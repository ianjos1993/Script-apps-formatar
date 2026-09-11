<#
.SYNOPSIS
    Utilitário Completo de Pós-Formatação para Windows (WPF GUI)
    Desenvolvido por Andyz0x.
    Totalmente em Português (Brasil) com Ícones Oficiais, Pack PC Gamer e Destaque Open Source.
    Executável remotamente via: irm unbk.com.br/setup | iex

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
$Global:AppLogoBase64 = "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAYAAABccqhmAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP+lSURBVHhe7L0HeJRlty78PO+UJDOTTDI9M5My6T2hd0IPkEnvhTSSkELovQVpIr2ISBFFbCiCYgFRARVQBBUFRRFEkN575n0n5P6v553g9nz/3ud8+/vP+c/e35d1XeuaySSgGWa1e91rLULapE3apE3apE3apE3apE3apE3apE3apE3apE3apE3apE3apE3apE3apE3a5L+AUEJA//bFNmmTNvlXkMR9UpJzQi4+PtGcNyV/v1NgP9fIuRxJm7RJm/z3kEZworEP/tCNlO5zFzX7kAcpPet63uGo7N8cATNwcKRRfPyLwYP++XfkvCkn1Udlf35P/LNPsgtwhLwpEV8T/442aZM2+b8jzABFoz0lGr6x+JiSMK0+qiAVBzw1Rae89DknVOLXT16vvqgQf67ipCdh33vyZ1LZ12fU6tpzPqT0rLeo7PtMi055sZ/Xsp9JO+tN0i9oPdMvaNnPk+zzHuJ/nzkcpl0PefyZfTAnwhzFv2UhT/Sv8sQJtUmbtMm/L6BilP+rMSVCShpOuT0xdlJ9Rq2qvqjzGHHDoii65kuGXzGSqtbH+rtaUnPZ4Fl/Qasqv6RX1lw2sK/Z95Ts+9UXdaTkhsW74lGAsbQp0Kf6kb+i9IFJVX5Prxnx0OJRdMPqUfHQrCh64KvOawr0GfbIX53SZPPIf2hW5t83qgru6dijIueqSZl/xahOO+vtk3NGre1+0tPXflRhHHhMKWYhTxwDey7qutbMhL22Tvb3lypt0ib/3NKabje6jN5Vy8tdekIupulMWRQffl6jLjznQ+qumtzrHgWoy+8EGSubbO4VtwJI9SN/Mr4lwKPhoZWMfWghdbcC3BruBLuNbLK5Db8TQipv29xGNAWSupYAecWFcGX26Vhl7vkYWe75GEXG8Xj5sGthqtLrEeJr+eeiFWnfJSjs37dXpvwcJ0s6Ij7q8i6EeRb8EeqZdyHMK+9qsKniUYCm5IZFm//QrMiByZhx32AafEnPnICm6IaX16A7Gv/kcz5qpolnvZmTeKLi79kmbfIvJi5jfxLh/w28k7O0nkVQlqKLqXwdS+fPqMWUnKXfLF1nkbzhodVtTFOQrORctCz/5zhZ/g9xbnVNIfLSixHKkp/jZOXH4z1yD3aSZu3tIs0/3FGWezxekXukPVNZzlcdSOrhjtLBO3u6D9zWWzrwgx7SpF3dpAO2Jkr6vdHXLXHzALf+b/VxPd8wmH0t7b2jl7Tn1kRpr2293fu910vUPtsT3Qd+0MNz6N4uiuRvOqjtR9or007G+mScjtFmXw83FF4J0hX8EarNvB5hGvx7lD79anDg0FsBgUMfBfjaH/kbMy4bCMsUmIMTM4OcVtzhf9A2aZN/BhHBNBe49v+K7K31NDP2wh98WMpOhl3QisrS9REPLaT6lj+L9u61j/xEQy+/FMWMnxm0R9aBjh5Ze7u423f2dB+8NdGt36aBbgM2JSn6r0l2S2LGvHmAsv/mAW4DX+vHvpb3WpMs77Y8Xd5zebpH7zUp8t5rh8p7rUyTdVmQJ4ufU8zUveOCPI/Oi3Lc280e5p4wq1QWP7vIvf3C3Ccq77g6Vd5l7VC3rhsGu/V6rZ97z62J3j23Jqq7v9FX3fuNvurEt/qoe23t593vvV4+/T/upumxp6tnz8+7qPt+0yFg4IkEw+AzcYbkO0G6pGu+XoPOazSDT3lpOruUZQb6qBMqEvKhG4l6Uy6WDm3OoE3++wqo+CEWAbITchGAKzrl5VN9VM1AOzUD31qNXTTwkU02UvcogEV4wtL12tZIX3ImTpp1uKPUvqubNGNPV/bolvR6H0m/TQPl/dYNkfdYmiHptSjriXI9FuZy3eYWyLrPKZZ1nVsk6zZ7mKzr7CJZh+nDpbFjRssTxo2WdphSI20/qVYa3TBBGlk3TRo1coo0etQkaeTIidLoiXVuMeMaPKLHjXaPGj1OHjVqvDxizFi3qAn1brFTqt1iZpXLEuYWyDstzVB0Wm1nTsE9en6+MmpugTJmTrEybkGeZ/vVdq/2m5K84jYleUavtisTNg/w7byjl7b3/k76vr/EmwbciAxIQqBf6kOzceBlQ8DQqyZWPvgmXtR5dT2veeIUREeZ2MjKhTZH0Cb/TYQh9szoB59ys4497yEaPjP28lN/ifDnNaT6no4ZPBl7J4SU/y5GdlnluWhZzfkYWeGJBGnG/k7S9F3dpPadPd36bxgs770mRZL4nJ30WJzJdZufz4yc6zx9uDx+zFhp+zGjufZjx3AxI6dw8WPHcAmjxksT6qdK2zVMlsRUzZVEVc/7UyOGL6aRZctpROkKSfiw1TS8dDWNGL6Ihg1fJAmvfIaGVc2nYVVzJWFV82VhlQs8QsqXyoLLF8mChy+UhVXPk4fXTZOHjxovDR/XII8YO0YaM7FGHjF6jHvoqPHy4FHjPSIm1CsiplYpImaVMqegilme7h27Ms07bk2KV8KmgaqErYmaLnu7mHsfa2fsey7aNOBspLn/tTDroDshrExg5YIx6Xag/8Amm2XwDaup5z29PvGqqi0jaJP/itL6gWRpPiR/RnxWz5ee9VYWXzaIyHv9QzOpfeRHRsFfXnY31K3uTojb2KYQWcmv0aKxs7p9yAc93Aa90Zel9G4DtvRnEV4yYO1QSd/VqbLOjSXShIl1XLvxI5mhk/Zjx9DY6qdo1PDFksiSNZLwkmfFx7DCzTSs8CUaWbyBqSSy8CVJWP7rktD8N5jSsILXJKF5W7mgrF3SkKyPpcGZH3FBWR/ToJydnC13uzQoZwcXlLNDasvZIQ3MfVsakPOe1D9rt8w/+wNZQN42aWD+K7LgYc/LbMOek9tKVrkFl69wCy5b5hZc8YxH8PCFHiGVC9xCK592C6marwipm6kMGzNWGTahnqln+IwyZfT8fFXswmxV5PJ0z8h1Q1Ttd/TSdjvYSdvpcEdT98Md/Xt+08GceCLB3O3Hdv5dvung3+WHDkHdzscEdGkKtHW5YmRlgpW1Hxk/QeQptEmb/F+TJ/U9JK6I/6GrpmfGz4C7msuGJ2k9qb0TxIA6WfHpGI/0zzp75B/u6J7+cTd3+9ZEaeq23lI7A+LWDZH0X5PMDF7ee3Em131BHtdtVjnXaUItF1c/VRJZtkwSMex5Glm8nkYOW0fCC14mYXnbaEjWLhqctcelGQeoLf0IDUr7hganHaHB6UfZcy4o9XvOlvYNZ0v7lgtK+ZkLtP/GBaac4wLtF2mA/Q8akHKGBqT8wvn/qac4P/uvEov9tNRiPy2xpn0v8Uv7WmJN/1JmTT8g80s/IBc181OZX+YnMmv2BzJrznsy/9zt8sD81+X+Ba+6+xdtcg8oXeEeWLbcw1b5tCKkptE9uG6aMmT0GFXQlBpF0IwyVfiiHO+INcmGyM0DTDFbE5n6dvighznh/e7WDp91NiXs72Rpv6drcPtvOtg6XQvzb//AV93znA9zAi5HIHYT2rKCNvn/S1qNXmTIiVRcFwOPKSPPsPReROtb9O6T4c8MXpr+WWdp6t4uJOWDHpL+mweIdXu/lSmynvPzua6NJaJ2mVHGdZlSTTpOqSbtR43n2tdN4xJqZ0miy5fS6LJVNLxwMw3J/pCGZn5KQzP2cyFpX9Pg1B9oUMoZGmT/TVSb/QK1JV8ntqG3qG3oQ2pLfkiD7A9okL2JBiU/5ILEr5uozS5QW8pjGpjSTANTWmigvZkG2J3U36US9uhnF6jV7uAs9iYpU2vyfYk1+bbEmnxDak2+KrXab0gtydelFvtlqcV+VmpJPSm1pJ6QW1OPyS1pR2SWjINyS+Z+d2v2+27W3LfcA4o2ugeUPOsWWL7UI7BiiUfAiNmKwIbJyoBR41W2iXXqoFnl3oGNJd6Bs0o1IQuzdaJT2NKfqT564yBz9PvdA+JPJAR0uRFp6HknSJ/4wKRtd91s7nRBqw2//pesoE3a5P+cuCi0LNo/oeCyaM969KzGb7inZyk+qb8bJqs4HSMrOxnLanjJwJcGSfqsTGNKei/N4LrPKeY6Tanh4kZOkcSOmCOJqZpPY8oX0eiKJTSmbDmNYRE+/xUalfcmDc/8lAvNOERD076nwSnnaHDyRRqcfJ0GJT+gQclNNNjO0+BUngtKZY+PuZB00JBM0NAs0LBs0LAccGE54iMNywUXlgsalgcalu/SkHzQYJdy4mOe63lQAWhQLrjAbEgCs8EFZkDinw6pfyak4mM6pH6pkFlSWmSWFKfcYnfIzMn3ZGb7TZkl+arUbP9DZk455WZOPS43px2WmzP3yS1ZH7ubs993t+TsdLMWbPHwK9yk8CtbqbRWPq2y1s5S+TVM9vIbOUXtN2aszn9KtT5wVqk+YEaZLmBugS5ktd0Uua23OXx3d0vEvq6+sd90sMaejg2LuR5hSbgb6tvhkT9zBiGsg9DGNmyT/73SCuo1tPLvWaRnhBzWp6+94yO27Gof+clLz0aI9XzW+93lA18YIhm4boicGXy32cNI1yk1pOeUaq7T2FFcwsgpNLZqDo1k4FvRRhqW/yoNzXGl8qEZ+2ho2tc0JOVnl8Hbb9Dg5Ec0xO6kIamgIWmgIRmgocy4s8GF54FGFopKooaBRpeDxgwHFzMchGn0cNBWJdGVIFHVIFE1IFEjXBoxAiT8/600jGkVaOhw0OAyUbngUkiCSiANGgZpUDGkgQWQBuRB5p8LuV825JZMyK2ZcPNjj2ktMnOKIPO1P5Cakm/LTfabcqP9mocp5ay7KfW4m2/6V26mjIPupuyPPMz5rygtJWuVviVrPE0lz3obhy/28a2aozHXzfTxHTnF2zyp1ts8oV7jN6vUELg81RS0dqgx+PU+1qjPOgcm/BLvG/F9e7/4y9Eh0U3BUVFXTdau5z3+9l+wTdrkHxVX1GeGn3NCxWivIg234rqZjHngS6quBou1feHpWJL1eRfJoE0DJX0XZ8q6TqvkmLYbM5bGjJhLY4cvJvHlS2nUsOdoZOEmGlHwMg3NeY+GZHxOg9K+pkGpx7gg+1kalHydC052cMH2ZtHgQzNAw3NAIwtAo4pAmZFHlYDGlIPGDQeNGwEaVwcS3wASPw4kdhJI9CSQ8PEgYa0aPg4keipIu0aQ9rNBOs0B7ToPXLf5kHR7WlRp1wXguswH7TgPJH42SPRMkPCpIEHjQfxGg5hHgZjrQax1IH51IAEjQAKrwAVUQmqrgMxWBnlgCeQBTIdBHlAEN788yC3ZkJsz4WZOh7spDe5Gu+BmTL7nZrRfczPaL7obUk+6GTO+UJgy9ymMWR976nN2eOoLXvUyFW1UG0vWqE2VC7wt9VPVvqMmaSxjx7DMQGudW2QIWJphjdiaaA5/v7spZGuizfZZ58jIm9FBCY7QsA4XdW3lQJv8b5DWyJ+91UNM84tOeTGyjki3HYMg+cjrEdKMg51I/1cHMOCOMNCuS2MZ1270OBpduYDGlC2TRA57nkYUbaLheVtpRM5OGp7xGQ1N+4YEp/xEg+wXaFDybWpLvifW5sEpj7mwDHAR2aCReaDRxSDRJaCxFaAJNaAJdSBxDSAxo0Aix4JETgKJnwnSbQEk/VfAJ+sF+Fe/idCpHyJy0adIePYzdNn8NXpuO4H+u39D0heXMOSrSxh69DLSj11F9vFryPnhGvK+v4aiY9eQ981VZH55CRn7/0DaR+eR8s5vGPraTxi87lskLjmADlM/RGz9doQUvwbzkLXw7LYUsqiZILbJIJZxooOgfnXgAmohs42A3FYJt8ByuPkPg7u1CO6WfLj7ZsPdxJxBSouH0S546JMfuOuTbyj09gsKQ8oppT79K6U24zOVLmuXpz53u9pYuNnHXLbKx1y23Nu3bJm3YfhCH2PDZK1p0giD/5xivf/sYRbL0zl+fqtTA0O2JvrHft8+LO62LSrqhCok5JRbqyNoYxe2yX9SnozLsgEcRsetYtH+mi+pbLLJa29Euog5O3tKeq1J5jrPHiYavastt4hGlqyh4flvcOE573AhmZ/S4PQvaVDKzzQo5QINst+iQcmPaJBdoCFpLSQ0EzQ8CzQiHyS6GDSuHDR+uGjwJGEUSOwYkMhxIDHTQDrPhXTAUpiLNiN66gfovPZLDH3/V+R9ewV5v91EzrWHyL3XjPQmoPejFnS+34KEu0DMNSDmEhD1ewtif21BzE/NiDnuRPz3zWj/bTPafdOMTkea0eWrZnQ75ESvQ070PfQYSV8+RtqRFhQdA8q+B8qOASO+bUHtkWbUHOJR//k91O26iMrXTiNn6TfoWb8TEWkvwth1CTyCp4EYx4IY6kHMIyD3q4KHfwUU1lJ4WIqhMBdAYc6BwpQFhSEdCoPdqdDZHQpd8j2lxn5RqUk9qdKlf+2lSz/gZcp5z8uYs02tz3+DZQdqfekKjaFmhrdv3TStedR4vXlincUye5i//6KcwMCXBoVGnUgIb9diDog/622MO6a0Wtu6BW3yP5UnyH4rZVdM+c+6k4ZTXqyH71H50MoouISRdHK+6UDsWxPJgE1JJHF5Otdu0ggSXTudRpYtE3vvYbnbaWj2h6z9xgWl/cjZ7H+4jH7oQxqc4hRTegbOMYOPKgaNKQOJHQ4aXwvabjRI/FiQ6HEg7WaB9l0GU97LiJ65G31f/R65X15AwekbyLvFI4sH+gtApyYg5nYzAi474fO7Ex6nBEh/dEB+jIf7Nzw8DvNQfSnA66AT3p8L0O4ToPuUh/5jHr4fCfDbzcN/F4+g9wWEvssjfDuPyLd4RL/BI/4NHh3eEND1NQd6vuJA75d59HmJR79NDiS95ED6qzwK32zGiPdaMOETYNo+YPZeJ2Z/dB8TXj2P8kXHMLDqPYT3fQ7eEU+BM00E0Y6C3FQLpWUElNZyKM2lUPoWQ2nMhcqQBZUhA0pdOhRau0Optd9Sae1XVbqU05661B/UuvSvvDSZn6p1Oe+odQUve+uL13vrKp/WGOun6nzHjTaZJ9WazQtz9cG7u/sn3IgKj28KjIh44Bsbe87HaDymJIQRidqmENvkf5DWBRuspcdGbllbT1ywcdubRX23hqZgWcnPcdKUD3pIMz/oQQZtGEx6Lcgj3WYP4zpOqCfR1U/RiGHPcWE5b3NhWXtoSPpRGpJ6ggTZL4npfVAyT0NSW1hqTyNyXTV8TAVoXDVoQq0ryseMA4mfDtLrGRgLN6PD4r0o3HUa5T/fQMFNHkOdQBe+BeF3H0N3WYDsvAB6WoDkJA/5CR7uPzihOOaE4lsByiNOKA87oTgkQHmAh/JzHqp9Arw+EeD1kQD1h074vMdD+64Aww4e5u08/N7mEbCVR/DrPEJe5RG2RUD4Zh6RL/GIe4lH+008Om7k0WWDAz3WCei9lkffNQ4MXOPA4GcFpDwrIHO1gNxVPIpW8Rj+vIBRLzkxYxuw+CNgxUdOzH/zKsat/Amp1R8ivOtaeFpmgqpHQaarg8pcA5V5ODyNpfA0FsPTUAhPfTa8dGnw1KU89tTZBU+d/a6XNuWCWpv2o1qTcdBbm/WxtzZrl48m/xWNYfhivXHEXJ2pZobBMrXKbF6Z4h/8fveQyB/bhcfeDWdOIC7usoGVBYS8KW8lEbU5gn9pebJg40lLr+iUF2PtKUqvmkj9dTMpuxYqyzmRIE3b3d1t8Jb+8u5Ls0hPRr2dNIKLq51FWeuOte0iC1+iEaw/z4g3KWdIsP0GCU5+SIIYiJcGEp4NGlUILrYUNL4KtH0DSLsJIDGTQOJmQDZwJYLH7cTQLd+h6ocrGHbHgUy0oJOzBb53neAuO0DO8iC/CCAnnaA/CeCOC5B874TkWwGSIwIkh3lIDgmQHOAh/VyAbL8A2V4B8k8EuO8R4PEhD8VOHsp3eKje5uH1Fg/vNwToXhNgetUJ8ysCrC854b9JQMALAmzrBQQ/zyN0LY/I5xyIftaB+FU8Oqzi0XmVE92WO9FjmYDeS3j0W8RjwCIegxc5kPJ0E9IX8Mh5mkfhfB7D5jtQvsCB2kUCJq50Yv5LLVi74zHWb3fgmXV/oGbyAfRIegl623zI1OMh866GylgFb1MlvI2lUBsKodblQK3PhFqb1qLW2J1qn+T7Xhr7ebUm7YRak3rM2yfzU402702NruBVjb54rc5UO91gmFqlY5mAdX1SYOgv8RERjrC4iLthUVG3/AMCrppCNKe8Asg+9zYn8C8pf0nzn0T+ipOezPi9K24FeI64G8rSfOng7YmSQW/0Zai+vNvibK5TYxnj19O4ynk0qmQtDct9i4Rnv09D0r+iIam/0uDk2zTYLlAG4oVng4vMFWt6ElcOrkMtaEcW5SeBJDSCG/Qcgibugn3rCQw/cwtFTqBvCxDw6DGkN3iQCw6Q0w6QU8zoedATAuj3AugxAfRbHvQoD/K1E/SgE/RzAXS/APKpAPKxE2SPE/TjFkj3APKPXOq+G1B8CCjfA7zeAby3A9ptgOlNwPoGYHkV8H8ZsL0EBG4CAjcCweuB0HVAxHNA1CogZjmQsAzosATo+EwLOs13ouscAT1m8+jVyKPvrCYMmOnAkJkOpMx0IGMGj5zpPIpm8Cid4cDw6Tyqp/EYOa0JExt5zF3ajHUvA6+97cRzG65g3JRv0bv/S/A2TYfMswEqXR18TCPgYyiHj34YvPX58NZmQ61Jg9onxan2tj9Qe9svqTWpx7016V/7aDI/8dHk7NDrS1cYjSMn6owzKgy+SzMsllf6BgTs68pwgaioG1GRkY7Q4OCbfiEhp7wSXbhAm/xLCZvFF/fmnRDHcsWJvIpWnn7F9XAG7rExWgbuSVp7+Fz8mLGUpfqRLkYeF5b9EQ1JPU6D7Oddab7dQULTQBl6H1UIGlsGEl8N2q4eJGGcGOlJ9+Ww1GzHoFe/R/GZO8hvBro/fgzj/WaQKwLIOQHkrAP0lCvKk+MO0O8dotGTb3iQowLoYQHkKwHkSyfIwccgBwF6AKAHAckXgMe+x/DY44DbuzegfPVci9faH+G9+Et4zfoEyknvQVH/BhQVm6Ao3Qhl0Xp45T4LdeZyeKUvh3fGCvhkrIZP5vPQ5G6CruB1+Ja8A//yDxFctRfho44gZtIptJ91FZ3m3EPXeQK6z32MHo1Az5lA4gyg/7QWDJzsxOBJTiRPEJA6rglZ4xzIH+/AsPE8ysfzqBkvYOQEHg3jeIwezWPiOAfmNQpYvxbY+koznl32B2qq9qJdwlp4qqfBw6sB3rpqaPTl0GiHQaPJhY9PFry906H2tjvV6uR73t72y97eKT95e6d/pfXO/kCnLXzJoBu+0Nc4fpTJNHuYr+/ydLN584CAgD1dg4JOxzAnEBr60BIQcNY7IOCsexs28C8hrZH/yWguA/lqz/moC+8EiTP2hadj2ZitGPX7r0kmDNnvNKmWa1c7nUSVLSfhBVtoWPYHNISl+mK//h4Ve/VpLhRfNPxyEb3n2o8GSZgCEjcT7oOfRYe5+1H09WUUPmxGr+bH0N8VQK40gfzBg/zmBPmFB/lJAP1RAP2BB/3OAfqNQzR6ctgJ8lUz6BGAHgOkxwCPIy2Qf3IP7q/9CtXKQ3CfuRPy2vVQ5M6De/+JkHaohCwi67E0KNXJ+Q9pJr5JAjENvE+M/e4Rg6g3qaH/Parre5Po+p4l2j6/E02fs1TT5zTV9D1PNH1vEe/+94n3gFvEp/9N4jPgAacbcl9uTHvo7pfPe4ZWOrUJE2Hq8TT8+q9DWNo76FByGL3qf0fSxIdInwqkTQJSxwIZI4HsOicK6wWU1Asor+MxvJZHdQ2PuhoHRtc4ML6Ox8TaJkyvd+CZSQJeXNKMN59/iEUzTyEjeRuMxka4uddA7VMFva4COm0xtD750HhnQuOd2uKttju8ve23NF7237Te6V9pvDP26Xzytum1ZctMhrqZRv2oSSbD1BEm08Jsve/6pGDzrm4xYWfiYkObglhJEBR02uDre1TRxh34Z5Y/122dkBM2ossifx1MsvSvOkjtH7vm6wduHMT6+SIvP65+Ko2tXEAYcScs9y0anP4VYUQdm/0uF5TipCHpYn1PGEEntgy0PUvzx4PETwPpOB+G4lcx5JVjGH7hHlKdzfB/wINccYBcEEB+F0BO86A/86LRk+M86DEe5FsB5KgD5IgA8i3A/QDIvwHc9t2D4q0zUK78DO7jtkCV9zRk3esgC8+CJGDoY+o7yEmN/QRi6nefmAfeJH5DrpGAIWwu4GcSaD9Og1KOUVvqN9SWcpwGpX0rEo8CU45TW9oRass4SAMzP6EBon4qqn/G59Sa/jlnTt/LmdM/43zT9nOm9H3UmPYxMaTsJprBB4h6wNdE1ecXokq8Qjz735X4DLmpMGbd0AXXPrR1XNAcN+A19Mg6gOSys8ivd6C0ASgZAQwrf4xhJQLKSxyoLuNRV85jVJmAMSU8xpc6MKXMgWmlDjxV8QgbZzzGh88349Xll1BV8CFCAxbAQz4aGp86GHVV0PuUQO9dAJ06Cxqv1BaNl13w8Uq+rlGn/KJRZxzyUee8o/Up2qjTVD5t0NXNMOjGjdbrG0uspg2D/c27u0cEnY8JDm4KiQtrssUFXTZ0FduF4shxm/xzSesabFfaryJFN7zIqPtGMuxsJFuPJbL3Bq4bQtgyjQ5TR0iiKxcQNnUXlv86Dcn8hAanHidB9stccPIjLpTV+AzNLxRbeDRhBEiHMSDtZ4L0WgW/UR8gefdvKL3dhF7Ox/C+1wxykQf5lQc5xdQJ8rMAyoz+e2b4zNidoN+2gB4HZD8AbgceQvHWaSgWfQSPsmVw61UPSXQRSEAKiHFgC/Ud6KT+SQ+pbcgNGjz0Eg1OvkyCk6+REPsVGmy/SELs52lwylkanHqGBjFN+Z2zpVzmAu03OJv9Bg1MucUF2K+Jr7FHf/sViZ/9ksRqv8j5pZznrCmnmUosKb9LfFPOS8ypJzlLxiHOkr2b883+UGrKYo/vc6aMjzlj+udSQ8Y+qT79Y6k2dQ9VD32PKPrvJe6JP3OqQVdU2kzeEjpOaNd9Q/OA5APIzr+EirLHGFEGVBW3oCpfwIhcHnU5PEblOjAhn8fUAh7T8x2YkePArFwH1tQ344NlwK7nb2FaxeeIC1wNL/kk6NR1MPpUwOBdDL1XAbTqbGi90qDxSn7k7Wn/w8cr7RuNOmuXVp3/ulZTvEHrU7ZSr22YYNI3lrCyINC6rXe43+GOzBGEhbXYogIemKKsJzSJBG3YwD+VsOjP6n5G7GGLOEovB8oKv0uQDH2jr6TPmmRJvzUpXI85hVI2Yx9TPY9GFK+lodnvilHfZj9P2OBNcGoLDcsU6bgM2KPt6kA7jnVF/G7LEDBhDzIPX0OxoxlxjmZIWYrPIv3ZZtHo6Qke5IcmV10vGr4T5IcW0J8AOTP6T69Duf5LeDRsgFu/iaLBU/MQUEO/ZuKX5KC2oQ4aNPQODUq+wdmSb1Kb/RoNTrlJg+33uNBUBxeS2swGgbjgdHBBqS0i0SjY3sQFJT/iAu0PuAC7gwu0N4nPA+13uQD7TS7AfovzS75Hrfa7nJ/9hsRqvyKxplzmrPZrEkvybYk5+Z7EbH8g9U1+JGXPfe03pUb7LalRfGR6Q2pIuSY1pJyV69NOyAyZ+2TGvG1yQ9FGmaFkpUxX+LzUK+09qhj0CfFIPCBRJv3kpc1/GBwy/XFirx3IST2Fylwe9bnAyCygId2JsRkCJqTzmJgmYIrdgRkpDsxK4zE71YFVRTx2z32MvSvvYlrxl4ixrIKXdDyM3vXw9RkOo7oEBq886L3SofWyCxpP+00fVcovOq/0L3XeWXu03rlv6zTDntNrq5/y1Y8f6es7p9BsWJ3qb3ytn810sFNowKXIWP87QR2Cbqn/9iPUJv9tBVQ0fDa1x4g9pU2BssLzsR4Z+7qyLTvi+iyRsz9yEo0pX0FEjn7WbteobfIVytJ9ZvgRBaAxJSAJ1SAdRoO0mw7SZRks9R8i4/PLyG1yIqrJ6artxRRfAP3JIRo+Pe5C8cnRJhCG4B8H5D8CHp/fhOr5g/AoXQxplypwgekgliGgAUOcnG3oIxI09DYJSr5Jg+x3SJDYWnzE2VLZKG8zDUp5zAWnggtKE42eMg1KfUyD7Dy1iYZ+l9rsV2mQ/aJrTNh+kQbaz9PA1FM0MPUHGpB2jAakfU/9U3/i/FJPcX6pP3HW1BOi+qUe4/xST0qsKT9LLCk/c+bUnySW1JOcOeW0xJxyRmKyn5f62q9Kjfa7MoP9gcxob5Ibk3m53v5Apk++I9OnXJLrM7900+fsdNPnvyHXFa/10FUs8dCVPSP1TN1B5AP2Uln/Tz29sr8P9Jtwv3/nbahM/g3jsx5jYjowZmgzxibxmJjkwJRBDkwfxGNmEo/ZSTzmDnDguSweexsf48CzdzAp91MEqRfAW9YAk3oETN7lMHgVweCVA51XGrSeybzG035Z65X6k8Yr43ONd84OvXfxBqPPiLlG3dhRJtOsUoNhTqGvdnm6n+/OnlEBvyS087tu/ttPUZv8dxWW+j8h9jC0n83np+7t4ibW+4szidjXr2lkvH0Skfcmm8TjguyXqY2N26Y8FgdxooeBxI8A7TQOpON0kHbz4FP6JgbvOY/ch82IbGoGufRIrOsZoEdPMkDPCXqMAXlNIN8IID8AkhOA26EHUG48DI+KZZB2rQUXkArOMugxDRzq5IKTeRKSfJ+GDL1Fg+33aXDKIy441ckFpTLjBg1KaaHsa1uKk7OJhs5Ggu9Qm/0+ZVHdZr/GBaVc4ESQMvVXLph1KtK+5YLFuv8wDcz4nAvM+IKKG4Cydotqy94t1v+BWXtpQMZnnH/mPi4gaw8XkPE555+1V2LN/IKl/xJL+hGpNe0biSXtsMQ37XupOe2Y1Df1O6lv6jGpKfWk1JRyWmq0n5cZ7ZflRvsVN0PyTTfd0IfuWvtld13aj27a9C/dfbL2eGgLNys1lU8rDaPGeniXPC31GPIalfU9rPbMvBgZMPVuWuddqB90E1OTgSlJwKR+AiYlOjC1twMz+wiY05fHgj48nundhBczeBye14y9z1xGSe9tMEpnQO8xGmafWpjU5TB5FcLomQWtKqVFo0y+o1GlnNF6ZhzQqbN36ryKNhl8KheYtKPGG3RTqvV65ghWp4YGft6la3BTSGIUVG1jxf/dRTT+VsBv+H0jqbsTIhr/4I2DJImLs7lubPlGTSONLn6ei8x9i4ay7TliW+8xZRx9RteNKQPXrg5cxykgHRZAZn8FXTb/hPxbPOJYxP+jSYz2Ys/+R1bXt7bvvmMR3wlyDJAdY334C1DM3gF50mRwrJY39H9M/AY/IsyAg5Mf0hD7Axpib6KhKQ4uNMXJhaaBC2ERPqXFtcDD/oAZuTgtaEu+TgPF6H5FbEUGp/xCQ1J/4ELTvuFCM77gQjP3caGZ+7mwrI+50KxdHJs6DGXOLe9NEszGjvO20pCC12hQwcuSoMIXaEjpaomtcJPEVvCaxJb/hiSocLOEfc+Wt5Xzz9lJ/XN2cH5Zu6V+2bs5/+xdUr+sXVJrzk6pJfddqSVrl8w38xOZOeOA3JT2rdyUesLNmPqT3JB6ws2Q+pO7PvW4uzb1Fzed/by7xn7FQ5NyVqHJOKjU5m731BZtVPmUrlZ4ly1z8xr2DHEf+oJE1n+/ybv8Ru/wDRjZ9wxmJgHTE4Ep3QTM6Clgdi8e83rwWNiDx5JeApZ3d+CtXAHfLnTiram/YkDYZuikM2D2GgWzVwV8PYtgVOVBp0p7rFUlP9KpUs6JJYE68yOdV942nbp0tUFTO8uon1Bv1E8v9zOsTIu27u/U03Y3rGPwTb/w8OuebavH/rsJWlt+Tw5qVF3zZTv4SMbBTpKkzQM4RuXtNK6BxlcuoLFFm0hU9k5mQJRt0glKBQnLAo0sBo2tBMfS/QRW5y+Hfs4B9Dr9AB2bWiC/0ORq3/3IUnoe5HsnyHcC6JFWFJ9F++OA8vUf4Va23FXTW5IeU//BzWxbDwlKvkFsyVfF6B2S1sKFpoMTZ/1TW2iIvZkt+uBs9vucLfkGDWLzBCKod5KGsMUgaceYciFph7nQjANcaOYnXET2u1x47nYakf8KYezEqIItJLJwszh2HFH4gohrRJSvIOFly2hY2SoaVrpaElq2TBI2fBGNqJrPloFKwoYvloWVr5CEVyyXhFUsEb8fXLJGElS6WhpU/II0sOA1thNQHlTyrDRg2Dq5X+ELckvhK3L/wk1yv4LXZJbcd+XmrD1yU9bHTN1NmZ+4mzI/dTOkH3DTpx1206d946ZL/85DY//Nwzv5msLbfk3hnXJa5Z21R6UpX6rS1M3w0tTMcFPkLCdc/z0+ysxf2/vNeVza8QjmJDZjfk9gdrdmzO3qxIIuAp7pwmNpFwdWdOWxpmsTPqlqxvHFTZib8xUCPRZALxsFi1cVfL1KYFIVwqBKh05ld+hVyVf1XqkntV7pX2m9st/Xexe+YPSpmmvyaZhg1Mwq99OuTg3z3dkzwfJbfDfTo4Ao/VXV337E2uS/rLAR3nUuwI8Z/7h7OvGQRuGJBEnf1/rJ+6+2Mw4/jWJbcdkijoxDNDjld2pLvi/W1WxQhxkro+0mjAGJmQV58Zsw7L+IoHuA50VBRPHJcZbiM1aeA/Rr3kXQ+eoxyHeA22EnlC98BfeihZCE5YGYBjhJYNItEa0PSr5J2OhvSArPhaQ0s3YiDU6DWNfb7Pda9wFcpyEp52lI6kkSmvYtDc04yIVlfM4iujhoFJG3jYbnvSmJyH9FEln0IhW1cBMVR4/ZvoGSZ1n7kkSWPMuGlCSR5UslkRVLaMSIuTSCgZwulUbVNEojamZyEbWzuKiGyVzUyClcdO10Lrpumiysaq4sdMRsaVjdTHl47XRZSPU8t5CKJW4h5YtkbFtwcPVTssDqeWzFl1tA+Qq3gLKVcv+SNXJL4Qtya+FLcnPhZjdzwRY33/w33Ey5292NWbvdjNkfuhuyP1Do0r9U6NK/UmpSv1P42M8qve1nVd7235Re6d96eue/qfYevtBHN7XKy6u+gUqTXlLKBp9pb5qGqnYHMK+3gIXdgfmdHmNBBwHPtOOxpIMDKzs5sDLBgRd7OHBkdDPeH/8HhkZshoZMgllVB4tnBUyehTCqsmFQpbboVMn3NZ72SxpV+ncaVc5OrVfxBlYS+GrGjDbpZ5VatcvTI3TbE7sYfo5LCGnRd2hrD/53EHZeq7XVx9L+yhtWefX1CFn+sXYStmW356IcrsvUKob0S1hK7OrtM4DMwYyQsLVZbEIvrlqcyKOdn4H3ii+hv+KE23WAMCRfZOYJIF/zoF/xoIcEkC+cIIcBt68BxYYjcEubDc4/GcQ8kOeChj6iwcl3aIj9qmu7TwobA3ZF+2CW3qc4iI1NC9r/oMEpp2mI/VeRZRie8TmNzH6fRuZuZ9GcRhe8Jq4JiyzcTKJLV7MFIzSu8hkSW7mAS6hp5NrXzmKPktgRsyWx1U+xR2lcTSMXO3IiozBzsSMncdEjJ3Ixo8ZzMeMauJjxI6XxU0dIY8Y1yGKnVMvazR4m68gGnGYPk7WbVS6Nm1QrjZ1QL4udWiU+jxk7Sho1arw0asxYaVjDZFFDGibLg2uny2zVT8mDamfJg2pmyAKr5ssCKxe4BZQvcrOWL3XzL1vu5lexRG4pW6XwHfach6noRYUh922FMXe70pD9oUKX+alCk/G5yjv1B5Xafl6ltv+h8kr73ktd8LKPT8MEH/Wo8SrFsGVS6cAdSunAY/H6SY9GJBzGkh4teKYDsCBOwKJ4B5bG8Vgex2N1LI810U3YlebE8dlNmJN5AAHyuTC4NcCqrobFk2UDeTAo01g24NQo7Te1itTjWs+sXTp1wRa9d8USk8/ocX6aGWX+mqVZUfqdPTsbb9uirHc0HUSyUBtj8L+mPLm803DKTaT3ljYFksLzsdKUPV3Zem2G9pPOE+ppXNV8Gl74Eg3JOMDqZxFZZxFYBPtKQWNqQUInQJ62CT57L8HrDkRQjxzhQRgV9xAP8jkPst8Bup+9Bsi/AhTrjsI96ylwtjQQ34GCiN6HJF8kwcy4UwSOLftwqZMG2x+JOwFsrKZnffvUn2ho+tc0PHM/jcje3Wr4b7kie/F6157AsmXiVqEONTNIhzFjuc7jR4qDSZ3GNTCVdhw3Wtp+7CiRvdhpYg1bMMp1mV7OdZpaxfVoLCGdp1Vw7adUc+1mD5N0XpTDlGs3P1/Wbn4+12lhLlNJ95Vpkp6r7exykKzTnELmEGQd5hbI2s8tEh1E9LRKWfysclnsjDJp1NQR0vAxo6XsFkDYqEnS8FHj5SFjxooaPGq83FY3TRZQ/RR7ZMs/FYGjJyqstbPcTaUrFObS1UyVhqKNSkPhZoU+d7tSm7XLU3QEaYc9vZgzSPnF0yvtRy/PjM/VqsKXdOrR43xUtZOkksFvqiRJv3c1zcbY2BNY0RFYEgssihawNErAyigez8byWBvD45WODhyra8GOut+RaNkAA50Af69aWD3L4asqgFGZAZ3SzmsVyde1ypRftJ7pB3RerEtQsdzoM2qSr2b68FDd2qEdjIc6d9Pei+iufWh27Rxsk/9iAuqa6jsrru1S1D0widt403Z3Z1t4JWzFdvuxo2hcxTPM+ElwxufElnLORedNFZdkkphycDENILFz4D7lY6h/aYL0V4B87gD5TADdx4sDN/RjAWQ3D/IxID0AKN44BffiRSKwR039H9GgIbdoSPJ1Gmq/RoLtd8UBoeCUx2xCkO0F4ILZmLD9DxqSeoqGpn3LhWYcZNOEJDL3LVftXrSRxpatonHliyTtRszh4munc51GjZd2Gtcg6zK1ius5p5jrPb+Q670wV1SGZ/RakMf1mFXKdZ9bxPWcny/puTCbdTgk/Vfb2TyDpPfyVEni8nSSyL5eN4Qp6bVxkKQzOxXGZh5cr7n1Wp8k6btxEHsung1j2n11KvsZeYeVafKEhdkydh6sw6IcWcKcQlnMjAouakaZW+yMMln09OFuEdMqn6gsbFqlW/iUGkX4jApF2LRKZfCEekVgwwQPS9VcN0vVHA9L9VNKc9V8D9PwhQrfsmVKffF6L13BFk9t7ttemuz3Vd4ZBz3VqSc9Pe1nvbxSf1B7ZX/goypfofeqn+rjWTGH4wbs0MhSztotazE/4SpWxwGLI51YEilgRSSPVVEOPBfFY0OoA5/anfhh5j3U93gfRjoNVlUDrKwkUBZCr8xkTqBZp0y+o1OmnNOp0o/qvLJ3GtXDnrN4108N0MwoC/NZNyRec6hzT921sFaOQFsW8F9KGNovLuw8K87wy0fcDWVHNpjxEzbJ121WuTShdharkbmQrL3UlnKO2OwPSHBqC2GbcqMrQCJHg+u1FJ6bfoLHaYB82SwaOv1QAH2fB9npAHmXB3m3GdwewGP7DXiM3ARJRA6r8XkanPwHDUs9QUNZKm+/xwXbnWJpEWS/SUNSzpFQlt6nnqRhad+KkT4y5z0ak/8GjW41+uiSZ0nM8MU0tvJp0mHkFI5F9C4T60SOQs/Zw5jRyxMX5Xj0W54u778mWT5w3RDJoA2DxcekTUnsUc6OiAzaNJB1OdySX+8j0ptZ6ZO4YbCo7NAIc4gDtvRn9wLZUVA2+CQeB+3/eh92jEQ8SMKeszuDTPusT3LrsylJ0vuVvvIu64bIOy7OFJ1C55Vp8i7scU0yU492i7I8EhblyOIW5MkiZpXKIhpL2Lkwj5ilGarYxdnKqDmFitCpVR4BY8e4W0eNV/iPnKiy1sxQWOqnKqyjJyp9R8z2MpYv9TSUPKvSFbwsdgl8sj72VGfuV6nTj3p5pZ709ko96aPK2qNTDV9s8po0wstj2DMy2uegTTnsWlXwLqyIb8ayKGBJJO9yApE8nosS8HwYj+3deJye2YwVeYcRJJ8PX/eRsHoOh1lVCJMyCwZlaoteaXfoFPZrBlXqMb1nzg6TV+kKq3rU+EDt7GFBunVD4o2HOvcyP/KLE5eLtJUC/0WEXdo9IWe9fhb55ZXXwtiVHQb4scjn2rNfN02MqmG579Lg1FNsBx8Ra/48kMhykPCRkGVugOfua5AdBci7Asg2J+ibAshWAeQ1HuRVHmQbINvxGIrZH0HWqaSFmvry1DbkEg0VN/ieoSEplylL+cW0335TXAEWkvoTF5FxgEZkfspF5rwnicrbSuOK19O4kmdpXNly2q76Ka5d3QyuXf100mn0ONJ9WiWXOKdYkrgoh6ms78JcSb+VKQy8VAxYO1Q56JW+7pnv9pCmb+/pnrW7u3va+92luXu6ehTv7cK2EbPbgR7Zn3SWth4OdUt6q4972u7urBR6ouJB0fRd3cTHodt6S5N29GLq1nfjIOYYxOvA4u3BV/pK2CPLCvps6S/pvWmgW+Lzg+UsW2DXg3u91s8t8fU+bj239GcHQ+Xtl2aIx0PZvcB2i7IU7dckszNgiuiNgzzbrU5VxT6d4xneWKayTatUBU6tUtimD/dkx0GCpo7wso5r8DLVzPA0Vs3xNFY/pTKWLVdpC1/y9Ml7y9Mnb5und9bHXp5p3/p42n/z8Uw75qPM2aFVlS81KGoaFbKspQra/2gP7SzMjv0Da+KAFeGPsSJcwKoIHmsjeawPF/BytAPHypqxo+wMOnithFE2CgGelbAoi2BW5cCoTINBaXfoFfYremXaN3plzju+XuVL/bzHjGZOIES7JqWj8XRM55AWK9spkNM2PPR/W9C6tPOQB9vJL0b+rMMdRePvvjqV68SGemoamfFzkdnvcqyNJvbdGa2XrdOuAIkYA/fy16Hc/QD0PYBsEkA2OkE38CDrHCDPs8dmcC8DHs9dgHvqUy3U0vcq8Rv4IxeRfpQpDUk5xai5JMh+S+Thh6b9SMMyDpOIzE/YIlBJFIv0RZskcSXPStpVLuA61MzgOo8Zy3WdUiNqj+nDxQtA3ecWSfqvTBOvAw3aMFgyeEt/t9Q3+rrZt/Rnl4NEo8042Emau78TO/3NrgvJhh1rJ6s7Fy0ffyNKvClYfDxeVv5LvIydA6+8HM3Ohcsb2LTjdwmsEyLLPxOnyP2+vTT7s87iGXF2f1C8QfhZZ+nQ3d2l7Gx46t4u4n9n4Ls9xK9bMwRp32293ftsTXTvu623asDWRPcBO3u6932/O/varfvGQeLV4O4bB0l6bumv6LQ+SdVtW2+Pbvs7qeLf7aGMf72Pov2mJM/Y1ake0WtSlGELc5WRC/LUIYtyfIIX5moDZw/ztk6oV/mOnOJpGjNWbRozwdNYOc9TV/y8l7Z4g1qT96baO2uPt3fmPrVX+pfeKvtZH2Xaj1pF3lZfRd00vaJmshtNetXqXnC2PHgH1sQ1Y1UosCzEgVVhPJ4L5/F8OI8NtiZ8keTEl8NvYLD5Rei5sQj0HAE/1TCYlbkwKVMfGxTJD/UK+0WtMu1bvTJ7p+gENGPGBmoaS8TOgM4R2s7voTlKzzYMtcn/JWld5fUk9a+GvzjSy67v9F07lDBEO3b0RHGGP4zx+sX9fDeozd7MjmSQ8BKQqAYoxnwM963NIM81gyxpAlncBPKMA2ThI5CFD0EWPYZ0hRMeNdshic65Rcx9vqFROW/S6JwdNIq15lJ/Euv5J+l9ZMZeEcSLLthC4kpXk/ZVcxnZiGtfN5PrOmasjN0G6Da9nNXvssT5+WKt3m9phiRpTbJkyGv9xCjONHtXN9nwn+Pko29EyqpOx8rKvm/PFpXIKs7HiAdEK3+NJqPuhpIpTUFk/KMAt9G3A9kZMvmou6FuDXeC2Sozt9FNgaKOaQqS11wPlw+7FkbK7wSR4VdD5EW/R7kcwrF2stzj8eyROU9Z0ZH2zHmw8+OK9K86uPfb0UvKDN2+q5vH4D1dpcmfdWavK/KPtWMnzpgTYK8zJ/BEVb139FJ139FL1WNnT4/++zsp+n7Vwavb/k6e3d7vruu0rbdP3HrxYrAiasNgz8i1Q1UhC7PVIYuyvG1zi9TWWeVq/ynVXn6Taj19x47x1FfP89INX6zWlTzrrSt6Ua3Jf93LO/dttVfGZz6eqb96q1LOaZXpX+kUZavMnjMqPCUFcxWk7+Heusbm+ZGXsTYcWBksYEUwj9XBPNaG8lgf6MBH3ZrxQ/UDDIt4E0ZuIgJUtbCqhsGizIVRmQq9IvmRVmm/rPNI/c6gzH3L5FW2nJUDNs3i7Dj9zp5dTJciOwU8MIWQNlDw/4I0cuL+PtbuEy/vPjAx42cpsXhMs9+iHNKBreauWCKCfuLufXFH3yO2kJOEFoLGjYJy0heQr2kBmfUIdNo9kGl3QCbfBJl8A2TSTdAZDsin/AF50uwH1NL3OxKS+iaNHfY8jRv2PBeT8x6NSD8iXuyJzNpFo/LfpNHsmk/ByzS2ZC3XsaaRdBs7ius1fTiL8KTXjDLSd04hJ6b0y9MZQCcfsm6INH1ronvuO72lBZ91llX+kkCqzsdKhx3uSFjkHueIIFNaQsj0R35uY++EyOvvhrmPbwlwH3XLX8FuErCDJOwMGdO6qyaP+utm99qbfoqqa77sObtfoBx+xegx4qFFvE9YecNKam/6kZIbFlLGDplcjBB3IZRcjpbln4uWl/8eJR93L0J0ADkuI1fknEhgq9GYk1AUH49nPy/+mfzL0cr8n+PEnxF/7qsO0iEHOkoHH+zkOXBvF/de73f36LGnq+gABn3VwWvAgY4ePfd28emys6c67uV+XtHrkxTRLw3yid6U5B22Mk1tW5TFMgFNyKIcpl62OYVq67QKlhWojaMmqfVV8720Zcs8tWWr1N4Fr6l9ct5RqzM+U7OWoWfKGR+l/TetIu8tk3LMWJNixHQ513dPoEfRgzHBB7E2GlgW1IyVNh7PBvNYFyrghSAe7yQ48WOlgDHtd8FEJsNPVQ2r57B/KwcUYjlw3qDI3K9XFLxmUpUvCtRNqQ7RLM2K1r7Vp7fpbGQX231jnPGyso02/P+nsLSfGX7BRZ14Ypvt7yv8poNb2pb+zMC4ruNHUnaEI6JgCw1h3Hf7b8TG9u6ng4QWgGs/BsrxRyB9SgCpvwlSdwm05neQ6jOglb+AVP8CbtQFuA37CNKY0j+o/8A3JTHFa2j7yqdpu+GLJQmlqyWx+W9w0Tnv0JjCzbRdxRIW6WmHEbO5TrXTua5jx8h6zSqV9FucLRm0PF2M8E+ivH3jINHomWbv6qaoPJEgH3chzG18k02M5GPuBMlHXw9nUdt9/KMAMu6mHxl1xegx9oaFGTUzbmbYPuwqUeuhEnHCke0zrGP7DC9oRa0958PeI2XNZQP7s6T6lr+oZa0OgDkDlh1U3raRouvhbBuSW21TkLgEtfB0rKKYlRHH49lz8Ww5exSfX44mRZeilMwBZLu+fvJzquxLUZ7Zd8NVeTciZSnnopUpP8cpko/HK5KOtFcOPB2j7n+snWePPV1F7bynqzr+lb662G29De12ddNGvdZPE7FpoCZi4yDv4OWp6qDFmdrAlWk+fgvyfCxTqtllIG9D3Qy1tmq+2qfkWW9N8Qa1T8EWL5+cnWo2+6+y/+ajTL6mUWXuMyrKlhuUlQsUsszlPpKhZ/L9XsGa6Md41gassglYEyJgXQjLBHi8Ec7jRPFjzOj0KXy5yfBXjYC/qgQWZR6MijQYFcn39YqU33WKjEMsE7Coq+b4e02oD/ZamBure6d3R/P18HjrQwvDBP72Y9om/9vlSbtvn7u4r5998Ksf+cuKz8e4Z37QQ95veTrXfVolW+TBTm5xIRmfiS03W/JDEfQLzoK06wQox38HbtQNkOLTIMU/gBZ+A5J/GCT3c5CcLyApPAS3fssec8H2AyQqdz7XaeQUruvoiVyXmhm0Y+U8rkvdTNKhaj5tXzWHGTvpOq6B9JxaxfWeUcH1nV8oSVqdKsna0l+S9Xofkr01UVq8u7u0YFc3ad773cVIP/KXeFnliQRSczlGPs4R5jHpoZUZOYvozIg96+9qmUGLEb78kl48L15z2SDyG4pOeWkrTnrqWfbzZM6B3S2oOOmprj3nwxyCNvWkp4ZNPk486UkaLunZ38kyA9EBVNwKEB/Z13WPAsRSofZOEBFLhLORrHwgw25EynJ/EcsCETsoORdNmBPIPR5PWp2A6AyKz8cocxnucD6GUa1ZicEcgGfe3TBRCxyhrufXwrzSm4JVQ29EKoZ+l6BI+r69ov+xdl6Jhztqun7WWdttfydD+z1ddbE7ennH7uiljdzSnzkDbfjrfXRB64Zo/BfleFvnFvmYpo5QG8aM9dbVTvfRVs3x9ilb5uNTukbMCNSZ+328Ur/zUab+qlGkfa9XFLxqVIyconXLX6qk/U711S3EsujbWBsMrAgQsDpQwHM2HusDeLwaLOD7rMeY3fEzWKWTEaCqQYCSOYEc+CrSoFeI3YHzBkXGQV9V4Uv+XjWNgV5TR4Sql2ZEaj7v0k5/JyTBdK+NLfh/VkDFTb4s9WfRjxl/7SM/lq6yVV5kwPokrvvsItJ+5EQSVbKGhuW+zYWknqC25Lvi9p6QLEi7jIey4VtwFadA0vaBpu0CSfkQ1P4O6NA3QYZshXTwy5C2G32dBg3ZKu1QPYWl8KJxiwY+pZpLnFYpGnrvaRVc4uxhkqTlmZKhK9Mk9pUpkiGr7ZLkTUnSwg96yBq+bkfqvkuQ1RxrJ6s/HSurPx8rG3U+hoy7HuE29mqI24Q7wWTy7UD3cTf9PBpuWFmk9qy/oGVGrK87odIwo2ZRnBk4y3aYspFmBngy5ydOODJHuFPBvsecwp/6xAGMPaFRjLnmy/TPM+WjmwLJhKZgMv5WAJl8y5+MbQpxY2VG2elYwoBD0bB/iZexlD7rQEdR0z/rzI6dsoMosizmFFzGL2YKWcfaKQpPJDCMQV17J8hYedumLr5t8xl2y9+n7JGfW97tQPeym34e2Q8tbmlNgZ7JjlDV0EuRqsG/R2mTroebBlyKNPQ+HctU1+1YO137I+3ZSXBd5I5exujX+2hCNg5imYA2YHk62/SrMTWWsKtAeuO4Bh/9qElq7YjZPrrKBd4+RS9q1Nk7NV6Z+308077VKOy/6jyy9hg9KpboFMWr3Gji0XjP+qa54WfxXBCwwspjZQCP52wCNtgEbA7icSQZmN3+c9EJ+CtHIFBVAqsqF75K0Qk8MChSThsVWR+bPYs2Wr1qGm3qaZWhPmuHJmgPdurl32KLiLigbVs0+n9K2DLPxEapaAjDrxjdRt62yUrOxIltKta6Ykc62k+qpTEVzxDGiRejf/IVdoyDhGZA2mkcFCUHQLMPgQzcCtp3A0ifNSCJq0F7LwdNXA5Jj/ngIop+IxFZz3A9x9fJ+swq5USdWyRJWpwpSVs7VJK+bghJW59EMjcPkBS+0ZcU7eglHfFZZ6ayhmPtyKif45ih/1UZCi8fdS3UjRn85Fv+yvGXDczgyZTWdL3+gpZFbjGqi5gGu02wlUV3140CNtfAHB97/a/Pn2j2IQ/f6qMKX/tRhZH9eRb5qy/q3Mc98ntSWpApTSHyiY5Q+cS74fKGG1HyKY4wMr0lmBk/e42Bf2I3YCgjT73e50++QJ/1SWxVmjTt/e4eGXu6ug/YnsguIrnbd/aUpu3oxR7FVqJ9VzdGvnKruhOsHtlkU5c2BfqU3fTTlNywMBxCkXPVpCi65sscgU+ayyHoh141+Qx65KcfdCdEm3gvQtPzRpSh/flYQ/vTsZqIPV19InZ18w7d1ltt2zzAJ+D5wTr/Ncka69IMrXVOocEyp1hnnlGhNU2o1ejrp3prhi/29i5ey+b9fbwyP9F4pn+t9Uz7nqXuvophz5s9hi9U0KQ3gt2Lrk0J/h7rbcBKK49VgTzWBjqx3l/Ai/4CDvdvwVNxzAlMQoCq1QkocmBSpLDuwG29R9r3RmX2uxbPkmf91SMnBvssyIvUbunfyXguurPlobVD0Bl1mxP43y1PjnPWnVDpS6+a3Ma32FQjLkWJTD+2zqv/mmTGgGOcdwkbhgnNeYcGpZwmNrtAglIgbT8SirwPQZPeBen9PGj3xSCdGkE6TAZlO/rbjQOXUA8anvkrjc5ez3Uf1yDr21giH7goR5Ky2s4MXpKxaaAk942+Ymqf/XI/Un+kPRl7PJ4wo6874Yr0dScSyNjTsSy9lw470FFWcaydfNz1CPdG+LtPf+THanGxTh97XsMiNTNUVsuLz59E+bGHPEReAzN09sg2GT25X8AM3wV+uo6YMGU/V7rPnRm/OPzEMqOp941u01tsstozcdLcfV2lmR+JR02k6Tt7umdu6y3N39tFVnakPfv/YxwCxilgLUdxGSpjTTLadNc5haKKl41nlTKVdZ1dJOs6v5BrP61S1rmxhGVc7Gfl3ZenMkfhPnBbb7H9WHg61m34nRAxC8i76Ufq72pVBRd1ioxrvuxRlX1Jz9TXflFnGnxJr0+8atIk3rAae9226bveCdH1vBsmOoJ2P8dpoj7prIs90t4Y9Vln37DtPbVBr/XT+q1M09lW2/X+i3I05unl3sbxIzWG2lk++up5Pj4lz+q8C17VqrN3azwz9orMPkX6UbOidLW/oqbRS5K8ySLPuDkh5CA2hLBMwImVfjxWWwU8Z+HxgpnH0QHArPh9sMgmIFBZBX9FMcyKLBgV9ma9R/JVgzLtsEmV96ZFVbEkyGdiTbDXgrwY3fbEDtqLETEGBgoyolCb/G8SuNL+hlNeYi1bfcvfbWxTiKzsdCyLQJKey9O5bnMLuA7jGsQlnhGFL3Ah6UfFcdvAZEjja+GR/iZonxdAuswD6TRTPMxBY2tAo8tA2NhvWPZ9Gpp+kMblrec6184iPcaO4XpMGsH1nT1MMmR5uiT9pUFiPZ+3oxfJ3dabZL7Rl6S81o99LWU1Pntk3ytm7butiZLUzQOYsrqfFO3vJG/4PUo9vcnGoj8zfva7sDSfRWsWuZ9E8T+jPTP6asj+NP6/ni1jrz9xEINbM4HsQx7MiSgZjjC+ycb6/6yVKBm6YbCLMjynkOs5t4CwDgTjGCStSSb9V6YxFb/fY1Yp6TKxjs0YkHajJnExjDtRuYDElC8i0WVLSGTZMhI2bJ2EjRSHF2+goYUv0PDS1ewAKomtnc61n1Avaz+1it1PkPddO5SxCRX5X7djeIJ6RFOgYfgVo+ewC1rROQ0+5cXOq6vsF3XGgZcNxozLBuYI2HNdr2u+2u7XzZrON6y+3a5HGDuej9HFHWvHMgKm5vjvEiyRe7uwa8DagFf6Gm0rU3TW+fksE9D5TqnWmUaP0xlqp+sMwxfrfApe1nnn7NB4Zn6iVaYd0yvSvzIq8l/x9Rgx11OW/rxRlnJ5ZOAneN4GLDU5scSXxwozj2fNDmwyC/h6UDNGR74PX8lo2FSV8FcWwaLMYE6AN3jYLxsU6QdMqvxXLeqquVbviXVie9BnZ89Oumth3YxPFoy2UYb/vwmr+dmHndX8DAhj0XMyAllKzaI/Sdo8gLHl2MALja9+qnWl1xbWmiO2pIeSyGJ4DH0JXO9VIO2niCe0acwI0Chm+Pkg4ZmgISkPSFjaZyQm/2USU7SetKtYQDpXN5JOtdNJjwn1pO/sYWTg/HwyYH4uSVqWRoY8N4RkvNyPMCMatCSdJM4tIL3nFJI+s4sI6++zQZz2Y0eRntPLSZ9FWaTv6lRp9vZE+ZS7Ye6TH/mzupxFfjFVFwlMH7qRxtYIz4z9idH/qY3/5gDE90Mcevq3DcetmZFyfItBPvJihHvOhz3lfVamMWIRiWUMyKo5JKp4DYktW0JiKuaRmOFzSWzlUzS24mkSN3w+iSpZTsLyXySh2TtIcOYeGpLxMQ3O2E9taV+QoNRjxJZykgSmfk8DU34i/snnSUDyRWKznyW2lB9ocNoBLihzF40oeFHMvKKrn3LrMrXKo+fCbMYklI+4FOU+Cv6sBGCRX3QAaWe9mRNQJ5/zYUbPMgD26NnpglbV85KeqegYejXZTF3uRZq63Ig0xp2PYWptfzrWP/ZIe3PUdwnW6P2djMFv9DXa1iTr/Rdnm4LWDjX6LcjTmibVsluBWm3ZMnERqHfu2xqv7A91qozDemXaYYN73jazoqZRLct6Ticd8uMI6/tY7Qc8Y3JisZXHCguP1b48XrIKONRfQIltK0yykbCphsNPWQizMpN1BpoNCvsfBkXmPpNn/isWr4pnrN4T6oO1K9M6GD/r3Nd8NzxOed+QGMCuD7U5gX9MnpB8WIQUPzxXjCKIVXsp0iP7s86MtirW/V0bS9hlXhLNVnoVvUhDMr8gtsEXuNCsx+4DngXttrj14OZwcBF54g5/EpoO4pcEYuzXQnz73CTm/l8SvyGvE7+h64j/0BeI/9CXiI09T1tG/LKeIgEZc0lA+hzin76Q+GcsIH4Zs0lg2jISkLyRWIa8QsxJbxFz0g7im/QesQzeRfyGfEAsSTuIZegLxC9zOuk5a5is6kh7j8YWMxntAvXEyN/IRpcZnZT1kJ9wy/9yqJThHszo//oaW3YiZgNgTsCdZRIM6Xeb3mST5n7QQzJwZQrHph5D83YQy5AfiWHAj8TQ/zdi7H+RGAdeFJ8b+p8mhv6/EyN77HeeGPpfIoYBt4mhv4OYBrIbAs3EMOgxMbL3aAiIKdmlvikgpiEg+v4tRNdPINqBTuI7xEGC7Le5oJSfudDs9yRxVfOlHSfWMeoywxXcGlpEQpJHxXWzmAUUnvNRMycw4IyaOQGfAWfUTBnA6dPhjFrd85wPcwK+PW75G3o2BZl73g0zx90NC4i5HmHrdDcsoMuNSEvMz3EBkcfaGYJ3dfMN3dHLGPRaP1Pott5G22q7zndqlY9h1HgfffVTGs3whVpv5gSKXtR65bynU6UxJ/CN0T33Xat7TaPWrWiuRpr0Q6V1J54NAJ7xbcZiiwPLW53AZj8n9nVvQrL+BZjdahGkqoC/sgBmRSYMimTBoEj5w6DM+NxXVfCy2aumMcR7TnG88Y2+va3nY3v4wj9ce9Kz7dbAPySN3J/pLYuU4jLPqybCeP5Zn3eRDGDDKUszuJ4LCrh2Y8bSuOp5JKp4A2EXe4KST1NbykOP3s+A67YQJHYkSFS56yJviP0R8e37gAQlP+5eOJ2fvfqt5td37Gt5+/0Dznd3H3rw0d4jN9//9Ks773508OG7Hx14tOPjQ/e2ffLl7dc/+fLO5k++vPfCngOOdXu+cKz+6AvHst37Hy/etR/PfLjv8YIP9rY89cFezPxwH6Z99Bmm7PkME3bvbZn16RcthatevSCJLpsjzf6ks7KxxeAC6FpRfOYA3nxyqPLfcQB/vvbvvM4yBdYGrD3n4zalKcg9671ebM0ZYfsOIktXE/2AM25DRqH/O/tR+ObHKHnrU1S8sx9V7+xH9Y59GLF9H+q278PI7fsxesfnGLPjC4zfcQCT3z2EaTu/wrQdhzB9xyHMeucrzHn3K8wT9TAWbD+AJW/vx6JXP8Xop99Au7Q5IP4FIJakFhqccooLzdkmiSpfxLIyVm64p3zQQ156PUJd2WRTVD3wVRee8/HKPq9hDoBlAprBp7yMA48pxZIm6oRKHX/WmzkCZbfLBmM3V1lg6fzQau3aFOLb45E/ewzodi/CP+FSlDX2dGxA/IkES8LxeEvEnq66gHVDtAwc9J1apTdNrDMYxow2aGoatZrypTrvkrUar5wdOlXGQb0y7VujouA1f0XdDI1b4UKtLOm3KusHWOkPLPQVsNiXxzJfHqtMPF7ze4wPu9xAD/Uy+HnUIVBVAasqH77KdOg9kh8YPFJ/NSizP/BVDnsuQD1qfIh2TmGs6Z3ejCnYxXDf6Noh0Cb/GXH1+pnh151QsdYYqblvcBvBtvl+l+A2+KVBcpEvvzRL1n1qFU2omktZ248tzghNO0ICkq66dZ7aIu06DyS6EoRt8xVTfXsz0fQ6E5885tpHB06AySMAPwL4AsA+ALsBvANgG4A3AbwCYCOAtQBWtepSAPMAzAAwEcDoZqDBCYzggdImIP8BkH0PyLoHZN4EKu4DkbPWbyBxn4ep5rfoWa0upv+Nb8rF1J9FeDHK/z3yxAGwrUeu90gxrcVXNvyHOC5xYb60Q8NkEj1sHbGlHCGavvcG7TyA2QBGAqgGUAmgBEBxqw4DUAqgHMDwVmU/MwJAHYB6AA0twJgWYDyASa2/9zOt78suAN/xj7H5nW9g7lDNMgM28vwHZTsIIyuWsMxM0mdlGmsluo1BkHv1I39V+Sk9cwIiFpB4QiUaP+t+sKvMcceUms6nvKxdD3mwR6+u5zXKLleMDCRU9bynZ87A1O1WgKXL3dDA7o5w/86XoiwJv8Rboo/HBzCsIGhLfwYM6i2zh+nN08sNvlOrfH3Hj9RrR8zW6YYv1noXbdR55b6r9cz4wqDMOGj0yP7A7FH1tEae9bxelvR7nd+nWGEGFhgEPGMSsMwsYJXRgW3BLXi54++IVcxHgKIWAcpSF2VYYW82eCRfNynTDhuVedtMKjY92DAhULcwN86yt0tXfVNIL90D37auwH9GWNrL2l+sD86Mv/KhlYxpCiLll6IYki0ZsDpV0m9hNpc4o0zavn4qjRu+iEYxYCrzU+KfdEEWU+OUdZ4NyqI+u9zDduuF2R3E0EdIG/H0/bv3+eYHAHY2N2NekwPVD5uQ97AJGY94DHnIo899B3rcc6DTHQfibzoQcU1A0BUefpd4+F7kobkgwO28APJb66GPnxwgPzhAvmXLQXiQg2x/AA/ymRPkTQfc9wsIWP3GFhKwPVIxASYx+osryltrf1YC/GcdAIv+LDuquO7pPr0lwG3IywOlDASNKH6eBKf9SExDHptynsJkoRnxPI+ARzz8HgnwfSBAd4+H9p4An7s8fO7w0NwRoL0twHBLgOmGE6ZrPExXeVjY73xVQMAVHrYrPIKv8Ii4IiDumoDONx3oeZdH7wc88hy86Dh/+OUqQnuOBbGkgtiSr3MhWbskkWXLuI7Ty90GvdFXlv9DHMsClGw5a/Z5jchzEMHMU276xBMqEvWmq+PR9ZCHqMwhDHQ5BFYWqBPPeqsSL+pEJ9D3VoA1sTUT6Hwpyq/TuWiGDfiG7expDGWYwKIsfcDiTF/r3CKTZeoIk75hgkFX06jTMCcwbJ3Bp3CzwTPjM70i7XuDe857Zo+qhQwTMMpSzzSYv8QyEzBf7xRxgaW+PJYbm7A9HFgS/h0CZZNhU1SLnQFfRSZrDz40Kuy/mlSZn/qqCjdbPKvnMVAwxLja3sl0uOMga1NId7EUaJO/Q1pPdov97bPerLYlox75k5Izcaz3LB7wYFTfXjPKuM4jJ4prsaJK1pDI3LepbfAP0vCSh3LW3ossA2H1Ptu+E5byC/Hte6pzxkShyfEYfwCY3eRArYNHpUNAQZOAtPs8ku7z6HefFz/YnW6xD7oDUVd4hF0SEHSBh+95AarfBUjOOFuv9jpBTjS7loGy7b/sYOfnTtB97FJvM+hHLSAbBah28jAue+M1Er41lnH4XYSenQoxgv9b7f/3A0VPlp1WH1UwajAbEhI3HLOpx+DMj2iA3cFS8qJPjovR3vTQAcsDHr73BBjvCNDfckJ3S4DPDQHe1wR4XxXgdZGH5wUe3n8I0P/hhOkPJyznBFjO8fA7z8P/HI+g8wJCzgsIP88j6oKAhMs8ul7n0ee2gMH3m/AhgAPfnIdHWCWInx1cYMpJSXjBy6T9mNGsU8OGtFTDb0SyMkAEA5kDEAe5xH9rd/HfXeR6/AUIZQ6i69Y/swFz/wta5gxYRmAedNPPv+eVIFsnR5itpyPM1goQWhMOdjKHbelvCVo71GRblKO3Ti/X+45rMJhGjTfq66eyoyAGTckao3fBq3rPzE90HqnHDe7Z7/sramepJbkL/eVZFyZaj2OhAZhj4PG0ScAiXwHLDDzej2zBaOsuWGUjEagog58iX2QKGj2S75g80r7xVea9ZVGVL/VTjx4Xol+UE295q89A6+WYnqZ7+rZZgb9HGLDFWn4VJz0Ze41MeGBiE2+MPsuWYEgSF2ZzvWYXkS5su8/whWLEi8x/nYSlf8wFZ91y6zANJKIE7JAHCbY7aGjKWRKaeogLtH/62benhSYAy3ke1U0Chj1sQu4jHqkPBQy650Cv2w50ucmj3XVBNPyQiw74/8HDdF6A+qwAt98E13kvth7suCBuACZfC6CHnK6dgHsF0D0C6C4nyHtO0O1OkOUCVG8+hnHl26+S+BsWVsr8SfQR23v/gLA/xxzA2DsawiYCe6/I4BLqp5Kw/Fc4m/13YkiCuWghGptbEMMLsDxwwnCbh/YGD6/rApRXBXhc5iH7g4f8DwHycwIkZwVQdqvwVx7SUwIUvzrhc8oJLdNfBOh+5mH6mYflZwF+PwuwnRYQ+ruAuAsCul1zou9dAWmPmnASwPintoJok0ACk++ToPSDNKp8Eek0tcpt4MZBipxvOrjX3Qpw0ZvPqP9kM7ZmAqLhi4Yi4iLiFWcra3F2P+lpYsBg4kWdZ/8LWq9B5zUsE2BOwNL5htWYeDvQ3MkR5tfjcrS16+lYv5gDHa1sxiB4ebrGb0aZj2VqldbMMIGxY3yNI6cY9dXztNph63Tq7HcNyozPDIr0r3yVhS9YPMaOUdL0Z8Lcyy9Ps/6BBUZgrknAAiOPRUYBq43NeC/agVTvjbC418KmLIXVIxtmD/tjs0fKOV9Fxl6WBfipq5/y95lWGWpanNnB98OefU2PAqxiW7Btvfj/XNiHu/iyktX9ogOY/siPDDvWTjLo5YFiu69HYwnXfsxoBvq5NuAWbKFROTtosP24LKbmMY0oAwP42PksEmw/Q6My9hFDvy/S65ecYjX/NqcTYwQeFY94ZN/nkXzPgYH3ePS6zaPTDR5xVwVEXBZgu8DDfI6H5jcebqLR/+V67/fsVLdrGSj9zAn6qRN0jxP0fQFkh2uRCHldAPcyDzJfgOqlxzCt2bmeGFuUYtR7wub7u9P+v4rIBRCXnjJqLyP4kI4T60hE4SZqSzlJbaktxD8X5Z9+jxy0QH9fgOmWE5qrPFSXecgv8uAu8CC/t94qZGvNf3a4thw/cWzirUIe3HcC3I4JUH4vwPMHAd4/8NB+z0P/PQ/fH3n4/8wj+IyAmPMCOl4W0OW2A5Oczfjl4h0YO9aD+KWCBtov0JDct6UxNY3yXouy2G4BNmPAphPFjgBzAk/eD+YAok7IXZG/tTOS86bEmn3eg5UIrFPASgDmBFg2wBwBe27ocsVoaSUR+fU4JzoAU7sDHY3Rb/Q1BCxPNwTMLdAFLsgz+M8tYhRi5gRMhtpZOm3pap1P4WajV/a7RkXGZ0ZF5icmRcmzYcoFeQo6dGk71ehH8/zvi05gvpHHAiPDBXisNwObIy6jneJpBChGIFBRDKtHJnzdk+/5eqQe91Vmf2jxLF7r7zNykk07pzjC9+WBvU2XIlkW0NoWbJN/V1hKLKa2Z9QeYx9a2Jy7rO5ytCTtrT6SPouyuK7Th3Mdx46h8SNmU9byY4s9o1j0T9srCS+6JYksB7Uls917V0hI6nc0IutjElPwIjH2O7Tu9U9wB8BkhwNVTQLyHwpIuSeg/20Het7i0fGmgPirAsIv8Qj4Q4DxdwFevzkhZcZxgtX4bBswD3LE4doEfJAHZfsBP3KCfiCAvNO6OegVAWSzAPICD26dADLTCdXaFphW7Fwl/o5PWHxipPsrwv93CjOM7EMe6to7PmxHgLzfigzxlmEIu/CT3ETMmfCvfA6Tm1tgeuCAz20B6muuiC/50/Bdxs7OkJNjDtdVYpbNsMvER5ygXzldi09ZScM2Hh8SIPlKgNsRJ5Rf8/A86oDmmADjcQGWH3kE/ywg8jce7S4L6HWHx9cAZi1+D8SQwRxAEw1MPUrDS57lOk6pZpuFpBkHO3mMbbGoWBbAZh3+mgWwz8Df8CAYw5EpcwIMBxCNv9MF7RMHwIhDzAEEJN4O9O12L4JlAb7tv+qgj9veUxe2bog2eHWq3rYw22RbnK33Z+DgxDqzcfREo75qvklfNd/oU7LG6Jmzw6DK2mtUZn9oVdQ0+snHjFVxfXcO0C5qXhjwGLMNzXiKOQFWDuideC0QmB90FIGysbApyuDvkQezu73Z5G6/6Ktk2UTeW37qqrmBPlOqWSnAuAFslVjntonB/0BY6t9KZfWY+NDMxmEZhdUtefMA0fjZTH3Hhgls9TWJH76YxBSvZ1tzuYjMD7mwzF+lrOYPyoS47Ydd94nM3knjhz1H4ksXSCIzDnz53RkcZgj3IweKHvLIeCBg4B0evW7x6HKDR/w1JyIvCQgUjZ+H52kHJE+OfjxZA84APmYY+5jh86BsMej7POg2tjJMAHmJB93Igz7Pg65xgK4QQCY5oVzRAt/l25eIv+cTss8/mgoy0LDuhIq9R9LUd3qTTpNqaUTRiyQo5UcSmAoSVIbhB87ADkB5T4DqOg+Piw5Iz/MgZ13Xiyj7ndidwm/YTQMBlJUxX7FSRgA9IIB+7sIyyOeCuPVYXIa6lz06IPtCgOIrAaqveXgf5WH8ToDfD04EnXQi8jcBcVcE1Duc+Ob8LWji61xZQID9EssCuJjaWfKeC7PFtmD93TCP+odm1zRnKyD6xPhFFuRfHp+UBwwU7HrIg3UNWOuQcQhYWcCUEYc0/W5YjAObbMZu52NYBmCI2dXNGPVaP0Pklv768PVJTzABY8CMMr2RXQFqmGzQ1U1jjkCvKVmr98p+16DK3m1UZn9gcS9bZXWvmegl6f9Vnu+beNoMNOqdmGNwYr6Bx2KdEzujW1BhfhNWWTVsYhaQDl+PZN6ssP9mVmTtsXqVLw3UjBsdrJ09LMr4Wr9Ea1NIgumS/j+F9/xLCIgrrS3+SEmm3NXKp1wLk1X82I4t9mCLMKWdJ9RzHRnaX7WQLc6kEXlbaVTOTsI28kRkfC4JzxNoSDZDnu9TFvkZIBhXsoaN75JOtQ2aTkWfnvz9KnYAKHjEI/OBA0Puuoy/03Ue8VcERLUav+F3AarTPCQ/M+Nn6bAT5GtXJKRfuIyBRX3yLkP4BVBxX6AA8qIA8rwAuloAWcaDLOJBFwggox1QLn4M4/Lti8Xf1WX8f9Pf/3sFlEVLz/oWrXz42UhJn2fTXLV/9ns0MPkeMWUgqGI1ZjYDvk0CvO44oWSR/5xDrO1Zt0KM+t/xovGzFef0SwH0ILtrwLoWzNAF0L1OEFbWfCqA+5g5u1aH9zEP8okAyX4BHgedUB3i4XNYgOFbAZYfeAT9yCPqDI/oS01iV2DKwneeZAGPaWDqcRJW+JLYFuy3bogHO89W1xQiLjVhLUBm6E+c45P17qLxs3KnlfX4xCn8pXPAMgL/5HM+DBwU2YNJtwPNbMKw+4GOlvZ7u5hit/XWR2wcZIpcN8QSunaob9DcApNtTrHOOq3S4DtutNk0epzJUDdDp61coPMuXqv3zNtqUGbuNzIDdquar3UrnqeX2f+o8T2KeTpgplbAbB2PBXoXHrA19ja6eS6Av3sJAjzyYPFIY6XAHV+PtG8tqvzXrerqeYHe40cFG5an97Scievh+8i/lSLcJn/Kn/P9Z9QejQ/NbKjGLe31Poy7znWdOoLrwmp+1uorfEESlfcmjcjaS8PYLr4M9niKBqU2U3YrLzTtGxqZt43Gla/guk2oJwPmFpDExmxd17JtP569Kvb0Mx/ySL7Lo88th6vmv8Ij/AIP23leTPsVZ3hwrN5np76egHwHBJD9AggzgA/ZVmAe9C2W6vMgG55EfB5kBQ+6yAE6zwEy2wE6SwCpeQDlMwJzAK4MQKxt/0EHwKL/xOuebEmIBxvw6TSlhkSVrCTs6Kd/SjND/us+/wWZAFT3nVBdFyC7KICe4V0HTb5jh0pZJsMuGAkgzPA/40HZ78Y6F8z4P2k1+A8d4iZk+p4AslMAec8B+gHbkMyDfCRA8okA98+cUH7hhPoQD+0RB3yP8Qj6yYHQsw6U3xfw3R93oW0/ASQgAyRw6HUalLGXlStsboNNGbLtQ6ShRS92e9jkIzPsJw7gSQnQYR1zAv/2tfhaqxNI3OfOsgHREaSd9fZPuuYbOPRWgHnI3TD/fpei/Lt81cE3/oMevtGbknzjNw7Shy7O1AfOHmawzS80+TWWsFKAdQf0RldnQK+tnseuBhtU2R8YFJmfmjzytlo9quarpfaXwjzKbk0zXUGjD3MCPGbrnJij5fGCLzDf/ygC5XWwKUvg75ENX3e7w9fDftbskfmpxbN4Q4DPyClsl2A788fdugfeDW8rA/5W2D+o/aiCjceKAzMFH3eT9F2dyvWaW8SxRRsJFc9Ioos20aicd7iw9C9pWNqPNCTlLLEO/IMGJV8Wr+mEpx+g4blv0+hhz3Odx46RsCm+zPVJJOm5AYbuwzefOHsZG9CCIfd5DLjtal8lMMDvooCA8zwMZ3koTjvB/eQyFnpMAGWGwoxfRPcZyOcE2e6q9ekrbGmoA/RZHmSpA/QZhyviz+FBZvEgU3nQSQ6QiltQzX8E84ptC8Xf9U8H8J8UkRuxz51MvaeXlZ5IkPRamkWjKp6hwVl7xOhvTIV/yRJMbX4M6yMeXrcFuF1ygv7uFE+Ui+n+107QL52gB1nXotWpibcOnKAfMxVAdwsg7wugzMltF0Df5kF3OEF3sMdW3ekE+UAAt0uA+6cOKPbx8DzAQ3eEh/8PAsJ+ERB1vgl7AUx9xoUFkMBkBw1KOySJLF0tbTeuge1slOV/3Y6MafF9srnoz87IXw3+z/eLAaZiy9TVJnxSGpSeFZ0AAwhZBuA34Lo5cOijgMDU6+G+Pb/pYO72fnd93PokQ+TydF3Q/Hx9QGOZMWB6uTGgsYw5AJ11RoXePKGeOQGDrmaG3qdsmVFd+JJRmbPDqMw4aFJkv+uvqJuppgNf6e71FGYZmzFN04zpOh4zdQJmq53Y7N+MAt0WWNwqEOBRAItHaovJI/mO2SPtG4tn3lZ/75pGf8304VHWDYM72A51ZivE/qHPwD+ntG74Yej4ZPjLxpyLFifY+izIY71+0qVhMo0pelFE+sMyDor798JSzhNb0j3loBoHZa2+oNRviLiHb9hz7Ngnm92XFu3o5VG+twvJ3dnJkli/5Mezl7GqBejDyCs3BXS8JiD6oqu3zdJ+D3bWmxk/i/zM+I+0GsledgTEFQXFWv91J8hLAsj61qi/lKX6PMhsHmQGDzKlCYQZ/rgm0NEPQYovQjX7DszLti5w/b7/CPLfWjpUX1SwxZ+SIa8NJAkNE0ho/hsiyh6YDhJcjMqDv2BwSwuUtwS4X+FBzzlBfhFAWNeCOTMx1WeG39qyZNH+EwFkjxPkQwHkA3b7gAGazNE5Xb/vm7yoLOOhbzldQCd77W3W8eAhec8B9494uO/loT7Iw/eogJDjAsJOC6h+0Izvzt2Cd2wNiF8KSFDKTzS84GVpQt00dqiFjQ7LR1wLFcFAttTkSbr/14Ence7hr9I6EfnESbSWA2yXgnXQeU1o8g1LcNpNvwD79Qhrr886+/d8t4cxfk2yPnxRli50QQHLAPSBs0oNtmmVzBGYmVOwTi/XiDyB0eNMurqZJk35IpN30SYDWy2mzDhkUVQssbrXT1BL+n+Zq38HM/XAJC2PaToBM3Q8ntY/xnO2q4hznwaLR6HYFvRV2JvNitRfLaqc9/xUwxcFaSeNYC3BaOvmpI6hV4Ks1vNtZYAoIqnllJuKrfQefSOSVB/uyDbrcL1mlXIdRk2i8WWrRIpvRMZBdlyDhtqvEL/+D2TdSlt0H1+Hqmw1iKHPFzSqeC1tVzWf6zmlms3tK9jKrfHnY0jlj9H+/SfMPPHbJTzTAnS77UDX6wLiLjsRdE6A6awAxelWYIyx+Y45/kz7RUIPQ/nf4UG2OkBedoC+4ARdy4OucIAuZm0+B0hjE8j01og/5j7IqHsgI++C1twCyf0NqmlXYV70xAH87Qf67xH2oT8hJwz5L/yiA9dlWjWJLFlFg9K+JYF2gdX+weWrMPVxC3R3HfC45gRlTMVTPOhxFv0FEdGnn7tSffpJa8Tf5Tp6Qt53ilGdRXqxhcnKG2bobzB1gr7Gg77qBH2lGWQLexTE18gbDADlIX3PAflHAhR7BWgPCvD/RkD4TwKizznwMaNLz9sGok1lWcAdLoRtTK5YIus6p9Ct70uDZMU/xXiNbdH8OQb9Jzj6H71Pf8kGWp1AVM4Jua/9ooKVAbb8+0Zr9g2LOfG7hIDuu7qZe73fvdUB5OgjFmcaQucWGIMay4xBs8qNthkVpsBZpXrzpFqxFDA3TDDqR8w26Sqe8dWyTKBgi16V+SnLBlhnQCfLXeQnz7rSYPwVU3TABJ2AyToeU7U8nvcDxln3wFdaigAFywIYIGi/ZlZkfGZVFrwYqB41KdwwpzDWf0v/bgEXIzqH3PD6h4Hgfxphaa2I/p5Rk2ktvqTi63YS+7ohbAaf6z6plsaVLWNtPhqRuY+GscMb9gdcqL2ZWgc99lrxESQ7AdW6R3DvN+0ksaY2iqn/0JVpirrvEtSTmwJV4y5GkLIjsdakSZO+++0iZj8GOt7kkXDZxWgznBWgZEbyo8MVJRmVlx38PMBafLzLQN5lQB/fWu87xKhPl/MgC/nWdJ8ZvwNksgN07AOQkbdAaq6DjrgGUnUNJONnqCZegHnhG/P/9tf/u6W19UcaHlolQ14eSGJqZ1FX9P+D2lj0L0ftwdPo+7gF3HUBUna9mJF6TjhAv+VdpcwXDNxjZ80YZ6E1q2H1PeMtsGj+dmuGs5UZPDPw1jLnZSfoZicoAzlfcLU36Ys86GYBdIvDdTDlTQek7wrw2O2E1z4BpkM8gr51tQcr7zfj8G83oQovB7EOaaa2lB9JZOlqrtO0Snniaju7S6Acf9/wb3sQ1sn+vum5VgfQ4aisQ4ejMnavj5UC5vS72iD7LX9LvzNxft0PdDR2fqWvsfPL/fRxGwbrItnG4enDdcFTq0whc4qN/uMadJYxY42WsaNM5oYJBvOo8TpTzUyjvvopX231PINP6WqjV8EWoyprl69H4WZ/9zET1LKhazt4TXZONDkwRiNgrI7HRAPLBB5jfeh9JKqfhtmtAFaPLJg8kh9ZPNK+tSpydvp5VSwJ088e1tG6PbF3wKXInv53fKIY5+FfVsQBmLPuZDIz/ge+8tFnIyVpm5K4vnMLuC6jxtN2lQvEi7jhmZ/SsJTTNHToLS405TFrK7nnzIcHS2NX8CBPAx5TfocstupT0mF0jiRjaz82Gaeaek9vnN5kIyXfxAUOmjj56zMXWiY9BuKuMyqrK/KrfhXAiS2x1hqZ9b/Z0c8naf/bLMo5QBmhZ70DZLUDdAkPOt+V8tPpPMjkR6ATm0BZ5B95E2TEFdCqyyDD/wCt+AMk/QSUY8/DPOf/kwOQk9G3vcWlnYlLc2hU6QouOOMLarM3EXMWIiufw1OPAfcbPMgFHpQxFhmxh7X6WN3/hdNl/B8JILucoB+6uAtiLc9+R3b9SIzyDpAtrcb9siAaPjuSQpnhs99/rQN0LTuU4gDZ6AB90SGWQ+xnJa8LkO90QvGRAM1eAZYvnWIpEPHbI7wHoGrKiyDaZMbTuE3C8l7nYuumyRgYOGhbX3nRhXBxLkCkBDM+wJt/n2E8oQ23AoMsC2AOwJzW4kfI6o6E1PQjZNRAYnq2t679W710CeuGaMPnFhlDpg/XB80o0wdMqtX7NUzWWkdO1FtHTjJa6qcazDWNZlPtLF9j/VSjtnqer3fZMpNn3laTImtPgEf1U/7KcfU+sgFfZRvex1gdUK9twmiDA2MNPBZagFmBR+DvNhz+inyRHWhSpJyzeGR+YvUsXsvKgDjja/262k7H9jLf9Ovgc0b9r5sFuAAcb7a6SlZzOkaStaMP139BHlu8SROGL5TEFLzMiDxUPLrBevv2xzQ0AzSsBOo3fgZ9EyLiLqbfswC3sq8hia5fIsv6MI4saNGSxvMaHcsqKn+MDhw4adLB0xce1wkQiT5+rNXHjJ/V+987xF642N9nPW+WHrO0mBF7WHRjH3JW7692uI6FzOFBZzpApjpAJzxsTfnvgtTdAKm+5DL88nMgZadBh/0KYv8GyobfYJr5emsJ8J8U5igZP6IROlL6TQeuw/iRNDxvKw1O/p0EsdZnJUZ+fgr9mx+DXHK4BpRY3X/cCcrmE1j7kpUyrN5vjfqU/W5PIj9rZb7OIr0DdLMDZBPvuoz0Ag+ykV1EEsSShzC8gwGeq5gjbP2aXUxiXRDmJF7iIX3NAcU7AhS7BGjZANQRAbafBBTfeYzPz1yDKmo4iF+yk7MxenDpCrbHwS1p8wB2d4BUQ+fLcACWCbDPxn9YAvwP4sIDBn8otgTFseKMFoNEP3fwyNmv7Xx718Gjq178YHevpCmvE/ecyYSUZ8tNMzKNkQvyDMHTKn0Dp1YZAkaPM1hrZmotI2brfavm6i3V8wymupkmU91Mo37EXJOm4hmTd8GLRlX2BxZF/uvBygn1Bnn52GCPkkvVhguo1Qio1T9Ag74JY/VOLA8UMFizAmb3AvixMkBhv2VRZHzh51m0MUgzdkyEaXkm6wYkBjQFJvre0/1rMgMZ6Uec8b+kJ5ObAqXFn3eRDF2TzMA7dgWXxhRtZDf0aFjKj1yo/S4NTXlMIzJB/DKhqNkA9wMAWSuIF3zoUywKN4ObAHjYX/nNrf/TQerl8CbjLupEB1BzITxg8NSxB3+/7CxrAvzPCfA5I7jQ/m8doEdajZ+h4R8xYg8zDEblZcbPPuRNIKzef4YHYf8tlu5PagIZ98Bl+PW3QGuuggy/AFJ6DqTkDEjxKZCik6AFJ0AGH4Cy9meYZrzyj2QAlEU39ejb3myhqLzP0iwaWfIsF8Q2Hac4iTkbQcWrMNXZArcbTSDnWqm9jL/ACD4M9GO8hdZevkha2iGAMhCP1e+v8eBe5cWanpGYyCZH6zm0v7Q2VwugqwTQlbxLlztAlruei87gWR7cWgF0vQDJJh7urwpw3yFA9ZETvl84EfxtM0J/doi8gOppm0E0SaCByRdpWOFmrsPEGsmA9UlS+8FO7tXwF/cispLQRfpp5Uv8zwTi+8McBpsXUKfBm5ANIZlL3jr0OYDGC8D6K8CBP+7hg0+O3ps6/YVvo9qP2EaofT7h8htUlqdydCEzKvR+9VMN1ppGvW/VHL3viNkmc+0sk6l2utlQN9NirH7KpC1bafIuetGozNnm71n5dKznuiFqmX1OD+8lQoPJiSr9fdToH6Be9wjTDMDs4B8R6j4Cfh5ZjBh0hzkAq6roxUCfUZPCDHOK4y1v9O3pfymqn/WhpYPvxX/BXQGs1ptyzodMemhldFZxh559ZYqMRf92I2ZLogte48LTvqah9luSMHszx4w/Ih9cp/Hw2X8VZOdjkPVs0IaBcE6Q6S2Qjb0Pt/6rVpAPW//uxvMa0nhPx3bfhyTPrd13/gqf+xDQnuEhYcb/PQ96hI3uuiK/y/h5V5tPZPUxYg9j87ETYa56n05vEtN9MuYhSMMdsdYnLN1nqX7JbyBFv4LknwTJOw6a9wNozjGQgXuhrPwBpsmv/iMZgNghYUtE3PM+7c51HDOaC83eyQUm3yVBGSD+wzDi4x8x8DFc0f+0QzR+ykA/RlVmTu1jRlwSxB6+GPWfGP/rrLRxgLLfkzk6FvHFNF9wRXpW7rBIz7gNyxygy3jQpYIIfNIlDlDW+mTOgJVh7GcYNrKeh+wFB+SvOuC+U4DuUwG2QwKCjgkou/UYn/58GR7BBQwLuE1D8l9ni1wkvVenug/d3Z3ddGTXndh4s5gFsNbwn9uQ/l1p5VK4gMAAxhIMgLvavmxs/i/XMfREM8zv8wja6UDfj3k0/gR8dBX48tRVbNm6915R6YLvfaxFLxIyZDZxHzZeb6mdarY2TPANHNdgMtfNNFnrZprNNTMtviNmW001jVZN+VKTZ/6rFlXhCyHqGRWByll5ern9qwLTlxhh4FFpuIMRuvuo1zjAqMNpuudhkqfB7J58l5GCrKqCLTZ19VNhuunDI8yr7e39v2/f168luKf/OZ+//cX+uYX9o7ZO+rFaXVryWWfJoNV2F+o/chKNLV3NRWR/yOp+LiRZ4CLSwcXkgQSVwHP6+/A4BhBWk29wipGJLBTAPQ24Fb57ldjqw8jWFg/VuIs6tnabPH3Oh4GLIRmLyz88f5kf8gCQMobf9y4jYXx+MUKyNhgDxJjxvy6IaTBlde5yB+jTvCvLmNYEMuER6JgHIPW3XSDf8IsgZWdBin8FKTwJkn8CJPsYSOY3oJlHQdO/Bun3EZTl38F38ivz/vat+F8K+/CPP6Z0azgXLO+7KpPGDZ/PBacdJoHJj4lvJiJKV2JWcwtUtwTQ806Qk00ikClGflbO7OFBGJDJIj8DM7fxYmYjovii8bM0n/EZXG1N8hwzfCcIi+4s2ovGz4MuZtiHALJIAGXOkL0nzwig7GvRIbT+LMsGnndAzjKBNwV4fSDAuldA+GEeYT86RCygeMxaEHW/ZmpLP0iiK58WtwYN2taXlFwN9qhssZJSeJMO+B9Zga5M4N/JBlo7AiIGABkh9drOr372U+Y1IHQ3j9D3eES8zSN2G49Ob/Po/XYTSnY7sfYH4OuLLThw5DesXffOmST71A8kytTnCckcrfSZkmcKmFjj69cw2c9v9DireeREi2/dNItxxGyzd/EGC4vknpULgjxnlWuleRPjVBNuVBtuoEx7A9WGW6gx3Md4H2Cu9SxC3Ytgch9yz6JMP2JV5b3p71W+NFQzflS4aVFWu4CPu/UIvhndT+QE/Hu/2z+riP1sF+ov1v6DWM9/bhHpMnocA/4ksYWbaWT6lzQ0+ToNT2mh0XmgMWWQd5mBgH3XQD9oBmEA1QYB9FkBZEkL3OfdgHufmctEVtm4ezqWAaimXtI/cQDhWc9UvHnuktD1LsTaWGyLMePf62K1Udb7Zq2vV1z1L2WGwKLe0w7QRgfoFAfI+EcgDQ9Aam6DVl8RAT5ayq4K/Qxa8KMY8UnOdyAZX4OkfwWSdgg09QBIn/ehLP8Wlskvz/nbt+J/KSwKjoa3uF6867RKGjlsHQlMOUdsWSBBVZjw+SkMaAbIZd4V/Vkb8yuHq5z5mPX1HSA7WyO/2NMXxHae6OBYfc+U1fAs5Wd1PqMxM+Nn0Z0Z9iIehJU+C3nQhQLIAh50Hg86l7EdW5+z15hTYE5guQCyigf3HA/ZiwLc3xag2+VE0GcCAo86UXatGbtO/AG3gGyWBfzOhrm4hLGjJIPe6CvPuxtGwnZHEDLXRtwagokvFOK6s78uTHFxAv5iLH8yKsXXfEZtHt/nDwciDzpheseJgLccCHmlCVFbeHR4hUfiqwIGvtaM5JcFFL3iwLyPHmP3L8CP55qwd//39+YteO1ATLtRLxKSPsPDs3JMYOC0an//qVV+lrFjrKZR4y366qcsPmWr/L3Llod6TRoR7bVxkE6WsWiIz+uo0FxHqe4yavUOTDfcR4l2E+/nnsqb3IdetyjTv7aqst/19ypbHqIZMzrCtDgzwf/97p1Df4vvar1hIf9S24JEOutJTzLukZ9Y+/dbnM3u+LG7epKY4g1cVPYHNDzlDA1NdtDITNC4EpDwWlgbd8F4AmLLibWfKItczzoheR5Q1O74VRozMVE18nqEYto1X/fpN/2UjezoxjkfMqVFG5OxsPzl85eF6JtwLe5gaP9+pwiK0fdcvWyxzcdS4GdZetv6wW7kReOn41jKfw+E9fUrr4CWsVr/tKvOzz8OmvsDSPZ3oMz40w6CpnwOmrwfdOg+kMSdUJYdhWXyK/9JB8B2In7oxjb9SgZvGcTF104noZkfEnbizJKH8Ip1mN0CyBnyzwg/Pwtiy4984XARfHYxNp8g1vzMudHW9p5Y2mxkwGZT6+lzJ+ia1jqfpfOLXSUPM2rxPVgggM4VQOc5Qeey98QBMsvlGDmmLDua6xp7ps84QRe7/h7pah5uW3h4bRfgu1uA7QsB4d858I4TSKlYBOLV5xYNzdvGtZ9YRwZ90lnee/EQy6i1zyZtP3Bs1fenrner3ugqmRIhdelfV6c9Mfwn7EBR3G0fHDkb+SugfMMBzWsOGF90IGAjj5ANDkRv4NFxnQO91wlI3igge6OA4o0Cyp8XMPElB7Z83IITvwG/nr6JN97Ye7NDh5EvqX1qq0NCFmcH+s8e5m8cP9LPNHpcgL5+aqCmptHmXTs9XL0oxywbkxvuMeJ0ieE31BgeYozlZyQqp53SS/p+bvYY+pvFI+1ni2fGZ1avnPf81aUrgjTjRkczQlDw+93bx56PHRB0y991Q+A/LHX+yYS1edgG28amIFK2u7t4dafLyCm0fcUz0pj8N2hE+lEalnyXhqe20OgC0PjhkHWfi/YHrkHChlQYK42lryxtXdsCjxXX4DFg2lKS/VUUW7stUomn3wr4MwOYDHVC4fq05/+4zIdebmnlvzNU3CkSYMhbPMgrrrYWq3sJ6yzMdYAwpH/SIxfKX38HhKX8lZdASs+CMHS/8CRo3nHR8EnmETHq05QDIMn7QYZ8Cpr0EWjSHpDe70BZchS+E/+TJQCLeg03vOQ1F8LZHgTK9vIzxqMt7TEJKMOYvSeR9LgF5KID9HQr6s/Gdxl/4cm8AkP52e/HqMuvOV1jyqx9t84hljiUDS+tYVH/yQATi/IOV5tznsuwKeM6PMW6LWy2gRevJYuMx+kO8TnriNBZrd+fwxwFcwQ8ZEsFuD/ngPJVHtrtPPw/5hFwSED5lcd4/eDPkJjZgFDaXi565CRZ0Kh8w9QPztm2Cwh/HxhwDOi6/CMQEtdTfC8YKMhwoydO4AkT8C8OwGfp1nkh5wDPbTzcNwnw3MDDe40DplU8/FfwCF3JI2YFjy4rePRd7kDKKh55qwWUrhZQs8qBUSscmLzqETZudeLKVWD/rh8faT2rZvsHbeoXFrRuiM06p9DmO314sO/UqmDNuIYAnxGzQ7wm1sUrNg7ScZmzko2vPC4L2PsgTlX9io7LmBnoUbDFqsj8wqrM/MLimbXHKlKCy5bZdKPHhVsW5QQHbBgcF3msXee4JhubEHStDPtXcAI5J1TsFp58zt1QSe7mAeKNvY7sCEXhJhqR+SkXar9Ew+zNNCobNG4YSFQd4ibuQPtfmkHecbim715mH2Qe3IuAYvQ7vxNbdQq7vee2qCXYbUFTiMekG1aGA4hA4MQWz4ThWwcu+uNKU8DFFtfE28fM+F0pMet7M4KP2NZawsA+hwvpn8BS/rsuoK/yMkj5Hy7jL/4FpPBHEAbyZX3jSvdTD4DaPwMdsg+EGf2gXSADPwAZ8D5I921QlX8D66RXGv/2rfifCmuFjW8xMN4/12FKDQ3Pe53a7DcZ8h9W+izmNbfA/abDNeL7BPVn3P5drIXJi4bvmlRsrfnFHQWuHj5d3QS6ij06xelFVueLLU4WxZ/iQWezYabWDIjNNTDDZwY/1QGOZUSTeVBGfBKVZUk86DTmEFw/T58SIFkgQLZQgHKdAO+tAkzvCwj+XEDE0SbsYllA5TMgPn1+IxGM01Da4DF4yxWSeRKk9ArI1HuI3fcAmt4TviDkVZ2+Dq4jqOIKtb92BuAiDHWeGuV38LTD5yBEMJI5HsUqBzyX8NAsbIJlIQ/b0wIiFvBImM+jx3weAxfySH3agfxFPCqWODByuYDJKwTMXunExk1OvLnmCuKNT7+qsx0OiwreMJg5gUC/hblhgQvyQowzKmz6CfWhuinVXYyv9+mh+DY+3mfy5DBl7bgItwWDIpSjxwV6FG30V2V/5KfM+MzimbXLz7PwFX+fqvlBmjGjwy1LswKsy9Mjgnd16xjrCO8cdtsW6/+Dz7/AYVFQNvghn3g3lAz/rDPXf34h13XMWNp++ELKRnvDU0/QsOSHNDIDXEwBaPsqcB2mIXX3GXgdbgYRWXnMAThBNjbDbc1dyIc2PifL+Mh1g2/0dwns6q73kwyAlQCToW43/OXB8y5ccVj+AAjLIpiRtKb9DLkW0e4lLPK3ftDFep+l/DdcQF/p761R/2cX0MfQ/cwjoKkHQZjhD/0UdPDHoIM+Ahn4IeiA90EHvAfa712Qzm9ANeY7mGduS/nbd+M/lkbXUtRJLVZp1nu9aGz1UzQ49SgVo38xRu09iSEM+WcLPhioyRZ5sMyGdTLESUVXi49uaZ1YZDV/a61PnnWl6CKbcSnDUBiQyqK9Q2xzUsZsZFF9JpttYM6wSQRA6WTWAWHvTVOrstLIAW4c40OwbInNQbiGoMgMAXQ2D+lTTrgt4qHewkP3No/AjwQEfu5Aw9UWvPrFT+D0Sb+T8NKFpP3MDGnUnJmy/jtA0g+DVN+EakMzYtd+BeJevJ4MgPpv3iCJvlOOKaPxbWv24sW2zrsPfhF1HqBrm0CXNUGypAmyZxxQPs3DZx4P01wBAXN4hM7mEdvIo/NsAb1m8xgyx4HMeTyKFwiofNqJsYsETFnoxLp1j1FX+BE0ZPTizoNbvGJj93WNjdzRKyJk08DoiJcGRVgWZ0ZY5xaEWWYPizQsT+9q/Kxze807Xdp7v94rRj29PEhVscTfM3e71TNjn9kz/YDFM/sjf3XhSwGa4Ytt2lHjg02NJSGWRTnxAW/0TYj+Jb5LpCO0k/mCNuCfnhPAUjgW1Ub+Ei9JXp3KicBf1XwaN2wdjczaS0PtV0XgLyYHtF0pSFwtQitewoBfHCC7eZHAQhkzT6ShAooJH92QhZaUSKsPdCQFWxMl2a/18yjd19V7+qMAVSPLAM56k8YWgzHlOfuEn39zWq8DhCHjjAHH0n6WCq9qTX2fcoBOF1wf5ob7ICOutxr/b66oLxr+9yAZR0FTvwSxfyEaPkn66M+I/8Toad/tIH22gSbuAE3+At6TPjvnW1399/d7O6yT+Uy+pZaP+D2K7fuj4cXruUD7NTbxFzJsGaY1t8DtKg9yRgD5gWEareO8rNXHmH2vMYbev5F6xHLpOZejEzsnrNZf5kLxxZSfOT5Wy7M0fiajNjeBTG0CncIM3yEaPjehSTR4Opa1QVk3hA07OUBHOUDHsNd58b2jTxzBNB7cTAekjTy8nhXg8xoP33d4BO8REPl1E3YKwMCiRgfxHrCdJD5n9xlwVO3e47nvafInoCVnQcYK6P4VEFm/5i4hSe0zN6ztUfnO7jkTDh16b9p3J3+s/+7MzeqTV25kH7v8qMePLVAxwhabyHy6CdwCHpJ5Atzn8lA/JUA/i4d1lgNBMxyInMGj3Uwe3WfxGNAowD7LgdxGHiWznaidI2DMDAEvbnwIe+J6yMjEosGDW7y6dLkR2T72qw7R0e93jw/7oEdswLoh4eblqcwRRJkWZ7czb+kfr984qINh08AY7eyiAK/Cl/w9Mz+yMlWzxSA5O63qgpf9fcqW2bTVT4UYJtaEWxZnRwduSoqN+KpDl+gbkZ2irprCw1kZ8L/iPvx3FlbHTb7lLy18p7eMbfjpNHIKTShfSqNzt9Pw1GNcaPI9GpkGGlsA2qEKJH4ShrzyAyzsQ/6BQxxNFXv0mx9DvsUBt6Ezv5BEjcyRJK8dytaES9LWJ7EhIHUjApVTrxhZCaB++o4PMS4PzP7wwA+hgGv+nTkSRn5hrT6W/s5zgrDZffbhHfvI1eYTkf7fQUpOgYpg3wmQrGOgaV+DphwCZQ5g8Kegg3aDDvgQtP8HoP13guu7A7T/O5AMYjjAt/CceAqG6VsK/vat+I/FRW5hw1HS7I+7kY5jx5CQjN3UP8VB/Isxat9JJDpbQP5w0X3pN630ZRb9Weov9vd5UJbuM5CP6XOuRSUiyLfMIU4wuhaWuEoesdMhpvvMCbYaPiM7sYg/gUV5RnV+BDqqCbShCRzTkU0gdY9A65tc2vAXZyBmBa7SQDKdh/s8Ht4vCNC+LiBgpwD/Tx0YcxV46dNjID6DfiHt5xYRgHNr31gpGbILJOMwSPkNqBc60evoPbTfe+Ju/29vIP0noPdRIOg9QLOlBar1DsjXtDI057u6E2R2EySNPKQzHZDPaILndB7eUx0wTnHANoVHxBQeMZN5dJrCo/dkHoMm80idwiN/Ko/h0xwYNcWJTc/fQIxtboub29LBvZJafHvGXQvr0eNydEL0/k4xEbu6tQ/d0asbA/GC3+gbblmUFcnIPYalGe19Nw6KNi7I8/POe8vqmfWx1Sv7gyfq55273c+n8IUAn9IVgfqGCYGmWaWhAWuHRocd7JQQdSOqY/AjvzjjZXZQ9J/VAbBDFhcVbmOvhkgyXx3A9ZhQT9tXPk1Z2y8qcz8Ns5/nwuwCjcoCjS8BaVcDH/tzSD7+0PUBZ9GNteoYc+11QLno28eS6LxlJHFeDuskSAYuzpZkbh6gaDjWTt2IoCddADU7w9UIrvu0ZR1jjv56S3kekO8HPN4GlC+1QLnGCdVSBzyffgTPuffhOes21NOuw2fKZfhMugifceehGfM7fBrOwqf+NHxqTsJnxEn4VJ2Ed9kxeJcchXfpt1CXHoN62LfwKvh/uPvv6CjLr3scvq57Jr03SK+TNum9kh7SeyGkB0joXToaBEEEQRHpiiAqCCrSRLAgiogUqUoH6b2TzNwTyH7XuWcC4senvL+/vj7XWteagKZwT07bZ5999sG0+jBMGk7BfNBuTfdxa4b+/Un8t4fALWJJjmp3keW8n8MCmuYw97wLzL4Q3n0WYtxTQO+GCoz4/qTus5voyyLYJu1QDqdWJg3rkOGTLJnE5qPevkbb3iPDf103xUh4Bxk+pfsEelL58yzV1400j1BBGNYOPqQdwiC6Ku0d0A7evw28fzs4fTxABWGgCnygGnyw1hmwUSKEcR0QJmhgOkcDyxUiHNZo4PlVB4L2idgsdiKxZPwdZlkz1KD+vpe+91R/g6QVbSx3J3jl72BNd8HGPIIRSau93gb2ugrs9Q7J2KWfnYDK1zTSv0EqWwicJB0Gcjxj1ZCNUcFotBqWL4no9pIIl9EaeI3SwH+kBmEjRcSPVCNtpIicUSLKRqvRMFaNCVOBWVNPwdZ4+GVDq5WucZmd3WJj7yuSk1WKyOCLgcH+38eE+GxIiPXZkhDqsTzT32Veka/jK01Khyk14a7z84OcZpe7Wfd5w8mibLt0Lcu/1n5cvsnZsmqNi3XtUk/bga+4dx811MdxZmWAz5YEP7+LgQFed1xi/++OCINTTWvS+qgbgXUsb1GukDhmkCy8aY4sqNdarizZLfjk3Wa+BZ1E+hHC+oIFDEPq6zsQff6J1KuX0nZisa3SQG8tYNrvvQPMtXyoLG1WhV7KlBohfUqNQcknaSbDzgQatbY5SyUADRpRy5EuY8y15o1wlw17ljluOPVrt7d+PW07ZddZ24k/nLYb++2pbqO/OdFt1Fcnug3bdLLboC9Pdhu4/li35s+P2/Vb97td05pj3Zo+Ot6t8aMT3Ro+PNat/qPf7eo//MOuZgXd47Y1K093a/zoTLf6j07aVa862r3585/sX9o0y2vs1IC/P4n/8VCZNPS2ORt2yVuIb23kirLNzDVXw1yqMOSHk0gUAXaOhEq1gz7PU381+Cc6cg/V/IRtSMQebdov1f1U71PUp7adhOzTHAXV/LqJRor8XXX+KBXYcG3E54Pbwcn4u4y+uR28Xxt4v8fa20x/1/X37eDNKvABavAhlBGI4KNEyCaKsFiogc0HIty/EKHYIWLUbWD2pt1PmHHGeiFkai1L/FFpEDFnrYxKqqxvwCpPgfW9CzaSfjaNVmhlikpbqujakYQ3MAIiaRSbnBaVKOSwhqsgjFDDcLgI8xEa2I7UwHG4CLehavgMEREyRIOYoSKShqqRNVxEyUgRNSM0mD4bGDN0Fwz4gDX0doSEnLeMyr1hH5Osco9KuBAQErIzOiRgS0KEzxeJ4Z6fpAW5zy9Uuk2v9nGdUqewHzvQx27sQC/bgZOcLMu2O1oW73O0LN7vaFGy01FyAhUbXSx7f+Ju0/iWZ7cBrQr78QMC3N/rGep9LkTKAIKpHfh/cTiI0Nuhp8wNxt/3lNfsjZJlzC4V4oePkoXWLeaB5Ru5b9Hv3CdfxZUlEIJrwCMGQBY7FWU7LsF8v1qaYJOGc9ZQy64ThgsvQT+q7ydC+PBmIbW1Xh4/dqAse1aFvHpLgtnkW75S9KfIT/sEyfhpeWYLca6f11cKxgycnZmRIpsZ0FW2Mv2IFqbXdVvBhORWJq9Yy2TSxzuYPGKJ9u/pVoDJui59rmIoM6DPA+kb/n8+4Fq58E5recn2WEa9f8/C46xbLrxr5mCsphPyyyqtPDkNMNF8Pw34fEmIvxpsJfEjiOSjAaf+PgF+8zRaXoMU+XU9fUmuTKWr9wnBp3kKXQ1PUX8k1ffaqM8p2g/sMnwy+EfgjQ+1t+kBeNN9CE30Mf0d/bfH4E2Pwfu2QehP2YIawhARbIgI42kaWCzTwPETEb5fPUHQbhErHnQgLH/UfWae/75e3k8RstCFGfox73SwpNXgeTvBay6ADXgENkKUyFh8bJu2RKFuxFgN+GhR0l2Uyg/KPMhZDVCBDVBDNliEwRARJoNEWA4U0b2/CNcWEYoWEYH91YgcKCJxkIj0IWoUDhfRe1gHZs5+gl6FH4Ox3uPpHYmIuGIb2eOOS0zSA+/oxKvK0NCfo8KDv48JC9waF+K7OiXEbU6Jn9u03j6uE/u5dxv0MtX4btZNsx0tS3c4mhceczQvPOpgWXjQyaJkt6Nl2XeOFuVbXK1qlnvY9p2pcBg5Quk6qyLWe3d0etB9z7ygC1YR0jj0/7UjzbJftTMZfCZI3ntjIk39sejBE3hQzXtcWfa14JN/hcA/IaASPLQJLGwYnBs+QtZJFdi3akl+iuSp2Mc0yELg3+aHzDH3LdZjYj8hctBEIXroS1QGyBu2x1q8rnqW/kuMQ3IA+fuN3QhVlySn8P8u60rq/Z8yMBhyzUNImlvJ/auXc7e8+6T1N/THk+ihgZbxRzLehPrTXL8kR06tPh2fn5B+Xc0vDe0QQ49Sfgnlp3RZ27uX0n0p5afoKWrr/a6oL9X67RAGUorfBt7yGKz5kdb4+zwAb7wPXt9170Gov//s8roH4PW62/QYQr92CC1q8BaNhBOYvN0B22Ui3FZr4LRJxOBrwJzNu8FM036RxcwvpMdgHDJlkSxuOVjqZ+Alh8BrrkhlBhv4GHxoG9hwEWyYBnyICD5IDSZlJiqwZhWYlIGIYP3U4M1qyFtEGPZTw6SvGtaNajg2qOHZpIJ/PzXC+2sQ119E6kA18oZoUDmkA2/Mfohg5YynjA3MiGiBXmTkHZfIyFu+5ABiMh54J6bdVsbFXQwMD9oeG6zcmOjvszDH33Vqrbv90Jc8bPpPdbPuO9PFsvp9R7Oy7x3NCs44mheecrQo+t3RouiwlA1Yln7nZFH1EXUEyAH4u06pC3VZnpmouKrMDKZ14uf/j3UC6Je6zy4z44mPHfSaD4fLCpZls2Qa+mmaJQusWs19i/dw77xHwjPwr58E/mUuOYCAM0/ASJyS2n9EavnoKQxWizAumrKbefYazxJGD+FhfWcL0cPHyLLnlMgbf4gyIACQHMBIkps+ayFF/9GHTKRLtbU0aKITmqTNvINumNqMuWXGRl8zkbIEuuQsloCyFgPpY3qVSCg0nEJ3h5ythUy6z/7uL/f/K5JLc/CtMJX3/jpaCB34Cvcq+oXZZXT41M/B5Ced0LuilqK/JE/+PYl2kkwXcRm08wuS8dMgD0X9tzRSyi9ReCnlp9SZav2JGqlGZhRBqX9PUZ9aepRmD6f0WQVhcBuEQY8h9Kf0/jFY34fSlYy/4R543V3w2jvgtfd1r3ch1N4Fr7kDoeYuhJo7kNXeg1D3AELDY/DGdvC+7ZJRGk3WwGqBBvbkBNZ1IOBHEZ8+6kB44ZizzGJUMYGB+g4NfvKwN5+y+JXgWd+Dlx6FUHcdrO8D8D6PwFpU2qszeNaXXlVgfdXgTSow3eWNasga1TBoVMOoXg3LWjXsa9Vwq1PBr0lESD8NovqpkdIiImeAGvl9RLz5jgrFhSs0jDUnhyTDMjjqgU9AzHn/uNR2t4z8dtfk5Id+qakPfBMSjoaEBKxJVXrNL/RzndCscBo5glJ/D5vmaW7WdYudzUu/JQfgbJ5/xdm84LzkDCwKjztaFu9xsijf4Gpdt1AqAxzHDPJ2nlMS5flrZKr/Xbd431v/xzoByTvktOWHGHryph9jZJkzy6X0P7xxrkA6f4qCP7hPfocE/gXXgIU1Qz/hNVT9ch3GNKorCXHqJLlWA0Zv/QG5svwrFtYyjkUNmCwLqV9AGQDhCvI+uyINWlXu0iAQOQCK/mT4XTgAjZvO7jRhb3SaUZrNRt91Y6Nu+rAJV/zYgHO+bPBZHzbivicbesOLLu20Nxhyz8Og+YIX63/NnTWcd2cNuteBFzwN6k95seqTnqzliisb2eZk0HTBk6YP2XhYsdGdJqwFxhKLTWKt/U9Hi5NIykiZ80uYX+8PmEvOdeZcjGE/HtdGf5L2Pihqpb2oLUqinR93Gb9OoJQGmCjl7zJ+AsmoxUkI/0RtvcwIoac7RtQZvg60o3qfwD6K/Lp0/5nhN92XjF+ouycZOq+5DVZ9B7z3LQjVt6XLq25BqLojXU5/V3MPQu1DCHWPwRvaIDSJkA1Uw3xWB6wXauC8SoTzRhEv3QRmbv75IROaKlkD7Olp6AdN/06IXwnWYzWEnB8gFB8Dr7sBVntL+v6s/j5Y0yOwhkdg9eRkHoPXt4PXdd028Np2yGrV0KtVw6hahHmVCt17q+Fao4Z3nRoBjSLCm0T06Csio58auX3U6DesDd99+xCtrR/vZ6x3va3TTe+g2DNBiYkPfJIyHnhT9E9OvhgYE7MnIiRgdUqg55wSX5fWRo/u4/oYs8Y+nGXPspQVrHG37rXexaL0BxfzwnPO5vnXnczzbjua5Z9zNC864GhRus3VqnqFl13zNPfuw8a6O02pC3P/Mik58JZfhM9DW1I4+vtvx7/00C/1DkOSfCLyD/XphdSp1ULc0JdkoQ3zubJ8G/cu+JMR8496/yENYIED4Fn7AfJIyprGdGlK73OSnlJDWAcYjfrsAXfKWM2iBrzMQxvfkoU1ziPZcMIV5LXfx1i8Dk+pBUgYAEV/AgKle9eCVnPrjznuy/LWRzCnGTHMaVAu8xhYwFz6FzHXfuXMuV8JcxlYwJwHFkt/dh9UxNyG5TKXET2Zw6Ai1q1PDbNrqWCOgwuZfUsp696vktn27cVsh+Uyu4Gl0n/v3tKLdRuTziznBDG/LT5sQqedTuHmv/fqya1yykb0B1/2YQmv9OVeJT8y257wrnsTY550Qk7R/1iHdnnHdzqpbppc/EA7i08zDJLxE5efBnh0HH6tPDkh5CpJtoyR0Y/WgI/SSCi9lPIPoauW0H0J0W9pA+8yfF3KL9TfAa+7rTW+6ttgvW+BV92EUHUDQq8b4L2uQ6i8Dl5xA7ziFngv+u/kIMgZaB2BrL4drEENg7EirN6hLEANj7VPEPyDiKV31YiumbWEWX+rdPsAhob+02v1YhaCRS8CT14LnrUDvPQkePUVsN7XwatvgtfdA6t5AFZ1H7zqgXRZ1UOwqjawqnbw3u2QVauh31sDoyoNzMrVsC1Xw7m3CK9qEX61agTXiYiuUyG5QY28fiKKm0QMGt6O/fuBZUs2PTQyqh3GDO65pyeqfZKSbvtT/R8eviciMuDnqFi/L5LdrKeWMlbXy9S4f/OYcctXL3h37ZX0uCG3LGR5axQ2DfNdzIsOOJvl33U2zb/nbFZwwdm86BBlB66WVR972TXO9eo2cJKn4ysNvu7Ls2L9DofH+be7ZUpg4P8FWjBFvpb9xpaj2930+hwKo349bfjh4S2vyYJop1/Jj9wn/yb3LYQQVAVO6L9yGDLn7ULw+adaHX5qbxGf/eMnMFitgVHO+PPcPfcj2vojlRBhfWczEgItXJBH+wTMW+8rJBZgVwlAdOCZZy1opl5v3MkQ5lY+oXtyy4bhcz7+cf4nm09/tOHbE+9/8c2JxZ9vP7lk/TcnFq3/9vi8L7459faGb0/M+vLbk29s/P6P6Ru/P/bK+u0nX1r39flRX2w7PWzD9hPN67edrP9i6+maL7edrPhy2x8l67ee6bVx2+nqTdtP1m355viAb388Fv/ayk9Z4Gd+z8qH/+5IJQls5fW7o1lwv9eYW94V5tYbTT+eRIQK2jXkRPcl1J+4/sT2I3rvIpVWmIOYfTS2S6O6JE8ugX269hgx+SYQW48ozjoGn0ToUYNR5Kc+vtTa09X7OuMXJOO/B0aGX0eR95bW8KrJuLVGzyuvQSi7Al52WbpC+TUI5dfBpXsDQvkt8MrbEKruQVb9EEKtGryPGpZvdMBuoQYuH2jQfZ0KzVeBSZt+vMH0S0bo977pzSLWWhgEvXpQiHwbPHYJeOoG8KyfwIp/B688C6HXBfCqa2BVN8ErboNX3NHeSnICj8F6tUtXqFRDr5cIwwoRZuUibMvUcKxQw6OXGj69RAT0UiOsUoWE3iIyG0SU9hNR26zB4CEq/PgtsOmLX+8p3EY3MfarT0LCBYkLEBn6c1Q3k6+CGeufGRIwcvKM2au/2ffzmZsPTnbi6Rngyon7iPRt3tZd3jDW3apio6t5/iVn87zrTmYFl10sCk87WxTvcbao+NLDtm6hj8PQcQrnV5r83ecVRXl9Exfj/8A7OeSeJWkc/v1X5N936Bd/zC0zg6H3veQVXyVK6H+Pif14RL8ZQkDFl9y38CjV/9y/WEL/WdhAyKKnoH7HRVjSZNs2NTjx/yXNOsBo/hnIlGWHmH/lB0Jgr3VyZcVGHtk8jUREZb1Wp5iMvRZg0arypDkAs/GXbczJCcy5aG06r9POYFqnF3MbXFI+dOaf5y/dxBNA2mS7E8AWAGsAfAhgOYAlAN6lLcIA5gJ4E8BrtFIcwFTae0dbbwCM6gQGdQBNHUBDB1AnAnVqoEUD9HkM9Dx9H25jFuVKmRCpIP13Z16ngX7/M95C+hu9mE/5FmabDe/6tzBc0wnZeZVWqpyUign4W0/tUC29VzL+N1XSEJNAxt81pkvMvskqLUd/nBqCxObrqvdVEIa3SUAfG0IO4AlYf7UW6OtDiP49bcqvi/wCpd1k+L1vgFdd1xk+GfhVrdGXXgIruQBechG8mP58FZxuCd1rEEpvQFZ2C/LKuxB6PwbvrYbhKBFW857AboEaTqs0UH6nxuI7Kvj2HPkjs2/NpUdi7D06Tx76Olj4LAgJH4KnbgbP2wNeehy87DR42TnwsgvgkgOin+cmWMU98MpH4L3aIFSoIStXQ69MDcMSNUxL1LAp1cChXIRbuQhFmRrKMjVCy9SIKVcjuUqFgsYOVLWI6Ntfg34N7dj6OfDTd8ceBwa+NJSxR90Ya3NmbGDPgpypr3+4avNvx49cV109APy2HPh+Sjt+GK/Cg2+AVe98dUefpS/0s+7zprt52Xcu5oV/uJgXnHe2KDzlZFm818WyfIuHXe1SRbdBL3s5TWj29ZhVFqr4Ijky+FBYcnSbc1AQCYX8D0Hj//mT/ZWB6aiHtvpDbytlZetShIyZlULcqOE8pH6BRP31zT/HffJFafAnpBEsZAjcKt5D1dl2sJ9VklY9l9J/LfpvNG5TJ3dK30mSYbQaTFoUEj14gl7GtN7y6s+SzCY/8LVoVblTBiDxAMZftrFpveVo2vqnkoUuiKocu/hDjaZTMvxxKhWy2tQIeqyC+0M1uj9Qw/quGma31TC6oYb8ugr8qgrsEkltdWntkeKOCuwIGWQ72AHd/P1ParAf1NqOxXbdPP7KJzD54j4c3vlEywL873CACsisWzvN5cVfJNIGJOaWd4M5V6B553FEt0HaT0iCpSTsSRkRJ1EPQvxpdJkEO4gJN0OEQMQYMnxpeEfL6OtC9yUKr3S70v52icknH/0UBuMewWCCSmrbsVoyegL77oPVE9inM/4uo6+8pjX80ivgpZchSEZ/QbpC0Z/ghXQvgBddBC+6BKHwMoSiq5AVX4es9CaEinuQVakhVKth2qqB9VwRTktFOH4qYsR1YNK6b24yoXIoDXHRo9Hzn/AHD30DPPIdCD1Wg/f8BrzoIFjRMbCC38EKToAVngMrvAJWcBWs8BZ48X3wkvvgxY8gK2qDvKANRgXtMC9UwaZIDfsiNVxKRHgWq+FXrEJIsRoxJWokVYrIrBZRWC+iqkFEn74iWhra8NVaYO9Pxx9kpY1+Z/DgBdM3b9h96Mie2zi4DfhiVgdWjVVh9QQ1Pp8kYvNYEbsnanDnkArpwS2XHWQV0/xs+k/zsCjb6mpe+IezRcEZJ8uSX12tKja6WfX+UGHX8hoBgX6ec0pCFZ8mB/ntiE0MvuwT5XfZpuJ/pY78/+rRMdqMSfiD0n9S/CXCTvSQsbLAmg8E/+Jdgk/+Ne5b8JRT+h/eDBYwAnGtXyP16hOwHWqtXv1nakmoQ5/q/6o37zKH9I3S7EBAxXoqAWj/nz5xAOo2Juq3PvAxbG13JRCQHABdi9mdHpLcmLL37B8PnlD9DqCkrR0JKg1CH2vgdV8Dp3sadL+rgdWtDphc18DgSgfkF3Urtbp2BNIl5t1vHWAETkqLQnWjxVSTExWXloXSoBHtDpzfAaMP78D89dUDpQzgv5K2oudEk26T2l2ExGl13Lvsa9atJxQ1szC8A5Cd1y0npUWdJFZKbL8PSJ1XJ1pC9b5Eg6WorxvZlfr6agjSgpL254QeXXuPD24DG6yBwdh2mFZshEHkRI1R5nyYjjgNgdD16gdaZL/mFlj1DTCK/Lp0X4q2pZfASy8+M36mM3yh8DyEgnMQ8ulVe2UFFyEUXIZQcAVC4XUIJbcgK3sIXqKCfrMa1rM6YP+uCPePOhC54wmW3GhDYOlrs5lzpzU9HkPfyaNlobPBQqeDxy8DT/kCLOdX8PKTkFWdg0H1eRjVXoFx/U0Y19+DQe1jyHupwIvbwPIeg+c8gl5OGwxzVbDIU8M2X0T3fDWc8tXwzFfDt0CFoAI1oopFJJaLSCkXkd1LRHG1BtV1Ivo2qtFc3Y5PlnTg1x/v4NfvH+PLD4DXh6nR2qTCrGFqLBwnYvl4ER+NFfHZGBFfj1Dj9lZg3dJt7casYFxC9wUF/laN77hbFO93MS887mpZ/IurVcV6d8vq971s+870dhg1NIhKAO/PkkKUu6PJAfRUXrSu6Jp2/FceadXzFVtJ9qvx5yj9vPmFxP/n4c3TuLLyC8GveL/gm3+TuP9CSC141CCwkHEo+/gIPM7QXLtG2+Yi9h/V/x/c6TSI7nuKKwo/lejDgeUbyBHQQJEsa3YpZQAmY88EGc1pc5IygOlX7UxmPyJH4Mf8+/eNr31l16OnwOQODWJVGgQ8EuF+T4TzXQ3sb2lgfV0D02sa6NGEHUV7yfC7NgWJOn19UbdBVwTXLdKUWIrScg0C5mhtFomMdIDN1sD4g1uwXripQftA/skBaHn/tOpbXrUtRhL9cM87x9x6oe8PxxH+CNJCT8nZUOpP3ZAPaaSXUn/S6NNJlJPh0wgv9fep3qf2HoF9o2hRifo5m29wG/ggGnR6DL0JnTCt3QGZfeX7+rbpPoJVrzEGkbNhNvkmeAMBaFTnXwMjw5fS/mtg5ZelVF+6OsPvurzgPHj+WQgFZ6VXWR7dc5DlnwfPuwCeewlC3hVwcgJFtyEveghZaTssJ3eg29sauL2ngesaEYOvApM379nH2NhYNhBWxq6LHeQBk2+wkBngsYuhl/EFjEq+g1XNjzAr+wGm2ethkb4GFumfwqLnFljk/wCriv2wrjwC88qLsKh6BJPSJzDI7oBppga2PdWwzxbhlCPCM0eEb4GIoEIR4QUi4oo1SCoWkV6iRl6lGuW9NaipUaNPvRr9G1QYM1DES80qjGhUY2yLBi8PFDFtiApzRopYPFrE8pEafDxaxJaxIvZN0+DOYRUqU6Ys8WPz44KtB0/wNC/7xs2s6FdX88KDbhblX3tY1nygsGme7mM3dFyQ87TeEV6rU3oE7QtPVt5Q9FTet07+FysFcWmF9WBa8/3AV177dbw0/Zc0uQ8BgJw0//wlB3CP2H88tB4sehgMk6aj397LMKHUWtrAqyW5sDWA8RsHnsq88ndxZcVqHlC5gQWUbyAuAWEKVFoY1qzvYTr5qr/xa48diAdAykBGczqdjAbvimSOvQYOfu3DH6+B6nQVIto64HZXDfubIuyui7C6KsL0igZ6lzq08/WkqX9UDU6EG9IOJMMnkU3J6GlDri7aExhHRk+GSUAliZWQ+Ab15mdoYLT0Fizf/bzm2TP5+6Ho37DD0Ghsp7OQOruS+5SvY7aZon/T2xj6BOCn1VqNP3KGpOxDQijSfgKdOu8bFPk1z1B+TqO4Y3WDOITwE8g3VAVGhj/wEXj/h+Atj8CHamA26hz0lS/t/evPJXcc84VJ7U4YEE+g7BZYr2tS1GeVV8DLr4CVXgQr7jL682CF5yXDZ/lnpcvzzkDIPQ0h7xSE3FMQcuieAc85CyHnPGS5FyHLvwIh/xrkBbchz2+DQYM2C3B8R4THyg5E73iCBTceQVk1s5UpOqUlmga+o6fKohbCIO59GIfPhpH/S09M/F66Yur32reGfnPfk3m3TtXzfXmKge87b5n4vfmZlf+s382C5z6yiFoMu9QtcC09Apfq63AuFWGX2YFuySIcU9Vwz1DBJ1tEYK4GoXkiovLUiMtTIyVfjYwiNfIrRFT0FlFbK6KpTo1+dWoMalBjWB81RvUVMbFZgykDRLw2SI05g0UsGqbBByM1WDdWxNcj1bixDtiw/IczRqyuNMb6lSYfq+r3PcxLv3U3L/nR3aJ8s6dV71We1n1ne9kNnkAOINrzw7TEoD0RWTH33NP9Ltv8ex0ApbtDT5kbDe10NhlwMVBetr6HfhYBgOMH8EitA2B+hUe4T/4jIaBcy/6LGAb3Xh+gF/HcSa+PjIsMazUZFGA4fG0Hc0z9iQf2/kAIKN/AAivXsfB+rwtJE/vIct4qlvfbHms+TeVl/NINe3IA1q+1OVnObneTV69JYo6lY0bM/OSHU5T+i2oEtHXA8bYI6ysizC+qYXRBlFJtTkj7cQ048ex1m4ElyXDdshBJZJN+LhLZJPot9eHXEj9Bu1BDmr2nQRwi5kx7AqOFt2Exb1X53x/Ps0MOYBwsWN3eMCFy+BjukXeCOZWj784TCHvwVLumjL73JjUYLe3QbSYSiOhDfX4S8KBhHhLiGE8LSrQ8fjaCGH064x/UJm0o5i0PwZrvg/Wlel8Do+wlYEaJMX/9cUycBwcZRMxVW0w9r+2tl93S1vvlhPBfBC+lqH8erOAcuO6y/DPguafAc09Lr0LOSQi5JyBkH4eQRfckZNmnIeSchSznT+jlXIQ89wrkeTchz78PWe5jmI4S0W1OB9wWi/BaK2L8XWDspt17GMuWHICdcpC9cehrKkP/l++bKEbNsFaOVtrZVZj+9Wf/62llTHD1m+tgHzQxxzpo+myb0AUn7aI+hWvqd/AvPgdFvginpA64JavhkyYiIEODkJ4iwrLUiMpSISFbhbQ8EdlFIorLNaiq1KCml4j6Xir07dWOgTVqDGsQMaZRxKS+GrzSLGJGsxpvDxCxZIiID4eL+HKEBj+OUOHm7seoSmtd7skm54bbTmj2saxd7GlevsHTvGK9p2XlOk+rxne8uw2YrHR8pSnc/b2eiUEHIlLD73tlel7r9u91ABUVMrPBD2xo8k+v34EI2tWnR+u+EkYNl8Q/lOWbuU/+NcGP6v9e4OF9wYJGIGzsJiSSuu13WvqvJNqxSoT+WsCwanY7c0zfwoN6f8gDyr/igRVfkowYtRVlRYtyWf+d0YbTtEIg1AEgJ2D4drurrGZdCnMsennQ1OW/HgOQqVbD60EHut0UYXlFA6OLGsgo6ksAH+0HFMEP0jLNDvBdumEbiviStLZGm5VI23S0CrukK0ADONK6LIrO0rIMDfjLGhjNvwWbhe9J9NZ/POQA5nRas7L1PbhP1UfMNqPDq2EumkWA/94O9osanLAFeg5E9qHhHjJ+0t2jPj9JcJH4xgSN1vi7wL5hhO4TyPdIivyCFPkfgPd7IPX7TYaegZ7fSxv//uPQ0XMYtMCs3zYYEW246C54+TWp5tem/eclB/A86p8GyzsFnnMSPPsEWNYf4NnaK2T9AaHnccgyj0PW8ySEbHIOZyHPOgt59kXIcq9CnnsTermPYFChgt10DZznaeC1ogNxPz3Ba1fuw6P0jdGMHZFks218WyINleNc//7z/m+OUsn07UNfr7ALWLDFPuwjKNIPILriDpRZT6BI7IB/qojgdBGhGSIie4pIyFIjJUeNnrki8vJFlBSqUVkqorZMRFOpGs0VagysEjGiRsSYOjUmNYiY0qjGzL4i5rd04P1BHVgzWMSmFhWurwE+Xfz1bX1WW1zptj02lARBzCvXeZpXfOlhWbHe06phvsJ2QKuv/fgBwe5Ls+J9f41MDnzol+V30+HfuzqsFYLJhM7uxgT+lXySJm38SZ7YTx4zcJIspHYZU5b+IPjm35fS/+DeYDT7HzQWGQv2wffsUy2gRnW0RHN9AsOP2mCYNPg+88j5WlIO8i/dIQRWrpOWgSZPbpSVLMuWt/waadF637ML/KMSwHppp7O8ZWscc8yf2b916ZEjAFJUIlzudMD6qgamlzSQ/anRMuyIYkv7AQ+owfdQ1CeRjQ7w755oB24k49et0iLDX0XS2rrlIWT4pKxL2vjEwV/YIXHsjebdgM2CZf+1ElDDeUPD0e1uQsL0au5e8BtF/+YfjiP4zhOwvWotDkKEHxqBJpov7SigoR6ddBdReyVa7xhRGt3V9vUJ4HsEPogUjR6CtdzXGn/zA6m/rz9aDcO09yG3Lo7++49Dx8CuVqEfPU9jOe+GlllXchNMcgB/PncAhVTnU8Q/CZ5zAqzL+Hv+DoFulu4183fIMv6AkHEcQuYJyRHIMk9BnnkO8qxL0Mu+Bv28O9DPaYPFYDUc52rgvkANj49VGHYb6L3ks/OMNVSZDe60+fvP+Td14Oerw7Wv/1lu6Y5H4pv53YOX73eP+QmxJZcQXaSGb4KIgCQ1QlJFRGaIiO+pRlKWiLSeamRlicjPEVFWKKJ3kYj6QhGNhWo0l6gxqKwdo3qpML5ajcm1akyrV2N2o4jFfTVY2SLi8wEifhot4vbux2jKmj07SG9NeITN+AE+lrVLvcwrv/A07/WZl2XtYi+b/lN8nCf0DfVemRHrvTM6w/uhf4HHo+7/XkZga6tgPbHNyah5b5RB4coMvfSp1fLE0cNkEf1myIJ7fyL4FR4UfPIfcyWp/taCRw4Ci30VJVv/RHcS/6D2H/H/yQF8AhguOPdUriw7KfgUfs2Vpd+SfoBEJIoY8KqQ3FpLOgB6g46FGky67yUBgJIe4BVb48WdDvIB22OZY+H0AS8vPnYQQHybCg43RJheEqF3QaNN+6V6n1aCa8B/IWRfV+d3LdEkgI9EROjnoRYcyZKv6NBO3lHEJ0mxLqUdaWtOB9hoFYzmXoHl/IX5f388usPZTFjIe++O5gF17zKb9Hb/Pm9hcAfAj7VrUX8CQWmJBy3knEdqvTrZslat2s4zLr9k/LqoP/jxs3pfSvmb74D3uwPW5y74kA4YDTgNA+8R6//+w/z1yJ3HLTHr/y2MaelK/m2dA9Cm/9rUXxv5Wc4JKdqzrGPgmX+9WgfAM46Cpx8FSzsKIf0YhPTfIUs/AXn6acgzz0Ov5yUYZF+DQdZ9GBS0o3urBk5zRbgvERG/4wlaz95Gt7gRC5nPz34O+aD14dIaMKJX21XcMHUrumdpUXTPslva9e7O5fetrSruWlhlnLWwiT9upt00LLXR/sMZVCiZvnvEguluYZueRuWcRY/SdigTNAjpoUZEsgqxaSJ6pGuQnC4iLV2NnEwNCrNElGWLqMoWUZsrojFfjf6FIoaVihhTKWJiLzVaq9R4vVqNefVqLOujwUd91fiyQY0bK4FNC7+/pM8aihOtZ5cHkjYgGb955RceVtUrvexaXlW6Ta0O912TGq3YHpumuK3Mdbthr1T+L3ck/j93WlsFozG3HI2bD4cbFK1K10ufViOPGzZaFtbwtoTe+xWcEPwK1EJABYSwRrDo4TDJfgu9Dt2E3q+69J/ILjT+uwYwmfITBPee52QBFWtlfiU7BWXZdqkDEDdstF7GzEqiGOsNORpC8wbPdABmXLYxntvpIG/eHM8cC2cMfGXpof0AIh6rYHdNA+MLGgjU5qMeO4F9e0UwCd3XtfXI+LvQfZq4+4x26OmWZq7okDblSosyiYhD7TjSFCQaLmnpU30+og3Gc67A6l0iAv390FbkUwYG/a+5C0mvVzOvwp+YUxFadp1A8D1oo/82lRZYJGkvUr2hry0N9dAMvHZXgZT2U71Prb2hWsNn/R9po30/qvfvgve9LV3W9AB6YzUwyFgFuU1h5N9/or8eA7u+Cv2IN0TLBVe0HYGia+BdDiD/nITy87yTYDl/gGcdBe955Lnx9zwKnnkUPOMIePphCKmHwdOOSFdGN/V3yNJOap1A+jnoZVyEQeZN6Kc9glmdCo6zNfBcoIH3RyIG3QCK3ll3lLERPQyqVZ4mtY+6GVc8treqaHe16KVyt8696m+ZfjzIIm1fePfMi4GOOTd9PPPbXV2zbjrQklByBs6xui1D/9BT90uYmemgXHs1JPE40ksfISRBg/AEEdFJIuKTRSSliEhJEdEzVURuuojCDBFlmRpU9RRRny2iX56IwQUiRhaLGFuixuRSNV6rUGNutYhF9WqsaBCxtkGNnf3UuLn1Efqmv/2yUm99aLjtyGE+Fr0/oTLA3aL3Ki+b5ml+ThOaQz2X5JDQSHLgFb80j+vdsxWn/qVsQJ0D0Bt4NljKAKR13yNGysLqF/DAsq3cN/8i1f9CUC8IVP9HjYRz75UoPqWS1lizLbpUm1LfNYD+0LXgzimXOLEHA8u+EwLKtkozAIkjh0kcgIYtCfqtt/wkKbDR17oRA5AcgdG8TmdZ9coM5pA3u/8ry/bvARDyWAXLqxrISU9PWhFGs/XU01dLxs9JNJSWalAWQi29LoSfpLYI5KNlGrQ3T9LYIzlt6sXrloiQ2Aal5693gA9+BOPZF//BAYCzliV6NJSkV/VDGA/sO4tZpz0Kan5bqv2lTcU0A/ElAYskW0btPq36DW+lGf6/RH6a26eoT4Y/4JEE9PHm++Bk+H3ugPchw78F1ngbwtAOmA05CwO/SV+++PP885G7TFxqNuBbGBPPIO82eMklcEL9qfaXov9x8OzftQ4g84jWCUiO4DCEzMPgGYchpB2CLJWM/ggEek05AnnKUchT/4A89QT0Uk5DL/UcDNOuwij9PgzS2mA3VgOPd5/A//0nSP25E+NOXBMtAkePZkGHg/TKrgUY5x0NsSj8Pcwq6Zs4i9CVGVbhy7Msg+fnm4es6GkV/01ct/QzQU55D7wdel7x6555z8M++6qdVQQ5AlLbaZX/vR0blDjC09V37bGw2LPILHmMsDgNouLViE1UI7GHiKQeItJ7iMhKUiMvRURxqojKdBE1mWo0ZanRP0uNYXkiRueLmFigxpRiNWaVqzG/SoP3a0SsrlNjc40at1YCW5fuOqTH5gZkOM4vVFo1zvOQyoDaZV42zVN9u40aHuoyryjGZ2NiUuhN78zga92y/7V04NZWwbj1sb3e4ItB2hKAtP+HjpMFV6/ggaXbJAfgX9gpC9Zp/4UNR8CQtcg4S3UvEYB0m3o+1ED+CaBfPa+DO6fs4wHlW3hA6bcEAJKakKQqlDOrjA38OcpgmsrLfJLKy6i1zZFAQNPWh7ZWCzpdZFUfZjL7vHdaXlm2/ycAQY9UMLlEfX6q+dUSv15L6BG1TDtC+rsyEDL8NVoikhSJCYWnqE8pf9fUHa3IogUapK03RSXx7/nUDrDmezCefg5W7yzMef5goNW0p6m/lx7bs6LV6UxR/ilF/4G7T8P/+hOwXdp/P6X+0q4C2tTzuk69h+b3KfLr6Lw0G88H0qy+NuLzvvfA+9zTpvuNt8HJ+BtugtXdgdGkdhj3XAo948Kwv75V/9XRt2301o98S7Reeh1Ckxos75oW9c87A5ZLdf/v4D0p4h/RRvueRyBIkZ+M/wiEjMO6iH8EQsph7U06DFnSUciTj0Iv+Q/op5yEQcpZGKVchFHqTRgmPYRpYTs83ngCv8UaBK3RYOJdoOjN1YcZa+5plP5zlGHilgTD1M3xFvEfpZqFLSgwDZ5dahE4p8QyaF6RZeSnyebpP0fZpu6JsI/7Oco5/UyQQ367q0fa9e6O6ZdtpNJAMqoXnUB4j4kOrj5fnoxNvoCswnZERqkRGyciLl5EfLwKKfEiMhNUyElUIb+HCiXJalSliqhPU6FfuhqDskSMzBExLkfEK3lqzChS4a1SEYsrNPiwt4hNdSJ+aRFxcfPtp/17LhkSYTA/JdCq/zQvi+oVPpZ93vS2GzzBz2FCM0mKxQf+GkldgLTA690r/rUlAK1weumGvTHV5aUfpeplTKkTYgdNpLVfQkDpt4Jv/jXBvxBCcDV45ACwkJeQNO0rxFx4oh0Aeib/rYHhqicwzp2sYq4ZO8kBCP6l3xGOQB0A0hWQ5c0pYYMOhhq0qhRUAtAkIDkAwgCkDKD20zTKAFqmvLd3BwD/xyIM/tTW/ZKcNhk/6enTWnAi9ZDxU71P/XwataUdBDRxR7x7SsWJgKPT0dci8VrevUC9eALlXqbWXAdYnzswmX4adm/Nz/rLg9E6gHGw0KveE8GiRw9hVmmnlS1voYEGfn59rCUWkfMjcJHGe2n/3lQN2CQa5dVI2ALN7EtrygZ2tfbugvW9A95EEV97JQfQSOOzNyEMVsFs+GnoBYz9X0X/rqPnOXm+xbDvYfpmB1jGLbD8i1oHkH0SjND+zGNgFP0lo3/xClL6f+i58ScfhCzpEGRJRyBPOgq9pN+hn3wchimnYZh8HoYpl2GcehsmiW1waBHht6ADgcs7ULC3E6OPnoex75Ax8qDPY2Vxq9LliZ8mW0STA5hXYBo0u9w8ZGalRfCsMouI1SlWPTbHd++xM9o5dme0U+rJEKc8tTc5ge5Z19zdkm/YUzbglkyiGy86gYD4Zi8Pv01303veQHqmGlHhasRGqxEfLSI5RoX0WBFZcWrkxalQnKhGZbKI2iQ1+iSrMDBdxIgMNcZlipicLWJanog5BWosKFJjRZka60pU2FX4FGenq1Ae0Pqjr8GrWQEW/WZ4W1a/72PZNMvXbsgYP/vW+giX5ZlJwXvDSBeAmID/XgyAHMCEh3a0+490+gTCAGIHviILqlrN/Yt3cZ/8uwINAIXUQIgaCBY6CTmLf4Pvn5CWWbIvqLdOrLenMFjxGPpxA1TMLWsP9yv5ifuW7JQyifC+M4Wk8S2y/AUFegP3ROi3qn0MSQ58wlU781ZdCbCo00neb30P5lQ0pf+rH/z8DQCvxxroUduvq+7/SUu0kQyPlIcksE8Ep/KDpu2Wa7RtPRLXJJCP0nEC44iBR6O2kpquBpyktWjijvYIThTB+96BycxTsJ7/dubzB0NbbY7p02SirHBNBvMo3cBdS9Cy7xx8iP5MJKPPtTwCvoSkvLRbiiTRznEkf6Wr+SVizwOwFor4FOnJ2G+BN94Eo9twA1x3WcN9GI5th1Hq0k49k/Kgv75NL5znu/eeHQPXJk/96LkaqyWXIdS3gfe8CpZ3Fiz3lIT8E+rPMo6CpR8GSz8k1fycXlPpHoSQchA8me4hCEm/QZb0G+RJhyHvcQR65AR6/A6DpOMwTDoL4+SLMEq+AbPkR7BMa4f3yxoEL+1A2BoNXroH5M1e8y1jw1PkKVsSTGJWp1jErUq3jF6QZx48vco8eEYv86BpvS1DFuRZRq/vYZ3yfYx12s5oi/RDYe6FD3xdslVennlqb6fk287OsRet7ZKPmepmM17493oHtWb4Kn9EfsF9JMSpER2uRnyUGklRItKiRfSMUSMvRo3iODV6JYqoTRTRmKhG/yQ1hqeKGJOmxsRMEVOzNXgzV40FeSJWFjzB972Br6vOdZa4vQwv1vJ2uuP7Gf7WTXO8LWve87XpN8PbZthoygCi3JZlp4WdCE4Ouu0c4XnW4t/LA6AHSw6AMIDcZdlC8qQmHt08jQdWbOJ+hQe5T94jSf8vpBYCUYDDJ6P487NwPv5Um/7TABCl3Ss7ob/gWqdeYNU17pFzjCsK/+DeRYdpEpCHN83RS57YT1a8JIf2Api3qhRGrbccaQCI9gGQEzB+F/byQdtimEvp+AFTlu/6CoDLQxFyohp3pf60RVdaDU6Th9Rzp8ivI/UQ+r5Uuz5LktSWUn5SoiX5aS3vXlqTRRN3Ev1WJ6hJ9Xn9TZjMOAHrd+ZmPHsqNBHYcN7QvPmUlxA9oT+zSLkcOHA+atQE/Km0HYdPqK2o0/IjJ0OAH3H6KeWX1HlpQSnV+/fB+t3VGf9NCH81+vqr4HVXwWquQxgkwqTlD+h5jfrihXfo+dHOKdDk5t8cAB19xStLzIbvgAkJiqbfAMu/IGUB2vbfcbBMcgJHJCdARs+Tf4OQ/JvW6FMOQpZyUDJ+occByHocgDzxIOSJh6HX4wgMEo/CMPF3GCWehlGPczBOugyz5HuwSFTBoagdwXM7ELq8A6V7gOG/HO8QHBtfkoev7mEQvybVJGFdinX8ez2tI2aWmwdOqzEPmlptE/JWsU30J2lW8VvjzNN2Rtsk74p0yboWQFmAa57KU5Gt8nLK1joBRfYpcwkg/FvL0MVr/qyY+AsozG9DVLAaCREikiJEpEaqkRmpRk6UGkXRIipi1egdo0JdjBp949QY0kONl5LVmJSmxtQMEbMz1Fic9gTbegFLi35EuGUtLFn6xyVOp5zju80v9Lfs97q3Vf0CGhTysR0+yr/7pL4Rbotyk4LOBKWFtDlFK06Z/3sdQGurQArAEg8ga36hkDh2oCys8S0eSBTgot+5b147tQCFsAbw6CHgca+i1w9/wnafdgCIiC+cmHUfAkZv/PFU7lVwhXvlH+WKgpNcUXBCUFZs4pH93tBLntCsTzoAAw9ESBwA0gGg+X/aCTj+gpXJ24+6Gw3ZGc2cSsc3T1m++0sA9g9ECCdpmEcD/hOtCdNKjlPbUQv26SK/ZPwE9pHxa7QoPKX9BMbRnL2ksKPbHDxGty2HlogOfyR1AMj4jKf+Aes333yeASjX6jssgTHx/plP9XzmlCfW7TsL98tPJYkviflIizzm64Z8yMlIy0l1aj0Sj/+BhC8wau0Rwt90C0LjdfCGa+AN1yXDl27tVWmO3/ClNhj2WPBEz6Qk8IX3qOt07dp7tor7xaho6NniqhfxhspywZ8QSGor55q2E5BzCizrhM4BUBZwBDzlEHjSb2BJB6RXMn55KqX9ByCXjP83yBIOQp5wCHqJh2EQfxSG8cdglHACxglnYJJ4AaY9bsAy6TGs41Tw6KtCxHsdiFmlxtirQMKExXsY61NmmPp1vGnCxkTzmOWZFmGzyswCp9ZSJkBgoHXkygybqFXp1snbYykTcCm4FuCR88CHnIBHjtrHLeueu0fa2e6OUZdtrKNPmevS7Of/Zjdm6OH95cX8nIdIj29HbLAayREiUsLVSA9XIztchcIIESWRalRGtKMmUoU+0WoMjldjTA8NJiWrMbWHBkvSgbV5dztbAt+Cuyz/ni3La6YvX6+44BVi/dIIb4umt32sGt/xsek3Q2E3ZKy/w6S+4a4L8pKCjgdlhT92IAfw790a3LJfz7gV9hILMHdekZD40kBZZONcgQBAv4Izgm++RhZYAVlEH7CYkTBJexP1B67C8BdyADqW3Uq15ADMJ+8Cd8t8wBUFRwRFwVmuKDzOyQGE93tdL3VyH/2C+fl6g/eFUwZA5B/JAdBGIHIACzu7yUfsimQupROaXln22zoANvdUEGjQZw/t0qONQ6Q5SKm3tsfPaGEIjdoSuUdi3lGL77mwpgTyTSL9eYrM7do1YiPbwIc9Bhv2AGzIPXDaKVh1Fcav/gGrmW92YQCcDf3KgM3otGFZ7xYxi7QfggbOQa92gP3crv1309Zj6i7MUkv79aRSgjYVkWQXLeHor436TEL3tem+NuqT8V8Dr7sCVnsJvPYSWPUVSZHXuOU4DDyHr/3bO6Q7pFMgibboSZfaZf/gBPQ9Jy0xG7QNZgs7wLJuS1kAzz0jOQAJB+hyAKnaWp8lHQQnJ6DLBmQ99kOeuB96dBMOQC/hN+gnHIJB/GEYxB2BYdwxmMSdgFn8WZglXIZl4l3YJbaje0I7AiaoEbWyA5W/AkN/OApmUTldHrM5xjTusyQqA6xiluRYhM4st1JO620TOq+IHIBl7KfJ1j2+jXZI3RPhWnhV6ZZ7298t/6EfvbqX3nUjLIAcgEPEfmOt8MaLeICn59SqhJg/UJzzGLGBKiSHaZASLiItTI2sUBXyw1QoClejMkyN2nARTZFqDIoVMSZRxMvxGixLB5akHUZa9wFtZizxY0fWy4e+blNop11it3eK/S37vOllXvOel0XdQi/rvjOpBAiwn1IX7f5ez+SQY6EZEe2uNA6cLHUt/o2nFfq0AFRe/200y55TIvSY0F+rAVi6Q/DPPy/4Fmhk1AKM7AsWMwo2uYvQcOweOM3Vb+yQ5t2l2vtDwHj01+Au6Y+5Iv+04JV/mfsUHhMCe33GIlteo+EiWenyLL2xZ4Isp3W6PVMDJh7A69oMQG/U3jByAA0vLzlKoh8Wt9UQiPX3s0a7UIN4/YQ5kLIu1f1E6dUtC5XScIr8hPJLc/ZU32uXZxAYx0fqIj7tERx0D3zgbfABN8EG3garvASTV/+A9YxZPf/6XNjwa+4scPAowaXgUuNvf8K1i/lIoCcBjQQwEtmHRnol4ydm32Nt5O93G6wPtfWIpXcVvP6a9MrqLoPX0r0EVnMRvOaipJ1n9NJDGCW/q9YzKfun/QTPU38yflJMpglOcgJ/G102cJnkpRc4p8Nq6TnIBooSFsBpyCfrlET6IeNn1Ounnj/V/H9xABT9ZYn7IJeuzgkk7odBwm8wjD8Ew9hDMI49ApPY32EWdwLm8edgEX8VNon3YR+nhktGGyLmdiBxbQemXgei+s39ibEx6ZQBmCZvTLRJXJVuHrE80yJgVplN0PxCyQFEfppMGYBz5sVA1+yrSrqeedcCPYpv+rgU3nIk4hB1BbpnHjLROgByei+WAr4+aw/l9XyMjFgVkkJEpIaqkRZKDkCNvBA1ikLJAYioCRfRGCliYIyIMbEaLEgXO1+JXn9foZd/3Zgl6CZBGSt3/dOjh92qnkEWw8d4WTYs9LDotdbLsn6Rl03/ab52o4YGOc2qiHJdlZ6o/FMZH9bmGKu8aP3vFQRphdxgxH1Pea9NPVjWzEqpXUd9e9IA8Mu/yH0LOnhwJYTIfmDRo+Bc/gFqiQNAEZlIN4S+0xrrlYD+gM/AnNJU3LvggqDIv0wYgCy411pJVYjmAMo/STOZfCHAeO5jByn1l/YBajMA9iZs2eg9Ecy5uLVh8pKjqwAY3RLBj2rn+DkBjlT304w9LdWgnYO0RJMiP6H9FPmpty+p6+gAvjFt4CMfgQ1/qN0eTGvEBt7V7hJsvibtE+T0WnkRJtN+h/X06c9LgFYY69X9HMZMc+f4D3vrcdEDgO1QaVuOH2jAiFdAqj403ENLLoYTs09L59Wm+ze0yL5k9FfBai+DVV+ULu99Aaz6AngN/d0lCEPaYTzwMOSK/h++8N68cLTjyJIDkBh2XxlIH/+DfJncYdxys75bYP5+B1jaLbCef4Jl67IAXQbAqASg+j/pgK4MIOPf/8wB6CXs1b3ug0HCfhjEHYSR5AAOwyTmKMxijsEi5iQs4/6ETfxtdE9QwTlGhHdpO+KWaDDgCDB864F2ZlQz1Cj6q1irnl/H2/b4LEky+IjlmbYRi3LpVSoBUr6P6V5wIYCivlfBtQC34tv+bkX33H0zbjm6ZNxy9My81o3AQMIBkukZ/M3YnNzn9I9PvIzSnHYkKtuREqxCWrAaPYNF5AarURiikjKAmjA1GsLVGBAhYnpCJ6bHf6exY6nzGMuRoj6dJkWnXXK3NRlBlqOG+1m1vOZlWbeYWoAeVg1vK2wHvhLYfXKfEOe3imM8NyZmhD7wTvd7YBOv3RP4H+/Dv+O07NeTZMB6f5Uoy55dLsSPGioLr10k+Bf9SkNA3Df/CQ+ughDVHyz6JXj3/RQ15zrAviVjIPlvbTTkHwB6jSvAHFPbuU/+ZS5lAMX7JDpx5IBWIXlKnbz3p8kkBWY1rdOlSwVIkgLrKgEIA3DMf6N+4uI/PgAgu0nKuvS9dFN2JDii26dH67OllVqSui61+nSS2i/r1HVeapPSfTbsEdjQ+2CD7oINuAPWfEO7QrzPZbDGi+B9roCV/wmTacdg/XrrcxCQVG4S5mcKPpXbK478Cfsu0JM2+RLhZ7ZuzRWBfiTRLQF+96WWIgF9vPG6FO0lw6+hNP8CePWfWuPvfR6893mtQ6i9CePxj2CU9l6nnkVF6Avvzd8P/fJT1O+69GfJIF48hg4trvoBM9qsFp6GjOTD0m+A55wHzz4F1vMEWMYxKQNghAH02A/eYz8EMn56TdgHIX4v5HF7oRf7K/Tj9kI/bj8MYvfDMOY3GEcfgkn0EZhFH4VF9O+wjDkDm7grsI97CJd4NTziVAhtViH7iw68dr0DUQ1z1zCDl1OtEjck2PbcE2Ebv74HRX7byCU51uHv9bRJWJ1il7glwTHzWKhCVwJ4FdxXKEpuOwcU3XFRZN92dsu9Ye+WfN7SLZl2RdC/9296DVaeFr5+W++U5bUjKbANyQEqpAWpkRkkIkdyAGqUharRO1SNxjA1+oeJmJ8GDA1+X8OYnfTMSdGnj8stxyyXTT1CbCb0V1j2nUXcf4Vl7TJPm8Z3FDYtr/nYjhiptH+lIcJpUW4P753R8ZHnfOM8r3WLcKBFNv/W07JEz3BSuwup9LKcOWXy2METZKFVH3Fl0V7Bj0RAC54Kwb0hRA8Eix4L3xGbUPQnrQBTSSi8xIBb2gHZckCvagG4Y8pDrsi/yj3zbnPvwqM0CCTEDhkrjQH33xlt2vrQz2pSu0vXSnDtPsDzluQAjKgL4JA3q27CwtPvA+DXiPzT8WyVNsmNcxLZkIxfpd2nR3x+Ce0nIE4X/WlZJtX6Q2nQ5j74wDu6qH8djAy+8RJ44wXwunPgDRfASs/CZOpRWE/7iwN4F6ZMf0BOdOuS6+UPaVOxSot3ELuQVndRqUF1Pw31kGpP//taHj8ZP6X7UsQnY/8TrPcFyeB51bkXLut1EbJB7TDpexhy1+H/FfL/l6MrA7pepdsq/3sZQEffZcIyk6ZNsKD17JkPwHMvg9Gsf9ZJ8IzfwdOOSug/63FA6wDI8OnG7YUQ9ytkMXsgj9kD/ZhfYRCzD4bkAKIPwCjqNxhHHoJZ5BGYRx2DZdQJWMech13MTTjGtMErQYR/khpRI9ow8gQwdPPe24xV9bFI2htmlXcx0DpxWwwZvl3Usmy78KVZ9rGfJjvGb41zTdsXTsbvmKP2cc2+rVRk3/dS5t919Sq640J0YdfEC1ZUBkhTd/8g2eatWLW+OLsdmZHtSPJvR1qACj0DRGQHqpEXpEZJsIhewWo0hooYFN6Bt9KAaYmbOhnzTaHPr/V81C3DcV16hF1rvb/V8DEKi8Z5CsvapQrLusUe1nWLPa2ap/vZjR4S4Di9KtJ1ZUaSx89RiVE3feJ9bzkq7Y6Z/r0s+fec1h1ycgCGdd/EMcoA4oaMlwVVrRGUxfsFv7xb3K+wk4dUQ4geABY5BgGjNyDrDMlpieDkACgaL9NA7z1Av/RtygAecO/8q9yLHEDRYSGg8gshetBE/Zw5ZWzwr5FmUx94E/NQmwFcsCJJcIvxF6xM3++0kxyAff7MhomLTy2j7cBX2qUOAEl3SSIbNMtPq6VJXXe+SmL4SX3+qbqan4yf+vtSPf5Ym/L3vw3echO8rzbq84aLYPUXwOtplfhpsLqzYMVnYNx6FDYvv5yueygCq4C+Uc5rA6rO3XjqePSpdp8fdRvepejfAT6lQxv9KfIT0k8c/kYC9yjia9N8ydArz4D3OgtedRaMbq8z0se89zlt92HsAxgmvKXWN833+/tb85+Hfsm6lplAeJYF/AMYaOE23F0/ZG677YcXoDeqA7znTbDcsxB6/gGefkyLA0idgAPgiV0OgIx/L4TYPVoHEPUL9KP2wCB6LwzpRu2FUcQ+mETsh2nEIVhEHIFlxDFYR56GbfRl2Ec9hGusGr5JGgRmqNBzmojZF0Uoy19fxEw2BTrE7ImwTT8UZpWwMdEmek2qU8y6FMe4zfEOCRsTXVP3REgtwAKVh1fP+wqfgnselAFQCWDeU9sK9C08biZlAVIG8KLT81G8OTA3/QYKkh4i0ecxUpXtyFCqkKVUI1epRlGACr0C1WgMFjE4XINpscCCtINwENLG0ef3crvmnuGwMivcdnyLn/XAV7zNm972sqhf4GVZt9DTummOwnpAq6/tqOH+9lPqiASUTKPAYTcUccHXumn3BP6nU/p3nBboSXsAdQ6AxQ19iQdXfcz9i/YJvnm3BWUxhNBaCNGDJAcQOm4j0gkD2KprhVELUHIAndAvnEkO4CFT5F+RnIBP8X4CAYXYYWMlHYCBByL0Jz/wlnYB6DgAXSCg5ACG/RDF7PNm1U9YcHYxOYBLNGffAS5t06VsQwf6zVeBz1GBvaHSRn7J+FVgE1RS9JdafEPugw24rU35yfibKOW/AEb77GvJ+E+BVR8Hrz0JXnwSJlOOwKZ1khQNpNqajbdy+uSbXcpbkHgHktgpgY00PESz/bQAk6b6+t+TOPyE7LM6SvXJ+P/UGn/FabDyU+Dlp7UfV5555gBY1Z8QhrbBpO8ByN1a3vv72/JfH90IbVc78JkD+M8IJPd4dbnpgB2wWvsULOcuePZ5sMw/JONnBAJ2OQDq+ydqHQCP+xVC7K+QRf8CedRu6EXuhn7kHhhE7YFhxB4Yh/8K04i9MA0/AIvwg7AMOwLr8BOwi7wI+6g7cIlqh3ecGoFpGoRmqzDsc2Dgp7suMdZY1D31WoBb8sFQQvzJ8F0SNibaJW5IoPLALfNYKBk/AX+U9nddiv40KETG71u4y4wyAO1OvhcdgLt7H9+EyIMdFVltSPR5JDmAdP929PRTIddfhaIANXoFqFEfLGJgmAbjQzuxLP08QkxqPmcMsnrvNqcC1y0JkXZT6vytB032tmx8y8uqfoGnVf27JAXmbdU81dtGywIMc16Wnej9fQypASWHnLdMdtth+O8VBV0Lmf6wM96yys9ShbTpVdIikGDaA1C8h1MGoCwCD60Fjx4MFjEGYS9/hSTaefeVWjsEpHMA+u89gUH+NDCn1MfcW8IOLgn+JT8RE5DFjhxBJCA2/BjRgLUcAEr9u/YBjjtrQSWA3rA9Ecyx4PWGiQtPLyQHcFGl3atHwzZEullOIh4qqd3HZqvAprfr1mipJH09KfUfTXX/A/BBd8BabknGz59F/nNgdWfAak6C9f4DrOqo9MqLTsBk6jHYTn85ueuxmPWeP9xyx13tUg9J3qsDwlza3kOpv47fTwy/vsThp5T/EngN1fjnpYjPyODLToKVHQcrPQlWSo7glM4BnAeruwnjcQ9gGDdHZWBeoHjxTfn70Rl3VxvwWfr/Vwfwn6O0Zk5jvPWDF4rW752FfKQaPO0KeOYJaeSXp1AJQGQgAgAJA6Da/1cp/RdifoE8ejf0o36GfuTP0IvYBYOI3TCK+AXGEb/COGIvzML2wTz0ACxDD8E69Bjsws/AIeIqnCMfwTtaDWWSGuGZGqQ0qDFzfxs80sZ/zCw3BBPa79BjX7hT4vcxFPldEr5I9Mg+EexaeFupLLih8E677USG79Xzjotz3m2nLgdAGYAy+ZipIvuUATkBHRj413+zUYjftktV+SokB95Div9jpPm2IdNXhVw/NYr9VagMVKM+SIOWYBEjgzrwXs9biLEecNGILXIaFwGLao/jQSkO84oCrAdM9qWob1m3RGHTOE9h2+dNL+t+r/t1Gz4q1GlmeazHyoxkv+2xeaEPvGkOINaZSEr/VgfQCsFg9D0PefW2BEkJOGrgJB7c6xPSAeS+eXdoDwA5AIkGHDYGEVO2IoFGc6kXTjRc4t8v64DBex0wzH0VzDm9jfvk3+C+BZe5f8lPPLh2GYsdMZI4BkQDpnVgkgZA1wowuq2nzI3mdzrKh/8oYQD1ExedmE8O4IIKbJdOYHMVDfhQ3f+X1H9KO9jkdrAJ7WBj2sFG0ULK+9rWXn8C+66DU+Sv/xOcon7NabDqE2BVv4P1OgJWcRis8ihY/jGYvnYMNq+3ajMAxpjlwA+XGS4GGG3tfVcFPlcn60U04lEk2kkLOG+DNxDCfxGs9zlwMu6KU2DlJ8BK/wAr+UNajsFKjoOV0N+d1P73yj8hH6qCed9foOfS9M6Lb8gLR5vqEyuRLqX8LaD+v/4zLgC9kgP4BxyAjp7j+HeMylbDYkUbWPpNCBnnwNL/AEs9IjkAqQPQYz9kCXshi9sDWexuyGJ+hl70z9CP/hl6kT9BP/xHGIb/COPwXTAJ3w3jsN0wDfkF5iF7YRV6EDYhh2EX9jvsw87BOewOPCLa4R8rIjhFRESmGmM/Bvq+ufkmY30Ku8WeCSIHQDMATgnbY11jNySQAyD03y/ngY9k+Gm3nQj4c827YKUF/7S3ixFI7UCtAMeLgiJB/tt2VBV1Ii34LpJ8HyDV57HkAHL8VCj2U6NCqUZdgIiWQBEjyAHkPkCyw4iHjJV6LomAXl8vlSLN/v2cYGL72TRPpT0B3jaNcz1tGud62zRPVXYfNTTccWZljMfyzBT/72MKI2/50pLQiIj9xlqH9G88FZAZTWxzkjfvjZKlzylj4c1TeUjVGsGv8Bj3zbvH/UvAQ2rAowaAhb2EqKlbEU8OgAQ2aQhnBTmAJzBYpoFh7hQwp/R27pNHDuBP2icgC6p5j8WNGi7LXlBAisPPHEDrMdNny0Bbj5lKegBDdkeTA6gev+DE3E6Anaex3w5J3EMC/xa3g72tkub5+Qzi9reDTyTjJ8T/0fPIT8bffFWL9NdfAKuhmvsUWO/jYL1oW81RcDL+soNgZYfBsg/BdOpR2Ex/NbXrsRhXfjxXf/xT8NlPtMQiKjUm0V57Lb9f6vU30QDPJS2qLxm/LuKXHAMvPgJedBSc9uQVH9M6A3IClBX0ugLjsfdgmDBbbWCR6fHiG/KXQ4ZN7DdJtflZva/fJbTxjA8gOYB/bkOZOuTbyj3G3LSec1jKAlgKZQGntVmAxAM4AOGZA/hF5wB2Qz+GHMBP0I/8CQZhO7UOIHQnTEJ/hEnIjzAN/hmWIb/CKmQ/bEIOwjbkCLqHnIBj6CW4hD6AIkKNwAQRUWka5NIiz2/uwTVy3Bw9x82h5ACo5vfNORPkln4ojByAFv1XKSj6U+SnqcAIXeT3/GsGoNBmAM8dwPMT4PvpVzWlQErgHSQo7iLN5xF6+rQjx0eFAl8Vyv3VqFWq0RykxvBgDVYUqdDTdfgtxpikZ1jlcsEx3+2buBTn5Vkx9lNrlST/ZdM418e276yA7sPGBjlMaA51ntY7xnNJTnrgN3F5oZe8E0Ov2gUHbzP5F1OBIUj7AMde9Wf5S3JICFQIqvxc5k9CIHn3uLIYEggoZQAvIfrVr5FwjiS31FoFHALlFj+BwdIOGOZNpQzgMfctuCD4FZ7iASQGUruUUWsx561i1rA9lk2750HTf6z1irF0R+42oizAdAlsJSagc3Fr9fgFR2c9Bdg5Nfi3OqUdyjQW03INXfR/jRyAGpzqfkr7h94H1xF8WMsNbeSvpX77OfDeVHufAK88Bl5xRGv8FWT8+8HKfgPP3AeTV36D5auvPisBjPNXvm0wqA3yqU/AJnVoVXxJw4+Mv+WBluRTR/U+AX1U658AL/sdrPQoWMkR8OLD4EVHwIqPgkmv5ASOgxWfhrzlIUxrf4LMuc+8F9+Mvx2K+mTYDTCUIj+tS9deQxbbacSU+N9NoBnUDjHKfR+WpNpccBe851ktIzBNSwYi7n9XCdCVBcjJ+KN0DiD8BxiGfg+j0O9hHPw9TIJ/gFnQTzAP+hkWwb/AOngf7IIOonvwMTgGn4Jz0FV4hrUjIEZEeLKIyDQVpnwItMz48iBjEyOdk84E+eepvWn4hyK/BzmC3Nv+hPx752mjPzmAoMQLVmT4VAI45F8xVmR/ZUAlABm/NuK+6ACCfTcsrS9/ioyQu+jhdRfpisfoqWhHtkKFfB81yvzUqFaq0S9IxJBADRbnP8V7Q7eowsNjw7VfAXrljrd8K7wORPT0+ig11nlaTaj92IER9uMHhHQbOSLIccygMJcZvWK9lmWn+30Tlx1+wys54qFtZvA2k9Z/LQ9AYpndNqedAKxoWa4QO/AVIahiveBX8LvMP+++hAE8cwBjETp5M6IJA9ignQKUtt4s6oDeYioBXgNzTnvMffP/5P4FJ7h/6Xc8uG4xix09hFaCsz5b4/Snqr1JDViK/tKK7/3GrHW/MVvWaa1HRCDX0sk1ExYdfOMJwM6otJN/1GkgoU1q+72pAp+uHfCRgL+x7WAjtIg/638HrN8Nbauvnkg3fzH+it/Byinq0z0EVnYAvGQvWPGvYOQAJu2H1awZcV0Pxbjn+4sM+t2FQBt6R4oQaLKPVHtJvouMv1Zr/KySUv4/wErJwI+AlxwGKzoMVnAYvPAIWOFRnSOgexys/AqMht2Efvir7Yz1cHnxrfiPIzCvVgULnhDI4lr9DJJbFSz9dU+z4qU+3RsWuXtPXOEUvvhzh9hNu50i13/topg8L8x19LQ0n2mvp/m+8Uaq17wFqQEfrUl1H/Xuyw5zvofdT0/Biu+D9bwAlnlcygJY8mGwHr+BJxwAj9sLLnUAfoFe9C7p6kf8AIOw72EY+g2MQr6THIBx0PcwDfoB5oE7YRG4C9aBv8A2aB+6Bx6EQ8AxOAedg0fIXfiFtSM4VkRUkgYlfTV4e+PVDo/w1/oZ+ne6uWXB3S1L5a7IvqokJ+Cd+9DfM/+uq5T+Jz9P/yn60+2eeU1iAnaBgBXPgc9nJUCY8tvZDRVPkBVxH0mKe0hTPESGVzuyFGrke5MDEFGtFNEnSIMhoSJGBaqwaYgGB1b8eW/Pd/s+Wrbgq1p3+YwYxuYHhbLvQnKdfozJcF2d3sNlXlGk4+Q+EU6t9ZFu06vi/d7rmeKzLaEg7IaiZ+x96/yI/cb/XiIQPUDaCfjSfS9ZwcJ8ecygl4XgXusEZdEBwT//JjmA55OAY+A/biMiThALUNQCc+QAFnZAb9FTGOTOIAfwkPvknycpMckBhDW8LWkBFMzPpwxAf8wDX+OJjx20DmC/MVtCbLZj+pLi7ph94cyl6NWq8Qt+n9EBsJPUbejQGj+Bf2+rwWepJJ6/lvDTrkX8hz3U9voJ8afI30A9/vPg1afBe1Pk/wO87AhY6SGwkt/AS/ZLhs8Ld4MX7AbruQ+mkw/AevbsZ9LbRqmLlunXX5cWdbCBtImXKL60j+82eP1lMGrtlZ8EL9em/GTgvOgQWOFBsIKDYPm/aV8LDmkvOYHC45ANeAiT2h8gc6x9+8W34cXj/fH2IYEbDv8Usm7flcCPf77v98kv933XHbzv+/mxe37r/7gbuPHUnYCNp+/6bzl7z3/LxQfeWy61ea6/AK+Nl6DYfBFuX5yH/ScX4bDuJpy3PEb3TWqYTLwJ/bIr0K+4CP2S09AvPAH9/BMwyPkDBlm/wzDjKAzTjkE/6XfIo/dCL+JHGERQ9P8WRiHkAL6FSdB3MAn8FmaB38M88AdYBuyEVcBPsA3Yje4B+2AfcBhOgSfhFnQZ3kEPEBCuRlS8iNjkdsz6CBgybdN2xnY5OmS0u2rr/Pue3rm3/an+p74/OQCp7593wYoMPyT5vGVw5jUT0gWQqMAvRP8XOx+hQVvnN/Z+iozwe0hQ3EGK4gHSvB4jS9GOfIUKpb4a9FZq0BggYmCwiFHhGowNUmFZ3lP8Ogs4uekh9n/3x5UP39+8bWD9inrG3rRlDBb5DrvDU9znFaV7zM9P8FySk+C3PLOH/5dJhZHnfNOjHtgkS63Jf7MDaIWp/pDzfrKcd4rlsYMmyoN7rZUFFB+U+eXfEaRtQDUQSAwkfDT8Rm9EAolzftmu1b8nYsy7HdBb0Am9gjnUBXjIvPPPcW8aBCr/moc3zmUpk/rKyt7rqUdiIOPve0qDQAT+kQMYespAGrxZCCspA3AperV68sLjrxEGcFytlfem/jsJfFD6T7v1qO9PPX8C/qjfP+g+WP+bWoYftfrqqNVHdf9JyfhZxRFt1C/5Dax4P3jRHrCCn8HzfgLP+xks7ReYvHwIVq9OT+h6KMY9Fs7Vr/pTWsHN+lLKf1sS8pDYfUTiKSdknwA+SvEP6wz/N7D8A+D5+3X3gPbP9PeFh8HKL8H4pbvQD5/axliY44tvg+44xxoFf7Z/g/vHp2He71OYlK+QrlHRezDMXwTDvPkwyJ4H/Yw3oZ86C3opb0AvZRbkKbMhS5oFeew0yGNegTx6CmSRMyCPmg1Z5BuQBU6Fvv946AeOgUHgeBgox8JAOQaGynEw8h8LI+/RMFKMhonfBBgGvwnjpB+gH7UX+mE7YEjGH7wNRsHbYRy4HaYB22Gi3A5z5XewUH4PK+UO2Ch/RHflHtgrf4Oj8ijcA8/CO+g2lEEqhEaIiKGR3D4avP3Jn6Kt98wqYyXsPTPuWvj1uOngn3vXzbfonnsX6YekwdyKtKAfOQEyfor8EglIMn6K/v/pAKLC1m1urnmKZP9rSPS8jVTv+0hXPEJPr8fI9VKhyFuNXr4iGgJE9A9SY0SYiAkxIl5NeILXE0QsyWzH98M6cX4lcHLLVezeeWjf0qWbZ/gYTS5O6f5lTIbnqvQk70W5SYrlmUn+m3qQA8jIuGuhlQT/ZxD233FaO82N6nZFCunTq4W4AZPlYdUrZcriX2R+khpQp0QFjmgBCx0J36FfIIOkuTe0a3UAaChmfgdk7wJ6pe+CO6Y+5l7556RxYBIEjeg7SzsItDKDjb4YaPRam5O0DpzAP7qEAYy8aMReh5XeqENhzLH4lZqJC09OIwzgmFrLAXhfO/BDAh98hkrb+puoA+SG0tjtbbB+V6Xozxv+BKvVtfp6/QFWflRn/Acl42dFe8ALfgbL+xE8Zyd47o9gqT/DpPUoLFunJXU9EqO4Oa/p02bbvo/AGm6B11NZcU1i9kntPDL+YkrvD2kNPG8/eO5eMN3lefvA8+nu1zqGvKOQD3gI88afIHPoO/vFN+D58Zj31STFyj/BAl8B8xoC5j0IzLs/mE8zmKIRzKM3mHsFmGspmEshmHMRmHNhJ3MuaGOO+TeZY8Fx7liwlzsV/iE4FZ0TXMq/k7nXLJe51M2XuTXMFDz6T5Arhg2Se47sr+c+qE7ftX+5vmNVoYFNZprMpmeqYJ3TxM1Tdxh4jYBJ5mHohf0Ig5DtMAraBsPgrTAK+Aomyq9gqvwa5sptsFR+Ayvlt7BW7kA35S7Y+/8KR//f4Ko8Ds+gC/ALuI/gYDViY9RITFRj4YdA31GfbmbsK2fPuEfdfONvORLnvwv9p4+D8rS1P11pCEjX+qPaX9tv7yICvegAUhK/3zmgXoMExRX08LyFVO97SFc8RKbnI2R7qVCoUKPCR416pVrqBAwNUWNspIjJ8Rq8lqzBW5kaLE0XsTKxHV8XqXBhHtDxB7D1019P+5hPyy7z3RWZ6fNJWpr/+h49Q3ZHF4RdVFQk3zDVOoD/5GH8a47phId2rPHnKCFlWg2P6D9FFlK1WiYRgfJvcL/8J0JQJXhEP7CwEXDv8wkyTuq0+GgOYKlGuwDjHUCv1/uUATziXvl/khYA9y/fxsMa3xISJzTTwlE24arS+LVOBzbwgpWUAVAZ0LrDkM25aMTm3LfWf+OBL3MsnlQ9ceHJVzSQtvrS+K8k8UXafrNJw4/6/u1g41TSLD8fRGo7t3QsPzL+s2DVJ8GrjoNXdBm/LvIX/ioZP0V+lvsDWNZ3YFnfg6XvhsmrR2E5qfW5A4iaOV2v4DdJLITXXgGvPi+Rd6iPL7X5CNwrPCRFecnwc36FQIswc/aA5ewFz90nXUFyAvT9z8F41E0YRLz8iLFEuxffAe2xGPi6lfPbP12Rp84FCxgNHjgU3K8PuG8NuE9vcO9e4F5l4B6Fndw97wl3y1Mz9zwVc899wNzzznP3/MPcs2gP9yr+jnuWfMO9ytZx37q5LHjwS0LImBa9qOmVssQP0lnZiWCDJnhaLYHFPwmLMLcdhrJuDSdNkr+QhEAMArfDMHArDAM2w0i5GSbKzTBVboa58itYKLfBSvkNrJXfwU65A/bKn+GkPAAX5WG4K0/A2/86AgLaEBUmIjGuAy2Dn+KtZb+rjM0n9ewe19nNLZlm/q93p7qfjF+ZrOX9d7H+ulB/Sv21df9fjf+Fn90kI2XX1ZZaEbEe19FDcQMpijtI87qPDI+HyPJsQ4FCJTmAWn8R/QI0GBxCZYCI8dEipiRqMDNVxDsZanyQp8b6Ug2+rxBxtJ8Kd3a0oV/WO5MzDa55DIi8GFgYtiuyLOxscFHkZZfo6FPmOgzgP5/jv+WYTui0k/fdHU17++Sxw8bKQ2qXyQJKfhJ88y9LDiCwEkJYX7DwoXCuWoGCUzoZ7o86wBeTxr4afB6gV70GzEHKAM5TBiD4l20nOTCWNLkPy1uUyyb8qSQhUIkCTA6g9pAJWwI9yQm8ft/KjByAc/nYuleWHH2ZVHcPtGspwLTIY54IPlMX/Qn8o9bfUKr9SXCDUP9LEtGHE723itJ+Av2OaI2/aB9Y4V7w/N3g+T+B5f0AlkPG/w1Y1rfgadoMwGrStMSuZ2IU+do0Pdpv3/ui1ugrT+oAP+rnU2vvEBhFdzL67D3g2b+AZe3Wfiw5gV91mcB+sLwjkDffhQkt+HSsm/ni039+XGZsfdN69FdgHn3AggaBK/tB8K2GoCiD4FUC7lUE7lnQwTzyHjGP/Nvcg2YuCs4LXoVHuaJkN/cu2869yr7h3hWbuKJqDfepXSTzb5rD/fu9LgQMmigPGz9AL3xyo37CggJ52voexpUnQ4xq2pxZ0XlLJg3aSDPt0i+yrFufQgOfyTDN3A+9gG+hH7AFhgEbYazcIF1T/w0w998MC+VWWAZsg7XyG9j5f4vu/jvh6P8LnP33w1V5FJ7+5+Hndw9hwSJ6xHUgPaUdS1cCjQNXf8LYl2aKxKt2nnHXutH1S79sQym/b7zW+EkAhKK+1PJ7wfil84ID8PYeGVJRdvppTdEDRLreQKL3DfTwuokUzzvI8HiALI925HuqUOajRrWfGk0BIgYEihgWqssC4kS81kPE3HQR7+WJ+LRUxNe9NDjY3IHjyy6jKWFOSSzrNBoWcde1MOzXyPLwi0GFYW2ONAn471UE1h7OyAHQVuDsOSXyGNoJ0PiWEFj2jeCff4775mt4YDmE0D6SA7AtWIqCP9q16Lwkha3WLth4G9CrXw/mkEYZgFQCCP6EAZAg6ORGWe6CPDb2QoBUAhAFmBwAlQDSSKvWAUgZgFP5iMZXl/32MmUAB1TgX3Ro5bbpexD636rdqkukH0nQoz9Jal+TgD9i+XHq9UuR/6gW9CveB15INf8vYHm7pNSf5XwPnv0tWNZ2sOxvwNN+gsmkQ7B5Y+4zDX6D8Gmv6eX8DF5xTovwlx4FLzumbfUVHwQv2AeWS4a/Gyxrl3Q53eyfwenzcn4Bp/9O0b/oPIwGXYV+8JQHjCXbvvj4tad77exuLjN+ui9PmALm3w/Mvx7ctze4TyUERTEZ/lPukS9yz/wH3Cv/BvPMP8e8Co8yRckuQVG2lSsqvuSKys+5d6+1zLduCfNrnMeUfWcLQYMmCqGjh7HwCc16ka806UVP6y1LWZ7FUj5N1ivZF27WW+1tXPNYYts959lrj2BXtdsk6TMYxO2HvnIjDAM2wEj5JUyUX8JU+SXMlRtgodwEC/+vYO2/Dba+29HN51vY++6Ak99uuPofhIf/H/D1v4LgwMeIDReREi1i5PBOvLP0yH2mNzVMkd1p4BBxxdYvSmv81OvXGr+25n9u/BV/qfv/M9pGRS0cPaBvG7JjbyHS7Rriva4jkRyAx22ke95Hpsdj5HqqUOKtRpUflQG6LEACA7VZwKuJIt5MF7E4R4OPCkWsLxZxfBzw/cx9txhztRod3GkyIui6Z1nYr1IGQA4gM/iQyb+XBqw9nI147MD6/Bopy5mfL8SOGspDG98RSBLML/+0zDdfIwRWQAjvAx45XFIEyjhwG8L2Dq0W3yLd9tu3AOOWb8EdM1XaDKDwD8G/bCupAUkYQP6SHH1dBkAagM8cAHUByAmQA5jxwIc5Vw1umPbe/knUBThAAiAdktoPzftLNFxJd4+26xD4R1Jb18Fpuo84/r1PaI1favcdBCvZJxk+z9sFnvsTeO5OcJ3x8+ztYFlbwXpuBUvdCeMJBzq7LV78TIjTIGT6DL3M78GpdVd4ELxwP1ghOZODEAjgy/0FjIxdMvqfwLJ+As/68fml/5ZLmcBvkPe9DZOyryHrXjftxUf//DjP+n6u1eANYJ4NYMq+kvEL3mUQFCXgnoWd3COvnXvk3xE8868KnoWnmVfhQaYo+Z55V65j3r0+ZT7VK8nwuW/DfK7sO5srW15jAQMnyYOGjRViJjeyqKnVQviUGlnMrDJZyqp0lrw9lhWdCTLopXI3rrhhb9GVBfzFAci6FaUbeI2BceoB6Cu/hqHySxgpv4Cpcj1M/b+Emf+XMPf7EpZ+m2DluwU2vlth570V3b23w9FnJ5x998Ld/zB8lKcR4H8bEYFqpER2IDtRhfc/eIrG5k9nkTGT4ZMDoHSaBmso7e+K/M/bff9l6i+duORNPzQ3AXF+1xDtcQmxHpeR6HEVyR43kOpBWcBD5Hq1o9hbRKWvKBGCmpQiBgSJGB4qYlyUiNZEUSoD3u2pwYpcEeuy1Dg3Ffhi4rcf0fcYF3HXon/oJe+ywF8je4Wd9y8PfWinXQjybwYApQzgoR3rfzKE5SzJYXFjBvHoltd4cK+1gn/BCZlvnihQBkAOIGoo5HFTkfzjRRh+R/r75ABoJFcN9iZgNHw/ZG65D7hn3nnuU/SbJCwa3ucNPRIDKVuVThuBjFpvO0tS4OQACP1v3SGXMoCZsNAfc9yXOfYe1Dhjxa5xlAH8ptZOHNIEHq3XflWr7aed9nukpfxSz5+iP9X+vX4H62r3dQF++bvAcn98Zvwsezt49tfgZPyZm8EzNoMlfw+TiQdg99a7z+bxDYKnviFP+xq84LAuld8NlkNfa4/WsHN/1hp+Nhn7j+A9d4L1/EG60sc55HT2gpWchtHwy9APnnCHsRDLFx+99rg2z3VwfHXnI1nEWHCfOjDfGjDvSjCvYnCPgg7umdcmeOTf5B75VwTPwuOCovhn7lO2nfn1+oz51bzHfGuXct/6d7lfnzeEwEEvc7+W14TAwRNY+EuDhfDxLSx+Ri8hiox/dqlB2vJMeeaGBJa2M1q/+Kq/YR1cTcuv2rHk85aMhDf/RmmV2dXuN0nYBMPoPTD0Wy85AGP/z2Hi9xlM/T6XHICFz5ew9PkSVt4bYOu9Gd0UX8PB+1u4+OyCu+9vUPgdg5/fRQT7PUJ8kBopoSqMHQ7MmbP3FmNj/SkLIMOnGxFxxfhFpl+X8XcZ/n86ABoEKul1UqwufYQwlz8R7Xke0e7nEe9+EUke15DqcUvKAiQHIAGBImr91Wj016AlgMBAEWOjRbySqMHryRq8k6HBimwRn2eK+GN6G6aXfziQvs8g5Q3ThsATftXKY6FNkfc9i5LPW2p/zv90SP+eQxzyUQ9t2bCLgbKchfn6xNuPbXlNCOm1TqYsPCb45at5YBlkoQ0QaC9gxCuI23geZqQIRBr8i3SCHLM6oTfhHOTeZbe5R84pGgXmhAFE9J3NUl9pYrR1eOCBCMNJd1wkERBpBuCYvuQAhp4ysCIHMOqsD3Oqa26aueq7MYQBHFRrd/zRwo0ZarBXVFqlHwn9fyBRfnmfS2B157TAXy9K0Q/r6v5fwQop+lPk/wEs+zvwrO3gFPEzt0iGz9M3gqVtAEvcDpPJB2EzY3ZU12MxCJg0Q566STJiTtE9eyd41k6t0ed0/ZkMfgcYZQq6yzJ3gPf8UcoOWM5+6A+8B9Pe30Hm0DDlxQf//LhO+WaRZeNaMK9acL9qcEUZuFcxmEf+E+aR18Y98m8InvnnuVfRUa4o/Y57V6znviTbXr2CU9T3b3yLK5unU50vhI4azsLHDGLRk/uwxFkVsri3imVJCwpkifPzZcnLsuVZ63vI83+I0qs4FqrfW+1tUKryNC656WDa+4qtJMEt7en7SxZg01hk4PUyTFP3wsBvM4z8P4OR3xoY+66Bie+nMPP9HOY+n8PC+3NYKb6AjeJLdFNsgb33djj7/AA331/g5fMbfHxPIND3JqL825ESokF+ohqr3hdRW/3JBPo+1Nt3c9th6Oy82+i5A/hru++fjZ9OasbqeSNHAymhlxDufA7RXmcQ43kW8R7nkeBxCcke15HpcQ85no9R6KVCqbeIan8NGpUdaA7QYFioiLFRGrySoHMA6SI+yBSxraITu6adeJJkP176vRikPGbaP7bNqX+S2rsh5p57dvQp838YSvqXHfoHDLxgpT/qpo+0uTdm1HBZTPN0eUjl50QG4j55D0kVWBZcBxmxAYPHIXrF77Dd26mdze9S4n3jKfRfvQu9kKbHzD3ruOBTvJ+6ACyMHMDkPpIDGHw43GLcPXcpA9ASgaj+12UAdy30J1/yZg61fetnrPpuNGUA5ADWaMBI7ovUfij9l3bsEfp/F7zfVS3yX31a2/Kj9L/0EHjRXrB8avXp0v7s78Ayt4FnbtVG/PSN4KkbwFLWg6d8DpbwFUxfOQTrmXOebeE18B0+Vd5jndbgM+jztZf3pBKCovwOcPpzxjfgGdvBM76FkEF/JiewE4ywgaJTMBlwDgZBY68x5mv24oPXHrOat3y7vfRNhyxoKLg3If1l2pTfPU9kHvkPmEf+Xe4hAX0HuaJ0B/eWov5y5l+7lPvT+ramWTyo/xQhZMRIIWL8ABb5SpMQPaVOljC7VNZjQZ4saVGuQep7PWWpn6TJMzYmUvTXqz0awhoe+pn2fuhnXnBfYVR+24myAMkBPJMZe/5LLbNtPGQavx4GkT/CyPdTyfiNfT6BifdqmHp/CjPvNbBUrIW112ew8focdoqNcPDeBmfvb+Hm/QM8FL/A2/sglL7nEer7AAlKNTJCREwfC7w1/ZeThOATkaaL4tuV/re+8HP8s5G5BgVZVTcevDOgjwoBDqcR7noCUe4nEet5GgnuZ5HodgFJHleR7nELPT3uIc/jMYq9VKj0E1FHtODADikDGBOpFQmdnkydABHvp6mxbwSwceJPJylzS06GvDb4kElT5HVPiv4VUTfsn9f///yz/TsO1VjjzlpYtMKT9vbpJU9uFGIHtFIrkPuX7KZWoMyvCPKQashIFixoNELn/gi3o506FqBu0+4bT6A/TQ2DuJEq7ppxkPuVfietBw+pXyDEjhipnze/UG/YiWAaBmI0DEQkIOmXrVWQMoE3bpkZTLvhxRz61DS+uearYVIGoBX/lCS+SetP6v3TZl3S3rulHfOVoj+x/Qj4o+h/QBv5Ke3P2alt9fXcBpbxFXj6ZrDUDeCp68GTPwNPXgeeshYscSvMphyB9avPmYD6iv6vyONWgVNET9/+7LLMb8B7fgue+Q2E9G3gaVvB078Gp4/TvwFPJ0fxA1jGbug1XoVRwTrI7YrGvvjQn5/uY77+3LRqrdTf54rSTh3Yp+EeBbeYZ8FZ7lVwiivIEVdsZL69VzH/2mVcWb+IK2l5a8tr8pBBk4XgwROEsNFDBIr6sVOrZQkLCmRJS3JkqSt6yjI/SZOlr04xpMifujlenr41jtVeDGTNKi+LfioPy+q7buQACAOQtPe7hov+8kut172p0sh/OsxS9sHAZ73OAXwME+9VMFN8DDPFJ7D0WgNrz3Ww8foMtor1sFdsgpPXVrgovoGr5w/w8PoFfj7HEORzFdG+bcgI7kBlSgfen3MfuZnvNtL3IeOnmr+iArLWZ9ON/71xJaZ/unjY8KdIjT6PAKdjCHM9gii3PxDnfgoJbmfQw/U8kt0uIdX9KjI8biPH7SEK3dtR7q1Gjb8afXQ4wKgIERPjNJiWpMY8cgDpIv6YBsyr/3wpfZ98h/3GLZ5nLQYG3HFpjLzjkh9xxbacdhj+F6PY/55DD3rcWQuDSSovefWWBL3UqdVCNMmC1SyXdvv55F8RfAs7JWXgiL5gIcPhPWEDlMeIokvqPOQANGAzOyCb+hT6ma9ruGvabloOKtCC0ND6d4XooS/JyAEMPxZqOK3dTQIBJQ4AlQC6cdfZ10zY6/fcmUv/yobZq7cMlNqAtHNArd23R3JfE0Twke1afT+J9UeaesT4I+Sfav+D2uhPvX4i+GRTNN4Glqmr99M2gqesB0teB5a0Bixptfb22ArTKcdgNXZafNdj0ffqN1Ee/R542nawtC1gqVvA0r6SLk/fqn1N3QIhlb4u/TdyBNvA0r/ROoC8YzBpOQf9oPHXGFOavvjQtce2YVlEt2HbwZWDwHwp9S8B98gTuUfeHe5RcJl7FfzOfEp3MN/KL6RaX9k4jwX0eVOmbJqlRfeHviSEE8L/0mAC+mQ9ZpWx5Pn5rMfSLFn6ygx5xqfJlPKznA0J8p6b4+Up9LozmjU+8NbvfcvPrPdNb+v6204EAkqtwC4H8J+jrVzm2HLMPOlrGIV9DyPvj2Ds8xFMJQewCuaKj2Cp+ARWXp/CxnMd7DzXobvXF3Dy3Axnz61w8fgGHh4/wVdxAAHeZxHucx9JShHpShEzhgPTx+88ps0C/v87kYnTMuqaLqMk/w687Q8jxOMQwt2PIMr9KGLc/kC86wkkumqdQIrbZaS73UC22z0UuLejzEtEtS+VAcQK1GAEdQJiaU+AiLfSNFiVo8G+GbdQEzW7kr5XH9/jZnV+l21qgm4710Tfdi6PvWita//9i42fDkVhcgCj73kY9trUQy95ehVxAXhI9QqtAyj4U/DOF4UAagU2goUOhnPTKsT/3qGd0acMYK5OI28qIC/+AMwl9ShXVn4hD6z4jBwAixk+StIDGLwv3GCSyoO13v8LBqBL81rPGxrN6XRibiNzm95au3GAtH9PNwZMar+02YdWbpH0dn+S+LoMXv+ndsa/SucASoh2S+2+n8BzqD6n1HwrWDoZ6Sat8SetBevxCViPj8B6fKxzAF/B7JWjMJ/4vA2or2gZL49eBp5CIOEGcN2VPk7ZDE6Gn0IOZSOE1E1aB0GOgRxA+k9S9DcpWg+hW69RLz7w58dxzLebTYqWgLkXg/uUgXuXgCmKnjL7zIfMJfsxVxSe5QT0BfedxYObpzP/Pm/ygL4zhZAhY4WY8S1C3KQmIXl6FUt+vYIlUco/r0gWP7+Qor8887Mk6VLkT1vfw7Dn1/F6JYfDWZ9bvoYt7a4U+a3qrrialFzrxmgRJ83al//VAbwYefW69+trFDAXZol7oa/4BEbeH8LY+0OYeq+EhWIVLBUfwcrrE9h6roGdx6fo7vEZHD2+hJPHJri6b4OHxw54e/4CpdcxBHtdRYz3Y6T6iWhI1mD123eREzcj/6/f7386Hh4x3ctqf7vWp+kplG6H4O/8K0Lc9iPM/TdEuv2GaLdDiHU9hnjXk5ITSHa7iHT3a8j2uI18z4co8VSjyltEg7+I/sQHCBMxNkaNacQFSNJgUw2weeLeNgtW7kHPokZxyrxv4PXu5ABKwm865NGk4r+8/6899GYPPWXOxrY5S8tBMuYXCgkvDeZh9e8KAeVfcd/Co4J33kPBrwRCcA1Y+ABY57yNngfva2W6FmikNVy0f4+/Chg2fA3umnGa+5VvlAVWreEhtYsEcgCUAQw9FGY46a7bsy5AlwOgLITowLM7uzGPsZlN89ZtaKYlHLt0Y8AzNGC0c2+MKJF/WAu1/i6C1VDfnyi/v4MT448IP/m7dKn/t2A642epG8GTv9Sm/UlrwBM/Akv4EDxxFbjkDDbDbNIhWL7+vA2o7908SR61RPo81uMzsB7rdK+fgyd9oXMG68GTvgRP2giWvFHrBFK3g+UfhNmws9APGPUnY85GLz5w7bFvXhJl1+8LcEUduHcFGT4RfTq5bxXCKl6BdUQjWPfMNq4o+4YF9p0tBNOQ1qCXhZAhY4TI8S0E8D27sTMrZamLcinqG2R+mCbLWJVOaT8Zv2HqZ0lGud/HSKBf3VV/1v+eu2Wfu27WNbedTWqvdWMVZy2YBP6dMrfOPmXukL/f+J8cAFNW6Mu6NZ0yjf0KRkHbYaxYCRPvlTBTrICFYiUsvT6Elecq2Hh+BFv3T9Dd/VPYu6+TnICL+1dwd/8W3h4/wtdjHwI8TiLc4zaSfFXIV6qxeCwwb8KO/4Uo6rOjl1b49e4BQ4DIwD/g7bAbSpddCHLZjVCX3Yhw2YNolwOIcz2CBNfjSHQ9hRTX88j0uIpsz1vI87yHYk8VenmqUe8jojlAxOBQEaMjVWiNV2N2nIg9I4EVA7bsoF+FBjcY9lVetG5R3nXtFXnHpTDslmMRSYH9Z6b0rzxc6se/9Nhef9QVP6LsCimvNEj9+4CK9cy/5GfBJ/+G4FsAIahK2hAsi52G5O+uwHCTtkUncfQlSe6n0Bv2B2SK4uPcp2QTD+q1lgfVLSSpccIA2MiTIYat7a6SHiA5HckBEAawQ85GXzMhWTDmOiG96e21G/u2AWynGnx5B9hrGq0C7ygV+GBat3UdjMC/mlM61h/N4P+mJfxQ9M8mRJ5qcp3xp5Dxfw6eTNF/NVjCKrCEleAJK8DJEfTYCLOJhzutpi98tpJL37vvJHnkQnAy+oTVYPGfaG/CGrDET8F6UDbxOViPL8B6fAkhiTKDr8BSdkKv4RKM8z+HYF0y9MVH/fw4DP/qG6PUGWAuOZ3cq/Ap9yroZO5FnWZh/bDqxiO8fuQ8nBKa1My8x1nmWfI9D2h8h4UPfUlInF4lS5tXwLJWZrC0JTksY3mWLG1Jjqzn8kyDvxi+rOeaVMkBUOSvOhGsV38tgPV/4G3YcteVIr/kAKqud2cZZwihRRIAAIj/SURBVC1Y4XEzVnHMVMoAtG2t/+DZ0xHsqgcb+c2GZY89MPb6CMbeK2BKDsBrBSw8V8DKYwWsPVbCxmMVurmvRnf3NXBw/xxO7hvh5rYVCvfv4OO2G37uBxHi8SfiFY+Q49+BASkdWPHKZaSEvPpsGOu/ORapBT9+UVkPxIYdhZfDj1C6/gCly/cIcP4Bwc4/Isz5Z0S57EWM60HEux5DD7cTSHU7i0z3y8j2vIl8z/so9mhDLw81ahVq9PUXMShYjdHUCYjTYHaiBgda1Rif8d5L9A2zFafM+/jecmyJaH/mAKgDoOUo/F84lPaNvGhNOABr2JKgnz2rQogdMoYHV68iWS9BwgEKOjlRgiOawQLHI+a932G346m0IEPayEMTepM00B9/G3qhzdeYonAtD+z9IQ9tfEuIHjlCVqkdBjKYpvKQFIG6HMBaUrPZIZcyAHIALmMzm+Z+uqHvY2iXgS7rAJuikQQ5pO0+tNiD6v8uB1B5TAv+Ud+/YDd4HvXjv5FAP5ZGqTml7lT3r5XSfW301xo/i1+uvQnrYT7x4IsOwLPPZHnEfHAy+LiPwOI+lC6P+xgs/mOwhLVgCevAEikr0GYEPHUrWO5hmDQdh57PiFP/VfS3rnmvp23Teu1Qj0feE+aZd4975rUzz1JYRw7EsPM3UQRg/LU7T+LqX37ELJNF5lawj8oAWcaiXHn+p8kGhWtSyehlOZ+kGWQ+v5IDoNqfbuZnSRT5JeNvvu9l0P+eOxm+Uf1tJ2sC/qovWEkEoPjjZtQBkKK/pDxElOD/dACs+2gTmV3Ln5ZxW2AatAUmiuUw9VoOM4/3YU7X/X1YuL8Pa/eVsHP/CN3dV8PBbR2cXD+Hq+tGeLhtg8LlB/i6/opA9+OI9rqFTF8Rhd4qLBsCzOi3bf3fv+VfT0hUfUBJ7f6DJVVAsN9euNtvhJ/r1/B32Q6l8zYonbYhwPE7BDv9iHDnXxDtvBexLoeQ6HoMKW5nkOl2AyUeIordRZS6qlDpLqLaU4NGHxEDAykD0ODl2A4s6vkUW0b9/tTPeHwEOcNC3+Nmg5Q37Osi7rqWh9x2Kom71q0w/rjZ/5UM4FkZIO0HaPw5SpY1u1SIGz2Mh9Yu5bQizLfgsuCdrxGUZeChTWD+w+A1bjPc93Roh3RmacBoP95kEfLJauinvNbG3bI+Y8EN83lYv9eF6NFDZAXLsvWGnAwhDOCZJiA5gGeaducNSRaMeYwoaJrz6camR5BWcHMCGV8RwceJ4DT6S3P/UvuP1H506H/JIXBi6eXvgpBDffjtYBmUjlPkJ+Ok9H01WOIn4BT941eAxS0Hj3sfLO49sLi1sJx4EJaT3wnpeiT6nk0vy8LfAo9dCRb9PljMB2Cxy8FjV4DFfqjLCD4Fi18HTllA0pdgSV9Dv/48jLNWQrDO7fviQ352BNt+G341iJ8C5pxHvX6Re+Zdpz0KzL3gqVVoH/Q9cw0+T54iGsDYp09RMfvjTr3umW3MoWClkDClQZZJEX9ZtixrZYYsa12KXsWeCHnJz1Hy3M3xLHNDgmHu1/Hywu9j5GW/RurVnw1mDbf8DIar3I363HKUHED5X4A/KgHij5tR+v+sDajtAhAK/x9OQLCsHmzkOwdWib/CyONDmJAD8FwGM/elMHdbBku392Hl9gG6ua9Cd7eP4OD6MRxd1sDZ5XO4uWyCl8s38HP9CYHuBxHueR5Jng+Rr9DgpWRg1aizmkTXas+/f8+KCibLzF3dWFJ15k55jQZ+Pj/A3X4NvF0/h7fLBvi6bISf02b4O2yB0mErghy/Q6jTLkQ5/YJY5/2IdzmCnp43UOVzBhWKbQ/7BR3AsNCbGBmsweggYIQ/MEwJjA59gnGhHdhQB6wd9MMvjLkZljtfNGpSXLWjDIDAP6r/KyLOWjQknycNgP94Pv/Ww1n5biPjlx7b6w2+GCTLWZIjxI7tz8P7vCkElG8RfArOCN55Ku5X1MmD68CCB8G29woo92nAFqrBZnWAv9oBNkkFPrED+iUfqplbz3UspM+bLHzgK0L82IG0eZhEQS1IFbj1oS3ro2MC0i+clAUc0zea2ebM3IYUN8xZs6meVnGRHBixAGn9Fm31pUUfNPorAYC0XOM4ONF+i3WtPwn8ozYcteUIpOuK/GvACfBLWAUev0IyfB77HnjsUumy2E9hNeEwLEbM1UlDMabv0ThRFvomOBl/5BKw6GVgMcsgxNDn0tf4GDx+NXjCWvDEz8GSNoBl74Fp01HoeQ8+zZjiHwEiu94flln3puhfScZPLT/q81/mnvkXmUvOI6uAXp115652+qMTPmIHAjqeohJA+dZfOmxCe/3GLHuu5gH9p8pS5hUZ5m9MJONntWcCpdYepfrVx0JNm64q9Ruu+On3uezLGm96s6b7nkaD2xzN+160Nm25YkupPxF/qO6n+p8M36bwuBnJbj3THvyv+ts2hWZy+wHXrHt8B1PlRph4LIOpx1KYui+GufsSWLotg7X7cti5r0A315Wwd/kQji4fw8llLVyd18PLZSt8XXcgwO1XhHgcRZz7NeR4qVHprcGH/YApxZ++9fdv6RO89LWYhOMICPoRTk7vwdnxQ3g4r4SX8yoonFbDx3kdfB2/gK/Dl1Dab0aA49cIcdqBSOefEee8Dz2cz6LO7xzSHN94x04vLyTBemJJrvOM1lL3dzY1+n98ZkT4t5jZ4yTmZd7Eh6UijkzT4JXsxdK+gBrrU+bNfjcd6kNuO1Uob9gXxFzvnqw8ZqolKv1fOvSmDz9vafCSykuWvzpdSJzWWwgf8LIQWPk59ys6xL3zHtCWIB5UDR4yEPrJsxC0+y447cmjRRmUAUx6DDa+HQb130GmKFnLIgaNpw4AlQD6WbNL5Q3bY6kNKGUAz9qAEhFIzuadMjCcedeVuQ8vbJy7ZkMdbeP5RiNNAUp6/6PbpcWenPT++tBW3TNajT+a8+8a880l8E8X/dM2ghHJR2r3UeRfCRZHhrscPOY9sGgy6sXgMYvB4tbBcsJRGDe/8dwBuNe/JAueAR69FCxyAVjUQu3/T52BuJXg8R+Bx38slQi8B2EBW6Ffew7GacshWJbUv/hwnx1Zt/p1B/SjJoJ5FIG756uZB/X6i/fRZS45N6wDKjrr/7zW6Q3AXaWB02MNLNpEKAGUnrgIRd6wdmaaeIwFjRgur/w5Sq/sUJjkAEbeVxgMVXk9u0NUHqy/yp013nFh9bedTJuu2pnVXbZhdCn1r75gJdX/f3EAJLzxD1N3/3Hktg0vGysXwCL6Zxi7vwczjyWSAzBzWwxL9yWwdl8GO7f30c31fXR3WQFHlw/h7PwJ3Fw+g6fLRvi4bIe/6y4EuxNafxap7o9R4KHB+LhOvN/vj0dKu2T7v34/e/tXZ9nZzoSN5TB0t3sZTg7z4Oa4FO4Oy+DpsBIK+4+hsF8DH/vP4O+wAQGOWxHi9A0inH9EnNNh1PnfQo7L8k8IPPzr12WsyNKARaU7yNIXKk1Kdqc5DdnbEDHlbLHf6J9t2TDvoYpTBtWuF6yqKPqH33QoCb7WLSNivwU5gP879X/XAXh3Gs8d1e7C6ndHy9LmlAiRQ8bIQuuWcGXJTmnRh3eBRgjsBR7WAhYyHgHrT8NkQyeYxNMXwSe0gY2+D73Bp6Af0LSTBTVNYtEjRgoxI4bLes4pI0kwqQ04/oHNMzmwrkt/ngV75jo+o/HttevrqAQgB0AkI9r1J/X/SYf/mlbmm9B/av1R9C8gfj71/XWMPwL/iOKbQv3+TyS0n4xfSvsp8se8B04OIIoMehF43FpYjD8Koz6vPW8DutWNkAVMAY9YAB7xLjg5geiF4DFLwGOpdCCH8hF4wmoJKKRxYLOGQ5B79DtChv7iw9Uep/o19Ta9PgFzyQPzzKfhnkvcq3h/F7WXueT+bh3YC7WXbsOtE7Br08DisQjTx2roP9LAGUDBQzWUo+feYybpHzLfMTXy8p3RlAXoVV0IMBzY7mI48I4Lo9v82IH1fdSdNdywl4yeon/TVTs2+LKNlPpT9CfwT+cAnqP/fx2++YcMgBr23Wu76TkOvmcV9w1MfdfDzGOpFP3N3BbBwnURrNwWw9Z1Gexc30M35/fg4Lwczs4fwtV5DTyc10Ph/BX8XL9HkOsehLv+jgTnW8h2VaPGS4MvhwKzaj96gThla1ziYGcz4J6t1WB0sx0Jh24vw8X+bbjZL4Kn/Xvwsv8Aiu6r4NN9Dfzs1yPAYQuCnbYhxHEnyjyuoJfXF3uMWJ9/VmB6doipGe/FmKc3ZcStbjCs87zrWhX4qHutzz0Pqv2J/EPgH83//99zAHQIBR7b5sya90ax1PmFQtz4Fh7RPJ1TP9+38Bj3zmvjATQZ2BdMORIO076F7Y5OrUrvq7SR9zHY8FuQjbwJ/aRXrzCvkmksZuQwIWFsf+IBsIYdsebTVF5aVeD9xlLqL3EAqAtwyIRN77RjbpNSGt5Z+2U1lQBfieDUYhynBiNRzgG0heeKVvGHBn9o6KeIan8azNnxrO/P0zeBp1JdTmj932r+mKVSJGdRi8AlB7BYKgEsx/0Oo9pXnzEBDdzrhsqUL4OHvQUeMQ88Yj5Y1Lvaz4tZCt5VCkiA4Hro156BcfpSyCxTil58qF1Hqe9Ut+64fuhQMJfMNuaR/yf3Kv5F8KnYxP2q3+eBDW8z14KfzPwqkXXxDroDMH0kwvCRCvqPROg/0EDv7hMYtgE+HZ2dyg823jBwK1nLrGtHygu2JOjVngmUIv/A+56MDL1Bt3il4byl2eDLNpT6S39HkZ/qfp3xs8xDJuQASHXnP7n3//WR2VW+aqacB5uon2Hq9p7kAMzdF8LCdQEsXRfCxnUxbF2Wws5lGeydl8PJeQVcnD+Gu8tnUDhvhK/z1xJqH+K8DzHO55Dh/BgVbh14IwNY3u/Qeca6v0AMsrNpmGZr2QI7q/6wtx0F526vwa37O/CwXwBP+2Xw6r4S3t0+hm+3tVDaf4lA+23IdjuP3opvTyoN61z/+rX+N6fC86wF1f3V/u1uvfwe+BQF3HHJDr1qR6vAaRPQf5ch/XtPBWSGowgI3Bsly17RU0ie1luIG/ESC6l5j/sWHRC88x4QECiE1oMF9Ydh5VJY/0iTgBowaVfeY7BhN8BI9bboQw1zzV8pEVbSpldRe1HesivScFK7myQJRlJgXZRTcgAt+41NyQG4v5xcv/Dz9ZV3Ia3ilhZ/jlGDDSMC0B2t3Hf1KUneu4v2q239kQPYBp6xRUv1TVmr7fFT6h9Pkf/956l/1CKwqAXg0ZTWLwKLWw2rccdgVPc8A5C71wyV+U+CEPomGGEB4W+DR7wDQSoHFkkZhBDzgRYHyPwZJrWHIffsf+DFB/r82PVePdCq6H2w7ml3uHvBSe5V8hP3qfyC+1avYMr6BSy0zxuMsgCHrDuW5WM7Pc5c7bSkBakPRAh3RQi3OsCvd4BdVYPd0kgOwveXo+3mKc2/MOOiiSxtTape9cFQKYPre99aElupPWRi0+e4mcXAC1ZS+q+lXxtLjp6Mn5wAGT6NAT+r/f93DsDEo6C73GHoI9u472Hm8xnMPBbBwm2BdC1d58PaZQFsXRbBzmUJ7J3fh6PTB3B2XglX50/g6fw5fJw3w99pO4Kcf0aky+9Icb6FQlcV+ig0+HLgU4zKXPZCFmDtXO9kY1nXbmPeB92tRsDBZjxcu82Ee7d58Oi2GF52H8Db7kP42n0Cv26fI9HhN1R7/aSJtJxY8Nev8w9H9++EoGRr9Ynf39vhii0Bf70C2l16+6u9yQEU+NzzoC1AXavA/qfn82893GTCo+7GA06FGRRQS2leEUsY25+F93mTKUu/ZYq8q4JvETjxAYL7QoieAptt18CWPdUi9eQAht8EG3wd+jU7IXj3WidEjWwWEqfUyfKWZ7EhJ0MkRaDW2+aSAyDDJydAv3gN5w1paShzmpRSu3j9ujJyAJ/rHMBoWsL5SCv9RQQgmvwj8E8a+iF5Lx3xh4Z9pNqfUn9dy+8Z6LdMMnYp6kcuAoucDx79Lnj0AskBWI49CuPG155hAHKP2sGC/wTwkFngwW+Ah84BC5sLFk7ZADmBxeBUViR8BoOKYzDuMR8yq+zcFx+n7kS0GFtXrb4g92vqZC45h5l3xUbmV/MB86t+X2v8g15mEcPGCmEDJ/GA+neZefIu49Cado/vDsKWnMC9J2DXNOCXRQi0Lu2SCHZFAyM14HHuJrrVT77AjHJeYxHLMlndAx/Wt7O7FP3J2MkRVBwztao4a+FAf6ZlIgS+Sk7gvCH1/Z3LidP+dwbg//wLzq2b5pj5L4J1xPcwcVsMC10GYOX6Lmxc5sPWZQHsXBaju/NSODq9DycnygI+hJvTp1A4rYef41cIcNqJcJeDiHc+jyznR+jtosGyAuD9pl/P/L2UsrauWWRt3gd2lv1hbz0KzjZT4GrzJtxt34Gn3RJ42y2Hr91q+Nt9jSK3A50ZVq/1++vnv3h0ZU7FWpmbm1ZxOMJhv3GVyy3HAq/7ijzPS96F7rd8e/vc8itU/Kks9W93owyA0n8tA/B/fj7/ykOjuvrDbnrLq76PYVnLs1jilDoW1jyVygDmW/AH987v4NQODG4A8x0O6/m/wOBLSCo9kgMYcQds4GXIm4/DIHrSVyxqXAl1AOQ163voDbsYaDT2trO0F5B+MckBkCadxEPYLQmDMscZcbULdQ7gC43WAdD8/5CH4M3XtcIfNPlHU38E/lHt/2zgZwt42pcS8s97EEJPffv/X3vfAdXUtq29dgIEEkihpBEIvRcpIiiKiiJKs2AHsffeO+fYe++9d0AUUaQJoqJi7713BTuCyvePtUM46Dv3nnvf/e9775ybb4w1dkjZOwmZc836zXVs9J4ErtSY+zWp8FJTnpr0dC0CE7QFohGXwG833Uf7PehZd+jHcRkBxnMGiOcMVgmQSiXA+C4Gp+YqcGizUKNc8FsVgGvd8eSP3+RvkLTYNNw4fCmIvOE7YtcinzjHrSbu3aezy7Pnr8R/6CASMrk9N2RGLLfxwihO4OjexKxJHlcVAculKTCjVZF0SOm9z2DotKT75WDul4HcK4f+S8Dq9TdIp69/xFjETCYuG4MMun5xJr0/SFlznwp37HEjFf1+qdBTBUD9ffqd091fW/6rnTRcZdr+sRVATGMtudI+nyyCsiB02AUTdvdfAlOqAOhSLYWFahlkqhVQKFfDUrmOjeBbK7fBTrkHTsp9cLPMQg3LQtRSXUao6hXaWJdhmOtXHOj2GUPqzm1V/XLm5vFOEpO2X82EnSGTDITSdAysTafC1mwO7MyXwMF8DZzNd8BDmoMW6tzv/no9qtq7f4Q2xpHIobl8N7fLxjSwF6s6bhSjfmYTZvPIu4H1Gb+G1qd9I+weejS3felEMwBUAVAL4c9MAf7HSLhnSGv1aXuwXvv0YMoTSKP4jHuHdYxzzEniEPGecW4JxqMDiEsPGMWvhTDrK1sDQEZ+0lgAve+D6XUfBk1XPyBevVvpdcoLoDUA+oOfudOeA5YUNJFep3LUFf1R9izim0yrMCOWMwI7Lk3e0/INQPZQHsDK/n9qAdACoI6UlFMT/KOVfxoFQMt+aeSfVuMlaVJ/NOdPo/Ws2b+K3bE1pn+l8AfQ40IQP02uXzLyAvgdpvtpvwY9dYfeXKchYNwngbhPAfGYBsZrFhjWHVioCSIGbgevzSUY1ZoLImzY+McvshJewwTiyNVP9BziKoi66S3iEJtG6C5fo3cix2fwEE7Nsd3Zct5Gy5uRsHWNSfjmUF74mjASOK4bUUUdJWaNIOwxtUJ08xWYFwC5UwbmbjmYW2VgbpWDuVEOcuc7jF8B5kl5T3gBnRcS+ehm+q0euJMB7y3o7k9id2qEX6sAqOBTgaffPxV6av5X5f+1GYA/EP5KcM27LBV6bYaZbw5MrJdArK6mAKyXwtxyKaSWS6FQroBSuRoqy42wttwKO+UuOClT4KJIh6ciF/6WZxFi9QDNrT6is2UZNocDa9vkFf18PVNR+1Qz406QinpAIR4EK8lE2JjNhL35QjiZr4arxTa4WqSiue151LOYkEfjuT+eQavYKj8nbT9WPOGHOD0xb+0G46a2d5wa2h4PaGibF9DIrsA/zOaGd6TTPReaAWju8tgshM3//xX9fy3oD6LvZWPeqBIbtjcgbHEkp+64bsSnyyzi2uowcYx4xThHg+PWFox7VzABEyBKf8HO0NOM6HoO0usuSJfrMIjdBz3P3uP1O+b50t3fYNhrNzLik5IdCc66AJcN2LkAWiUwH2KinFy7w+LdKS1eA2RnGTh0Lh87kusd2wBE/X+28i+GVv6d0LD9hNE2XFr2S9t8NeY/m/MPrNz9A1ax0X7W7/dfDOK/CCSA7v7UnJ8HJmA9xEPPQ695YhUfAKsAHAeDuFKOvl9BPKZoXAHv2SC+80FomXDDQxC0ygfXqiP9of0uTFtuHCcImUlnJj7kOLXK5Lq030q7+ti6/oBx3WgTD2m8JowbvjmULlrlx96O2V2fU2dSB+LYcTkxCd1m1GzwYeP8a1/13tKRad/A3PgG5upXMJfLwVwsBblYBv1ngNmRq+DHDEslpqPDSLdSBzbwR01+dp5gOq/K1NcurQv2T8YAtDAw7+Wopxz+XeKfA6HdVojVi2FqvVijAKyWwIIqAOVSyBXLobSkCmADrC23wFa5HQ6KXXCWp8Jdlgk/RSGCldfQVFGMdooyjHX+isOd36NfzRlNql9PKkoINTXuCHPjjpCLekMlHglb05mwN1sAJ/MVcDXfAHeLPQi1vIQuLgfAJ3V+SslqP9tvSoDm9CP9nvAbWJ22r63YEBasSK0TJN9Tr65qT70G1odqN7G55hxe471FqMtjM0pU+nsFUn8hsLPnDciApxbGQ1+5cKN3NCAhU9tx/PtMZFxj9zGOkY8Yx8jvHOeW4LjHgTj2hsmiEzDYCpCBdETXc5AeN0E6nYdep9PgBf2SpNdoVSDpet7HYMRLR5YLgBYBUQVAhV4bB6A/wBkQEdWUgPZLkpKavwTINs1EXjL4M0jvYpAuD0DosA9K+xVDWX4LQJpSRp5DIKG07JfW5+9kfX/qn1MFwLAKYCWYWtT/pyk9za5PhZihu7/fPJCA9RANvgC96MSqIKC+dYceHMdBIK6JIK4Twbj/CsZ7ukYB+MwH8VsJo1aF4AfNAjELrZoqXB1Ct0RTScSqNxz7Np8Y24gzHKfYAzTiTzx6TOX4DhnI9u43WtWECjwJ3xnCbbK9vh5t3Y06UIcbtqUBL2Z7faPYvABa109kXbpxnVqeEG/JKDUqoWPTAHKhTEObRolTzpeBnCkH5xZgdvE1xOPWrCT2lx1Ia4jY/yfb508rL+mMwVy9KpO/+iL4py0ACj2LztvFHtth5pULkdUSSKwXwsxqEcxVGgVgoVwCuXIZlJaroLJcB2tayKPcAnvFdjjJk+EuP4Qa8jzUUpxDQ/lDtFR8Rl/LMuyNAlZFZaT9eDUwEkHrIlN+W0hNOsNSNAS2plNgbzoPTqbL4Wa2EV7mKfCzOI7hfi9QW9r/0M+vJwR6lMhDwz2wi0vdACSC4yAa3cVR2He8j3RxdA358mZ+7FrdLMLupSNVADQA6EdW/sUKgH4PtEOvZxGfN/itnV6bjDq0JoDO92M8O65jHKMvchwi3nOcYsBxawfi2gO8jisgoAM8Bn4G6fMSTNcbIPFnQTqegUHoksfcGuOb6fd+6MEb8taB5R+kCoAGpOiORJuB2FJgWhAEMVGt8Oywct+2qOcA2VoOZvJXkAGfQXq8YvP/pN0N1gVgYrT+f3Xzfw8b+Wdqb2TLdjmB1PyvNP1psM9/ESv0rPD7UH9+LhjfuSABGyEZdhH8Nr8FAfWtOnTmOAwA4zqxUgH8AsZrKpgas8D4LgJTfz/4rfKgZxWf9eOX9xuksTtmGNPdX9nwJuMYm864dVxDCTuJ96ARJDCxE7fB/GhtPT8VeL3Ig0FsWW+rAn+9Vjm19Due9jUZUeFo0PuVs16bUzWJdc9+HPPQQpMxyyv4976CXAXIqS9gztBVBkIrM4+XgXsLEO86cYOI5vmS2ApTVgH8LPDanV97ZG9XVwD/OPStOrkbKId9N6+RC7H1RphaL2KXmeVimCkXa9wA5XIoLFfAynINbCw3wk65GQ5UASiS2RJeT1kmfOWFCFZcR5SiBF0tv2Ka83ckRz34Guvcr6pLk0Ih7tDBQtAO5oJ4KE36w1o0FnbiWXCULIOb2RZ4W6TC3yIfHZxeId5lw3tCDNWaV7LCz6G7OKUdqz5g1N9sjbO1oF2SWhC/0lEyYLibxcQuTmbD+/lI50e39YZNE5eXihC33MohIP8JoLvFiE9K/a5XfNgIfuDo3owXJZ6MTWccIx9yHKO+M25twHh2BuM7GsJdj8DQSbrdX7HmPxN3FiT2KPTCt0PPa9gYMqTUwWhIhaW2D4CNSGvZZ9h12YCMgogoNzt3XH1gUzRVAHTuAC0x7kfHc73UjPxqR3n56fBNyr9Pe/4pCUdl3j+kcvevTev2tSm/ZZrAHzX7qeD70iDePI0CoP68zxxwam2A+ehL4Lf+LQagb9O+E8e+Hziu40FoPQBVAJ5TwHjPZHd/XquzMAqcDT2TsCoSkeoQRC2QiSNXfmBsYz8xdlF5jGvH9Yx71zkc3yGDSfDUdqT+whhNTf+6xrSmn0e796Jp226hn37CuRoGg945a6r5XlvSgJ7RiAqlfpvjvsR50EBi3HAnP37yKeOc+2WcC99ATpaBOVEG5vhXMEfLwRQBJmuO3ubKRkSSjh8VPwi9ln+h6nvX3ke7Mik5izYO8M9Bz6zHYZHLRpi5HYDEiqYBF0OiXAhTy0WsApBRBaBcAZVyDdSWG2Cn3AR75TY4KfbARZ4KD9lB+EiPIkh2EY3lz9BG/hn9ZGU42BhYHLovqfq1QtSJhjKTDo+lggQojftAZTwUNsIpcBJTBbAVNczTUFN6BHUtbmBywAP4CTvP+u3Vu7h+pEifsvnSFaKmPj0h1oL4GZZGzS+qjdvusjHusM5e2HWmrajLAl/ZlgZtvUtZBeAlo6Slf7US4L8F+kPo9tCU/hCpP0qCxnYl3t2nMW5ttzOO0Zc4DpGlLEeAB3UD+kHwSwYMNwGk8yswnW+A6XgGpGU2ONEHYBD0Sw7pdMmethyzGYBh5wVsVFoT/NNw0FEFMP2thEiXenVdf3BzS+oCbCgDk1iumcrb9QVI3F1NBqAFHcpBi39o268m9cfSe1VG/tm8PzX92cDfUjA1F4H4LagU/DlgaszW7OQ1qE8/E4z/apiNugSjFr9WRY31bTrEc+z7gnEZA8Z1HBi3RDAek0FoWrBOEozC0qAnb/43e9glEauXGgaMA1E1Pkac2+1gXOMXE6/eiRy684euDmcFn/r+jTaH8mgHX9ThQP12533042548waX2vF7vFTQ2n3Wh6c5fErc2vuxM2m6syHHcUgPQnxmC39d+8TgTgXI8XKQ/FIweWXg5JaDOQGYrD1xWU8+uybrAmiFnxV2Vrg15j17W1vRVt0v/sfNfy0M5X1CDFVjIfXNhMhqNSSWCyBRzoeZ5SLWBZDROIByOZSKlbBWrIWtkloBW+Ao3wlnWTLcpAdQQ5aLWrIzqC+7g0hpCbpIy7DYDUiNvlXeRBZjU/16UmGXiVJBNyiMu8HKZBDUJhPhKFoKN8lW+JilIdDiCAIl5zHSrRS9XVfQlKJ252bY3V+da0gFOrE1DBzFM+sqBc2fWQqiz1gax5y0Mm6VqTaOTbUTd5sdbF3oF+p82zPM/o0VHQLyn6MA6A+h9WVjowEVKr2Op2pyw+Y359QcNJRx77iecW55hHGIfMpxjPzGcaXBwB7QazwToqR3IP3egkm4DdL+FJjmlBxjH/TrL/rKrTkzkuyt0IwDo1V/NA2ojQHQHyJ1B2gMQDHHr/O6/dta0oj3uuoKgI7o0tT/swFAOuSDLf2lCoB2/dGafFqaS4tzaNHPSrZ8lxbvaHx+KvzzwPGhwj8ThO7kdHnNAPFdCdMRF6EXlRio/fSsC8AqgJFgXMeAuP0CxmMKiPcCGITnwMB9/FfCr1HVPVgdwsC5DsL68yoYdfObjEubrcQtYQGnRv/RnMCx3bkh85uzXXzU7KcR/ya761OTnxX+7rfcqfDTrj02j0+j9vR7ord7f5AadHvqShyX1eXKo+cLZ297Jbj1BeR05a5/pBxMVhmYjDIwRwHh5nMX+Pz1cuJHff5E6l5pdvgqrj0Wv0O5/d9TABT60h455jV2Q+qWDrFiIUxV1A2gCmAxZGwcYCksqQJQroGNgloBm+Eg3wZn2R64yvajhjwb/rITCJZfRpjsGTrIvmC08htyw4CFdffMq34tqaCbTCro+EHOT4CVyQCoTcbCUbwIHpJt8DVLR22LY2ggvYN2yk9YFHIJdnpRlVwDu7h07gCl86K7f2IIDNUmPTJUglZQGkc8UwkinygEkQ8tBZH33M1+iY/2/OIc4fnWrrHXM2kgpUz7S6cAfwYV0N7PpKTfSye91unBnAaTOhCf7tMY1zZJjFP0ecYh4iPj3Aoc9wQQp/4QLSmCwbyvGp6+toVgYg6BhO8Bt8k26Nf8RdPlRU1/GgOgioCmp7RBwET6I60QEtkaj7g1+zdHPwPImi/gTKQK4COYrs/BdLzFFgAxdMwXjf7T6T6U5Zct+6XtvrTPn5b80lr/FWyxT3Xhp2Y/3f1JjRmaAh+tAvBbycYA9KJ/qwTUt+4Yx7XrwyoA4jIaxJ1aAFPZ2n+jsFToKWJ3V/+qqkPSdM1mnteQ70QduYsSeXA9ekzm+I/oy+b5m6xrwiqARptD9ZoeqKPf5rSvwYCnbgZD37uQ4aX2mvr9e2JW+LWFOz0hIr1gQySbPPj1+ieKdx99Y/iI+v/fwckvA4fyJmR/BXO4HOTAV+idBERLs08QMkpEQqBRsP8DkWuBskcjgc2vsKx5BBLL1TBVLYa5cjEslIsgUy6CXLGEVQBWitWwkW+AnYIqgK1wku+Gq2IfPOUZ8JMdRZDiDBrK76GV7AP6K8uxxgPY1uDiOwVx+mGqkpU4YZ1S0A0q4/6wEY6Fk3gevCU7UMssB/WlVxEmf4UZgcC8BvlfLfXDvehrQkiuHmvKK+g8P0IcRb+2sDPpDhW/JSz5EV9UgoiPlvwoKPktL3nJNjUMdX7o2cz1szrC84FEwwH4z7tHf17Q4BEtJhlaYaXf44IvmxL07TuW8ei4ho0F2Ec+ZhyjwXFpC8axC3itlkBIR4bHPQLT5oRGATTbDRK2DQZBU54ZNNjsTHaBcgDw2RgATU9R4ac9AT1X6pPEClOiWOzbfu2BTVFPoBk6MrYMpNcHkC5PNRWAdOIPnfbTjFJzZ1Rr+qFEH+s19f60xZem/ajfXxX0m1dp+lOznyqASvOfKgK/lRAPPg/9iGoxAHX7dlzbHmCcR4KhCsBtPIj7dPCaHADPa8w3fVFI1RCR6jAOnu1mEjwDRN0yg7h1nsnx6jOR4zt0EPX7uaFLI0izLQ1IU0rRvTNEr8WRmvpdH3oYDP3iRAa/tSPdX6toHb+IreMv4pMRr0zo3EZe27f2hCzwMuk9e5Hp6dtlencBQnf9/K/g5JSDOfwF5OAXkAzA6BhgsjjztmHzjcGkNTSUa/j3C78WHEnCKTOPHZA6H4S5pUb4pazwaxSAUrGiUgGsh518Exzkm+Ek3wFX2sQjOwAfWS4C5IWop7yGSMVrdFZ8wXjLb8hpXIGptbaMr34te1l3d6VJt28KQT/YCMfBUTgXNSR7EGh2GmHy55hTE9gYeu5bR7vRCb+9Cgy1AGifv58i19xJOOisg3FPqI3bwsq4JVSCmAprQSuoBJ02eSv21Am1fmvXyPmVMtjzgeSvXAL8NwCGNUGp797jtidpsiKC1BrZh/HoPI9xa6eJBdhHlnOoFeBGJ9oMgMnCS+AMewXSvBAkOgOk6S6QhqvBrb8QBv5jxrKnZYtR0nnsUeuXUmUz7IOUKKbWabt63/ZmdIdbRMuLy0B6vAXp/Aik/TUwLc+Cocw/4ZSX/5CG358l+qRlv+sru/1o8O+3wB9bvcfu/lTgaUHPVDalx6GL5vb9VkA84Bz0m/yQBWjLtekKxmk4GNfRILQs2H85+A13Q88ydkf1b6k6xPXm7jZw7/ue2LWZTaf0cPyG9efUnhRHQpdG8CiJB935Iw8GUQIP0vuVMxlZoTIa8Ekl6PZcRihHX/xjM1q/L6G7Pm3s8d8YQozbdhNNXZcqulnCpvnI0TIwOWUgmV/B0BmNaV9AMgGj7E8Qjd9wnGs5rCExqzD5n9r5q8PArF20kdWvUPkWwMxyDcxZF2ChRgHIF7MKQCVfBbVirUYJ0CYe2Xa4yJPhJkuDtywbNeXHEay4gDDFI7SRfcYg2Vds9wW2Nz71khCJqPr1FMKu6Zb8gbAxHgMn4Sy4CZMRJX+GRQHfMSPgwCVfw4i61Z/vRi4b0N2fVljbm4yd7CocBXvjrrA36QI743jYmXSEWtD2paN4fKfaVgX+obZ3nGj+n/r/f/YZgP890AASpe+iFXxt99cl9RI7cXx6j+e6x61gnFtmM/aRbziO0WDc2oI4dIFh1w0QrPoIEnMeJJrO39sBpv4yMMFzoec36rqgcYaULQBihb+SD4BaAK0vG7DNQMppQa1WJCc3pQpgQRkYWgbcvVhDAdb2KhjK/Ev9fzrZt5L1hyX8oC2/bNPP6t9Kfv0WVUX82d2f7vhe01kXgHjPYM1/trjHfwVMf1YAqvbtOOouYJyGgnEexaYCDRqmwNA7sULf4vd3f37IrBqC2r+C2MTuYdx7/EIj/pzaiZ0JpesOXcEG/vSaZwYZDHznSGiEv98nJUk4J2ZdIjY1ekfEBvwGfpDx+lY4EKsJUYwyerNo6e5XAmoRna8AyS8DoYG+DDqi/QvI/nJwcgHjpNsQ9V++jPATfUl0hcn/5K7/MzjiuCKpRxJk9imwUC6AheUCyBULIJcvhFKxHCo2ELgaavla2FYqAGf5HrjJ98FLfhh+snwEyYvQUH4LMdK36CktxxSrr8hvWoZJvst6Vr+WpaRXMyvjobDmD4ej8Sq0s36CRUGPMMZ7w0Kqj6s/l/rvdPencwdsBbMauQonfnQxGQUnk77scjTuBSdhH6gFnVNdzWbF1LW+4NvYqcS2kd0d0Z99AvC/ADBs6Wi/T0qWLqzx3BYkaHg/4tV1JuPaJplxjLrOOER+5Di1AOMSB8ZzEISLroPT8xFIZBaYJtvB1F8KEjgNnIBEGHiN1NBkszUAVekpViGwpcDyef4tlyXtbfpYqwDKQLoVg4m7C6b1JTDNT2maf1jzn1J9UzIO2vVHW3M10X9N1R+t+KOVfprUH2EDf7SQZ7rGEtAqAeoCUAUw8Dz0G/5oAXDU1AIYBuI8Epwa82FUZwMMVG02Vf92qkNYf/YBffdeT4lT/EQ6qYfN9deb24IbujiSFvyQNrmBBoNeOZMhry1J3xdyKvAsB8OAm0LarMOa/aMhMeh415mI+rXS94lLl+zO+86j8ZDj30COlILklIMcLgdDd/19X6GfB5isL3rDb/LLCGJUqCKJMNak8v73wBF3iTNWz4HKKw9mimWwsFwIGVUAikVQKJdBpVgOK/lqqGXrYCvdCDvZFjhKd8JVvheeNB1IswHykwiRX0Ez6UvES79guKwMKf7A5obHbtGkw29Xa821NRl+z02wAXHWDzHB6+zVBNuREdXfjxY0/UdNfzWBoYvx2OwawjlwEY2Ei2goXERD4CYaAQfj3u+t+D3GucsWR4baPvQM96xQBapo8O/PPgDkXwH9QQ15a2rQ84mLXvPkEE79yR05/v3GsLEA5+YFHIeo+4x9RDkda0Vs4mEYvx78mSXsgAym0RYwdReCCZwExj8RXM9+N4Wxh0xZxUKFXzsdaEA6T0QLgczn+TZfsjutCd3x5n8BM6wMpMsbkA63wdACINoARPP/tO9fa/4HU6JOav6v1dT90zZfVgHQFl6qAGjqj/r900Eoyw9d3tM0wcAas8CpuQKSgWdB6k2qagbiWneMpRYAx2kIiMtI6NdaA32HfqU8kf9/4ayjENedXE8QOAHEpt1SEjgxgRM4uSMVfoNGy5sZRqXWoew9ZNBrVzKw2Jrt149/bGba8aaQmvvaRQaViEmXUjvC6xsqaDfmmLjoPvTuUHLULyw/IhV8cqhy508HDHMByaLMMwa+o1oQ6woF6Qs6gOTv/Ugro/z0WFXu+/ee/9+DwwCenlnfmwrPNMjtkiFTLoBMsRhyBbUAFsOSVQCroJathY3FBthZbIKDdAdcZSmVCiAbAbITqCu/gDDZQ8Saf0BfizLMtf6GI00+oY/j3B/Ke70t5vwaoTyG9jbJNFPwOyPYNOW+VAHQv+yMEgf6iRbDUzgT7uJf4SGeCHfRONQQT4LaML7QVjK0u59sd/0Qu2cejZw/Kf/S3X//IBjaQcbv8VFhMOi9K2m5px6nXmInpkaPyYxb252MY/MiYhfxkh1r5dgOjFsfCKdfAafjOZCQTWDqzANTcyKI91BwPPtCz703O231t9FgldTgNAtgPscvennS/sbUAphLmYDLQDq/AGl3q6oAiNDe/1BKwU2j/zs0XX+V/f6U4ott8aV1/qwCmAvGh/r+mt2fVQCe00A8aUqPKoOZ4PgvgylVACFTqkx7VgFYdwZx6A+Oxy/g+S6EvrLF4upfSnWYBE3I0HftcZr4De/EqTO1Azd4diz1+7kR2+vTKkgyutSBjPtsxe/7UU4oOUfHm0K2Uaf1ZWMLeox7JiDDIee6zmgqnrQ2S3jnPZjrVPjLNeSoh8vAUOHfXw4mE+AfKoZw9MZ0Yj6uHmlcISUDKn7HRK380bq9MCZ2d0QkoEJIPN9KiB1ExOWdGfF4LiMuj82Ic4UJcagQEu8SMfErFhGH10IiqxAQVQVNe/23Kt/0JfE9TGznQeWZD6l8GeTKxexSspmAZbCSr4S1bA1spT8qAA9ZOmrIsuAvO4ra8jNoKLuFaItX6GpWitEWZUgLANbVzTtR/Vq0MMhT3OOHasEfoUn9DQiv4MmNfq1ZS7zodaB4M3zFi+ErXgAf8RwESBbBzWT4d7lB860u5lPb1bQ66R/uUGpPm4QI+auw//4roMLa97IxJQyh1YHsKPHaY7sznl3ncFzb7Gbn19lEvmPsW4DYtgWv1TIIJj6obMyhtfPjQTwHg7j1AMex3S0SutGsqvLsBwWw3anF+vRtoTQGMIsyAZeCdHoKpu11lv+PiTwOQmfzNaQTe2jpLyXnpLs/bfmlTD205n9xZZ0/jf7PqRJ+uvMTrykgnlNB3Cdr0nqeM8DxWwqLoedAqrsAqg4dODbdQOz7Q897BvTsen4kyrpWP34pGhgH/1rHyGfIN2LfaRKhqb5GdEjH6nBusy0N9NoV+JOh75yo8JPhL+RsJyQVfmrua2i4NavPWwmJvW9r3HJOT+HFlyAXNcLPyS0Dk/mVZUciaeXgUpN/+9Wvxp1mzieCuZ5sqS/93/xXsMLPqzXfhp+wM0LQclFbfoeNkfz2W5uxq9P2pvwOWyKNWm2M4cftDOe32xnOb7+jmUnLTVGiTnsbiDvur2sSt7eWsNP+AFH8bh+e96AfCnH+CGp1gqG+Rf/7ll4Z7IAQmgZUsF2BGgVgrVhZFQOwl26Go2wXXGR74SY7AC8ZjQPkIVBehPqya2gqfYoOZp8xxKIcS+2/40jTN+hsNepvMC/9DHDp1OHWbjAgZgUm3qIpRxqapiBAvAYBklWoJVmJQPFa1DVdBWte2yIr4x5jXEzntghUXPCNtIM1TRn+Z6X+/haokLJkEu8tKP2UXvTeeqTB7JYcv/6jiXvnRYxT7AFiG/WAsY38ynGMBXHuAZPBx8BtlQ0SMBfEdwIYD9pd1wV0+g3XrfNMzXkr6wBoSnBUsYjIMmxbbs1aW+8+2IlADO0DiH8Mps1VkJgzYJodBdP4MMv3z1J+0cq/qqafFWBouy8r+DTwR01/mu/X7vxU+KngTwZhF/17BsvyIx1xHnp1xv5WCKRq154qAI7rWOh7TgJXEVOtnPRHGPuOzOU6djlFAkZ14tab3ZK289JcPzuXr/sDd0q0SiP9xgOeWrCmPpvfv2dY1aZLOyJpGXSDbG+TjssSeMeefCXHKkCyy0FoYU86NfkrwDsCmCw78tAwZORwIj6mVs2lO/TfhnjYigj5iZtPjU8//yjIe/BZkPfok0neo4/GuY8+Gmc9+ig4+OijIO3hJ37qg0/8lEcf+bsffeRve/jRaNPDd0ZrHr4zWvHgHW/JvfeGCx9/Mv71QrFp86VhP1/j70HPrMdIicNK2HjkQaZYASVVAApaDKRxAWxka2EvpzGAzWwMwEWaAndpWmVfwFEEyk+jvvwKmsgeoLXFB/SjwUBVOQobA6vqHTz28/V+H7u42vp9F+MJE0PMt8BftA61JOsQKNmA2uKtaGJ6AB7Gwz7JDFvOo7t/DemmxqG2L50a2z2TalJ/OmhAfXa6e/X5bKXX4nAgt/HSKFJnbFfi0XUm49x+G+PQvIixiyzm2MeAOLSHXr1JMB5wCqQWTceNB+NBm2sSwDi0Ase++RNe40W27HlpeSUNNA6gpmeGbcTmzHVBtNttcjkY2gcQ/wgk9gpI9GmQpvkgjTLA1E9mS38JbfxhGX9oz/+yqtw/w1b8UeGngb6pmp2f3f21wl+pANyngfFfBHNqAdSa8Nt0YHXblox1J3DdfgHXpssHgbShrPpXoYWw5uhwQ49+JcRjYG9u+PJmBiGLI3lU+Glbb5Pd9UnXqx60p4IKP/X5LdgCqMoyaLbrMp3HrkTwSe2UGoZh4yYa5jz6TnK+scLP+vs0v5/3FaJpqfmGjuPqEY8PMhJX8QfDNNN5kunbUoxpALEQIPkAyaVU62DPR2MIhBK57AHIDtp3AZCNtPgKICsAsgwgi2kgFiAzAcNFgKjVskU/X+XvQWTdQcKTDnlp430ESnUS2xFoqVwBS8WKalmADbCXb6m0AFI0FoA8C37yAgQqTqOe4hIay++gpbQEPaRlGG9Vjm3eFciLeIY2isH/yCQhFvaCqQ3qWKwuCxJvRYBkPYIlOxAs2YUmkmw0MtsIqV7Ta1aC7r+6mM5uGajKCwh3qFAFONwU/lYqrYMG9Ec7qERskPDKhdt0Z0NSf1pbOp+ecYlbzji3OsjYR95j7CNK6bBLYt8egjZboB+TDOJFC2n6gHHqAMYuuoJjF/VMz7vnYPacfkX6arYs+LWQWCTb119zYLP/TYAkloPp8wlMR6oALoNEndT4/3TUd306kYcG/+igDo3vr839a1J/tNafCj81+6mvT/v5Ky0A2tRDFQAl+3CbwhJ8mA04DRIwqaq0l2sdH8mxTgDXsT/0rVtMq/4VVIeRV+8Mrluftdx686K4DZdGcZuua6zXKq025efXb33Gj3R+5EhGP5CYDrgppNTbrNmvTYFWEXFcNiALK3jE/6CzUaNhc41ynoFkfAfZX6pJ8e1/DuGIdRuJ8SRXNsVHraY/xE2eaOaODYaXK0AOfwNzoBzM3i9gkstBdpeDbC8D2VLO9lvQMe/MqspR74soE3M5yPyvmpmPM+nUp3LwZn6FKGLhip+v8kfQl3T+1dR+NWxd8yCXrYClcqUmDShfA7V8HdTyjbCXb4WjbA9cZKlwlx+EtyIb/opjCFScQrDiIkIVtxEjf43OslKMVJVjvkM5TjcFFtZM3v7z9X4fuwx8TWedDTTfDB/REgSZbUKIWRoai/PRxuIoHI3ii6UGzdc5GI/r5mK+LLKR+qlrqMs7s0A6/vvfEST9U4NW7FETluawO133oryBlNiC49E7kaGz6x2bn2BsI18wtlFfGHvKHNQLxh0zwQTMAaFjsB3aUT78csY+6jrXo/NKk+YbnQjAYefS0RSWKM2u9voD22rQgpcJ5WB6fQDT4QGY2EuaCsAmWWAa7a9s/qlM/7G5/2Vs00+V369N+9G8P/X56c7vOQnEYxKY6laA+1RwfBfBtO+pb6TWfFftx9RXxbXjqruBq2xx18w5+nciy4SY+AyIMnDt/pDUGJlAvwde5OZQvWZ76tHvhQwrtSUDP1sTWuBDzX62pr+SkJOtf8BvrblUCSTAkIQ9tuJHJo43zn7BFvboHQGMN5z5yo9JXELIckeyEvx/JsVntmjHAiMaS9hHCVYrQHZ9A9leAbKlAmTDd5C1FSCrvoEs/w6ypAJk4TeQed9B5lCqd+qCVYBMrgD5BTCcBUhiFi35+Rp/BCPLFioDi1Gf7b2OQqXaCRXtCFSshrV8LdTyDbCVb4a9bAec2UKg/fCQH2IVQE3lMQQpTyNYeRENlTcRIX+O9tJPGKAowxSbMqQGAYeb3S5vKBpcFbf5W3AVj5vnI54JD9EvqCGeyyqAhmaHESe7hbqmU8rEeo1T7Pj9RzsKp7bzNttdv4lzqQ3N/WvSfzr8V/hRJUDn+72114vYX5cEz2/O8R3ej7h1m8U4t93FDrqwiXzJ2ER+IzYx4AVPhWHEDhCXPmDs24FQBeAQfZXxiF9p0GRhjGx2BRUOffYHTlKs/LYc2u5OFcC4cjA9SkDa3QGh03+jCjRjv2jvP5v+q2z+CaKMP3T3XwDiS6P+tOjnt7QfG/H3mKwh9aDLgyoCqgDocQo4/ktg3q/oOwmY7ab9iPpWcZ1pFoCjjB3244f/DXyvPicY196rSMN5UQb1l0ZQHsXKiL8dm+6jRT00wq+t6afCr6Xj0rbdUgVA/6ZxgMYVAlHX9a2MjpaAVwQI52bcMwwc1YmoT9iQERUm/2wwSpK4ZpK44B0MU0pgmFwMw6QSGO56C8PtJTDcXAzDjcUwXF8Cw7UlMFxVAsOVxTBcXgLDJcXgLSgGb24JDOe8heGcTzCZ/hSmUYs6/3yNfwRcSZ/FMsftcHTNg6WCVgGuh1qxATaKTbClu79iD5zldKrPAbYfQKMAjiPI8iyClZfRQHET4bKnaC39iJ7yUky0KcNy93JcbQ1M8tu86+frVYejcGQ7F9EwOJkMg5twHLxFs1nfv7n5SbRRHICFftO7CsP4efYmv8R7Sjc2amB5w7uR1Sell9d5QQihMxJ1+H3QQh7artrnrZ1ezKHaLINwzZF9uK6d5zPObXcydjEXGJuIN8SWTr2NhSBsJbg1E0HsWoGoI8sIjRd4xC/jNJrXxnBUsbXDgJs82bBnAkJOmvnsztnodAMgY8rBdHsN0vYGWwFIIvLAhB2srP7TcP6zjT+s+b8EjB9VAHNAqPnPRv6r+/6TflMAlYt2+FG6L47fQkgHnQPx/o0SzMC6Q6SeKvYR8ewj+fGDayD0G9Te0KPXdVJvQWNuBO3o0wg/b0ipA+3hZ0t7aXEP3flZn/8ebeqpxrtHUZmLZ1t1aaAKHNPEvW6mqecrTH7ZeYnIu8eSEBiSldCkS/85MCRwg6W49+oOkkEbe4i6rhwu7LJ6tDBh+ThhwrLRxvErR5t0Wjlc1HnVUFGXtcNEXVaPFHVdN1TcY8MgYZf1/URd1ncTd9uYIEnY0NOs9854YezCcFrj8/NF/hEYyjuo+RZDSh0986BWJcHWkjICbYatgrIC7YSTIgkuin1wk6ez/r+vMhcBygLUVp5BXcUV1FfcRpjiGVrKPqC78gvG2JRjrksZjoQDaS0vvJOTlpWEHz/Cmj9YYSWIfag2oSW+veAqHAMv0WzUFSWhjSIXtvy4N6b6Eftt+INGOJstjKK+f5h9qUOg6qEpbRr6T8/9/31UsgaxxJM0HtBsRwPSkLYMj+5N3LvOYZxi0xi7qOvEJuI1Y93sG9cpAUYNloA4dwGxifhGHGKOM15dZ3LDl0bRHdNsxCsTtuSYPDbzSDm6yu4aQEZTBfAKpM0VkJiTIE1zKv1/TQCQHe8dSEd8aev+K/v9q/z/3xQA40Wj/xolQNx+BeM6ScP15/Ir9PwXwGLgxe/E9bdCID+/nvoyr97SHz+0FmB4bl2OcbxHjiQdjvoZtcqpResjeMMqbA0HFlvTQRys2a9N87HCz47d/ts/KMrGQ58z4CbPsPm4YGI9243EV2hSpf8y6DleCzXrsjEhT/iE0O+a1g6wy0hzn4Yx59/R8mpk2m2llcs2uLkeh41iO+yU22Gv2AFHRRI7089Vkc4O8/CW58BXcRQBiuNsV2Cw/Arqy++iifw5Wireo4vlFwy3LcMMt6/YFPgNN7pV4Bff9RN+vl5ICPScxCPiVfwWx5T8yI82xvFwEg6Bl8kcxEhz4Cca+VGo32SPlfGAUc7CSR18ZdsaBtve8QpRf5RrOgX/aYX7n4hEDru79ahQkNaXa+hFJodwmyyN4NQc2Ycy39LUIGMbfY6xiXxCrJqUGXgNhoH/L9QCAHGMOc7x7jOORG9txI4lTywRs2Sh/Htyj33Hlqkp3dUoqgBealiAo2kBUDYIJf+k1F+0+o+l/Ka7/2K26KfK/KeFPzUqLQBq/muVAKsAfqna+Rm3yawC0K+9HKZ9Tn8m5oMVP3/C34PAtVOcvmO3HBK2u7ZeREpd2tJLBlOz/7mM0KGbWuGvMvsrux7/KKBEn0Pdq6q/KUXX31EafyKYKLs6i5UTvnvWOA07RRrslXvgQIVfuRcuiv1wVRyEhyIL3vI8+MiPIUBxGoHy86gjv4b6ivsIV7xiFUAn1RcMsC/Dr+7lWOpXjrMdgD0xRx/Tf0v167X2gyjAfH2Eo0nPXy2Noq5ZGcfCzrgngiTLEWQ2A6b6TbKsjPuOdhTOaOdmsTq8juUN78ZOpbaayL9O+P9xUNOUbWb5pCSUsIIqAdYSGDqAeHeZrUkPtsxibCMeEKum3wxqjADXtSsY22bXiGe3Gdzw1c0MRnxxZjsBWQvgrcRz/7HlNpcBMqIMDGUCoiSgUcc1DUCh+zRTf6qq/1ZoGH6pAqAEn2z6bwZIjekg3r+l/Rha+FNp9rPsPvRI6b6dpkAQmwXT3nl0pt/vFdT8CIdwnqFzQibHb0ondgR386wA2tJLBrxW0T5+TVWf1uzPNayK+LPC/LsK4Pfu+0tCaDEsxcE1A24ORbCTJ8FRmQoXZRrclOlwU2TAXZ4DL8VR+MpPIUB+DoHyywiW30RD5SM0Vb5BS8sPiLcuQx+HMoxxK8M8vzKkNP6Ka70+YaDj4h+ahCjFd2PVVQ8v0bhuVkbN8ywF0XA26Qc/0/GlcqNWaQqTzlMczCZ39LJY1aSmMjOogetntbe6REynA1U/jw7/COjORX/0PT4qaPqL+sTckFmtaUyA9sMzHp2WMI4tsxmbiHsc66jP+u49wdjGFDMu7dZzG85qze9+uQadSMRaACbvzNxTC1aoafR6yBcwnZ9pSoBpByAd/EkHf9CJv2z+n474XglSixb/LKy0ADTmvyYAOPW3aL+bxuRnqPlPLQC3iRq+f/d5EI54DF6bPbN//li/B75LXE8D197bSPxTV9K80E+/0zN30v2lk4AO4tAM3NAE/bQ03JrRW5WkHFX19/+RMJP38zdVzkYNjwtwUubAVXUAbpYZcFNmwV2RCw9FPmooT8BfcRYB8osIkl9HPcVdNFI+RzNlCVqqPiLOpgy9HMswwr0M032/YH3wF9zpB2yIPHSdkODKeI2G2aiDJySBFqvDVfw2O635LeAq6vXdwWTgZDvJ+HZOZpPivBVrwoKUV3wa2LxzpjP/NIy//7n/n38N1HSllkCfN1b6PW57UneADrvgBE+K06Mjr5zab2McY/cRm8hzHHXMa65DaxDHlkc4foOG6sXl1OKPrVDQqUSEPDR13HNktdUFgAwuBxP/hK0AJE3zNIM/2e4/OpZ7Awil/gqkFsBvAUBWAbCtvtUVQKW/zyqASZVK4FcQh0QYhO2FuO816Cl6/WFRicwrTmDomnCIW39rE0Kn73QrdeBR7n06gpt+drrbs1yH9zR8B9pc/3+44FeHsenoHA/PAtR0uwpXRQbcVFlwt8yHl+UxeCsL4ac8jZrKCwiUX0Ww8g7qWz5GmPI1Iizfo5X1Z8TZlaGncxmGeXzBFL8vWB1SjoL4ClwfSl2E2d00V6HfdWtuY1mFIMrqgbudcaclKqPm5XaCgVN8ZXtr1bE8HBhgeTgw2PqMX6jtF6dats9llCfgP8ka+3dA293HJ4MrFPrd7nix5cINF0Zx6kxM4Hr3mES58RiH1nsZm+iTHNvopxz7mJsc797juTQOMPqtnQkdG04em9nvzl1jeRYg/crAdHgEEnWaLQBiQg9o6v+p/08DgHUqXYDK2n/C5v9/J/1XpQA0hT8098+4TgXjNgeiwQ9gEr4j+x/55xu5depl4DloEZlSoeAlPLOhXX3syG12BFc1k58Kv7bIh1Jy6YS/CiLZkAbWNptQL/Au3FUn4GWVD2+rk/C1OgM/q/MIsLyIIMsrCFbeQn3Lh2ikeommlu8QbfUZrW2+oJNjGXq6fsEw7y+YVKscKxqWIzWmHK9+BVZHpJ3WzhOk/fvRZq9MWtp9cXSWDBumNh7Wu6Vrhbqh0x2vELuHHmHq9y5N1KU2dOfXdPv98f9fh38EbFFLiZj6xJTimhu6PpxWyNHZdzTox7h2nk+c2m1n7Frkc+xaHmE8e/7KjdrZkDf8rb0w8a0pIW9NbZPzV8pPA6TnFzDtHoBEFoKEZbP9/4QtANoKhvL/1aYpQEr9Vdn3r/X/afWfNgBIJ/qwJb9055+iCfxRJeAyF/zOFyFsn/1dX9HxD4tJRN4JYkOXTvv0w9L8yJgKi6qOvsrhm1WpPprPpwqA5var5u3pFEB1yBVTc2v5n0c9rwfwURXBT30ONdUXUcvqCmpb3UBd6zsIsX6EUKuXaGpdgijrT2hlU4p29mVIcClDH68yjPAvw+Q65VgWWobd0WW4OrQC5wbfr2gimMwOaaE1/FWz/uxvOSR4Qxzu8EkV41xq08S5xCba+ZPSr6rY5x8vrtLhD1HJ8Nu6SEQr4Sj7jV78SX9u002NuUHTW3NqjOxD3HpOYZzpkIy45RyfAaO4zVaHGwx67GwyjVoAbyVWyfkrZacA0v0LmNb3QCJOsA1ATAPK/ksHf1IXgHL/awuAFrIDPjTCX7n7Vy3a8TcVjPs0ducnzjT1NxP8+DMQ978Hvt8vo37+BL8HI8d2Awzchk4gAJd2RbJNPdXn7WnN/eqC/zMNtw4sLCyHeNtabfraLPAJ6tg9RID1NQSpryNYfQshNvfQQP0UjdSv0VT9HlE2n9HSthTtHL4g3rUM3TzLMdCvHGNql2NK/XIsDvuCHS3KcKRzOd5PAVY12LeZXoMqAJbGy+6OqKPpa2GY20PTEKfr5rS9ly76GBX+/0yar387aHrwoRFbKESj++MqbEn8eR+WC7/e4mjil9iJeA4aQbx6TmHpsutPa6vf9ZSP0ZQKS0IgUqedWGJRBJBelQqgGW0BztSM/q63i3UBKPuPJgW4RJMC9JlTyfBDXQAaA6imBDyng/GYAeIyCRyvxTDpeA6SfncgbLCE/bH8EQR2cVKeS9wm0q5Ayfbtaxl7tRV+2nl7/1XwdfgbsFRM+jXI6zLahXxAA4dnCLZ8hoY2L9BI/QZh6rdoZvMRze3L0NqxHO2cy5DgUY7uPuXoE1CO4cHlmNCwHFPDyrEkogzbWpUho0MZHo0F8nudK3Mkg9imLuoGsPTfbpeNWVJP73viSm5/vobfX2eZ/RtBqcTSeYQ2wNDCmLGfLGmNPOXE4zXaHMoJ+CWesuXq+Q4YThWAXscjNclYVgFI1GnHl0jP0xjAFzBttAqA1gBoXAC2BDiItgCvrCoAYsd81ZgLxpsqgllgKN03Jf7woDv/LJAaS2DQYDdEnS5DHHcS4vAFq39+x38Lhvat2xh4DZ1AimgtfrVuPq3wVx+7pRP+fxSMp8OGHeH+z9A++COiPT4hwqkUzexKEWX/BS2p4LuUo5NnObr5lKOX/xcMqP0FIxuWY0KTckyJ+II5MV+xonkZtrcuQ2bnclzoV47Pi4BhtZYfImSsorXbZYNIRRGf8vnT3Z66BK3ddhnQeYA64f8fAeUQuGdIOhYKWSUw4JOKdhHqx1/x4dZdE0bqzG3BoXTZDec312u5p55h4mdrYnpBpUrJ3cAqgG6fQFo+BQk7D9KwAKReBkidFJDArSD+a0B8loB4zwPxmgPiNRvEaxaI5yz2b4Yun4XgBm6EQf00CKLyYNI6D6LobR/Mms3t+/M7/XvgOcT24dZb0IxsqtD4+zTdR1dIruEPU3c0pr526fDHYILcNkwJdTn+vaXPS3Sr9x69G39Av7DPGNysFMMjSzE6uhQTY79gascyzO5cjkW9yrFm4FdsGvwV2wZ9Q8qAcmQO+YqTE77h+sxvKE8BMgdfgIfhkJDEEOhRDsCefkX6VAHQpZkHqMvK/M9BW+ceWcRnS2R7fbJk6a7b3PAmLXIDuY03hNGlF72nHkksdSAWl+Wy5CNbxDcA/amlMBj3GfpDSqDf9zn0uj+AfsIt6He8DL3Wp6HX8jj0mx+FfnQe9COPQL9ZFgyaZYHXLAf8iDwIoo5D0OokxK0OQdJyw1PT2IWzlE37Of38Fv8IfO++NXh1FzUkAMMO6RhSQV0AzUgzHf5lBHsO9GvgvGNJU+/c+839ij5HeBUiwuskYrzOoJXHObT1vIh4n5vo5nsXffxvY3jgPYyr/QCJQfcxo+5DLKj/CCubPMbW2KdI7fgUeV0fYHq9zS2okLPz/0KgF+lXxNcQg/z3Jx/p8C8BGmugwwOJSfw7M1o0ZDgQ1vrtLnrptTrpTzpe8DUY8c6RNr9IZ23sINl645vJvAcwmX0Xwul3IJx0F8IJtyEcfRPCEdchHHYFwsFXIex/CcI+ZyHqWwRhn8JyQc+TH4y75L0z75j8St5hy0lxp5XL5Z2mdPKcPvp3m3r+URjXHlGX12RzfdLmqDcJT3cjUXm2JOaQFa9Jig2hA0+CNzrx6q6y5YUscTAImupiEJToYlBrpiPPZ5oD8Z1lz6u90F77t0HNaU4GPuNdBTXHuwt8R3rq+4/x0Pcd76nvOdJT332Ut773SHf2tucQTwO3YW76TgO99F0G++q7DPRjj/b9fPUd+9Zgl30/Xz3bPjWNHPvW0nPsFaBHj3ZdgvXsutXRs+5TW8+mZz09u57BmmOvOnpWvesa2vQI4al7NOCqe9XnqvuwRz1Vz3pc694NedYDQ3nW/RvxVIOacFUDwunRQD2sqYHt6EgD65ERfOXoSL7l6GZ8+cimdAnlo8NF0tGN6DKTjgg1lY5pLDYfEWIiGR4kFI4MkEgSa5uajg0Ui0d5GxsPdTE2GOQq4vWycXBYyMNPO7EqkBjF19lnXdsu0d/bengdb/Ww+jVtxjbxUSZG+ymmNq9rNSumvuWCVg2UM6PDLBe3ama9Ii7KdlW3FjYre7WwXtG9hWpFl1irpW3b2M9p3trtqHW08zUTqgCoK0BTfZrdX4f/PWitAaoI6PQbmkMf+EFGehZbszz5tIU28QVltuWYtRvrrxiQGCbtOyZU2pOuCZpj1zGhlt1HNbTsMaIBPap6jAmx6jku2H7CHD+vjclOtc+8UnplHJOqB4X8xAn/E2g0PxGGLAfBIIhFoyH5I4otwwaz1fw6c735gVN8BSELPOhto6BpNQ1rjQs2DJhQ1zhgQl1BwLCGfK/ekUZefaIMPPs35XsNasLzHN6ILr7HwGZ8jyHNDNx6Rxu59WwtcO/ZVuDWtaOhW/eOhq7d4gzde3Xiu3RLELh0b2/o1iOB59yzC9+1dzzfvmsPI4fOfY0cO/Vnl338ACP7hAFG9p37G9h0GWhg22UY3y5hNF2Gtp3HGtl2mmSkjv/F0DphIs+60xQj6/gZRlZxs4zUcbP4qvh5fKtOCwXWXZYaWnVaaWTVaaXAussKI6suqwWqrhsEVt02GVv12GJs1X27QNVtt4mqx26Rde+9Iqu+aUJVn3SxZd8MsbLvYbGiX7apckiBhXLECQvFqBNSxbiTCsW4k3LZ2LNy6ZizMosRRXKzoRflpkPuyCUDb8gl/QsV4r7pcmH3LEth19WOkl/a+6pOe/rZFYu0bL3/PUDPgW1o0jYxsf0THFoERM1/Ov9PYwX8Ngpch/9VVNGB86vy6DSlRptoWI6Bm0KSyHam/f/9Z9FAXcRFCRV20vySPbfO6vrcoMVNuHVXNeH4z2zL8R7Vj+M5fDDXc1xrXvCen6i//z+/l78YqAA6mFYI3YQVps6iUhsXyXkPR9HKRraCMXHW/D7D1cYD+9oKx3V0Fo3s4iToOs1V2He8l2xplJfLHScXl3dmtAFHoSjiq9X3DCmBZyA5bkQ78ighJxu1t7sjosdIvyf8ELcXxjSaT6f1hNbUrPAaTy0i/Z6Ya4+N/O6IaOCPpQL3K9Knpj8dBvLz+9bhfw2VSoDSi2kpsagioBV1dDoOHSFOj4n3NKPD/jWfTdNvv7CCZ+A3L4br3H0p49BxE6OOOs1Yx5xg1M2PcayjLzDWUdeIVdRVYhV9iVG3OsLYtl/FdR3ciCRW0mIDGvKO/2j89n+o7Vxh4mp+xNHJbFVDV+nmUDvzZU0dxAuj7EwmJlgb956gFrTbpOK3ylQJYs5YG7fItRLEnLQ2al6i4keVqE37jPPxeerq6/vW3t3/jZWP8yuli8tLhY9rsdrVtVjt7f3a0sf1qdrbu8TG0/+tXW33F/b+ns/ZY70ajxwj/N/ahfm8dQilR/83Vuzf/m+smtV8IacKIbo2VRaaVB+b7qvqw9Dh/xAqBUpbOENTatoRWQOeWmiVADs5hz7GKgxw2UDcPwaNf0lf1/WVCYkvttaLyArQd0pYYeAYV6Hn3AeMuh2IbWtw7DqA2MaB2LQHY9MajDoWxKYNGNt24DgkHOe49BmjH7TJo+rMbPCPtQr+0ffyJ8UuriqwwkjmVSEIyYWewgnmcvM19WTCAQPMBPFrLIzapEmNYvdLBS0zpPyYkzKj6HNyo6ibCqPI55b8qHIrk5ZQG7eCrXEb2BvHwdq43SNLUa/JjrYbG7k6ptT18rrt4e/5zrmG21M3T8/bnh4ed7zcvG/U8PS97env9czD0/ehJ10+Pne82OVxx6um940aIUHvXRrU/uIcHPzFqU6dz9Z165bY1qlTbO3n98Q8JOSyMbUWQkLuGVbm+nXW2/9NaANAiZRYRKMANDX0mlw7Zc/teUfEMulqO+yqeusrC29Yn067WEtBI5gs5Vbl/EFqSXQtVpOI4wGk8baG3MB5UXr28clGNUZ/N6xLewhma9iBvShXIGUuHg3GfSQYt2EgbkPBuI0A4zYEHMdez7mOvZdy3UfVJ13p7D3os0SedALvnzO1pPnu2foF6NFIuUz2TEAF3s8PfJeaFWZqN8gV6nsuUumKUHPRkMEWxvH7pIKWb6WC5rDgN4eMHwM5v3mFQtACloI2sDJuD8q+Y2vSCXYmCXAR9UMN01FwFvb6qDJOSLeQdJ1iKR/fSa2Y39zObltDB4fDge41Lnk7ul2u4ep13sfRW3P08Lnu5UsVgs91L6oM6NHL/7wPVRJBQa9caoWU2vgHl9oFhLxW1ar1XFaz5mMzP787ImfnayZeXhkCleq4kSbir6vy+5OAjgevFFqWJz+dR49U8KkCoOOy2dLb6vRaVX32lUurGLQkHDS+QCsRexZb63e47akXvi+YGzi3BfEd2504dppLLJvc4Ln1+GoSsxVGHY+BaZQFErgLTNBGdsQ4O2GIkoyy3YWUVyARjPs4cJwGVnCdBxZwnQbO5npMaSFoUSElOyuMCKDHTudxqGz/1QScfq4LqKYg/i3K4iclVKkYtZaW22UDWeMKgcQPIlVghSldrJC7fbZWuMHazg/WMtdz7ibyGU2NJYN7SkR9JktNumcoRd2fqkQ9YSXqA7WIjuLuzy47k35wEA6Eg3gwHOl8PckIuJmNgZdZIgLMZ6Om+WTYi3s9kgnbr5Ka9hgns+g3RqEY3dPScnZLtXp5M7V6e30Xl9O+dh4F/rY+173U3pdr2Nd85u5Y67Wra80H7nT3p0fHWk9dXWo+dnKvXWrvVbfC1i3khdy3yUtFjeCnFt7e98SUv49W91G/381tl8FvuX4d/iSoNNU1wUGNS1A1PlyjBFirQNt4Q4tw2MfvGbIugnZpLQeaYaCjtukos+4vnfRaFfhzm2yvz609qxXxHdODce02g9i1OkwUjW9zrCLKjMMnQTzwBHi9noLE3AYJPQ0SegRMg3QwwbvBBG1ih44Q/8UgvrTvYB64NWaA6zb6q77LmFyu47C5HJfx7UhwphNbI1AEfTKsQsAqBFoSTbkAtUKo+WFWzuj7+UfKWkR6rNDSuEVI5e0q64Y9VnIKVi72u7rJI4EVRma1K0yEgRWmxn4wN6n5zowe+TUhN6tdoaTLwvetvcTltofI5YyfxDq1jqlyYyOJfHkzgXRce755v+7Gkq6jRMKO+6WirrctxUM/25omwtFsBpzMZ8LJfDqcTafDxXQWXE1nw910DrxM58DbfC58LObDz2IhgmSr0Ui5Gw3lG+AuGfnJwqT5NZEoeq+FRec5UvPu06TSIYPllomdFFYLYxQ2q5pYuabUtXHNqWXlU+BvW+u6l6XPdS+7oIceqqCHHuqg9y529b44UqFXh5TaODUutbVr9NnaIeS1yrbhc5lX0DMp3fXd3C4ba0p7wQb7dML/p4VWMGixTTW+fBoIpOZ/3HmBomcRX0GFPy5DUDVVp9Jl0A7aZKfs0vRip9eWlJyT1/etAyUpMYxIqcutt6wpp/a0tnpeA4exzUgOrQ4R68jHRNboK8chFoJWiyGefAv8RDqOrBik6U2QsLMgYXQaURaYBofA1EsBJ3gnmNpbwNTaACZgLbj+y6HnPQ1ct3FX9ZyGb9FzHj6c6zYpmtTa7kq6VFiQBMjJzAoTyuwrSoBYFAEJiYGYtIaIhFWYVv0dWmFGmleYkRCI6WKFOQTm9GhSs8LMOLjCQtC4Qsqv+VHO961Q0L9NPT+pRAEltiZej53Enhc8qXAbOmfXNnbKqGNsk1ZPYLutsUi1oIVAMa09XzauG9+sz3AjUcIvBsYxaw0EzQ7xjVsUio3j78qFQ0psJVPgar4aHtJt8LTYCS+LHfCy2A5v6Q74SHfBV7oL/hZJqGmRjFoWKQiSp6KuIg2hlpmIVB9FpCodAebTITdu/cnEpPFFsWnLg+bShMVmsp6/WsgGjDK3HNNDoZ7fXOm0OVThlFrHyqPAnwq/uublGup6T12Vtd8529V66egY/NaOCr1Ng89q55BSG+far5R013cJfWxmHfFAog65J7ZrdEek3flb099JlaLUpfr+5KhkydVaBFrzXlt7T9ttK818qhCoAqCCz1oJtO+AWgHU9O/2XMYy89IagxFfHPVpMxK1AhrObcEJ+iVez7v3eMa5w0bGrlUmUUfdIFbN3hFZOLjuXWEctwySaRfBn/IZnP6lIG1egrR4ACbmBpiIi2CangIJywfTMBNM/YMg9faDqZMMTu1d4NbaDI7vMnA9pnznuk68puc4MoVr03cpx3FkL677lCjiNrsh8dsaQAIP+pKg9JqkVkYtUvNgEAnIDSR18wL0G1zyJvVeu5Ja172I/3kfPZ/MIL0ah2rree6tx3Xf0YDrvKcB135jE679+nCe3fZQA/XqZvqqqR30VeO78xTD+htIBwzVN+s2mWeWMM1Q0nYJTxSzUV8Yvp8rCDvOM444JzBucU9sElciFQ39qjabDSeLLfCgE3nlR9hpPP7yAtRUUE4+OpjjBOooTqGe4jTqW55BA8vzaKA8j4aKCwhTXEas9V10dXyKdg7nUVM2H1KTNmVGxqH3heKo42ZmbZLMpAmLTeV9xpnJBwyXWo7pIbWb20LmtK2hzCunltLrvA/d9dkV/M5J3QQ2ikbF1qrA15Z2QR+kDsFPLehOb9f4mdQh/KmFU8gTc+foayaqwONGCr8ivirwocbP9yvS/622X2sZ6fAXABtU00wOpv9Ubb09VQjVlAB7jDsvqNr9K28Lej+T8nu8VBhRrr6xnywNRn9xYunLGyxvRunKODXH9KBkJIxrp6XEvs1uRh1zkrGOfMZYNisj0mbg2LcHv8VMiCYdg3DFRxj8CpAe5SBtSkBaPQdpcR8k+gZI5BWQ8LMgjY6DNDgCJiQHTL0MMMHpYGqngVtzJ7g+a8D1XACuy6RSruOEhxzbUef0rfod4Si6pXIVnZcxik6ziCx2HjFvuZRI2yQSWfwAIms/isjaTCXyNtOJeZsZxLz1TGIWO5cxbbmUETdfQcTRK7ji6JWMOGI9IwxP4ggbZXOEjY/pmTQ9q28SedtQ1OKJsajDe1NJ328Ki4nfrWSLYa/YCnfLdPhYHYO/9QUEWF1BoOo6u4IsbyBYdQf1VPfRQPUIjVRP0dj6OZqqXiJS9Qox1sVooX6H1urP6Ob0FX3di9HBsQA1lbMgE8fByDi0TCAMvyOUtMoUmXfYKLboPN/Ust8YM+XIPhZWExOkzouj5R47Q2RueQGWta57qQIfetqGvnOyDn1rJ29QrFaGvbGiQk93ee+Ye2LT8JtCSaM7IodwzUQlr8bnBQ7hN3lU6LWCr4m1VA8G60z//wBQC6GSQpu1CirptyoFny4aPJTQ6D8dzEFjAXQk96BSG/2Op30piy87ubfurFYkgLYl9x/BuPWYyjh02MDYtTrEWEedJerIx8Q64gORR4OxbgPD0FEw6b8T4tm3wZ9XBu6YSmXQ/j1ImzdgYp+DaX4fJOoWmGbXwTS5BKYxnTZ8GqTuMTDB+WDq5IIJzAE3IBd6NXNg4J8Fnu8BGHnvhpH7ehg5L4Ch/QzwbKZ9MLSZ/NLQesJLQ9XQ94aKQe8M5f0+GMn7vTeS9XvHl/b/yJcO+GgsHfZJJB1Tair/pcxMMaNcppxfYaVaB1tVEuyt0uGiPgYvm6vws7uPWjZPUUv9EoHq56ijfolg65cItnqJelav0MC6GKFWbxFm9R4R6k9s/320TSla2JUh1qYMra3LEG9bgQHuwCj/CvTzeYgohyS4K0ZDKIoCT9jwk7G46UMT05izQtPW+03MExaL5b0nSJQDhpuqx3Whu77UdWMjZY202kr/8z4a4b/tadPglbO8wWe1KuK1pXmTlwpZ4w9SUcg9MRV2+v+zCNF0XdKdngq+Rti1Zr72tlbgte6jDv9BqBwpTkeV0R8HVQKVMQHqGrDBQeoOdL1mIuz20JS6AzyqBLrfctdPOFfDMOpAHRK9px6d5kv8R/fkuPWewLh2n844xS1n7GL3MzZRlzg2kcUc68gvxLLZdyKPAtelEwTNp8Nk2AEIZzwAf+5X6I0DSN9vIHGlIO0+gGldAtLyNZjol2AiHoM0uQOm8W1wQm+BCbkObr3r0Kt7Hfp1roJX+zr4dW7BuM5NmATegrDmDYhr3oJ5rXuQ1bwLue8tKL1vwMrrJmy878LO6x7sPe7Dwf0BnN2ewM3tBTxc38Db+R18nT6iptNnBDiVopbjR9Rx+IRg+8+oZ/cZ9e0+oaHNFzS2/YImNqVoYluKJjZf0Mz2C6Lty9DS4Qvbd9/e+SvinL4iwekbenkAQ/2AMUHfMaT2M7T3y0ag3RxYSBLAEzSBoSjss0Ac8ZIVfLPW+4XmHdaJ5N2ni62HDRRajexlrp7c3tx1ZVN5jZ0hKr+8AHUQFf47XqqQhx7WjUtsVRGfLBUhT8y1Pj3d8VmhpzGewMrxaVW7fJVv/1ucSAcdNEqgcrVuzWUVQmUKsSpeMESTTmTrAXo/k5KxHxVk5CcVGV5hT4d56MVmBhk0XhrFCZrcnuM/vivHc/AQ4tFjMuPcfjPjGJvOOMScYmwjbzPqiPfEKrqCKKLBKKKh79oFgpgZMBm0F8LESxDMfg/eZIAzGCCdK0DafgXTqhSc5h/BiX4PTtR7cJp9ADf8PfTD3oEXWgJ+g2KYhBRDVK8YkuASmAWXQFb7LZRB76AKeg/rWh9g6/8B9r4f4eTzCS4+n+Hm/RmeXqXwcv8MH9dP8HcpRS2XLwh2K0eIWxnqu5ahoWsZwlzKEO5UjnDnL4h0LkOMczmaO5ejhXMZWjqXIdalDO1cvrIsO13cv6KfLzCiNjChATCx0WcMaXAH7QMyEOg8HzJZT/CEkdAzCaswFDf9KJBEPjY2jT5jbB6bYWLRbotASQV/6ABT9fiuEvtpbS3c1zVR+KbUlQcdq2lR55K3vNFrV9bcb1xiS0196ttToWcFPoRWe1ZL5bI1HJRTgWY9qoReBx3+HsBUlXtSJUB/SANu8tS0X58qhMpAIVtLQN0CqgiGf5Qbjfyk4o0qtdGPP+XDDjVpsCGMW29uC1J7ckeO39ABbIzArfNCxqndVsphSNTRl4lN5F1GHfGcUUV+IfKmoItr1wJG9YbApPMyCIdkwjjxLgRTP8BoPGAwCOD2APTiAYN238GL/QqjFl9hEvMV4ohymDb9AouwMijCyqFqXA7r0HLY1C+DfUgZnEPK4RZSDo/gMnjVLoNPUBkCAssQFFiGOgFlqOf/BfV9v6CRTxnCfcsR4VuOSN9yRPmUo0WNMrT0/oLYGmVo61OODjXKEOdThs6+39DTvwL9g4AxjYBJzYDEpp8wLOwBOocUoInvOrjYjoNI2hn64mhwReEwlDT7aiSJeGEkibrGN4s5LrCITedbtNsuUHSZJbAaNJRvO76ryHl2LBV8c9+Uuub1rvioQh96Kpu+c5I1KbVRRH62to16LlM2f2ymiHxiLgo5J6bZHDcq9GxbNQ34JmqCvrrKPR3+m9DsFKw1QHeQygwCtQJijxtRl0DrGrABQ1plSBuPaMnxmAoLg16PHPUTLtfQa5lRRy9mf11u45VN2YxB4LhunBoDhzEevSYTl04LiVPcCsa53SaOfYsjHPuY04xt1BVGHfGUUYS9I2YNSjnKsAp9lw4wDB4M41bzYNxjF0yHnIJ49H2IxxfDfOx3mI0AzPoDFt0AZUfAqi2gjv0OuxZfYR9VDsdm5XBtWgbv8HL4hZfBP6wctRqVoXajMoSElqFhgzI0bliO8AZfEVGvDFHBZWhepxytg7+ifb3viAv5ji4hFehZvwL9GgGDmwLDI4FRMd8xttV7jGz5BP0iLyEu7DAa1VwDR7uJkEi7gSduBY6wKQxMm343Mmv22dAs8pmhedQVI/PmBXxp211G8rjVfEXXOQLLnlNMrPuPMHFM7CT0WtXEuEZyiCwwL8CqwTN3RdgTF+uoEltlzGcr6tvLw59aUN+eTd/S3Z5aZyG5hqxy1mZ6fvPndbu9Dv/foLEK2FSiNoOwi1sVK0jI/aGIyKTfOzPDoZ+tDId9VlOGYv2utz1YhdA8OYTbeG1TUnduKxI4tQOp+UsCx3dEX45X/9GcGn3Hcj26zOK6tF+v59A6hbGnsYOYUxxVxH1G1uQ5MWtYRqSNwVE3h75rRxj694dJ6BQIW6+Babc0yPudgGrAFagH3IXDoKfwHPoOvkO+wG/gNwQNAOr1BRr0AsJ6AhHdgZjuQKuuQJsEoEMC0Lkz0CMB6BkP9Oz4Db3iStEn7h36xr9Cn45P0KPtXcRHn0PLsGw0DN4Kb695sLUfAwur3uBLO4IjbgFGFAF900jwzJuVG5pHvOWZR943tIi+zJe2zOYpWu8xVHRaIlD1mMq36T/CyHZ4P77d+M7GzrNjhV7rmkiCM+qIw+94mYY/dVM2felk2aJCZRv1QUZdLirwqtiHRqzgszUd1f4H1bM6On9eh/8h/GghVLcSEnIN6Q9Vax2QPg8kVCEIhn2QUoVABr+1I/GnfEhsXgCbSaBMRlE7G3LDN4Tp15naQT9wbHf9WmN76geO68a49/qFcY5fxjh2XMPYt06irgOjirxJlOHPiDzsPbFo9ImYhn4jFmHfGUUkODax0HOMA8+jB4R+Q2EWNBHSejOgaDgf6rDFsA9fA5eIjfCM2oYa0TvhH70Tfk23wS9sM/warYNPyAq4114ER/9ZUHsmQuk8AhYOA2Bq2wPGVp2gL20LRtIcRBwBxjS8Qs+s6VcD86bvDSwi3vDMI14YSCNv86TR5w1kzQsMla338pTttxlYdVpqaNt3rJHdkMF8+9E9jT1ntTapsbKpwG9TY5PamUHiprc9zVq+chG1LbWRtP1sJYv7IKUmPg3osX4969NXdnpW+fI/pOl0Qq/D/zqqjebWlt5WliKHp/NU1EqoVAgslRkdWjKsQmo8oMKCDIfccBSsecNKbfldznrrdzjqx487681PKPSjroN+vRltuMFzW3MbzG/J8R3Zh3HsPJ9xoEVHbXcxdm13Mjat0ohNqzTGqnk2YxV5glhGXiLypo+IRfhzYtbkDTFt/IZIGn0gkoalRNywjEgalRNJ469E0vg7kYRVELMmIKZhIJJG39j7TcO+ErOwL8Qi7BNj1uQDx6LJWz2L8FcGsqbPDGTNHvPYFfGQp4i6wlM2z+Op2u7iWbbbYmDZfoOBZdxyfZseUw1s+kw0sBsymOc0truR2+xYvteySOPA5BCTuodqi5pdriFo9cBdGFvqIGkNa37HCoUg7plU1OGBhObqqdDTAp0fIve6klwd/nxgi480rgNVCNVLkqtTgdO4Anv7jsg4EeaiRIjpMu7/xEWv49FA3ijYGI2tsKTWg36bPF9u6JoITvDM9vpBk+M5QdPacwISO9GMA/EaPoDj0W8M1637FMah0yLGIX4JYxu3nFG338C1brtLz6pVJlfV4ijXsnk+VxVTwFXFHOeqYgr1LWNO6VlGnzGwjC4ysIw5amDVIlNf1fKwvlWrQzxVqzSeqvUeA6v2mw1s4pYbqDuuNLDpsM7AusNaA5uExUb2PX81chk8hO86rpvAfWo7I++5LQxqLovk11wfLgjaHmocfKAOP+ySt0n0Y2dh27f2orhSW6OuFUo6+9Ak/rEZW3GpnYlA3SntFCRt5F7Xe6/DXwya4JRWKez6zVqgBSo0sKimKUcWq2VEupayCemRxhUC0rNYJBoEseGwCjWv/zNbg66PnQ26PXUVdL7tadjqUG1eREp9XsTWRgb1V0QY1FnQwqDukhhu0KLmHP8Z7fR9p3bQ8xjd28B54DADl8FDDNzoGjTUwG3IMAP3IYMNXAYNZR9zGzzEyGPYQJ7b2J48z8TOhp6/JPA8x/Tge4zvauQ3q7WB74IWRn6zYw19ZrQz9J3dxihgSYyw3qbG4ob765o2zqkljn3oadD+paOw01t7YdxbB1FciS3pXSGl751dVNipT69tx2ZbrKsLPNuCXZmbr7500OFfwPDh4+zz8wsOnz17NuvSpctZW7btnPXzc/73QX/obM85k3bwcPyVa7eOnDxZlHv27LmsafN3RrMViwPSeRZ9LxvLhj0TmHV9ZSLq85aNL5gO+WQpHPDWXjSoxMawZ7G1qMtzO173EluD7u+cjDvedyOxN930W5z1NorIC+C3OO3Ljz7mQ5c49oKnoNVFL0HUdS9R80I/fuRpX36Ls97i2Gue4haXvMWtrnuJIo/7Shpn1DGNyAsQxF7wFMa9cDDteN/NuP11F1FCiY2kz2crcdenaknPz9bmPSoUog5vJaTvC031JCVPqT734Ie6Ck169b9OOv5Z+HUKQId/EYmJif4fPpZCi4LjJ079/Jx/L/65H/GNW7enV71ZADuSMjWzB7TBxsr6BDa2wKYlnwlMB7wW0lQkLX9V9HzCp0qCKghqNUjo7jsIYhpzkHarkJE+kJgOqBA6DKgQSnqCtSzoc4Xd3poaD4W5rPcHqWpIhal6UIlY1AcSs64VSla4KQdi3xfG9LXED5Xkm5TmjBKg0jZlaKjZtOb8v5SH/+e+Mx10+JtYs2aN88vXH6oE6mjBiZM/P+f/Eq7d0CiAsm9ABYCD2bnxmkdYofhNMOjuScuXqdBVW1QxsMohPJ3nMCCdx7oVlcqC7Xxk02rHjej97GMJuYba12jTmayZnpBryNbOU2EOyTVk76O7NiHEo2FDmd/y1Y3tl+yLd1mQkVBjwcZm3gkJYtaMr3JjCAmcOdO3xp79zVx3pDRz2Lw/1m5jaoLthtQ4px37mnvsT2/msmZzmHVUrG3VZ/oJtQkx8dm8PtRld3KCetPWLuqtW7vY0bVzW4Ldtp0Jjkl72zms2RDm3KiR8ufXWs6a20m+al2idP7SidL5iydKFyxJlC5alihfsiJRvmBJonxe5d/LViVar97UUz2oj+vP59DhL4CZMxcrjxeeOnz58vWc+/cf5ibvTZv/83P+LyEzM7sTfZ+XLt/Mu3zlxpE9e1Lr/Pyc34GmhbX1Li6tinPTKIPfUpRsmrJaliIxV89PqzzY42UDBzYIp+mHYF/Ppt60LbE0oAkO8U4QW287kKQ8+6BE+uAd5I8+QPHoE1R3i2G3emMz7ZtxGDM3xOXouSLL6y8gvv8Zxnc/QvjgMyRPSiF6XArhw8+QPCqF6cOPkJ69/9Fme/o6B1NTYbXPQ+xWbOqiOnn9gfzxR4iffYfxk3IInpTD5OlXiJ59hejJV5g8Lofw3kfIz99/o1q/c0K1lzOyjMIHgneA4YMKdhk9AgyfAEba9QgQPAaMnwDGD79DfPZBuXzdzv/Tvw0ddPhfBb9miNzi4mPoASDFAPPgO8g9KmRlsNp+MIY+Rxnfz0lVcO2tyQeAPATIE4A8B8gLgLzRLKYE0CsGyCOAPAYkbwHLpOz12uuol61tKrv5FpyXYM/P0NfT288BzmtA/w3AeQWQpwC5D+g9ByyefoNqU1I/7TlMj5y/rv8J4NLXPAO41ZbeC0D/JaD/AuDQc9yoALkFCJ8A5su3DNGeQ4e/AObOnWu0fOW64StWr5+wYtW68fPmLY3SPjZs2GzBihWr+q1dv3HY0uWrxyxfvnrMqlXrR6ykz1+xftiqVRuHrlixfsSyZWvG7tqV0nnPnrQGnTt3tvrxCoTMXrTKdtkKev41ievWbUpcs25D4sqVaycuXbpy4rJlqxJXrVqXuGbNpsRVqzYkrl67cfTBg4ebDB83zv7n81DMmbMgePX6jROWrFgzfvnKteMmTZrp+PNz6KDhdZs31z14MLv18uVrRy5btmb8ihXrEpcuXT1xyZIVY3fu3NPtUFZWg6GjE//m+DI3t0DTvWkHG6WkHOy8adO2flu27Oy9efOuXtt3pnTbuXNv140b6d87+u7ck9pt7970dqNHj5YQCwtj5a7D+Rb55++L8s+/Nbj9BeT6Nxhd/wD5ht1N6Xnlm/dOFFLBuvENhncB45wrH8UZp4skeZcKxUcvFUoKrpwwPXbhnGlu0Q2jwrvfmBtlILcB/olHMB0wxo2ew3Rvzj4DKvDXv0H/ygeIs87dMc29kCPJOZ9jeuxyvtmpG8dNj17KFx06c0lw+S24d75D7wEgPnj2hYWbBR0IQ5TJh7qanX04xfTUremSkzensuvY1amSY9emmZ2+Ps3szM1pkpNXfjFJLdhldOLBV3KpDMw9wOzgqats9kWHvwZyc4vM7z14ivefvuFzGXAoI/u09rH5y+Y7P3z4BO8/fMOzVx/x4s1HvHxDjx/wsvgjXhV/wpuSz3hT/BlPX7zD/UevcOv2g/eHDx/5IZOQmZPX9tOXCrx9V46S92V4+7EMb99/wZu3n9lzFL/7gg+fvuH9p6/s7SfP3+LKjftfjuQXLvfy8hJUP1dR0cWZZd+B129L2TjA7uT9Pao/npqa3u3mrTv3Hz1+iWcvP7Dvr+TdF7wpKcWL1x/x4tVHvKaf4dVb3Lh5r7zw1Nmdc+asNK9+jh07dnW8fuPukxev3uHVm0949foTXla+lj3H6494/uoDnr36gFcln/H8ZQnGJU4Oq3YKI/X4GS3F1z6CXAeMrn+CfFNSOH1AuDd/g95DgHMHkOTffC1pEOVe7XXVoW8+ZWF33oV3INcAw5vfIZ23vjd9QLy/8DpzF+DeBUz2nshQEML/+cUUIISRbD+8gXcPIOcBw+y7ZeLJ49Q/P++PYJKctZJzCyCXAeOM8+9MlCZmPz9Hhz8pLl68KLl55/GbOw9e4emrD8jOO5ajfWz2wtluz56/YQXtxZvPrBJ4WfwZr0pK8frtF5S8L8fbj19R8q6MFYabd57iwdMSvPv0DQcOZv6iPU96Rla7Z6/e4db9Z7h26wnuPniFh09L8OTFWzx9+Q6Pn5fg4dM3ePikGPcevMLNO89w//EbfCkHDh0+UmX6Upw9fzXx6YsPuHrzMR49eY20tIw47WMpKWm9ios/ssJ+695z3Ln/Eg+evMb9x69w9+FLPHj0Ck+fleDRkze4dfcp7j16hU+lwNlzl4vCwzuyPnZSUpLHzZsP2M966+4zPHn+Dq9LqAL5glfFpex6WVzKfh/PX33Em3elKHn3Gb9OmcHu8FrYrV0bzL9YAnIFENwsg3xTSit6v2BtahoVfs49wDz33OHqr/kZpnFdahkdewhyFeDfAsxnrhhL7xfuKXhI6FDX24Ak78rwn19XHZJZa0cbXgbIacDg0K2vJuPHO//8nD+Cye6cRQa3AXIJMN539p1IJPqX5j/q8H8IFy8elVy8cuvN1ZuPcP/xa2Rk51UpgBkzZojy8o6Nv3Dpxi/5BacSs7LyE3Oy8hPzjxxPLMgvTMwvKEw8XliUmH/8VGLB8aJNl6/e/Xbp+n3cffQShSfPPYmMjGR3pt3J+xMePn2Nyzce4OLVe8grOFWam3ei+ERhUfHJU2eKT5wsKj5SUFicm1dYfOr0xdJrNx/g0tX7uP/wFa5cvfV13LhxVZHworMXEx88Kcb5S7dx7dYjpKdntaP3h4SEGB8tOPniyfNiXL1xD7fvPcWZ89eQd+xUcW7+ieJjx04Xnzx1tvh00bniorMX31+7+RCXr97D1ZsP8abkI9IzMhPoeY6dODP+yatPuHDlHm7de4rTZy4Vnr94ZX7R2cvLTxVdWn727KUlBSdOrTmUkbtz/4GMvRmHc/dkZ+dvGT9+0g+uiP2GDQ3454pBzgH8K6VQrE1qQe8XbMrczaXCdA0wybx4SyUkptVfVx3itm3rCo4/ATkLGJ7/BvMZyway96eevkGVAucqIEo+cbA1IX+Tl990+qKxvIsAOQkYZd6BaMAAn+qPOyxY3thhU2ofu017u6jXbOtNl9221ASHHekdHdZs66rakDRdmPPoM+d0Bbg3ANNtObm6HoO/EKgFcO7itTcXr93B7fvP6M5dpQD+WRw/fqrw9v3nuHjtHs5fvP4+MzOTNRXTDma3vn7rEc5euoWrtx5h5sw504RCoalKpTJVaY8qlalQJTQdN26cfVbO0atXbj7CuYs3cevOQ6zbtK2x9hpUAVBFRYX76s0HSE5LZy2AefMW1bl45SbOX7pJ3QecPH2hZOHChSFubm6mKjeVKT0GBgayx+HDh8vT0jLW3bj9CGcvXMfj58U4euLUFnqecxdu/Hrt9jOcPncdl67dwejRo4OqfcR/GG7bdjY0vvCB3XmNTr+HctnWRvR+0zXJ442oOX36O7inSyHcf/6+9ND5fOmhC0fN953MNk8tzLI4UJQlO3g2y+xA0SWDgvcgRyvAO/YZZtOX9aHnME8uOMy7A5Bj32Fw9C3EqecuSbMuH5HlXM6THjyfY5FalGWeXJhlvutoljDtwj29wgpwjlOFcw/CXv0Dqr9P8y1ZhSa3AcF5gM+u7+Cf/Qajs98hOAcYXgK4pwHmRAVMdp55aB7f/W/GTXT4E4IqgKJzV98UXbiBG3ceY1/64R8UwMyZM5UZmdlzjh4vzCo8dTav8OTZgoLjp44eOXoi78jRwryjx0/n5eafyMkvKMwrLLpYcvr8VZw8dw3HTp4rPnToELu75ecfizx78RaOF13CxWt3sXjxilHVr/EzTp4+O+varYcoPHMJVKh3p6SEah87dep8It2ZC4su4sr1e9iRtLcLvT8lJSX0wpWbOH7qIquA9u4/lP3DSX9CWkZGrTMXruPYyYusIjl4OPsovT/36IkJN+8+R/7x8zh+8hIyc/OvZ2TlZWUfKcjKys7LOpSRm3U4Oy8zL78w80jeicwjR47NW7ZmzX8xq903bGlgcuY9u/PyC9/BetFGVgGo4ro5WBy+XmJIBfgkQC4A3KsAc0lzm3MR4FwBGLouAMyRryBZX8E78hlmkxezUXzppMXRFsdegnMBIAUa/559/mWAobs9vf8sQM5orsHkfAOTDxil3/lmOkwTSNTCdPPRs7xbAPcMwC0COPR4BtA/Bxic19ym12Dyv8J4x/kn0jFTvaq/Xoc/Oa5evWp2/NSFkuOnL+P8lTtISk2vUgCTZ82yz8w59oSa2hev3saNe49x5+ELXL/9BFduPGL9+Zv3nuParce4dvMRTpy5gpyjRcg/cQGZR04V79ypUQCZOXkxhWev4cixcyi6eBMLlixjfdm/haKzl+ZduHoH+SfO4uTZi9i+fXuVAjhScCqRfez4GZy9eA3b96SwhUBbtuxoUFB4Dtn5RTh17jr27T/8dxXAwYOZ9U+euYzco2dYy+RAhsby2b13r0/h6UsoOn8TOfmncbTwPE6dvYqi8zdQdO4aTp+7hrMXb+LcpVusFXLxyi0cO3m2ZG9aTq3q53des6WBceE7ECp4R9/BaunmqiChcsL8IPOkMycFOc/LDI++AS/vNXjZL8DLfQmjo8XgH3sLXu4rGGS+AHP4I0hGOQzzvsIscelI7TmkY+Z2EO+5cMno8JNvvPxiGOa/hmHuS/CyX8Io9zX4ua9hePgZ9DNfgcn6ApIFGOy99c105MgfCnpkC7Z0E+0pnCRYffAXweoDvwjWZ/wiWJc1yWRD/nTRhsxfhWsObTDc++ArfQ9UQYg35V8mhLAFTzr8BfDs2TNp3vEz73IKinD01CVs2p5cpQD2pqavvnrrCQ4fOYWc/CJk5Bx9fjgnP4e6Can7DubsTz+ck56RnbPvQEZOyr70nPTMvOKso6eRfbQImXknqyyAvfszYo+euoiD2SdAj3MWLh73w5v4CUcKTqw4c/EaDueeQG5BEdZv/k0BHM7KTywsuoLM3BM4dvICtQDYGMCGNRsa5OafQkb2MVDB3pd+OPOHk/6ErKwjdQuLLuFwTiEKz1xB6oFDR7SPrVm3uWve0cJbuXknvufkn8TBrKM4kJGHQ9lHkX+siFo3OHqCfh8FSD+cj3OXbyPtYGZBdd+YKgBBwVuQ7AoYZb2FYs66KjdGC9WQaQ5mI2aGioZOCBX1HaM5jpkaajZhZqjZwAmhon7DBxsk3QXJrIDRcUAycenUn07BUYyZ6iIa8WuoaOCYUFHPoaGirkNDzXqOCDWjf3cdGGo2fv46XnYZyCHAMOUuhN16/eAC/CMwWXtwKTcXIAcBQeq9j8p+zXVZgL8Knj37IM3MPf4uLbMAGXmnsWrd1ioFkJN77OTxU5dxKOc4MnKP49dfp/7dqrstO5MPHj5ahIPZx6nwFh86rlEASXvTYw/nnURS2hFkHDmJWXMW/l0FkJ1bsOLYqfPYdzAX6ZkFWLFmfZUCSDuUk5h37DzSDuXjSMEZrN6wiXUBVq9e1zj/2GmkZ+Yh9+hpJKceOvPDSX/Cjh07mhwpKELqwSPILjiDrTuTs35+TlJSkmr16g1+c+Ys9Js0fbrf9Olz/DZs3eq3desuvy07dtRJ2pfxLCPneOX1Drzz9PSsio7br9jQgH/kLUgmYJTzCZaLkiJ+PPsfw6x2bWfDpHsgGYBRPmCWuGLSz8/5I5iOXzDIMPc7yAHAKOkeTHoM+sFS+UdgvCl9lH4eQFIBXtKjYtXcxL8ZuNThT4br15+Y7z+UV5J0IAcHso9j+eqNVQogO/foycNHTiL5QA7SM/OxbuPGDrm5KeLcc7maRW9XrnO5ueLtu/YeST6Yh11p2dh7ILuaBXA4OiX9CLYmZyAt6ximz5z3d12A3PzCBfS6u/ZmYG96NpasWFOlAJLTDiVm5p1C0r4sZB4pxNylK9lmoAWzFnhlZOUjNf0I9uw7jL3pWRW7k/evnDdvweg5CxaMnjVvQeK8BYsSZ8+dP3HZirUTduzZfyFpfzZ2pmbgUO5pbN25dxo9z6BBg8Qz585s8OvUX+uOHDs2YNT48T6TJk3ymTR9ks/0OXN8Jk2f7jN+/CSfKVOmBG7fvf/J3oP5SM88iu27U996BgdXKQD10jUNjLJK2F3TKO8L5EuSYqsemzVLLh2e6GXafUCgeb/BvrKRI91lY8Z4mA8d6mPWb7C/Rf8h3qZ9B9WSLNu7Xv9wGci+CvAOlcL8l+Xt2RMkJuqZ9evnbz5woJ+kR5/adJn26FvLtHfvQEnPnsHi7r3rmiZ0D5QNGlVfsvnEaW4mQPYCvI3Xy0y7d1fRU0hHD7YT9+xbT9y1Zz1xlx4hooRu9dljt171RV17NKDnkXTuXFsxLjHMZMelK5zDAEkDDDdd+2DSPFRnAfxVcPbsTYvk/Vlvd+3LxP7MAixfu6lKAexO2rspI7cQW3anY0fKQexISqtI3nfwzb70w2/2Hjj8Jjnt4Jvk/elvUvans8cdSWnlG7buw6YdB7BtT3qVAkg7eDiCnn/T7gNIPVyAKdPm/F0L4EjByWn7DuZj2+50pKbnYM36zb8pgH3piQdzjmMbPdfBHCxesZa1AKj5vXnbniOHsguxZc8BbE8+iPTsAmTnFyLjyAmkZx/HgewCHMg6hv2H8rE16SA2bN+H3amHWUtj/uIVbLSfXutgdh52pdDPsB/bkvZjV3IaklIPInnfIezZewjbk9KwOyUd2/ekY9PONOzPKMDGLbsKq7sAdss2NeRnvgNJrQD/8CcoV+yrqrCUb88/ZJT+DLzdd2Gw6y54u+995yffqxCk3IPR7nsw3HkLhnvuwSDzK0jqV1bwBFsuf5fFdWfToQ4LN9ibJV34bpj8ELydd8HbcQe8nbfB23UXhnsewHDXffC23YZRylMYUOFP/grmECBclHeRVKYMzddmnjZMewHD3Q9guPs+DHc/hOEu+lrNouc03HEbgn0vwT0EkD3fQN0A0cpcGgOo7HbU4U+Pp0/fW+xOPVSRcugIDh05iSUr1la1Ay9evNhp+67UV2kZBdi9LxO792cjOS2L3X3p7V100ftTM7Ej9RA27zmArbup8B3Gtt1p30+ePMnuFHv3Z7SgLsaO1EzszzqOCZOnT/nhTfyEw9kFC9OzTmD33kwcyj6GVas2NtE+tjf9UOKBzKNYvyUFW/ccwNrNO6t21vHjJ7lv25V6Lz3zGCvUew9kIWV/Fivk9H1t3LGfFdhte9KxPekQ9uzLRuqBbOzZl16lkJavXtc4LeModu3NxLY9B9nX7Ug6iJ0pGdiedBBb96RjW9Ih7EzJxK7kDPazb9+1HwsWr2QLfbRwWL2tsXF+pemdUwHLZZpSYArzPdcK2QwA3VWpgOYA5EjlUXtflmZxjwD8A29hPmfPUO3rbRdvdxIe/gyGmuUZYP179nX0NfR4ECDplY9lAdR8F2279UWRuDK48hQc0cYL98mxyufTRZ9Lj/RcdGn/psdMQC8XEO6480GxYKv2HDr8FZBbdN38UFb+gdT0zJzDucdzNmzZMbf646NHj3bYtjPp113J+zL3HTicszv1QM7O5P05u5IO5GzfvY9dO9mVmrM9KTVnZ8qBnOT9GTkpaRmpBQUFJvQcu5LTgzNyjuUk7z+csz8jN2fSlFmdql/jZxw6fGRYdt7xnN2p6Tkp+zNy5s1b7Kt9bF9a1riUA7lYvm4H1m1Nwcr1W1tXf23PnkPNd+1KHZycsj9tX3pmwc6ktIs79uw/t2NX2ultu1JPbdmRcnZ3yoEzSamHcjdvS1o8ffosNj2nxfz5S2okpxzMSUrNyNnFfs79ObuTD7C3t+1Kzdm2MzVnV3J6TuqB7Fx6XL9p+4oJv06tW/0cFK7zl9Sy2HD0jcmqomLzjSfe2M1bXRU/sVx9OEW4+2aJyZpTJcK1J4uFG06XCDeeLRFuKCoWrj1dbLL2TLHJxgslpluvPjHfcXmvWeLS5tXPXTPzpJn5+mO3xRvOFYvXnSoWryksZs+z9mSxaM3JN6KVhW+EKwuLxevOFJvvvHnefO2xFWadh9WsdgpGsXR/pmTDpWLxipNvRKtOvRatLHwtXnvylWTtqdeSdadeidecfiVeffqVZPXZZxY7bxVK1hYstkgYXqPaOXTQ4X8eu1IOzNuWdBBLVm/D2i3JWLh8Tcefn/MT/req1hgRIRIVIab0+NP7EChNiBmtAhQSzTIxIWba20IhMTVREjMLQtjGnd+DKSFCem66rCuvQ4/apX3s59dVg5H2vVUusfp3lgMhP7Qh66DD/zh2Je3tkpWTn7g7+cD8dZt2vF+yeiuWrNqGDVv3Ys2mrT+Y3jrooMNfDJu3J19LPpCLTTv2Yf7SjZi7bD2Wrt6Czdv3Yt68xf4/P18HHXT4C2HT9uSzG7anYtGqrVi4cguWr9+FXXsPYt3m7atoQOvn5+uggw5/Iaxav3neslXrc+YsWJEzb9GqnEXL1h5Yt3ln15+fp4MOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KCDDjrooIMOOuiggw466KDD/w/8Pw7viV5OySTUAAAAAElFTkSuQmCC"

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
                <Border Name="BdrAppLogo" Width="52" Height="52" Margin="0,0,14,0" Background="Transparent" BorderThickness="0">
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
                        <!-- Barra de Busca de Ajustes -->
                        <RowDefinition Height="Auto" />
                        <!-- Presets Andyz0x -->
                        <RowDefinition Height="Auto" />
                        <!-- Lista de Tweaks -->
                        <RowDefinition Height="*" />
                    </Grid.RowDefinitions>

                    <!-- Barra de Busca Rápida de Ajustes -->
                    <Grid Grid.Row="0" Margin="0,0,0,12">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="380" />
                            <ColumnDefinition Width="*" />
                        </Grid.ColumnDefinitions>

                        <!-- Input de Pesquisa -->
                        <Border Grid.Column="0" Background="{DynamicResource SearchBg}" BorderBrush="{DynamicResource SearchBorder}" BorderThickness="1" CornerRadius="6" Padding="8,4" Margin="0,0,12,0">
                            <Grid>
                                <TextBox Name="TxtTweakSearch" Background="Transparent" Foreground="{DynamicResource SearchText}" BorderThickness="0" FontSize="13" VerticalContentAlignment="Center" />
                                <TextBlock Name="TxtTweakSearchPlaceholder" Text="🔍 Pesquisar ajuste por nome ou descrição..." Foreground="{DynamicResource TextSecondary}" IsHitTestVisible="False" VerticalAlignment="Center" Margin="2,0,0,0" />
                            </Grid>
                        </Border>

                        <!-- Resumo de Contagem de Tweaks -->
                        <TextBlock Name="TxtTweakSummary" Grid.Column="1" Text="Exibindo 66 de 66 ajustes" Foreground="{DynamicResource TextSecondary}" FontSize="12.5" VerticalAlignment="Center" />
                    </Grid>

                    <!-- Presets de Tweaks -->
                    <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="0,0,0,14">
                        <TextBlock Text="Presets de Ajustes:" VerticalAlignment="Center" Margin="0,0,10,0" Foreground="{DynamicResource TextSecondary}" FontSize="12" />
                        <Button Name="BtnPresetStandard" Content="⭐ Recomendado (Padrão)" Style="{StaticResource BtnHighlight}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetMinimal" Content="⚡ Mínimo" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnPresetAdvanced" Content="🚀 Avançado (Debloat Completo)" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnSelectAllTweaks" Content="Marcar Todos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnDeselectAllTweaks" Content="Desmarcar Todos" Style="{StaticResource BtnSecondary}" Margin="0,0,8,0" />
                        <Button Name="BtnRevertTweaksTab" Content="↩️ Reverter Selecionados" Style="{StaticResource BtnWarning}" />
                    </StackPanel>

                    <!-- Scroll dos Tweaks em Cartões Traduzidos -->
                    <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
                        <StackPanel Name="TweaksContainer" Margin="0,0,10,0">
                            <!-- Injetado dinamicamente em 4 categorias oficiais -->
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </TabItem>

            <!-- ABA 3: RECURSOS & CORREÇÕES (FEATURES & FIXES) -->
            <TabItem Name="TabItemFeatures" Header="🛠️ Recursos &amp; Correções">
                <Grid Margin="0,16,0,0">
                    <Grid.RowDefinitions>
                        <!-- Barra de Busca de Recursos -->
                        <RowDefinition Height="Auto" />
                        <!-- Conteúdo com Scroll -->
                        <RowDefinition Height="*" />
                    </Grid.RowDefinitions>

                    <!-- Barra de Busca de Recursos e Ferramentas -->
                    <Grid Grid.Row="0" Margin="0,0,0,12">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="380" />
                            <ColumnDefinition Width="*" />
                        </Grid.ColumnDefinitions>

                        <Border Grid.Column="0" Background="{DynamicResource SearchBg}" BorderBrush="{DynamicResource SearchBorder}" BorderThickness="1" CornerRadius="6" Padding="8,4" Margin="0,0,12,0">
                            <Grid>
                                <TextBox Name="TxtFeatureSearch" Background="Transparent" Foreground="{DynamicResource SearchText}" BorderThickness="0" FontSize="13" VerticalContentAlignment="Center" />
                                <TextBlock Name="TxtFeatureSearchPlaceholder" Text="🔍 Pesquisar recurso, ferramenta ou painel..." Foreground="{DynamicResource TextSecondary}" IsHitTestVisible="False" VerticalAlignment="Center" Margin="2,0,0,0" />
                            </Grid>
                        </Border>

                        <TextBlock Name="TxtFeatureSummary" Grid.Column="1" Text="Exibindo todos os recursos e ferramentas" Foreground="{DynamicResource TextSecondary}" FontSize="12.5" VerticalAlignment="Center" />
                    </Grid>

                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                        <StackPanel Margin="0,0,10,0">

                            <!-- Card de Recursos Opcionais (DISM) -->
                            <Border Name="CardFeatDism" Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,14">
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
                            <Border Name="CardFeatRepair" Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,14">
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
                            <Border Name="CardFeatPanels" Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,14">
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
                </Grid>
            </TabItem>

            <!-- ABA 4: CONSOLE / LOGS -->
            <TabItem Name="TabItemConsole" Header="📋 Console de Instalação">
                <Grid Margin="0,16,0,0">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto" />
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

                    <!-- Banner Ativo de Progresso & Velocidade de Download (Monitor de Atividade) -->
                    <Border Name="BdrLiveBanner" Grid.Row="1" Background="{DynamicResource BgCard}" BorderBrush="{DynamicResource AccentColor}" BorderThickness="1.5" CornerRadius="8" Padding="14,10" Margin="0,0,0,10" Visibility="Collapsed">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*" />
                                <ColumnDefinition Width="Auto" />
                            </Grid.ColumnDefinitions>

                            <StackPanel Grid.Column="0" VerticalAlignment="Center">
                                <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,0,4">
                                    <TextBlock Name="TxtLiveSpinner" Text="⚡" FontSize="14" Margin="0,0,8,0" VerticalAlignment="Center" Foreground="{DynamicResource AccentColor}" />
                                    <TextBlock Name="TxtLiveTaskTitle" Text="Aguardando início..." FontSize="13.5" FontWeight="Bold" Foreground="{DynamicResource TextPrimary}" VerticalAlignment="Center" />
                                </StackPanel>
                                <TextBlock Name="TxtLiveTaskStatus" Text="Velocidade e atividade em tempo real" FontSize="12" Foreground="{DynamicResource TextSecondary}" />
                            </StackPanel>

                            <Border Grid.Column="1" Background="{DynamicResource BadgeBg}" BorderBrush="{DynamicResource BadgeBorder}" BorderThickness="1" CornerRadius="6" Padding="10,5" VerticalAlignment="Center">
                                <TextBlock Name="TxtLiveWatchdogBadge" Text="🟢 Operação Ativa" FontSize="11.5" FontWeight="Bold" Foreground="{DynamicResource BadgeText}" />
                            </Border>
                        </Grid>
                    </Border>

                    <Border Grid.Row="2" Background="{DynamicResource TerminalBg}" BorderBrush="{DynamicResource BorderCard}" BorderThickness="1" CornerRadius="8" Padding="12">
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
                    <Grid Margin="0,0,0,6">
                        <TextBlock Name="TxtSelectionSummary" Text="0 aplicativos e 0 tweaks selecionados." Foreground="{DynamicResource TextSecondary}" FontSize="13" VerticalAlignment="Center" />
                        <TextBlock Name="TxtFooterLiveSpeed" Text="" Foreground="{DynamicResource AccentTitle1}" FontSize="12.5" FontWeight="SemiBold" HorizontalAlignment="Right" VerticalAlignment="Center" Visibility="Collapsed" />
                    </Grid>
                    <ProgressBar Name="ProgressBar" Height="10" Background="{DynamicResource ProgressBg}" Foreground="{DynamicResource AccentColor}" BorderThickness="0" Value="0" Maximum="100" />
                </StackPanel>

                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                    <Button Name="BtnCoffeeFooter" Content="☕ Considere Apoiar" Style="{StaticResource BtnCoffee}" Margin="0,0,10,0" ToolTip="Considere apoiar o nosso projeto no Buy Me a Coffee: https://buymeacoffee.com/ianjos1993" />
                    <Button Name="BtnUninstallApps" Content="🗑️ Desinstalar Apps" Style="{StaticResource BtnDanger}" Margin="0,0,10,0" ToolTip="Desinstala os aplicativos selecionados via WinGet" />
                    <Button Name="BtnRevertTweaks" Content="↩️ Reverter Tweaks" Style="{StaticResource BtnWarning}" Margin="0,0,10,10" ToolTip="Restaura os ajustes selecionados para os padrões originais do Windows" />
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

# Buscadores e Resumos das 3 Abas
$TxtTweakSearch = $Global:Window.FindName("TxtTweakSearch")
$TxtTweakSearchPlaceholder = $Global:Window.FindName("TxtTweakSearchPlaceholder")
$TxtTweakSummary = $Global:Window.FindName("TxtTweakSummary")

$TxtFeatureSearch = $Global:Window.FindName("TxtFeatureSearch")
$TxtFeatureSearchPlaceholder = $Global:Window.FindName("TxtFeatureSearchPlaceholder")
$TxtFeatureSummary = $Global:Window.FindName("TxtFeatureSummary")

$CardFeatDism = $Global:Window.FindName("CardFeatDism")
$CardFeatRepair = $Global:Window.FindName("CardFeatRepair")
$CardFeatPanels = $Global:Window.FindName("CardFeatPanels")

# Monitor de Execução, Download e Watchdog
$BdrLiveBanner = $Global:Window.FindName("BdrLiveBanner")
$TxtLiveSpinner = $Global:Window.FindName("TxtLiveSpinner")
$TxtLiveTaskTitle = $Global:Window.FindName("TxtLiveTaskTitle")
$TxtLiveTaskStatus = $Global:Window.FindName("TxtLiveTaskStatus")
$TxtLiveWatchdogBadge = $Global:Window.FindName("TxtLiveWatchdogBadge")
$TxtFooterLiveSpeed = $Global:Window.FindName("TxtFooterLiveSpeed")
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
$Global:TweakCategoryCards = @()

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
    $Global:TweakCategoryCards += @{
        Card = $tcard
        CategoryName = $tcat.Name
    }
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

# -------------------------------------------------------------------------
# 8.1 FILTRO EM TEMPO REAL DE AJUSTES DO WINDOWS (TWEAKS)
# -------------------------------------------------------------------------
function Filter-Tweaks {
    $searchTerm = if ($TxtTweakSearch) { $TxtTweakSearch.Text.Trim().ToLower() } else { "" }

    if ($searchTerm.Length -gt 0) {
        if ($TxtTweakSearchPlaceholder) { $TxtTweakSearchPlaceholder.Visibility = [System.Windows.Visibility]::Collapsed }
    } else {
        if ($TxtTweakSearchPlaceholder) { $TxtTweakSearchPlaceholder.Visibility = [System.Windows.Visibility]::Visible }
    }

    $visibleCount = 0

    foreach ($catCard in $Global:TweakCategoryCards) {
        $card = $catCard.Card
        $cardVisible = $false

        if ($card.Child -is [System.Windows.Controls.Panel]) {
            $tstack = $card.Child
            if ($tstack.Children.Count -ge 2 -and $tstack.Children[1] -is [System.Windows.Controls.WrapPanel]) {
                $twrap = $tstack.Children[1]
                foreach ($child in $twrap.Children) {
                    if ($child -is [System.Windows.Controls.CheckBox]) {
                        $text = if ($child.Content) { $child.Content.ToString().ToLower() } else { "" }
                        $tip = if ($child.ToolTip) { $child.ToolTip.ToString().ToLower() } else { "" }

                        $matches = ($searchTerm.Length -eq 0) -or ($text -like "*$searchTerm*") -or ($tip -like "*$searchTerm*")

                        if ($matches) {
                            $child.Visibility = [System.Windows.Visibility]::Visible
                            $cardVisible = $true
                            $visibleCount++
                        } else {
                            $child.Visibility = [System.Windows.Visibility]::Collapsed
                        }
                    }
                }
            }
        }

        if ($cardVisible) {
            $card.Visibility = [System.Windows.Visibility]::Visible
        } else {
            $card.Visibility = [System.Windows.Visibility]::Collapsed
        }
    }

    if ($TxtTweakSummary) {
        $totalTweaks = $Global:TweakCheckBoxes.Count
        if ($searchTerm.Length -gt 0) {
            $TxtTweakSummary.Text = "Exibindo $visibleCount de $totalTweaks ajustes encontrados"
        } else {
            $TxtTweakSummary.Text = "Exibindo 66 de 66 ajustes"
        }
    }
}

if ($TxtTweakSearch) {
    $TxtTweakSearch.Add_TextChanged({
        Filter-Tweaks
    })
}

# -------------------------------------------------------------------------
# 8.2 FILTRO EM TEMPO REAL DE RECURSOS & CORREÇÕES (TAB 3)
# -------------------------------------------------------------------------
function Filter-Features {
    $searchTerm = if ($TxtFeatureSearch) { $TxtFeatureSearch.Text.Trim().ToLower() } else { "" }

    if ($searchTerm.Length -gt 0) {
        if ($TxtFeatureSearchPlaceholder) { $TxtFeatureSearchPlaceholder.Visibility = [System.Windows.Visibility]::Collapsed }
    } else {
        if ($TxtFeatureSearchPlaceholder) { $TxtFeatureSearchPlaceholder.Visibility = [System.Windows.Visibility]::Visible }
    }

    $visibleCount = 0

    $featureGroups = @(
        @{ Card = $CardFeatDism; Elements = @($ChkFeatWsl, $ChkFeatHyperV, $ChkFeatSandbox, $ChkFeatDotNet, $ChkFeatDirectPlay) },
        @{ Card = $CardFeatRepair; Elements = @($BtnActionRepairWinGet, $BtnActionSfcDism, $BtnActionResetNetwork, $BtnActionResetWindowsUpdate, $BtnActionCleanDisk) },
        @{ Card = $CardFeatPanels; Elements = @($BtnLaunchControl, $BtnLaunchNcpa, $BtnLaunchSysdm, $BtnLaunchCompmgmt, $BtnLaunchAppwiz, $BtnLaunchSound, $BtnLaunchFirewall) }
    )

    foreach ($grp in $featureGroups) {
        if (-not $grp.Card) { continue }
        $cardHasVisible = $false

        foreach ($elem in $grp.Elements) {
            if (-not $elem) { continue }
            $text = if ($elem.Content) { $elem.Content.ToString().ToLower() } else { "" }
            $tip = if ($elem.ToolTip) { $elem.ToolTip.ToString().ToLower() } else { "" }

            $matches = ($searchTerm.Length -eq 0) -or ($text -like "*$searchTerm*") -or ($tip -like "*$searchTerm*")

            if ($matches) {
                $elem.Visibility = [System.Windows.Visibility]::Visible
                $cardHasVisible = $true
                $visibleCount++
            } else {
                $elem.Visibility = [System.Windows.Visibility]::Collapsed
            }
        }

        if ($cardHasVisible) {
            $grp.Card.Visibility = [System.Windows.Visibility]::Visible
        } else {
            $grp.Card.Visibility = [System.Windows.Visibility]::Collapsed
        }
    }

    if ($TxtFeatureSummary) {
        if ($searchTerm.Length -gt 0) {
            $TxtFeatureSummary.Text = "Exibindo $visibleCount item(ns) encontrado(s)"
        } else {
            $TxtFeatureSummary.Text = "Exibindo todos os recursos e ferramentas"
        }
    }
}

if ($TxtFeatureSearch) {
    $TxtFeatureSearch.Add_TextChanged({
        Filter-Features
    })
}

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

function Get-NetworkBytesReceived {
    try {
        $interfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() |
            Where-Object { $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up -and $_.NetworkInterfaceType -ne [System.Net.NetworkInformation.NetworkInterfaceType]::Loopback }
        $total = 0
        foreach ($iface in $interfaces) {
            $stats = $iface.GetIPv4Statistics()
            $total += $stats.BytesReceived
        }
        return $total
    } catch {
        return 0
    }
}

function Update-LiveBanner {
    param(
        [string]$TaskName,
        [string]$Detail,
        [int]$ElapsedSeconds = 0,
        [bool]$IsActive = $true
    )

    if (-not $BdrLiveBanner) { return }

    $BdrLiveBanner.Dispatcher.Invoke([Action]{
        if ($IsActive) {
            $BdrLiveBanner.Visibility = [System.Windows.Visibility]::Visible
            if ($TxtFooterLiveSpeed) { $TxtFooterLiveSpeed.Visibility = [System.Windows.Visibility]::Visible }
            
            $spinners = @("⚡", "🔄", "⏳", "🚀")
            $spinIdx = ($ElapsedSeconds) % 4
            if ($TxtLiveSpinner) { $TxtLiveSpinner.Text = $spinners[$spinIdx] }
            
            if ($TxtLiveTaskTitle) { $TxtLiveTaskTitle.Text = $TaskName }
            if ($TxtLiveTaskStatus) { $TxtLiveTaskStatus.Text = "$Detail • ⏱️ ${ElapsedSeconds}s decorridos" }
            if ($TxtFooterLiveSpeed) { $TxtFooterLiveSpeed.Text = "$Detail (⏱️ ${ElapsedSeconds}s)" }

            if ($TxtLiveWatchdogBadge) {
                if ($ElapsedSeconds -ge 25) {
                    $TxtLiveWatchdogBadge.Text = "🟢 Ativo há ${ElapsedSeconds}s (o instalador está trabalhando, não travou)"
                    $TxtLiveWatchdogBadge.Foreground = [System.Windows.Media.Brushes]::LimeGreen
                } else {
                    $TxtLiveWatchdogBadge.Text = "🟢 Operação em Andamento"
                    $TxtLiveWatchdogBadge.SetResourceReference([System.Windows.Controls.TextBlock]::ForegroundProperty, "BadgeText")
                }
            }
        } else {
            $BdrLiveBanner.Visibility = [System.Windows.Visibility]::Collapsed
            if ($TxtFooterLiveSpeed) { $TxtFooterLiveSpeed.Visibility = [System.Windows.Visibility]::Collapsed }
        }
    })
    Pump-GuiEvents
}

function Wait-ProcessWithLiveFeedback {
    param(
        [System.Diagnostics.Process]$Process,
        [string]$TaskName,
        [int]$CurrentIndex,
        [int]$TotalCount,
        [double]$Percent
    )

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $lastBytes = Get-NetworkBytesReceived
    $lastTime = [DateTime]::UtcNow
    $lastSpeedText = "Iniciando processo..."

    while (-not $Process.HasExited) {
        Start-Sleep -Milliseconds 400
        Pump-GuiEvents

        $now = [DateTime]::UtcNow
        $elapsedSec = ($now - $lastTime).TotalSeconds

        if ($elapsedSec -ge 0.8) {
            $currentBytes = Get-NetworkBytesReceived
            $bytesDiff = [math]::Max(0, $currentBytes - $lastBytes)
            $speedBytesPerSec = $bytesDiff / $elapsedSec
            $lastBytes = $currentBytes
            $lastTime = $now

            if ($speedBytesPerSec -ge 1MB) {
                $lastSpeedText = "⚡ Download: {0:N1} MB/s" -f ($speedBytesPerSec / 1MB)
            } elseif ($speedBytesPerSec -ge 50KB) {
                $lastSpeedText = "⚡ Download: {0:N0} KB/s" -f ($speedBytesPerSec / 1KB)
            } else {
                $lastSpeedText = "⚙️ Processando / Gravando no disco..."
            }

            $totalElapsed = [math]::Round($sw.Elapsed.TotalSeconds)
            $watchdog = if ($totalElapsed -ge 25) {
                " • 💡 Ativo há ${totalElapsed}s (não travou, aguarde...)"
            } else {
                " • ⏱️ ${totalElapsed}s"
            }

            Set-GuiStatus "[$CurrentIndex de $TotalCount] $TaskName • $lastSpeedText$watchdog" $Percent
            Update-LiveBanner -TaskName $TaskName -Detail $lastSpeedText -ElapsedSeconds $totalElapsed -IsActive $true
        }
    }

    $sw.Stop()
    Update-LiveBanner -TaskName $TaskName -Detail "Finalizado" -ElapsedSeconds ([math]::Round($sw.Elapsed.TotalSeconds)) -IsActive $false
    return $Process.ExitCode
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
            $process = Start-Process winget -ArgumentList "install --id `"$($app.Id)`" -e --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -PassThru
            $exitCode = Wait-ProcessWithLiveFeedback -Process $process -TaskName "Instalando $($app.Name)" -CurrentIndex $curr -TotalCount $total -Percent $percent

            if ($exitCode -eq 0) {
                Write-GuiLog "$($app.Name) instalado com sucesso!" "SUCCESS"
            } elseif ($exitCode -eq -1978335189 -or $exitCode -eq 2316632107) {
                Write-GuiLog "$($app.Name) já se encontra na versão mais recente." "SUCCESS"
            } else {
                Write-GuiLog "Aviso ao instalar $($app.Name) (ExitCode: $exitCode)." "WARN"
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

# -------------------------------------------------------------------------
# 13.1 MODAL MODERNO DE FINALIZAÇÃO, AGRADECIMENTO & BUY ME A COFFEE
# -------------------------------------------------------------------------
function Show-CompletionDialog {
    param(
        [int]$AppCount = 0,
        [int]$TweakCount = 0,
        [int]$FeatCount = 0,
        $OwnerWindow = $null
    )

    $dialogXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Setup Finalizado com Sucesso!"
        Width="580" Height="420"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        Background="#0f111a"
        Foreground="#ffffff"
        FontFamily="Segoe UI, Segoe UI Variable, Arial"
        WindowStyle="None"
        AllowsTransparency="True">

    <Border Background="#151824" BorderBrush="{DynamicResource AccentColor}" BorderThickness="1.5" CornerRadius="14" Padding="24">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto" />
                <RowDefinition Height="*" />
                <RowDefinition Height="Auto" />
            </Grid.RowDefinitions>

            <!-- Cabeçalho do Modal com Logo -->
            <StackPanel Grid.Row="0" Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,0,16">
                <Border Width="50" Height="50" CornerRadius="12" Margin="0,0,14,0" Background="#060810" BorderBrush="{DynamicResource AccentColor}" BorderThickness="1.5">
                    <Border Width="50" Height="50" Margin="0,0,14,0" Background="Transparent" BorderThickness="0">
                    <Image Name="ModalAppLogo" Width="50" Height="50" Stretch="Uniform" />
                </Border>
                <StackPanel VerticalAlignment="Center">
                    <TextBlock Text="🎉 Setup Finalizado com Sucesso!" FontSize="19" FontWeight="Bold" Foreground="#ffffff" />
                    <TextBlock Text="Todos os itens selecionados foram aplicados no seu computador." FontSize="12.5" Foreground="#94a3b8" Margin="0,3,0,0" />
                </StackPanel>
            </StackPanel>

            <!-- Mensagem de Agradecimento & Buy Me a Coffee -->
            <Border Grid.Row="1" Background="#0f111a" BorderBrush="#232838" BorderThickness="1" CornerRadius="10" Padding="16" Margin="0,0,0,20">
                <StackPanel VerticalAlignment="Center">
                    <TextBlock Text="Muito obrigado por utilizar o nosso Script!" FontSize="14.5" FontWeight="Bold" Foreground="#60a5fa" Margin="0,0,0,8" />
                    <TextBlock TextWrapping="Wrap" FontSize="13" LineHeight="20" Foreground="#cbd5e1">
                        Se este utilitário economizou seu tempo, facilitou a configuração do seu computador ou foi útil para você de alguma forma, considere apoiar o projeto com qualquer valor no <Bold Foreground="#FFDD00">Buy Me a Coffee</Bold>!
                    </TextBlock>
                    <TextBlock TextWrapping="Wrap" FontSize="12" Foreground="#94a3b8" Margin="0,8,0,0">
                        ☕ Sua contribuição nos ajuda a manter a lista de mais de 247 softwares sempre atualizada, testar novas otimizações e continuar trazendo melhorias.
                    </TextBlock>
                </StackPanel>
            </Border>

            <!-- Botões de Ação -->
            <Grid Grid.Row="2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*" />
                    <ColumnDefinition Width="Auto" />
                </Grid.ColumnDefinitions>

                <Button Name="BtnModalCoffee" Grid.Column="0" Content="☕ Apoiar no Buy Me a Coffee"
                        Height="42" Background="#FFDD00" Foreground="#000000" FontWeight="Bold" FontSize="13"
                        Cursor="Hand" Margin="0,0,12,0">
                    <Button.Template>
                        <ControlTemplate TargetType="Button">
                            <Border Name="Brd" Background="{TemplateBinding Background}" CornerRadius="8">
                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="Brd" Property="Background" Value="#FFE853" />
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Button.Template>
                </Button>

                <Button Name="BtnModalClose" Grid.Column="1" Content="✔️ Concluir"
                        Height="42" Width="110" Background="#3b82f6" Foreground="#ffffff" FontWeight="Bold" FontSize="13"
                        Cursor="Hand">
                    <Button.Template>
                        <ControlTemplate TargetType="Button">
                            <Border Name="Brd" Background="{TemplateBinding Background}" CornerRadius="8">
                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="Brd" Property="Background" Value="#2563eb" />
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

    $modalLogo = $dialog.FindName("ModalAppLogo")
    if ($modalLogo -and $Global:AppLogoBitmap) {
        $modalLogo.Source = $Global:AppLogoBitmap
    }

    $btnCoffee = $dialog.FindName("BtnModalCoffee")
    $btnClose = $dialog.FindName("BtnModalClose")

    if ($btnCoffee) {
        $btnCoffee.Add_Click({
            Start-Process "https://buymeacoffee.com/ianjos1993"
        })
    }

    if ($btnClose) {
        $btnClose.Add_Click({
            $dialog.Close()
        })
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

    $dialog.ShowDialog() | Out-Null
}

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
    # Modal Moderno de Agradecimento & Buy Me a Coffee
    Show-CompletionDialog -AppCount $appCount -TweakCount $tweakCount -FeatCount $featCount -OwnerWindow $Global:Window
})

# -------------------------------------------------------------------------
# 14. INICIALIZAÇÃO VISUAL (INÍCIO LIMPO - NENHUM AJUSTE PRÉ-MARCADO)
# -------------------------------------------------------------------------
Set-AppTheme -ThemeName "Claro"
Update-SelectionSummary

# Trazer janela para primeiro plano (tela inicial) ao abrir
$Global:Window.Add_Loaded({
    $Global:Window.Activate()
    $Global:Window.Topmost = $true
    $Global:Window.Topmost = $false
    $Global:Window.Focus()
})

# Exibir Janela com tratamento seguro de saída
try {
    $Global:Window.Topmost = $true
    $Global:Window.Topmost = $false
    $Global:Window.Activate()
    $Global:Window.ShowDialog() | Out-Null
} catch {
    Write-Host "[ERRO CRÍTICO NA INTERFACE]: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Yellow
} finally {
    $global:LASTEXITCODE = 0
}
