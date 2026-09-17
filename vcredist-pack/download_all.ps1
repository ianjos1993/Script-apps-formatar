<#
.SYNOPSIS
    Download oficial direto de todos os instaladores Microsoft Visual C++ Redistributable (2005 - 2022).
    Armazena os arquivos localmente para criação de pacote offline (pendrive ou instalador autônomo).
#>

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

$destFolder = $PSScriptRoot
if (-not $destFolder) { $destFolder = Get-Location }

$downloads = @(
    @{
        Name     = "Visual C++ 2005 (x86)"
        FileName = "vcredist2005_x86.exe"
        Url      = "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE"
    },
    @{
        Name     = "Visual C++ 2005 (x64)"
        FileName = "vcredist2005_x64.exe"
        Url      = "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE"
    },
    @{
        Name     = "Visual C++ 2008 (x86)"
        FileName = "vcredist2008_x86.exe"
        Url      = "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe"
    },
    @{
        Name     = "Visual C++ 2008 (x64)"
        FileName = "vcredist2008_x64.exe"
        Url      = "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe"
    },
    @{
        Name     = "Visual C++ 2010 (x86)"
        FileName = "vcredist2010_x86.exe"
        Url      = "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe"
    },
    @{
        Name     = "Visual C++ 2010 (x64)"
        FileName = "vcredist2010_x64.exe"
        Url      = "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe"
    },
    @{
        Name     = "Visual C++ 2012 (x86)"
        FileName = "vcredist2012_x86.exe"
        Url      = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"
    },
    @{
        Name     = "Visual C++ 2012 (x64)"
        FileName = "vcredist2012_x64.exe"
        Url      = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"
    },
    @{
        Name     = "Visual C++ 2013 (x86)"
        FileName = "vcredist2013_x86.exe"
        Url      = "https://download.visualstudio.microsoft.com/download/pr/10912113/5da66ddebb0ad32ebd4b922fd82e8e25/vcredist_x86.exe"
    },
    @{
        Name     = "Visual C++ 2013 (x64)"
        FileName = "vcredist2013_x64.exe"
        Url      = "https://download.visualstudio.microsoft.com/download/pr/10912041/cee5d6bca2ddbcd039da727bf4acb48a/vcredist_x64.exe"
    },
    @{
        Name     = "Visual C++ 2015-2022 (x86)"
        FileName = "vcredist_v14.x86.exe"
        Url      = "https://aka.ms/vs/17/release/vc_redist.x86.exe"
    },
    @{
        Name     = "Visual C++ 2015-2022 (x64)"
        FileName = "vcredist_v14.x64.exe"
        Url      = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
    }
)

Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  BAIXANDO PACOTE COMPLETO MICROSOFT VISUAL C++ REDISTRIBUTABLE (2005 - 2022)" -ForegroundColor Cyan
Write-Host "  Destino: $destFolder" -ForegroundColor Gray
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host ""

$index = 0
$total = $downloads.Count

foreach ($item in $downloads) {
    $index++
    $targetPath = Join-Path $destFolder $item.FileName

    if (Test-Path $targetPath) {
        $itemSize = (Get-Item $targetPath).Length
        if ($itemSize -gt 100000) {
            Write-Host "[$index/$total] $($item.FileName) já existe ($([math]::Round($itemSize/1MB, 2)) MB). Pulando." -ForegroundColor Green
            continue
        }
    }

    Write-Host "[$index/$total] Baixando $($item.Name) -> $($item.FileName)..." -ForegroundColor Yellow
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
        $webClient.DownloadFile($item.Url, $targetPath)
        $sizeMb = [math]::Round((Get-Item $targetPath).Length / 1MB, 2)
        Write-Host "  -> Concluído com sucesso ($sizeMb MB)!" -ForegroundColor Green
    } catch {
        Write-Host "  -> Erro ao baixar $($item.FileName): $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  Download concluído! Você já pode executar 'install_all.bat' para instalar." -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Cyan
