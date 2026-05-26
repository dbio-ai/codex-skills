# Moved to dbio-ai/claude-plugins

This repository has been consolidated into the main Dbio plugin repo for all AI tools (Claude, Codex, Cursor, and others).

→ **New location: [dbio-ai/claude-plugins](https://github.com/dbio-ai/claude-plugins)**

## Why moved

- Single source of truth for skills (no duplication between repos)
- 1 PR updates all AI tool integrations
- Easier discovery — one repo for all Dbio AI work

## Install for OpenAI Codex CLI

```bash
# macOS / Linux
curl -sSL https://raw.githubusercontent.com/dbio-ai/claude-plugins/main/install-codex.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/dbio-ai/claude-plugins/main/install-codex.ps1 | iex
```

See the new repo's [README](https://github.com/dbio-ai/claude-plugins) for full setup including MCP config (`~/.codex/config.toml`).

## Install for other tools

- **Claude Code**: `claude plugin marketplace add dbio-ai/claude-plugins && claude plugin install dbio`
- **Cursor**: copy MCP snippet from [main README](https://github.com/dbio-ai/claude-plugins)
- **Continue / Aider / others**: same MCP endpoint `https://mcp.dbio.ai/mcp`

## Old installer URLs

If you have existing scripts referencing the old URLs:
```
github.com/dbio-ai/codex-skills/main/install.sh    →  github.com/dbio-ai/claude-plugins/main/install-codex.sh
github.com/dbio-ai/codex-skills/main/install.ps1   →  github.com/dbio-ai/claude-plugins/main/install-codex.ps1
```

This repo is kept as a redirect; new commits go to the main repo.
