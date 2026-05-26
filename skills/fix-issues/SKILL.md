---
name: fix-issues
description: Diagnose and fix common Dbio site issues — page not visible, broken images, CSS layout broken, Mustache vars showing as text, menu 404, products not appearing, mobile layout issues, custom domain not working. Use when user says "lỗi", "không hiện", "broken", "không work", "fix", "sai".
---

# Troubleshoot & Fix Dbio Issues

Use when user reports something is broken or not working. Run through the relevant decision tree.

## Always: gather diagnostic info first

```
1. auth_get_session()          // active store, platform, plan
2. get_urls()                  // live URL
3. page_list()                 // pages + their status
4. domain_list()               // domains attached
```

Ask user for: which page, screenshot if possible, what they expected vs what they see.

---

## Issue: "Page không hiện" / "Trang không lên"

Decision tree:

```
1. Is the store published?
   → shop_publish() if not (check via auth_get_session → store.status)

2. Is the page published?
   → page_get({ page_id }) → if status: 0, then page_update({ status: 1 })

3. Cache stale (most common)?
   → Edge cache TTL ~60s. Ask user to refresh after 1 minute.
   → Hard refresh: Ctrl+Shift+R (or incognito tab)
   → cache_clear is dashboard-only — direct user there if urgent

4. Wrong URL?
   → Default URL: {global_code}.dbio.ai (or .vn)
   → Get exact URL: get_urls()
   → If custom domain: check domain_list() — domain must be verified

5. Page deleted accidentally?
   → page_backup_list({ page_id }) → page_backup_restore if found
```

## Issue: "{{varname}} hiện thẳng" (Mustache không render)

This is a known bug: R2 fast-path cache may serve unrendered Mustache.

```
1. Confirm: visit page in incognito → see {{vars}}?
2. Workaround: trigger re-publish
   → page_update({ page_id, status: 0 })   // unpublish
   → page_update({ page_id, status: 1 })   // re-publish
   → Forces R2 cache rebuild
3. If persists: report to support — known bug, fix in pipeline
```

## Issue: "Hình ảnh broken" (broken images)

```
1. Inspect section content via page_get → find image fields
2. Check field name for variant:
   → hero variant `split` / `product` → field is `image` or `image_url`
   → hero variant `restaurant` / `destination` / `tour` / `centered` → field is `background_image`
   → if user used wrong field name, image won't show

3. Verify the URL works:
   → Must be Dbio CDN: s3.dbio.ai/... or cdn-p*.dbio.ai/...
   → If external URL: re-upload via media_import_url({ url, ... }) → use returned URL

4. Image deleted from R2?
   → media_list() to confirm still exists
   → If gone: re-generate via media_generate_image OR upload new

5. Wrong media_id?
   → product_image / section content references media_id
   → media_list({ ids: [<id>] }) to verify exists
```

## Issue: "CSS layout sai" / "Section trông xấu"

Common cause: Dbio CSS compiler strips modern CSS from `template_css`:

```
STRIPPED by compiler:
  - flex-wrap
  - grid (display: grid)
  - clamp()
  - max-width
  - container queries

WORKAROUND:
  Use inline `style="..."` attribute in template_html, OR
  Use a registry variant that has these layouts built in
```

Diagnostic:

```
1. page_get → find broken section, inspect template_html
2. If custom template_html with stripped CSS → switch to a registry variant via section_update({ variant: "<correct one>" })
3. If wrong variant for use case → section_catalog({ section_type }) to find better variant
```

## Issue: "Menu items 404"

Cause: menu items missing `type: 'link'`.

```
1. store_get() → check settings.menu
2. Each item MUST have type: "link":
   { "label": "About", "type": "link", "link": "/about" }
3. Fix:
   store_update({
     settings: {
       menu: [
         { label: "Home", type: "link", link: "/" },
         { label: "About", type: "link", link: "/about" },
         { label: "Contact", type: "link", link: "/contact" }
       ]
     }
   })
4. Use route paths (/about), NOT anchors (#about) for multi-page nav
5. Target page must exist + be published
```

## Issue: "Products không hiện trong section"

```
1. page_get → find products section, inspect content
2. Check product_ids vs products_filter:
   → If product_ids: [101, 102] → run product_list({ ids: [101,102] }) to verify products exist + status:1
   → If products_filter: { category_slug: "x" } → check category exists, has products
3. If product status:0 (draft) → product_update({ product_id, status: 1 })
4. If product deleted → remove from section's product_ids OR re-create
5. For automatic preset:
   section_update({ content: { products_preset: "featured", products_limit: 8 } })
```

## Issue: "Mobile layout vỡ"

```
1. Open URL in browser DevTools → mobile viewport
2. Common causes:
   → Custom template_html with grid/flex-wrap stripped → use registry variant
   → Hero variant chosen for desktop only → switch to mobile-friendly variant
   → Long unbreakable text → not Dbio's fault, ask user to shorten
   → Image too large → use media_edit_image to resize, OR add ?v=1 marker for pre-baked variants

3. Sticky CTA hiding content on mobile:
   → Some variants have floating CTA; remove or change variant
```

## Issue: "Custom domain không work"

```
1. domain_list() → see what's attached
2. If domain listed but not verified:
   → domain_verify({ store_id, domain })  // re-run DNS check
   → If fails: ask user to check DNS TXT record at _dbio-verify.<domain>
3. If domain listed + verified but site doesn't load:
   → DNS may still be propagating (up to 30 min, .vn up to 2h)
   → User's CNAME at @ or www must point to: domains.dbio.ai
4. SSL not issuing:
   → Wait 5-15 min after verification, SSL auto-issues
   → If after 1 hour: contact support
5. Pending expired (7 day limit):
   → domain_add_custom again, re-do DNS
```

## Issue: "Sản phẩm tạo nhưng không lên store"

```
1. product_get({ product_id }) → check status (1 = active, 0 = draft)
2. Set status:1: product_update({ product_id, status: 1 })
3. If still missing: section showing products may be cached → wait 60s
4. Check category_names matches what storefront expects
```

## Issue: "Theme đổi xong vẫn cũ"

```
1. Edge cache 60s — wait 1 min, hard refresh
2. theme_get_store() → verify tokens actually saved
3. If still old: browser cache → incognito tab test
```

## Issue: "Quota exceeded" errors

```
1. quota_check() → see what's hit
2. Show user limits + plan
3. Suggestions:
   → Delete unused stores/products to free quota
   → pricing_list() → suggest upgrade plan
   → Dashboard → Billing → Upgrade
```

## Issue: "API key Unauthorized"

```
1. Tell user: key may be invalid / expired / revoked
2. Get new key:
   → International: https://dbio.ai/settings/api-keys
   → VN: https://dbio.vn/settings/api-keys
3. Update env var: export DBIO_API_KEY="<new>"
4. Restart Claude Code
```

## Don't

- ❌ Don't try `cache_clear` — dashboard-only
- ❌ Don't blame user for known bugs (Mustache R2 cache, mobile layout strip) — acknowledge it
- ❌ Don't suggest custom CSS for layout — use registry variants
- ❌ Don't auto-delete/restore without confirming with user
- ❌ Don't claim to fix things you can't (no `cache_clear`, no SSL force-renew via MCP)

## Escalate to support

If after diagnostic the issue is:
- Persistent Mustache R2 cache bug
- SSL not issuing > 1 hour after verified
- Data loss with no backup
- Billing / quota dispute

→ `report_issue({ ... })` or direct user to support@dbio.ai with diagnostic info.
