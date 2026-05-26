---
name: content-write
description: Write copy for any Dbio site element — headlines, descriptions, CTAs, product descriptions, about pages, hero text. Auto-detects context (industry, store type, page type) and adjusts tone accordingly.
---

# Content Writing (context-aware)

Use when user needs copy for any text element on their Dbio site. This skill is cross-cutting — works for ecom products, blog posts, landing heroes, restaurant menus, etc.

## ALWAYS detect context first

Before writing, gather:

1. `auth_get_session()` → user locale (vi/en/...), active store
2. Active store info: name, store_type, tags (industry), currency
3. (If editing existing page) `page_get({ page_id })` → current content + tone
4. Ask user for specifics if unclear

Build a CONTEXT object internally:
```
{
  locale: "vi",
  store_type: "ecomm",
  industry: "food",                  // from store.tags[0]
  page_type: "landing",              // or "blog", "product_detail", etc.
  brand_name: "Cafe Mekong",
  target_audience: "<inferred from user input>",
  tone_keywords: ["warm", "authentic"]
}
```

## Tone matrix (auto-select)

| Context | Tone | Examples |
|---|---|---|
| ecomm + food | Sensory, warm, sometimes nostalgic | "Hương vị truyền thống, công thức gia đình 3 đời" |
| ecomm + fashion | Aspirational, confident | "Designed for the bold. Made for every day." |
| ecomm + tech/SaaS | Clear, benefit-led | "Ship faster. Sleep better." |
| ecomm + service | Trust + expertise | "20+ năm đồng hành cùng doanh nghiệp Việt" |
| landing + bio | Authentic, personal | "Writer. Maker. Coffee enthusiast." |
| blog | Conversational, depth | "Last week I made the mistake of..." |
| wiki/docs | Direct, no fluff | "Install with `npm install dbio`." |
| restaurant landing | Warm + appetizing | "Bún bò Huế thật, không pha công thức nhanh" |
| event landing | Energetic + urgent | "Đăng ký trước 30/6 — chỉ còn 100 chỗ" |
| course landing | Outcome-focused | "Học xong, bạn có thể launch website đầu tiên" |

## By element type

### Hero (5-9 words title + 10-20 words subtitle + 1-3 words CTA)

```
title:    benefit-first hook
subtitle: qualifier + target audience
cta_text: verb-led action
```

Examples:
- F&B: `"Cafe Sài Gòn xưa, hương vị nay" / "Pha thủ công mỗi ngày, không hương liệu" / "Đặt bàn"`
- SaaS: `"Build sites with AI in minutes" / "From bio link to full storefront — one tool" / "Get started"`

### Product description

```
short_description: 1-2 sentence hook (product cards)
description: HTML, 3-5 paragraphs:
  Para 1: What it is + key benefit
  Para 2: Who/when to use
  Para 3: Specs / ingredients / materials
  Para 4: Trust signals (origin, awards)
  Para 5: CTA / FAQ snippet
```

For VN F&B: include sourcing story ("nguyên liệu organic từ Đà Lạt"), preparation method, allergens.
For fashion: fit guide, material composition, care instructions.
For services: outcome promise, duration, what's included.

### About / Story page

5-paragraph template:
1. Origin (when, why we started)
2. Mission (what we believe)
3. Approach (how we work)
4. People (who's behind it, optional)
5. Invite (what we want with reader)

Field name: `story` (NOT `description`).

### Blog post

Trigger `blog-write` skill — it has more detailed structure.

### CTA copy

- ✅ "Get started", "Order now", "Book a table", "Tải xuống miễn phí"
- ❌ "Click here", "Submit", "Read more"

### Email / notification copy

Subject: 30-50 chars, action-oriented
Preview: 50-100 chars, continuation of subject
Body: 50-150 words, single CTA

## SEO when relevant

If writing for a page with public traffic:
- Title tag: 50-60 chars, brand at end
- Meta description: 140-160 chars, include primary keyword + value
- H1 = hero title (only 1 per page)
- Alt text on images (descriptive, NOT keyword-stuffed)

Set via `page_update({ seo: { title, description, og_image } })`.

## Localization rules

### Vietnamese (vi)
- Pronouns: "bạn" (default, friendly), "anh/chị" (formal B2B), "mình" (very casual creator)
- Avoid English jargon when VN equivalent exists ("ship" → "giao hàng", "checkout" → "thanh toán")
- Currency: 99,000₫ or 99k (informal) — match store currency
- Numbers: Vietnamese number format (dấu phẩy ngăn cách hàng nghìn)

### English (en)
- Active voice, contractions OK
- Second person ("you")
- US English unless store targets UK/AU
- Currency: $9, $9.00 (no leading $0)

## Don't

- ❌ Don't translate VN→EN literally — rewrite for English audience
- ❌ Don't use buzzword salad ("synergize", "leverage", "disrupt")
- ❌ Don't fill placeholder text — ask user for real info
- ❌ Don't write 3rd person for solo creators (unless they prefer)
- ❌ Don't promise outcomes user can't deliver
- ❌ Don't use AI-generated text as-is — always offer for user review
