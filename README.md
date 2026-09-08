# 🚀 Script de Pós-Formatação Windows • por Igor Anjos (Andyz0x)

Um utilitário completo, moderno e de alta performance para configurar o Windows e instalar seus aplicativos essenciais logo após formatar a máquina — executável diretamente através de uma única linha no PowerShell ou Prompt de Comando (CMD):

```powershell
# Execução direta no PowerShell (Recomendado):
irm unbk.com.br/setup | iex
```

```cmd
:: Execução direta no CMD (Prompt de Comando):
curl.exe -sL https://unbk.com.br/setup | powershell -NoProfile -ExecutionPolicy Bypass -
```

> **Fallback via GitHub:**
> ```powershell
> irm https://raw.githubusercontent.com/ianjos1993/Script-apps-formatar/main/setup.ps1 | iex
> ```

> 💬 **Dúvidas ou Sugestões de novos apps?** Entre no nosso Discord oficial: **[discord.gg/unbk](https://discord.gg/unbk)**

---

Desenvolvido por **Igor Anjos**, o utilitário reúne um catálogo completo de **246 softwares oficiais** via **WinGet** e instaladores dedicados (como **NVIDIA App**, **AMD Software: Adrenalin Edition**, **Hydra Launcher**, **SignalRGB**, **Google Drive**, **Kaspersky** e **ExitLag**), **66 ajustes finos de sistema**, presets de 1 clique (**Kit Andyz0x** e **Pack PC Gamer**, ambos com seletor interativo de GPU), **5 Temas Visuais Dinâmicos**, recursos de **Desinstalação de Aplicativos** e **Reversão de Tweaks** — **100% em Português (Brasil)**, com **Ícones oficiais** de cada software e **Destaque nítido para softwares de Código Aberto (FOSS)**.

---

## 🌟 Principais Destaques

### 🎨 1. Seletor de Temas Visuais (5 Temas Dinâmicos)
Alterne o visual da aplicação em tempo real com 1 clique através do seletor `🎨 Tema` no cabeçalho:
1. 🌙 **Escuro (Dark Fluent / Padrão)**: Fundo preto obsidiana (`#0B0D13`), cartões em grafite elegante (`#161922`), acentuação índigo (`#6366F1`) e texto branco nítido.
2. ☀️ **Claro (Light Fluent / Clean)**: Fundo cinza suave moderníssimo (`#F1F5F9`), cartões brancos puros (`#FFFFFF`), acentuação índigo profundo (`#4F46E5`) e alto contraste.
3. 🌌 **Cyberpunk (Synthwave / Neon)**: Fundo violeta escuro (`#0B0813`), iluminação neon magenta/fúcsia (`#D946EF`), detalhes roxos elétricos e console rosa neon.
4. ❄️ **Nórdico Ártico (Polar Blue / Glacier Slate)**: Inspirado no padrão Nord, com fundo azul polar profundo (`#0F1724`), acentos em azul celeste glaciar (`#38BDF8`) e texto branco gélido.
5. 🌲 **Esmeralda (Matrix Obsidian / Menta)**: Fundo verde obsidiana profundo (`#06120C`), cartões verdes escuros (`#0E2118`), acentuação verde esmeralda luminosa (`#10B981`) e detalhes menta.

---

### 👑 2. Kit Andyz0x (Completo em 1 Clique com Seletor de GPU)
Preset autoral com a seleção definitiva de **30 ferramentas essenciais** para produtividade, desenvolvimento, jogos, utilitários de sistema e mídia — agora com **diálogo inteligente de seleção de GPU (NVIDIA ou AMD)**:
- 🎮 **Seleção Interativa de GPU**: Pergunta qual GPU o computador utiliza e ativa automaticamente o **NVIDIA App** ou o **AMD Software: Adrenalin Edition** com base na fabricante.
- 🌐 **Navegador**: Brave Browser
- 🎬 **Mídia & Gravação**: VLC Media Player, ShareX (captura e gravação de tela rápida)
- 📝 **Editores & IDEs**: Notepad++, VS Code
- 💬 **Comunicação & Social**: Discord, WhatsApp Desktop
- 🕹️ **Jogos & Launchers**: Steam, Epic Games Launcher, Hydra Launcher (launcher gamer open-source com BitTorrent integrado), Parsec
- 📄 **Documentos & Nuvem**: PDF24 Creator, Google Drive (cliente oficial desktop)
- 🛠️ **Utilitários & Iluminação**:
  - NanaZip (descompactador moderno baseado no 7-Zip)
  - Internet Download Manager (IDM - acelerador de downloads)
  - Nilesoft Shell (menu de contexto moderno e customizado)
  - SignalRGB (sincronização e controle universal de iluminação RGB de periféricos e hardware)
- 💻 **Ambiente Dev & Linguagens**: NodeJS LTS, Git, Python 3
- 🔐 **Segurança & Senhas**: Proton Pass
- 🚗 **Drivers**: Snappy Driver Installer Origin (SDIO)
- 🧰 **Diagnóstico & Inicialização**: Microsoft Sysinternals AutoRuns
- 📦 **Runtimes Essenciais**:
  - Microsoft .NET Desktop Runtimes (6.0, 8.0, 9.0 e **10.0**)
  - Microsoft Visual C++ 2015–2022 Redistributable (32-bit e 64-bit)

---

### 🎮 3. Pack PC Gamer (Com Seleção Interativa de GPU)
Ao clicar no preset **`🎮 Pack PC Gamer (Essenciais)`**, uma tela moderna em modo escuro é exibida para você escolher o perfil da sua placa de vídeo:
- **🟢 Perfil NVIDIA GeForce**:
  - Marca automaticamente o **NVIDIA App** (drivers Game Ready, otimização de jogos e ShadowPlay).
  - Marca o **NVCleanstall** (instalação enxuta de drivers NVIDIA sem telemetria).
- **🔴 Perfil AMD Radeon**:
  - Marca automaticamente o **AMD Software: Adrenalin Edition** (drivers Radeon, Radeon Anti-Lag, RSR, gravação e métricas).
- **⚪ Pular Drivers de Vídeo / Outra GPU**:
  - Aplica todos os jogos, launchers e utilitários sem marcar drivers dedicados de GPU.
- **Detecção em Tempo Real**: A interface detecta o modelo exato da placa de vídeo presente no PC e exibe uma badge recomendada (`★ DETECTADA NO SISTEMA`).

**Softwares Gamer Comuns Selecionados**:
- 🕹️ **Launchers & Comunicação**: Steam, Epic Games Launcher, Discord.
- ⚡ **Otimização de Rotas & Inicialização**: ExitLag (download e instalação silenciosa oficial), AutoRuns.
- 🛠️ **Utilitários de Hardware**: MSI Afterburner (monitor de FPS, temperaturas e overclock).
- 📦 **Runtimes Obrigatórios**: Visual C++ 2015–2022 (x64 e x86) para evitar erros de DLLs faltando.
- 🌐 **Navegador & Descompactador**: Brave e NanaZip.

**Otimizações e Tweaks de Jogos Aplicados**:
- Ativação do **Modo de Jogo do Windows (Game Mode)**.
- Desativação da **Aceleração do Mouse (Precisão 1:1)** para mira consistente em FPS.
- Desativação do **MPO (Multiplane Overlay)** para corrigir micro-travamentos (*stuttering*) e piscadas de tela em GPUs NVIDIA e AMD.
- Desbloqueio e ativação do **Plano de Energia: Desempenho Máximo (Ultimate Performance)**.
- Priorização de tráfego **IPv4 sobre IPv6** para menor latência e estabilidade em servidores de jogos.
- Desativação de **Apps em Segundo Plano** e **Telemetria do Windows**.
- Habilitação nativa do **DirectPlay** para compatibilidade com jogos clássicos.

---

### 🛡️ 4. Antivírus & Ferramentas de Segurança
Para garantir proteção completa imediata após a formatação:
- 🛡️ **Kaspersky Free / Standard**: Antivírus consagrado com proteção em tempo real, monitor comportamental Inspetor do Sistema e proteção web oficial.
- 🧰 **Kaspersky Virus Removal Tool (KVRT)**: Scanner portátil oficial para varredura e remoção profunda sem necessidade de instalação.
- 🦠 **Malwarebytes Anti-Malware**: Proteção multicamada contra trojans, ransomwares e ameaças persistentes.
- 🧹 **Malwarebytes AdwCleaner**: Utilitário leve essencial pós-formatação para eliminar adwares, sequestradores de navegador e barras indesejadas.
- 🛡️ **Bitdefender Antivirus Agent**: Solução mundialmente premiada em proteção contra ameaças digitais.

---

### 🗑️ 5. Desinstalação de Apps e ↩️ Reversão de Tweaks
Além de instalar e otimizar, o utilitário permite desfazer qualquer ação com total segurança:
- **🗑️ Desinstalar Aplicativos**: Marque os programas indesejados e clique em `🗑️ Desinstalar Selecionados`. O script executa o `winget uninstall --silent` para cada software.
- **↩️ Reverter Tweaks**: Marque os ajustes que deseja restaurar e clique em `↩️ Reverter Tweaks`. O script restaura automaticamente as chaves de registro originais do Windows (`OriginalValue`) ou executa os scripts de reversão dedicados (`UndoScript`).

---

### 🛠️ 6. Auto-Reparo e Reinstalação do WinGet (App Installer)
Caso o computador recém-formatado ou uma ISO personalizada do Windows esteja com o **WinGet corrompido, desregistrado ou ausente**, o utilitário conta com proteção dupla:
1. **Verificação Automática no Botão de Instalar**: Ao clicar em `🚀 Instalar / Aplicar`, o script testa a integridade do WinGet. Se detectar qualquer falha, ele repara automaticamente o ambiente em segundo plano (re-registra pacotes, baixa dependências oficiais `VCLibs` e `UI.Xaml`, reinstala o bundle `DesktopAppInstaller` via `aka.ms/getwinget` e redefine fontes) e **segue a instalação dos programas normalmente**.
2. **Botão Dedicado `🛠️ Reparar WinGet`**: Posicionado diretamente na barra de ações rápidas da tela inicial e na aba de Ferramentas de Manutenção para reparo manual a qualquer momento em 1 clique.

---

## 📦 Visão Geral do Catálogo (246 Softwares)

- 🌐 **Navegadores**: Brave, Chrome, Firefox, Edge, Opera, Opera GX, Tor, Vivaldi, LibreWolf, Floorp, Waterfox, Zen Browser, Chromium.
- 💬 **Comunicação**: Discord, Telegram, WhatsApp, Slack, Teams, Signal, Zoom, Skype, Thunderbird, BetterDiscord, Vencord, Element.
- 💻 **Desenvolvimento**: VS Code, Visual Studio Community, Git, GitHub Desktop, GitKraken, Docker Desktop, Node.js (LTS & Current), Python 3, Go, Rust, Java JDK, PyCharm, IntelliJ IDEA, Android Studio, Neovim, Windows Terminal, Postman, Insomnia, DBeaver, Zed.
- 📄 **Documentos & Escritório**: Google Drive, LibreOffice, Adobe Acrobat Reader, SumatraPDF, ONLYOFFICE, Obsidian, Notion, Logseq, Calibre, Zotero, PDF24 Creator.
- 🎮 **Jogos & Launchers**: **Hydra Launcher**, **ExitLag**, **NVIDIA App**, **AMD Software: Adrenalin Edition**, Steam, Epic Games Launcher, EA App, Ubisoft Connect, GOG Galaxy, Battle.net, Prism Launcher, Modrinth, Moonlight, Parsec, RetroArch, Heroic Games Launcher.
- 🎨 **Multimídia & Design**: Spotify Music, VLC Media Player, OBS Studio, HandBrake, Audacity, Blender, GIMP, Paint.NET, K-Lite Mega Codec Pack, DaVinci Resolve, Foobar2000, Shotcut, Kdenlive, LosslessCut.
- 🧰 **Ferramentas Microsoft**: PowerToys, Windows Terminal, Sysinternals Suite, AutoRuns, Process Explorer, Visual C++ Redistributables (AIO), DirectX End-User Runtime.
- 🛠️ **Utilitários do Sistema**: **SignalRGB**, NanaZip, 7-Zip, WinRAR, PeaZip, Notepad++, ShareX, Lightshot, FlameShot, AnyDesk, TeamViewer, RustDesk, Rufus, BalenaEtcher, Ventoy, CPU-Z, GPU-Z, HWMonitor, CrystalDiskInfo, CrystalDiskMark, TreeSize Free, BleachBit, Everything, Revo Uninstaller, AutoHotkey, WizTree.

- ⚡ **Ferramentas Pro & Redes**: Wireshark, Nmap, Putty, WinSCP, FileZilla, Advanced IP Scanner, Process Hacker, gsudo, NVCleanstall, MSI Afterburner.
- ☁️ **Ferramentas Self-Hosted**: Tailscale, Cloudflare WARP, ZeroTier, LocalSend, Kodi, Jellyfin.

---

## ⚙️ 66 Otimizações do Windows (Tweaks)

- 🛡️ **Tweaks Essenciais Recomendados**: Criar Ponto de Restauração, Desativar Telemetria e Diagnósticos, Desativar Histórico de Atividades, Desativar Rastreamento de Localização, Serviços Secundários em Manual, Desativar Promoções e Consumer Features, Desativar Otimização de Entrega P2P, Habilitar 'Finalizar Tarefa' no botão direito da Barra de Tarefas, etc.
- 🎨 **Customizações & Interface**: Ativar Modo Escuro no Sistema e Aplicativos, Exibir Extensões de Arquivos Conhecidos, Exibir Pastas e Arquivos Ocultos, Menu de Contexto Clássico do Windows 10 no Windows 11, etc.
- ⚠️ **Tweaks Avançados & Desempenho**: Desativar Hibernação (`powercfg /h off` para liberar espaço em disco no SSD), Desativar Widgets da Barra de Tarefas, Remover Microsoft Edge, Remover OneDrive, Desativar Copilot, Limpeza profunda de Arquivos Temporários (%TEMP%), etc.
- ⚡ **Planos de Energia**: Ativação do Plano de Desempenho Máximo (*Ultimate Performance*).

---

## 🛠️ Recursos Opcionais (DISM) & Reparos de Sistema

- **Recursos Windows (DISM)**: Ativação em 1 clique de **WSL 2**, **Hyper-V**, **Windows Sandbox**, **.NET Framework 3.5** e **DirectPlay**.
- **Ferramentas de Manutenção**:
  - Verificação e reparo de integridade do sistema (**SFC & DISM**).
  - Redefinição completa de Pilha de Rede, Winsock e cache DNS.
  - Reset completo dos componentes do **Windows Update**.
  - Acesso direto aos Painéis de Controle Clássicos do Windows (Desinstalar Programas, Conexões de Rede, Painel de Som, Firewall).

---

## 🌐 Como Executar em Qualquer Computador

### No PowerShell (Como Administrador):
```powershell
irm unbk.com.br/setup | iex
```

### No CMD (Prompt de Comando):
```cmd
curl.exe -sL https://unbk.com.br/setup | powershell -NoProfile -ExecutionPolicy Bypass -
```

### Execução Local:
Abra a pasta do projeto no PowerShell e execute:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup.ps1
```

---

## 💬 Sugestões & Comunidade no Discord

Tem alguma sugestão de novos softwares para adicionarmos ao catálogo, pedidos de otimizações ou dúvidas?
Participe da nossa comunidade no Discord e fale diretamente conosco:

👉 **[discord.gg/unbk](https://discord.gg/unbk)**

---

Desenvolvido por **Igor Anjos** • unbk.com.br
