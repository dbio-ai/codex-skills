---
name: bio-design
description: Design bio link pages and personal landing pages on Dbio (single_page type — link-in-bio, CV, profile, business card). For ecommerce/blog/wiki/event use the vertical-specific skill instead.
---

# Bio / Personal Landing Page Design

Use when user wants to build a **bio link** or **personal landing page** on a `single_page` store. For other use cases, use the vertical-specific skill:

- E-commerce store → `ecom-setup`
- Blog / news → `blog-setup`
- Wiki / docs → `wiki-structure`
- Event landing → `landing-cta` + event template
- Multi-page site → `template-search` first, then specific verticals

## Prerequisites

- Active store with `store_type: single_page` (or `multi_page` if user wants nav)
- `store_select` called

## Standard bio link / landing sections

For a typical personal bio or solo creator landing:

1. `header` (optional on single_page — only if has nav)
2. `hero` variant `minimal` or `split` (name + tagline + CTA)
3. `items` variant `link-grid` (key links: portfolio, social, contact)
4. `gallery` variant `masonry` (visual showcase if creator/artist)
5. `content` variant `story` (short about, 2-3 paragraphs)
6. `testimonials` variant `cards` (social proof, 3-5 quotes)
7. `cta` variant `floating` (sticky contact/follow CTA)
8. `footer` (social links, copyright)

For business landing (service business, solo founder):

1. `hero` variant `split` (value prop + hero image)
2. `features` variant `icon-grid` (3-4 benefits)
3. `process` variant `steps` (how it works, 3-5 steps)
4. `testimonials`
5. `cta` variant `banner` (book consultation / contact)
6. `footer`

## Section variants quick reference

Call `section_catalog()` for the full list. Common variants:

| Section | Variants | When to use |
|---|---|---|
| `hero` | minimal, split, centered, restaurant, tour, product | minimal for bio, split for business |
| `items` | link-grid, services, menu | link-grid for bio, services for business |
| `content` | story, split-image, timeline, custom | story for about |
| `gallery` | grid, masonry, carousel, lightbox | masonry for creative |
| `testimonials` | cards, slider, featured, minimal | cards for general |
| `cta` | banner, split, floating, inline | floating for sticky |

## Field name gotchas

Common WRONG → CORRECT:
- testimonials: `quote` → `content`, `name` → `author_name`, `role` → `author_title`, `avatar` → `author_avatar`
- about: `description` → `story`
- footer: `brand` → `logo_text`, columns `items[].text` → `links[].label`, `items[].link` → `links[].url`
- hero (restaurant/destination/tour/centered): use `background_image`, NOT `image`

## Mustache rule

All section content uses Mustache. NEVER hardcode text in template_html. Pass data via `content` field — backend auto-resolves `product_ids`, `media_id`, etc.

## Add sections

Use `section_upsert` (idempotent), or batch:

```
section_upsert({
  page_id, position: 1, section_type: "hero", variant: "minimal",
  content: { title, subtitle, avatar_image, cta_text, cta_link }
})

// Or many at once
section_batch_upsert({ page_id, sections: [...] })
```

## Theme

After sections, trigger `theme-customize` skill to apply preset matching the vibe.

## Header/footer inheritance

For sub-pages on multi_page stores (not bio link), DO NOT add header/footer — they inherit from store landing.

For single_page bio, all sections live on 1 page — no inheritance.

## Publish

```
page_publish({ page_id })
// or store_update({ status: 1 }) + page_update({ status: 1 })
```

## After designing

Trigger `landing-cta` if user wants conversion optimization.
Trigger `theme-customize` for visual styling.
Trigger `publish-deploy` for custom domain.

## Editing an EXISTING page?

→ Use `page-edit` skill instead. This skill is for designing NEW pages from scratch.

## Something broken?

→ Use `fix-issues` skill for diagnostics (page not visible, broken images, CSS issues).

## Don't

- ❌ Don't add `products` section to a bio link (use ecom-setup for that)
- ❌ Don't add complex sections (cart, checkout) to bio link
- ❌ Don't write custom template_html — use registry variants
- ❌ Don't add header/footer to sub-pages (inheritance handles it)
