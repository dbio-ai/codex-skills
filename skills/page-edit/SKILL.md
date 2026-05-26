---
name: page-edit
description: Edit existing pages and sections on a Dbio site — change text, swap images, reorder, delete sections, restore from backup. Use when user wants to MODIFY existing content (not create new). Trigger phrases - "sửa", "đổi", "thay", "edit", "update", "remove", "delete", "rollback".
---

# Page & Section Editing

Use when user wants to **modify existing** sections / pages — not create new ones.

If user wants to CREATE → use `bio-design`, `ecom-setup`, `blog-setup`, etc.

## Always: inspect first

Before editing, fetch current state to know what's there:

```
1. auth_get_session()                       // confirm active store
2. page_list()                              // find the page user means
3. page_get({ page_id })                    // get sections + content
```

`page_get` returns sections with `id`, `position`, `section_type`, `variant`, `content`. Use these IDs for edits.

If user says "edit my home page" → find page with `slug: "home"` from `page_list`.

## Edit a section's content (most common)

```
section_update({
  section_id: <from page_get>,
  content: { ...new content merged with old... }
})
```

⚠️ **Merge, don't replace** — fetch current `content` first, modify the field user wants changed, send back full object. Otherwise other fields wipe out.

Example: change hero title only:
```
// 1. Get current
const page = page_get({ page_id });
const hero = page.sections.find(s => s.section_type === 'hero');

// 2. Merge change
section_update({
  section_id: hero.id,
  content: { ...hero.content, title: "New title" }
})
```

## Change a section's variant

Variant change = layout overhaul. User may need different fields after:

```
1. section_catalog({ section_type: "hero" })   // see available variants + their schemas
2. section_update({ section_id, variant: "split", content: {...adjusted to split's schema...} })
```

Different variants need different fields (e.g. `restaurant` variant needs `background_image` not `image`). Show user the field changes before applying.

## Reorder sections

```
section_reorder({
  page_id,
  section_ids: [hero_id, items_id, gallery_id, footer_id]   // new order
})
```

Or single-section move via `section_update({ section_id, position: 3 })`.

## Delete a section

```
section_delete({ section_id })
```

Confirm with user first — irreversible without backup restore.

## Add a section to existing page

Use `section_upsert` (idempotent — also works for create) or `section_batch_upsert`:

```
section_upsert({
  page_id,
  position: 5,                         // insert at position 5
  section_type: "testimonials",
  variant: "cards",
  content: { ... }
})
```

## Backup & restore (undo)

Dbio auto-snapshots pages on every change. To undo:

```
1. page_backup_list({ page_id })            // see available snapshots
2. page_backup_restore({ page_id, backup_id: <selected> })
```

⚠️ Restore overwrites current state — confirm with user first.

## Edit page metadata (SEO, status, etc.)

```
page_update({
  page_id,
  name?: "...",
  slug?: "...",                              // ⚠️ changing slug breaks existing links
  status?: 1,                                // publish/unpublish
  seo?: { title, description, og_image },
  metadata?: { ... }
})
```

Don't change slug without user explicit OK — breaks URLs.

## Common edit scenarios

### "Đổi tiêu đề hero"
1. page_get(home) → find hero section
2. section_update({ section_id, content: { ...current, title: "New" } })

### "Đổi hình hero"
1. (If new image) media_upload OR media_generate_image → get media_id
2. page_get → find hero
3. section_update({ section_id, content: { ...current, image_url: "<new URL>" } })
   - For variants restaurant/destination/tour/centered: use `background_image` field

### "Sắp xếp lại sections"
1. page_get → list current order
2. Confirm new order with user
3. section_reorder({ page_id, section_ids: [new order] })

### "Xóa section testimonials"
1. page_get → find testimonials section_id
2. Confirm with user
3. section_delete({ section_id })

### "Thêm contact form vào trang home"
1. section_upsert({ page_id, position: 6, section_type: "contact", variant: "form", content: {...} })

### "Quay lại version cũ"
1. page_backup_list({ page_id })
2. Show snapshots with dates, let user pick
3. page_backup_restore({ page_id, backup_id })

## After editing

- If page is published (status:1), changes go live immediately. No need to re-publish.
- If page is draft (status:0), changes saved as draft. Use `page_publish` when ready.
- Storefront has edge cache ~60s — user may see stale for ~1 min after edit.

## Don't

- ❌ Don't `section_update` with `content: { title: "X" }` only — wipes other fields. ALWAYS merge with existing content first.
- ❌ Don't change `slug` without warning user (breaks existing URLs + SEO)
- ❌ Don't delete sections without confirmation
- ❌ Don't `section_update` with wrong variant's schema (call `section_catalog` first)
- ❌ Don't try to edit template_html directly — set fields via content, let renderer handle HTML
