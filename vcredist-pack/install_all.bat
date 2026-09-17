@echo off
setlocal enabledelayedexpansion
title Instalador Completo - Microsoft Visual C++ Runtimes (2005 - 2022)
color 0b

:: Verifica permissões de Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ==============================================================================
    echo  [ERRO] Este script precisa ser executado como ADMINISTRADOR!
    echo  Clique com o botao direito em 'install_all.bat' e selecione 'Executar como Administrador'.
    echo ==============================================================================
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

echo ==============================================================================
echo   INSTALADOR COMPLETO DE RUNTIMES MICROSOFT VISUAL C++ (AIO)
echo   Compativel com Jogos, Softwares e Emuladores (2005 ate 2022)
echo ==============================================================================
echo.

set "IS_X64=0"
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "IS_X64=1"
if "%PROCESSOR_ARCHITEW6432%"=="AMD64" set "IS_X64=1"

:: Verificar se os arquivos estao presentes
if not exist "vcredist_v14.x86.exe" (
    echo [AVISO] Instaladores locais nao encontrados nesta pasta!
    echo Deseja baixar todos os 12 instaladores oficiais da Microsoft agora? (S/N)
    set /p "BAIXAR="
    if /i "!BAIXAR!"=="S" (
        powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0download_all.ps1"
        if !errorlevel! neq 0 (
            echo Falha no download. Verifique sua conexao com a internet.
            pause
            exit /b 1
        )
    ) else (
        echo Operacao cancelada.
        pause
        exit /b 0
    )
)

echo.
echo [1/12] Instalando Visual C++ 2005 (x86)...
if exist "vcredist2005_x86.exe" start /wait "" "%~dp0vcredist2005_x86.exe" /q

if "!IS_X64!"=="1" (
    echo [2/12] Instalando Visual C++ 2005 (x64)...
    if exist "vcredist2005_x64.exe" start /wait "" "%~dp0vcredist2005_x64.exe" /q
)

echo [3/12] Instalando Visual C++ 2008 (x86)...
if exist "vcredist2008_x86.exe" start /wait "" "%~dp0vcredist2008_x86.exe" /qb

if "!IS_X64!"=="1" (
    echo [4/12] Instalando Visual C++ 2008 (x64)...
    if exist "vcredist2008_x64.exe" start /wait "" "%~dp0vcredist2008_x64.exe" /qb
)

echo [5/12] Instalando Visual C++ 2010 (x86)...
if exist "vcredist2010_x86.exe" start /wait "" "%~dp0vcredist2010_x86.exe" /passive /norestart

if "!IS_X64!"=="1" (
    echo [6/12] Instalando Visual C++ 2010 (x64)...
    if exist "vcredist2010_x64.exe" start /wait "" "%~dp0vcredist2010_x64.exe" /passive /norestart
)

echo [7/12] Instalando Visual C++ 2012 (x86)...
if exist "vcredist2012_x86.exe" start /wait "" "%~dp0vcredist2012_x86.exe" /install /passive /norestart

if "!IS_X64!"=="1" (
    echo [8/12] Instalando Visual C++ 2012 (x64)...
    if exist "vcredist2012_x64.exe" start /wait "" "%~dp0vcredist2012_x64.exe" /install /passive /norestart
)

echo [9/12] Instalando Visual C++ 2013 (x86)...
if exist "vcredist2013_x86.exe" start /wait "" "%~dp0vcredist2013_x86.exe" /install /passive /norestart

if "!IS_X64!"=="1" (
    echo [10/12] Instalando Visual C++ 2013 (x64)...
    if exist "vcredist2013_x64.exe" start /wait "" "%~dp0vcredist2013_x64.exe" /install /passive /norestart
)

echo [11/12] Instalando Visual C++ 2015-2022 (x86)...
if exist "vcredist_v14.x86.exe" start /wait "" "%~dp0vcredist_v14.x86.exe" /install /passive /norestart

if "!IS_X64!"=="1" (
    echo [12/12] Instalando Visual C++ 2015-2022 (x64)...
    if exist "vcredist_v14.x64.exe" start /wait "" "%~dp0vcredist_v14.x64.exe" /install /passive /norestart
)

echo.
echo ==============================================================================
echo  SUCESSO! Todos os pacotes Microsoft Visual C++ foram instalados com exito.
echo ==============================================================================
echo.
timeout /t 5
exit /b 0
