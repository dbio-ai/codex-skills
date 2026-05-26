# Dbio skills for OpenAI Codex CLI

Domain skills + MCP setup for using [Dbio](https://dbio.ai) (website / bio / e-commerce builder) inside [OpenAI Codex CLI](https://developers.openai.com/codex).

Mirror of [dbio-ai/claude-plugins](https://github.com/dbio-ai/claude-plugins) skills, packaged for Codex's `~/.agents/skills/` discovery path.

## What this gives you

After install, Codex automatically uses Dbio domain knowledge when relevant:

- **Build sites** — bio link, landing, e-commerce, blog, wiki, multi-page
- **Edit / fix** — modify sections, troubleshoot CSS / Mustache / images / domain
- **Vertical patterns** — restaurant, fashion, course, event templates

Skills auto-fire by intent matching. You don't need slash commands — just talk to Codex naturally.

## Install (1 command)

### macOS / Linux
```bash
curl -sSL https://raw.githubusercontent.com/dbio-ai/codex-skills/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/dbio-ai/codex-skills/main/install.ps1 | iex
```

The installer:
1. Clones this repo to `~/.dbio/codex-skills/`
2. Symlinks (or copies on Windows) each skill into `~/.agents/skills/`
3. Prints next steps for MCP setup

## Manual install

```bash
git clone https://github.com/dbio-ai/codex-skills.git ~/.dbio/codex-skills
mkdir -p ~/.agents/skills
ln -s ~/.dbio/codex-skills/skills/* ~/.agents/skills/
```

On Windows: use `mklink /D` or copy folders.

## MCP server setup

After installing skills, add the Dbio MCP server to Codex.

Edit `~/.codex/config.toml` (create if missing):

```toml
[mcp_servers.dbio]
url = "https://mcp.dbio.ai/mcp"
bearer_token_env_var = "DBIO_API_KEY"
```

For dbio.vn (Vietnam):
```toml
[mcp_servers.dbio]
url = "https://mcp.dbio.vn/mcp"
bearer_token_env_var = "DBIO_API_KEY"
```

See [`config.toml.example`](./config.toml.example) for more options.

## Get an API key

- International (USD): https://dbio.ai/settings/api-keys
- Vietnam (VND, SePay): https://dbio.vn/settings/api-keys

```bash
export DBIO_API_KEY="dbio_pk_xxxxxxxxxxxx"
```

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, or PowerShell `$PROFILE`) to persist.

## Verify it works

```bash
codex
```

Inside Codex:
```
/skills
```

You should see all the `dbio-*` skills listed.

Try:
```
Build me a tech blog with categories
```

Codex should auto-fire the `template-search` and `blog-setup` skills.

## Skill catalog (15 skills)

### Cross-cutting
| Skill | Purpose |
|---|---|
| `template-search` | Find a template by use case (call FIRST) |
| `store-create` | Build store from scratch when no template fits |
| `content-write` | Context-aware copy (industry / locale) |
| `theme-customize` | Colors, typography, design tokens |
| `publish-deploy` | Publish + custom domain + DNS verify |
| `page-edit` | Modify existing pages/sections |
| `fix-issues` | Diagnose & fix common problems |

### Vertical-specific
| Skill | Purpose |
|---|---|
| `bio-design` | Bio link / personal landing |
| `landing-cta` | Landing conversion optimization |
| `ecom-setup` | Full e-commerce setup |
| `ecom-product` | Add products with images/variants |
| `ecom-checkout` | Coupons, payment, order info |
| `blog-setup` | Blog/news site structure |
| `blog-write` | SEO-optimized post drafting |
| `wiki-structure` | Hierarchical docs/KB |

## Updates

Re-run the installer any time to pull the latest skills:

```bash
curl -sSL https://raw.githubusercontent.com/dbio-ai/codex-skills/main/install.sh | bash
```

Or `git pull` in `~/.dbio/codex-skills/` directly.

## Other AI tools

- **Claude Code**: use the plugin instead → [dbio-ai/claude-plugins](https://github.com/dbio-ai/claude-plugins)
- **Cursor**: MCP only — see [Claude plugin README](https://github.com/dbio-ai/claude-plugins#use-with-other-ai-tools) for Cursor config
- **Other MCP-compatible clients**: same MCP endpoint `https://mcp.dbio.ai/mcp`, point your client there

## Standalone MCP (no skills)

You can use just the MCP server without these skills. Tool descriptions are detailed enough for any AI to use Dbio:

- `agent_guidelines({ topic: "..." })` — in-depth flow docs
- `components_guide()` — section variant catalog
- Each tool's `description` includes warnings and examples

Skills are a convenience layer for domain expertise, not a requirement.

## Links

- Dbio website: https://dbio.ai · https://dbio.vn
- Dbio docs: https://docs.dbio.ai
- Claude Code version: https://github.com/dbio-ai/claude-plugins
- Issues: https://github.com/dbio-ai/codex-skills/issues
- Support: support@dbio.ai

## License

Apache 2.0
