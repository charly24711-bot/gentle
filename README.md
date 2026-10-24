# Gentle AI - Configuraciones del Ecosistema

Repositorio personal para sincronizar y restaurar las configuraciones de **Gentle AI**, **Antigravity**, **GGA (Gentleman Guardian Angel)** y **Engram** entre diferentes computadoras (casa / trabajo).

---

## 📦 Contenido del Repositorio

- **`.gentle-ai/state.json`**: Estado de instalación del ecosistema Gentle (preset `full-gentleman`, persona `gentleman`, componentes activos: `engram`, `skills`, `context7`, `permissions`, `gga`, `persona`).
- **`gemini/GEMINI.md`**: Reglas globales del sistema (Persona Senior Architect, protocolo Engram, Orchestrator ODD, Agent Routing y Remote Authorization).
- **`gemini/antigravity-cli/`**:
  - `mcp_config.json`: Servidores MCP configurados (Context7, etc.).
  - `settings.json`: Configuración de Antigravity CLI.
  - `plugins/gentle-ai-engram/`: Plugin con hooks y MCP config para Engram.
  - `skills/`: Skills instaladas por Gentle AI (`_shared`, `chained-pr`, `cognitive-doc-design`, `go-testing`, `judgment-day`, `skill-creator`, `skill-improver`, `skill-registry`, `work-unit-commits`).
- **`gga/`**:
  - `AGENTS.md`: Reglas de revisión de código automatizadas (TypeScript, React, Python, Go).
  - `config`: Configuración de Gentleman Guardian Angel (`PROVIDER="gemini"`, patrones de archivos y filtros).
- **`scripts/`**:
  - `install.ps1`: Script de instalación automática para nuevas PCs (Windows).
  - `backup.ps1`: Script para extraer los cambios locales y actualizar este repositorio.

---

## 🚀 Cómo instalar en la PC del trabajo

### Paso 1: Clonar el repositorio
Abre PowerShell en tu carpeta de proyectos y clona el repositorio:

```powershell
git clone https://github.com/charly24711-bot/gentle.git
cd gentle
```

### Paso 2: Ejecutar el instalador automático
Ejecuta el script de instalación (no requiere permisos de administrador):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

Este script copiará automáticamente:
- `state.json` a `~/.gentle-ai/state.json`
- `GEMINI.md` a `~/.gemini/GEMINI.md`
- Plugins, MCPs y Skills a `~/.gemini/antigravity-cli/`
- Reglas y configuración de GGA a `%APPDATA%\gga\`

### Paso 3: Instalar o verificar binarios CLI (Recomendado)

Si la PC nueva tiene Go instalado (`go version`), puedes instalar las herramientas oficiales de Gentle AI:

```powershell
# Instalar gentle-ai CLI
go install github.com/Gentleman-Programming/gentle-ai@latest

# Instalar memoria persistente Engram (opcional pero recomendado)
go install github.com/Gentleman-Programming/engram@latest
```

Una vez instalados, puedes ejecutar:
```powershell
gentle-ai sync
```

---

## 🔄 Cómo mantener sincronizadas ambas PCs

### Si haces cambios en una PC y quieres guardarlos:
1. En la carpeta del repositorio:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\backup.ps1
   git add .
   git commit -m "feat: update gentle configurations"
   git push
   ```

### Si estás en la otra PC y quieres recibir los cambios:
1. En la carpeta del repositorio:
   ```powershell
   git pull
   powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
   ```
