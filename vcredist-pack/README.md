# 📦 Pack Microsoft Visual C++ Runtimes (2005 - 2022)

Pacote completo e consolidado com todas as bibliotecas de tempo de execução do **Microsoft Visual C++ Redistributable (x86 e x64)** de 2005 até 2022.

Essencial para computadores recém-formatados, técnicos de informática, gamers e profissionais para evitar erros comuns de DLLs ausentes:
- `MSVCR80.dll`, `MSVCP80.dll` (Visual C++ 2005)
- `MSVCR90.dll`, `MSVCP90.dll` (Visual C++ 2008)
- `MSVCR100.dll`, `MSVCP100.dll` (Visual C++ 2010)
- `MSVCR110.dll`, `MSVCP110.dll` (Visual C++ 2012)
- `MSVCR120.dll`, `MSVCP120.dll` (Visual C++ 2013)
- `VCRUNTIME140.dll`, `MSVCP140.dll`, `VCRUNTIME140_1.dll` (Visual C++ 2015-2022)

---

## 🚀 Como Usar

### 1. Baixar os Instaladores Oficiais
Para gerar todos os arquivos `.exe` idênticos aos da imagem:
```powershell
powershell -ExecutionPolicy Bypass -File download_all.ps1
```

### 2. Instalação Silenciosa em Lote
Execute o arquivo **`install_all.bat`** como **Administrador**. Ele instalará todos os 12 pacotes sequencialmente de forma silenciosa e sem reiniciar o sistema.

---

## 📂 Arquivos do Pacote
- `install_all.bat`
- `download_all.ps1`
- `vcredist2005_x86.exe`
- `vcredist2005_x64.exe`
- `vcredist2008_x86.exe`
- `vcredist2008_x64.exe`
- `vcredist2010_x86.exe`
- `vcredist2010_x64.exe`
- `vcredist2012_x86.exe`
- `vcredist2012_x64.exe`
- `vcredist2013_x86.exe`
- `vcredist2013_x64.exe`
- `vcredist_v14.x86.exe` (2015-2022)
- `vcredist_v14.x64.exe` (2015-2022)
