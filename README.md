# 🚀 Script de Pós-Formatação Windows (Kit Andyz0x + Pack PC Gamer) • por Igor Anjos

Um utilitário completo, moderno e em modo escuro (*Dark Mode*) para configurar o Windows e instalar seus aplicativos essenciais logo após formatar a máquina — executável através de uma única linha de comando no PowerShell:

```powershell
# Execução rápida via domínio oficial:
irm unbk.com.br/setup | iex

# Ou diretamente pelo GitHub:
irm https://raw.githubusercontent.com/ianjos1993/Script-apps-formatar/main/setup.ps1 | iex
```

Desenvolvido por **Igor Anjos** e inspirado por **ChrisTitusTech**, reúne um catálogo robusto de **236 softwares oficiais** via **WinGet** e instaladores dedicados (como **Antigravity IDE**, **ExitLag**, **NVIDIA App** e **AMD Software: Adrenalin Edition**), **66 ajustes finos de sistema**, presets de 1 clique (**Kit Andyz0x** e **Pack PC Gamer**), suporte a **5 Temas Visuais Dinâmicos** (Escuro, Claro, Cyberpunk, Nord Ártico e Esmeralda), recursos de **Desinstalação de Softwares** e **Reversão de Tweaks**, interface gráfica com **destaque visual instantâneo e evidente** para opções selecionadas e ferramentas de diagnóstico e reparação — **100% em Português (Brasil)**, com **Ícones oficiais** de cada software e **Destaque nítido para softwares Open Source (FOSS)**.

---

## 🎨 Seletor de Temas Visuais (5 Temas Dinâmicos)

Alterne o visual da aplicação em tempo real com 1 clique através do seletor `🎨 Tema` no cabeçalho:
1. 🌙 **Escuro (Dark Fluent / Padrão)**: Fundo preto obsidiana (`#0B0D13`), cartões em grafite elegante (`#161922`), acentuação índigo (`#6366F1`) e texto branco nítido.
2. ☀️ **Claro (Light Fluent / Clean)**: Fundo cinza suave moderníssimo (`#F1F5F9`), cartões brancos puros (`#FFFFFF`), acentuação índigo profundo (`#4F46E5`) e alto contraste.
3. 🌌 **Cyberpunk (Synthwave / Neon)**: Fundo violeta escuro (`#0B0813`), iluminação neon magenta/fúcsia (`#D946EF`), detalhes roxos elétricos e console rosa neon.
4. ❄️ **Nord Ártico (Polar Blue / Glacier Slate)**: Inspirado no popular tema nórdico, com fundo azul polar profundo (`#0F1724`), acentos em azul celeste glaciar (`#38BDF8`) e texto branco gélido.
5. 🌲 **Esmeralda (Matrix Obsidian / Menta)**: Fundo verde obsidiana profundo (`#06120C`), cartões verdes escuros (`#0E2118`), acentuação verde esmeralda luminosa (`#10B981`) e detalhes menta.

---

## 🗑️ Desinstalação de Apps e ↩️ Reversão de Tweaks

Além de instalar e otimizar, o utilitário permite desfazer qualquer ação com total segurança:
- **🗑️ Desinstalar Aplicativos**: Marque os aplicativos que deseja remover e clique no botão vermelho `🗑️ Desinstalar Apps` no rodapé. O script executa o `winget uninstall --silent` para cada software selecionado.
- **↩️ Reverter Tweaks**: Marque os ajustes de sistema que deseja restaurar e clique em `↩️ Reverter Tweaks` (no rodapé ou no topo da aba de Ajustes). O script reverte automaticamente as chaves de registro para os valores originais do Windows (`OriginalValue`) ou executa os scripts de restauração dedicados (`UndoScript`).


---

## 👑 Kit Andyz0x (Completo em 1 Clique)

Preset oficial com a seleção definitiva de 25 ferramentas essenciais para produtividade, desenvolvimento, jogos, utilitários de sistema e mídia:
- 🌐 **Navegador**: Brave
- 🎬 **Mídia & Gravação**: VLC Media Player, ShareX (captura e gravação de tela)
- 📝 **Editores & IDEs**: Notepad++, **Antigravity IDE** (IDE Google de codificação agentica com IA)
- 💬 **Comunicação & Social**: Discord, WhatsApp Desktop
- 🕹️ **Jogos & Streaming**: Steam, Epic Games Launcher, Parsec
- 💻 **Ambiente Dev & Linguagens**: NodeJS LTS, Git, Python 3
- 📄 **Documentos**: PDF24 Creator
- 🛠️ **Utilitários do Sistema**: NanaZip (descompactador moderno), Internet Download Manager (IDM), Nilesoft Shell (menu de contexto customizado)
- 🔐 **Segurança & Senhas**: Proton Pass
- 🚗 **Drivers**: Snappy Driver Installer Origin (SDIO)
- 🧰 **Diagnóstico & Inicialização**: Microsoft Sysinternals AutoRuns
- 📦 **Runtimes Essenciais**:
  - Microsoft .NET Desktop Runtimes (6.0, 8.0 e 9.0)
  - Microsoft Visual C++ 2015–2022 Redistributable (32-bit e 64-bit)

---

## 🎮 Pack Essenciais PC Gamer (Com Seleção Interativa de GPU)

Ao clicar no preset **`🎮 Pack PC Gamer (Essenciais)`**, uma tela moderna em modo escuro é exibida para você escolher o perfil da sua placa de vídeo:
- **🟢 Perfil NVIDIA GeForce**:
  - Marca automaticamente o **NVIDIA App** (drivers Game Ready, otimização de jogos e ShadowPlay).
  - Marca o **NVCleanstall** (instalação enxuta de drivers NVIDIA sem telemetria).
  - Desmarca qualquer software da AMD.
- **🔴 Perfil AMD Radeon**:
  - Marca automaticamente o **AMD Software: Adrenalin Edition** (drivers Radeon, Radeon Anti-Lag, RSR, gravação e métricas).
  - Garante que softwares e instaladores exclusivos de NVIDIA fiquem desmarcados.
- **⚪ Pular Drivers de Vídeo / Outra GPU**:
  - Aplica todos os jogos, launchers e utilitários sem marcar drivers dedicados de GPU.
- **Hardware Detectado**: A tela exibe em tempo real o modelo exato da placa de vídeo detectada no sistema com um distintivo de recomendação (`★ DETECTADA NO SISTEMA`).

**Softwares Gamer Comuns Selecionados**:
- 🕹️ **Launchers & Comunicação**: Steam, Epic Games Launcher, Discord.
- ⚡ **Otimização de Rotas & Inicialização**: ExitLag (download e instalação silenciosa oficial), Microsoft Sysinternals AutoRuns.
- 🛠️ **Utilitários de Hardware**: MSI Afterburner (monitor de FPS, temperaturas e curva de fans).
- 📦 **Runtimes Obrigatórios**: Visual C++ 2015–2022 (x64 e x86) para evitar erros de DLLs faltando (`VCRUNTIME140.dll`, etc.).
- 🌐 **Navegador & Descompactador**: **Brave** (navegador ultrarrápido com bloqueador nativo de anúncios) e **NanaZip** (descompactador moderno open source integrado ao Windows 11).

**Otimizações e Tweaks de Jogos Aplicados**:
- Ativação do **Modo de Jogo do Windows (Game Mode)**.
- Desativação da **Aceleração do Mouse (Precisão 1:1)** para mira consistente em jogos de tiro.
- Desativação do **MPO (Multiplane Overlay)** para corrigir micro-travamentos (*stuttering*) e piscadas de tela em GPUs NVIDIA e AMD.
- Desbloqueio e ativação do **Plano de Energia: Desempenho Máximo (Ultimate Performance)**.
- Priorização de tráfego **IPv4 sobre IPv6** para menor latência e estabilidade em servidores de jogos.
- Desativação de **Apps em Segundo Plano** e **Telemetria do Windows**.
- Habilitação nativa do **DirectPlay** para compatibilidade com jogos clássicos e retro games.

---

## 🌟 Seleção Visualmente Evidente (Alto Destaque)

Para tornar imediatamente óbvio o que está marcado antes da execução:
1. **Transformação do Card**: Cada opção selecionada ganha fundo índigo profundo (`#1E1B4B`), borda luminosa reforçada (`#818CF8`), caixa de marcação preenchida em azul-violeta com checkmark branco (`✓`), texto em negrito puro branco e uma barra indicadora lateral de seleção.
2. **Botão `🎯 Apenas Selecionados`**: Permite isolar instantaneamente na tela apenas os aplicativos marcados, facilitando a revisão final antes de clicar em instalar.
3. **Contadores Dinâmicos nas Abas**: Os títulos das abas exibem em tempo real a contagem de itens ativos (Ex: `📦 Aplicativos (25 selecionados)` e `⚙️ Ajustes do Windows (20 selecionados)`).
4. **Resumo Luminoso no Rodapé**: Exibe detalhadamente a contagem de itens que serão processados com destaque em ciano.

---

## ✨ Recursos Gerais

- 🎨 **Interface Gráfica Moderna (WPF/XAML)**: Visual elegante em modo escuro estilo Fluent (Windows 11).
- 🖼️ **Ícones Oficiais em Todos os Aplicativos**: Carregamento dinâmico do logotipo oficial de cada software.
- 🍃 **Destaque Nítido de Código Aberto (Open Source / FOSS)**:
  - Badge em verde esmeralda `🍃 Open Source` em cada um dos softwares livres do catálogo.
  - Botão de filtro rápido: **`🍃 Apenas Open Source`** para isolar instantaneamente apenas aplicativos livres.
  - Tooltips detalhados indicando a licença (*Código Aberto* ou *Proprietário*).
- 🇧🇷 **Opções e Tweaks 100% em Português**:
  - 66 tweaks com títulos autoexplicativos em Português e descrições técnicas de impacto.
- 📦 **236 Aplicativos Oficiais**:
  - 🌐 **Navegadores**: Brave, Chrome, Firefox, Edge, Opera, Opera GX, Tor, Vivaldi, LibreWolf, Floorp, Waterfox, Zen Browser, Chromium.
  - 💬 **Comunicação**: Discord, Telegram, WhatsApp, Slack, Teams, Signal, Zoom, Skype, Thunderbird, BetterDiscord, Vencord, Element.
  - 💻 **Desenvolvimento**: **Antigravity IDE**, VS Code, Visual Studio Community, Git, GitHub Desktop, GitKraken, Docker Desktop, Node.js (LTS & Current), Python 3, Go, Rust, Java JDK, PyCharm, IntelliJ IDEA, Android Studio, Neovim, Windows Terminal, Postman, Insomnia, DBeaver, Zed.
  - 📄 **Documentos & Escritório**: LibreOffice, Adobe Acrobat Reader, SumatraPDF, ONLYOFFICE, Obsidian, Notion, Logseq, Calibre, Zotero.
  - 🎮 **Jogos, Drivers & Launchers**: **ExitLag**, **NVIDIA App**, **AMD Software: Adrenalin Edition**, Steam, Epic Games Launcher, EA App, Ubisoft Connect, GOG Galaxy, Battle.net, Prism Launcher, Modrinth, Moonlight, Parsec, RetroArch, Heroic Games Launcher.
  - 🎨 **Multimídia & Design**: VLC Media Player, Spotify, OBS Studio, HandBrake, Audacity, Blender, GIMP, Paint.NET, K-Lite Mega Codec Pack, DaVinci Resolve, Foobar2000, Shotcut, Kdenlive, LosslessCut.
  - 🧰 **Ferramentas Microsoft**: PowerToys, Windows Terminal, Sysinternals Suite, AutoRuns, Process Explorer, Visual C++ Redistributables (AIO), DirectX End-User Runtime.
  - 🛠️ **Utilitários do Sistema**: NanaZip, 7-Zip, WinRAR, PeaZip, Notepad++, ShareX, Lightshot, FlameShot, AnyDesk, TeamViewer, RustDesk, Rufus, BalenaEtcher, Ventoy, CPU-Z, GPU-Z, HWMonitor, CrystalDiskInfo, CrystalDiskMark, TreeSize Free, BleachBit, Everything, Revo Uninstaller, AutoHotkey, WizTree.
  - ⚡ **Ferramentas Pro & Redes**: Wireshark, Nmap, Putty, WinSCP, FileZilla, Advanced IP Scanner, Process Hacker, gsudo, NVCleanstall, MSI Afterburner.
  - ☁️ **Ferramentas Self-Hosted**: Tailscale, Cloudflare WARP, ZeroTier, LocalSend, Kodi, Jellyfin.
- ⚙️ **66 Otimizações do Windows**:
  - 🛡️ **Tweaks Essenciais Recomendados**: Ponto de Restauração, Desativar Telemetria, Desativar Histórico de Atividades, Desativar Rastreamento de Localização, Serviços em Manual, Desativar Promoções e Consumer Features, Desativar Delivery Optimization (P2P), Habilitar 'Finalizar Tarefa' na Barra de Tarefas, etc.
  - 🎨 **Customizações & Interface**: Modo Escuro (Sistema e Apps), Exibir Extensões de Arquivos, Exibir Ocultos, Menu de Contexto Clássico do Windows 10 no Windows 11, etc.
  - ⚠️ **Tweaks Avançados & Desempenho**: Desativar Hibernação (`powercfg /h off`), Desativar Widgets, Remover Edge, Remover OneDrive, Desativar Copilot / Windows AI, Limpeza de Temporários (%TEMP%), etc.
  - ⚡ **Planos de Energia**: Ativação do Plano de Desempenho Máximo (*Ultimate Performance*).
- ⭐ **Presets de Ajustes Andyz0x**:
  - `⭐ Recomendado (Padrão)`: Equilíbrio perfeito entre desempenho, privacidade e estabilidade.
  - `⚡ Mínimo`: O essencial para quem não quer alterar profundamente o sistema.
  - `🚀 Avançado (Debloat Completo)`: Remove bloatwares, telemetria pesada, OneDrive e recupera desempenho máximo.
- 🛠️ **Recursos do Windows (DISM) & Ferramentas de Manutenção**:
  - Ativação em 1 clique de **WSL**, **Hyper-V**, **Windows Sandbox**, **.NET 3.5** e **DirectPlay**.
  - Ferramentas de Reparação: Verificação **SFC & DISM**, Redefinição de Rede e DNS, Reset do Windows Update e Limpeza de Disco.
  - Acesso rápido aos Painéis de Controle Clássicos do Windows.
- 🗑️ **Desinstalação de Softwares**:
  - Botão **`🗑️ Desinstalar Apps`** no rodapé e na barra de aplicativos.
  - Remove com segurança e em modo silencioso qualquer aplicativo selecionado via **WinGet** com confirmação prévia e barra de progresso.
- ↩️ **Reversão de Otimizações & Tweaks**:
  - Botão **`↩️ Reverter Tweaks`** no rodapé e na barra de ajustes.
  - Restaura as chaves de registro originais do Windows (`OriginalValue`) e executa scripts de reversão (`UndoScript`) para desfazer modificações e retornar aos padrões do sistema operacional.
- 📋 **Terminal de Logs em Tempo Real**: Barra de porcentagem e status a cada operação realizada.
- 🛡️ **Auto-Elevação UAC**: Solicita automaticamente privilégios de Administrador caso seja aberto em terminal comum.

---

## 🧪 Como Testar Localmente

Abra o **PowerShell** na pasta do projeto e execute:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup.ps1
```

---

## 🌐 Como Executar Remotamente com 1 Linha (`irm ... | iex`)

### 1. Subir para o seu GitHub
```bash
git init
git add .
git commit -m "feat: setup pós-formatação por Andyz0x com drivers gpu e pack gamer atualizado"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/Script-apps-formatar.git
git push -u origin main
```

### 2. Pegar o Link "Raw"
No seu repositório no GitHub, abra o arquivo `setup.ps1` e clique no botão **Raw**:
```
https://raw.githubusercontent.com/SEU_USUARIO/Script-apps-formatar/main/setup.ps1
```

### 3. Encurtar o Link
Use o [TinyURL](https://tinyurl.com) para criar um link curto e memorável (ex: `tinyurl.com/andyz0x-setup`).

### 4. Executar em Qualquer PC Recém-Formatado
Abra o **PowerShell** como Administrador e execute:
```powershell
irm tinyurl.com/andyz0x-setup | iex
```

---

Desenvolvido por **Igor Anjos**.
