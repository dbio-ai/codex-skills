---
name: template-search
description: Find Dbio templates by store type and industry filter. Use FIRST whenever the user wants to create a new site, store, or page — cloning a template is faster than building from scratch. Templates are auto-scoped to the user's platform via API key.
---

# Template Search

ALWAYS call this skill BEFORE building anything from scratch. Cloning a template gives the user a polished starting point in seconds.

## When to use

✅ User says: "tạo trang nhà hàng", "I want a tech blog", "build a portfolio", "make me an event landing", "open an online shop"
✅ Before triggering `bio-design`, `ecom-setup`, `blog-setup`, `wiki-structure`
❌ Skip when user explicitly says "build from scratch" or "no template"

## Call pattern

```
template_browse({
  store_type: "single_page|multi_page|ecomm|wiki",  // optional filter
  tag: "food|fashion|tech|event|edu|...",            // optional industry tag
  limit: 10
})
```

Returns top templates with `code`, `name`, `screenshot_url`, `description`, `store_type`, `tags`.

Backend auto-scopes templates to the user's platform — plugin doesn't pass platform.

## Pick the right filter

| User intent | store_type | tag |
|---|---|---|
| Bio link / link-in-bio / personal landing | `single_page` | `bio_link` or relevant industry |
| Restaurant / cafe / food shop | `ecomm` | `food` |
| Online shop / boutique | `ecomm` | `shop` or `fashion`/`beauty`/... |
| Tech blog / news / magazine | `multi_page` | `blog` |
| Documentation / KB / docs | `wiki` | `docs` |
| Event / conference / promo landing | `single_page` | `event_promo` |
| Portfolio / showcase | `multi_page` | `portfolio` |
| Service business / agency | `multi_page` or `ecomm` | `service` |
| Course landing / online course | `ecomm` | `course` |
| Travel / tour / accommodation | `ecomm` | `travel` |

If unsure of tag, omit it — show all of that store_type, let user pick.

## Show results to user

For each template (top 5):
- Name + 1-line description
- Screenshot URL (if available)
- store_type + tags

Don't show more than 5 — choice overload.

## After user picks

```
template_clone_store({
  source_code: <selected template code>,
  new_name: <user's brand name>,
  global_code: <auto-suggest kebab-case from name>
})
```

Then `store_select({ store_id: <new_id> })` and trigger the matching vertical skill:
- `ecomm` template → `ecom-setup` for customization
- `multi_page` blog template → `blog-setup`
- `wiki` template → `wiki-structure`
- `single_page` template → `bio-design`

## If no matches

`template_browse` returns empty (filter too narrow) or only generic results:

> "Không có template khít với yêu cầu của bạn. Mình có thể build từ đầu — bạn thấy ổn không?"

Fall back to `store-create` skill for blank build.

## Don't

- ❌ Don't call `template_browse` 5 times with slight variations — pick a good filter and run once
- ❌ Don't auto-clone without showing options first
- ❌ Don't promise templates exist before browsing
- ❌ Don't pass `industry` or `features` params — only `store_type` and `tag` are supported by current `template_browse`
