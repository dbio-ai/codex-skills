# Dbio skills installer for OpenAI Codex CLI (Windows PowerShell)
# Mirrors install.sh — copies skills into %USERPROFILE%\.agents\skills\
#
# Usage:
#   irm https://raw.githubusercontent.com/dbio-ai/codex-skills/main/install.ps1 | iex
# Or after cloning:
#   .\install.ps1

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/dbio-ai/codex-skills.git"
$InstallDir = if ($env:DBIO_INSTALL_DIR) { $env:DBIO_INSTALL_DIR } else { "$env:USERPROFILE\.dbio\codex-skills" }
$SkillsDir = "$env:USERPROFILE\.agents\skills"

Write-Host "Dbio Codex skills installer"
Write-Host "==========================="

# Clone or update
if (Test-Path "$InstallDir\.git") {
    Write-Host "-> Updating existing clone at $InstallDir"
    git -C $InstallDir pull --quiet
} else {
    Write-Host "-> Cloning to $InstallDir"
    New-Item -ItemType Directory -Force -Path (Split-Path $InstallDir) | Out-Null
    git clone --quiet $RepoUrl $InstallDir
}

# Create target
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null

# Copy each skill (Windows: copy instead of symlink to avoid admin requirement)
Write-Host "-> Copying skills into $SkillsDir"
$linked = 0
Get-ChildItem "$InstallDir\skills" -Directory | ForEach-Object {
    $skillName = $_.Name
    $target = Join-Path $SkillsDir $skillName

    if (Test-Path $target) {
        Remove-Item -Recurse -Force $target
    }

    Copy-Item -Recurse $_.FullName $target
    Write-Host "  + $skillName"
    $linked++
}

Write-Host ""
Write-Host "-> Copied $linked skills"

Write-Host ""
Write-Host "Next step: configure the Dbio MCP server in ~/.codex/config.toml"
Write-Host ""
Write-Host "  Get-Content $InstallDir\config.toml.example | Add-Content ~/.codex/config.toml"
Write-Host ""
Write-Host "Then set your API key:"
Write-Host ""
Write-Host "  `$env:DBIO_API_KEY = '<get from https://dbio.ai/settings/api-keys>'"
Write-Host ""
Write-Host "Restart Codex and try:  /skills  (you should see dbio skills listed)"
