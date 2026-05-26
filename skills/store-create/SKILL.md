---
name: store-create
description: Create a new Dbio store from scratch (single_page, multi_page, wiki, or ecomm). Use ONLY when template_browse returned no matches OR user explicitly says "build from scratch / no template". For any other case, try template_browse first.
---

# Create a Dbio Store (from scratch)

Use only after `template-search` returned no matches, or when user explicitly opts out of templates.

## Store types (pick one)

| Type | Use for | Next skill |
|---|---|---|
| `single_page` | Bio link, landing page, CV, business card | `bio-design` |
| `multi_page` | Multi-page site: portfolio, catalog, corporate | `bio-design` then add pages |
| `wiki` | Docs, knowledge base, help center | `wiki-structure` |
| `ecomm` | Online shop with cart + checkout | `ecom-setup` |

If unsure, ask. Default for "bio link" / "landing" = `single_page`. Default for "shop" / "online store" = `ecomm`. Default for "blog" / "news" = `multi_page` + `tags: ["blog"]`. Default for "docs" / "wiki" = `wiki`.

## Flow

1. **Gather inputs** — ask for missing pieces:
   - `name` — store display name (e.g. "Cafe Mekong")
   - `store_type` — from table above
   - `global_code` — subdomain (auto-suggest kebab-case from name)
   - `currency` — default from user's platform (USD for dbio.ai, VND for dbio.vn). Override if user specifies.
   - `lang` — default from user's locale (en/vi)
   - `tags` — optional. E.g. `["food"]`, `["fashion"]`, `["docs"]`, `["blog"]`. First tag = primary subtype hint.

2. **Create store**:
   ```
   store_create({
     name, store_type, global_code, currency, lang,
     tags: ["food"]  // optional
   })
   ```

3. **Activate** — REQUIRED before next steps:
   ```
   store_select({ store_id: <new_id> })
   ```

4. **Trigger next skill** based on type (see table above).

## Naming rules

- `global_code` must be kebab-case, 3-30 chars, alphanumeric + hyphens.
- Template codes starting with `tpl-` are official templates.

## Common pitfalls

- ❌ Don't use legacy types (`bio`, `bio_store`, `shop`). Use the 4 canonical types above.
- ❌ Don't forget `store_select` — subsequent tool calls fail without active store context.
- ❌ Don't hardcode currency or domain — read from user/platform context via `auth_get_session`.
- ❌ Don't skip `template-search` — always try templates first unless user opts out.
