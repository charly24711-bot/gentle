<#
.SYNOPSIS
    Instala y restaura las configuraciones de Gentle-AI en esta máquina.
.DESCRIPTION
    Copia los archivos de configuración de GEMINI, Antigravity CLI, plugins,
    skills, estado de Gentle AI y GGA (Gentleman Guardian Angel) al perfil del usuario actual.
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$UserHome = $env:USERPROFILE
$AppData = $env:APPDATA

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Instalando configuraciones de Gentle AI  " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Destino: $UserHome" -ForegroundColor Gray

# 1. Estado de Gentle-AI
$destGentleDir = Join-Path $UserHome ".gentle-ai"
if (-not (Test-Path $destGentleDir)) { New-Item -ItemType Directory -Path $destGentleDir -Force | Out-Null }
$srcState = Join-Path $RepoRoot ".gentle-ai\state.json"
if (Test-Path $srcState) {
    Copy-Item -Path $srcState -Destination (Join-Path $destGentleDir "state.json") -Force
    Write-Host "[OK] .gentle-ai/state.json restaurado" -ForegroundColor Green
}

# 2. Reglas globales GEMINI.md
$destGeminiDir = Join-Path $UserHome ".gemini"
if (-not (Test-Path $destGeminiDir)) { New-Item -ItemType Directory -Path $destGeminiDir -Force | Out-Null }
$srcGeminiMd = Join-Path $RepoRoot "gemini\GEMINI.md"
if (Test-Path $srcGeminiMd) {
    Copy-Item -Path $srcGeminiMd -Destination (Join-Path $destGeminiDir "GEMINI.md") -Force
    Write-Host "[OK] .gemini/GEMINI.md restaurado" -ForegroundColor Green
}

# 3. Antigravity-CLI (settings, mcp_config, plugins, skills)
$destAgCli = Join-Path $destGeminiDir "antigravity-cli"
$srcAgCli = Join-Path $RepoRoot "geminintigravity-cli"
if (Test-Path $srcAgCli) {
    if (-not (Test-Path $destAgCli)) { New-Item -ItemType Directory -Path $destAgCli -Force | Out-Null }

    foreach ($file in @("mcp_config.json", "settings.json")) {
        $srcFile = Join-Path $srcAgCli $file
        if (Test-Path $srcFile) {
            Copy-Item -Path $srcFile -Destination (Join-Path $destAgCli $file) -Force
            Write-Host "[OK] antigravity-cli/$file restaurado" -ForegroundColor Green
        }
    }

    $srcPlugins = Join-Path $srcAgCli "plugins"
    if (Test-Path $srcPlugins) {
        $destPlugins = Join-Path $destAgCli "plugins"
        if (-not (Test-Path $destPlugins)) { New-Item -ItemType Directory -Path $destPlugins -Force | Out-Null }
        Copy-Item -Path "$srcPlugins\*" -Destination $destPlugins -Recurse -Force
        Write-Host "[OK] antigravity-cli/plugins restaurados" -ForegroundColor Green
    }

    $srcSkills = Join-Path $srcAgCli "skills"
    if (Test-Path $srcSkills) {
        $destSkills = Join-Path $destAgCli "skills"
        if (-not (Test-Path $destSkills)) { New-Item -ItemType Directory -Path $destSkills -Force | Out-Null }
        Copy-Item -Path "$srcSkills\*" -Destination $destSkills -Recurse -Force
        Write-Host "[OK] antigravity-cli/skills restaurados" -ForegroundColor Green
    }
}

# 4. Gentleman Guardian Angel (GGA)
$destGga = Join-Path $AppData "gga"
$srcGga = Join-Path $RepoRoot "gga"
if (Test-Path $srcGga) {
    if (-not (Test-Path $destGga)) { New-Item -ItemType Directory -Path $destGga -Force | Out-Null }
    Copy-Item -Path "$srcGga\*" -Destination $destGga -Recurse -Force
    Write-Host "[OK] AppData/Roaming/gga restaurado" -ForegroundColor Green
}

Write-Host "`n------------------------------------------" -ForegroundColor Gray
# Verificación de binarios
$gentleCmd = Get-Command gentle-ai -ErrorAction SilentlyContinue
if ($gentleCmd) {
    Write-Host "[INFO] gentle-ai detectado en $($gentleCmd.Source)." -ForegroundColor Cyan
    Write-Host "Ejecutando 'gentle-ai sync' para verificar componentes..." -ForegroundColor Cyan
    & gentle-ai sync
} else {
    Write-Host "[ADVERTENCIA] No se encontro 'gentle-ai' en el PATH." -ForegroundColor Yellow
    Write-Host "Para instalar el CLI oficial ejecute:" -ForegroundColor Yellow
    Write-Host "  go install github.com/Gentleman-Programming/gentle-ai@latest" -ForegroundColor Gray
}

$engramCmd = Get-Command engram -ErrorAction SilentlyContinue
if ($engramCmd) {
    Write-Host "[INFO] engram detectado en $($engramCmd.Source)." -ForegroundColor Cyan
} else {
    Write-Host "[INFO] Para habilitar la memoria persistente de Engram:" -ForegroundColor Yellow
    Write-Host "  go install github.com/Gentleman-Programming/engram@latest" -ForegroundColor Gray
}

Write-Host "`nInstalacion completada con exito." -ForegroundColor Green
