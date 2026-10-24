<#
.SYNOPSIS
    Exporta las configuraciones de Gentle-AI desde esta máquina hacia este repositorio.
.DESCRIPTION
    Copia los archivos actuales de GEMINI, Antigravity CLI, plugins, skills,
    .gentle-ai y GGA hacia este repositorio para luego hacer commit y push.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$UserHome = $env:USERPROFILE
$AppData = $env:APPDATA

Write-Host "Respaldando configuraciones de Gentle AI..." -ForegroundColor Cyan

# 1. .gentle-ai
$srcState = Join-Path $UserHome ".gentle-ai\state.json"
$dstGentle = Join-Path $RepoRoot ".gentle-ai"
if (Test-Path $srcState) {
    if (-not (Test-Path $dstGentle)) { New-Item -ItemType Directory -Path $dstGentle -Force | Out-Null }
    Copy-Item -Path $srcState -Destination (Join-Path $dstGentle "state.json") -Force
    Write-Host "  [OK] .gentle-ai/state.json" -ForegroundColor Green
}

# 2. gemini/GEMINI.md
$srcGeminiMd = Join-Path $UserHome ".gemini\GEMINI.md"
$dstGemini = Join-Path $RepoRoot "gemini"
if (Test-Path $srcGeminiMd) {
    if (-not (Test-Path $dstGemini)) { New-Item -ItemType Directory -Path $dstGemini -Force | Out-Null }
    Copy-Item -Path $srcGeminiMd -Destination (Join-Path $dstGemini "GEMINI.md") -Force
    Write-Host "  [OK] gemini/GEMINI.md" -ForegroundColor Green
}

# 3. antigravity-cli
$srcAgCli = Join-Path $UserHome ".gemini\antigravity-cli"
$dstAgCli = Join-Path $dstGemini "antigravity-cli"
if (Test-Path $srcAgCli) {
    if (-not (Test-Path $dstAgCli)) { New-Item -ItemType Directory -Path $dstAgCli -Force | Out-Null }

    foreach ($file in @("mcp_config.json", "settings.json")) {
        $p = Join-Path $srcAgCli $file
        if (Test-Path $p) {
            Copy-Item -Path $p -Destination (Join-Path $dstAgCli $file) -Force
            Write-Host "  [OK] gemini/antigravity-cli/$file" -ForegroundColor Green
        }
    }

    $srcPlugins = Join-Path $srcAgCli "plugins"
    if (Test-Path $srcPlugins) {
        $dstPlugins = Join-Path $dstAgCli "plugins"
        if (-not (Test-Path $dstPlugins)) { New-Item -ItemType Directory -Path $dstPlugins -Force | Out-Null }
        Copy-Item -Path "$srcPlugins\*" -Destination $dstPlugins -Recurse -Force
        Write-Host "  [OK] gemini/antigravity-cli/plugins" -ForegroundColor Green
    }

    $srcSkills = Join-Path $srcAgCli "skills"
    if (Test-Path $srcSkills) {
        $dstSkills = Join-Path $dstAgCli "skills"
        if (-not (Test-Path $dstSkills)) { New-Item -ItemType Directory -Path $dstSkills -Force | Out-Null }
        Copy-Item -Path "$srcSkills\*" -Destination $dstSkills -Recurse -Force
        Write-Host "  [OK] gemini/antigravity-cli/skills" -ForegroundColor Green
    }
}

# 4. GGA
$srcGga = Join-Path $AppData "gga"
$dstGga = Join-Path $RepoRoot "gga"
if (Test-Path $srcGga) {
    if (-not (Test-Path $dstGga)) { New-Item -ItemType Directory -Path $dstGga -Force | Out-Null }
    Copy-Item -Path "$srcGga\*" -Destination $dstGga -Recurse -Force
    Write-Host "  [OK] gga (AGENTS.md, config)" -ForegroundColor Green
}

Write-Host "`nRespaldo completado. Ya puedes hacer git commit y git push." -ForegroundColor Green
