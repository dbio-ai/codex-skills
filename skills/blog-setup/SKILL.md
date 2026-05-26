---
name: blog-setup
description: Set up a blog or news site on Dbio (multi-page with article list, categories, tags, search). Use when user wants to start a blog, news site, content site, or magazine on Dbio.
---

# Blog Setup

Use when user wants a content-driven multi-page site: blog, news, magazine, knowledge sharing.

## Prerequisites

- Store with `store_type: multi_page` and `tags: ["blog"]` (or `news`, `magazine`)
- `store_select` active

If user has no store yet → trigger `store-create` first, then come back.

## Recommended flow

### 1. Always try template_browse first

```
template_browse({
  store_type: "multi_page",
  tag: "blog",
  limit: 10
})
```

If template found → clone via `template_clone_store`, skip to step 5.

### 2. Create landing bio for blog homepage

```
page_create({ name: "Home", slug: "home", profile_type: "landing", status: 0 })
```

### 3. Add core sections to landing

Standard blog landing:
1. `header` with logo + nav (Home, Categories, About, Contact)
2. `hero` — featured post or tagline
3. `content` variant `featured-articles` — top 3 featured posts (use `products_filter` style for blog posts)
4. `items` variant `article-grid` — recent posts
5. `cta` — newsletter signup
6. `footer` — categories + social

### 4. Add article template page

Blog posts use `profile_type: blog` bio pages, slug = post slug:

```
page_create({
  name: "How to brew Vietnamese coffee",
  slug: "how-to-brew-vietnamese-coffee",
  profile_type: "blog",
  status: 0
})
```

Each blog post has standard sections:
1. `hero` variant `article-header` (title, author, date, cover image, read time)
2. `content` variant `article-body` (markdown/HTML body)
3. `cta` (related articles or newsletter)
4. Footer inherited from store landing

### 5. Categories & tags

Categorization for blog posts uses `metadata` on the page (not the ecommerce catalog). Call `page_schema({ profile_type: "blog" })` first to confirm available fields, then:

```
page_update({
  page_id,
  metadata: {
    categories: ["Tutorials", "Recipes"],
    tags: ["coffee", "vietnamese", "beginner"]
  }
})
```

If the storefront supports `/category/<slug>` archive pages, those are auto-generated from `metadata.categories`. Check `page_schema()` for the exact contract.

### 6. Menu

Set store menu pointing to category pages:
```
store_update({
  settings: {
    menu: [
      { label: "Home", type: "link", link: "/" },
      { label: "Tutorials", type: "link", link: "/category/tutorials" },
      { label: "Recipes", type: "link", link: "/category/recipes" },
      { label: "About", type: "link", link: "/about" }
    ]
  }
})
```

ALWAYS include `type: 'link'` on menu items.

### 7. SEO essentials

For each post:
```
page_update({
  page_id,
  seo: {
    title: "<post title> | <site name>",   // 50-60 chars
    description: "<meta description>",      // 140-160 chars
    og_image: "<cover image URL>",
    canonical: "<full URL or null>"
  }
})
```

### 8. Newsletter integration

Add a `newsletter` section on landing + every post footer:
```
section_upsert({
  page_id, section_type: "newsletter", variant: "inline",
  content: {
    title: "Nhận bài mới mỗi tuần",
    subtitle: "Không spam, hủy bất kỳ lúc nào",
    cta_text: "Đăng ký"
  }
})
```

Subscribers saved to `customers` table.

### 9. Search

Built-in search works automatically if `store_type` enables `search` feature. No config needed.

## Writing posts

Trigger `blog-write` skill for actual content generation.

## Publish workflow

- Draft: `status: 0` (not visible)
- Publish: `page_update({ status: 1 })` or `page_publish({ page_id })`
- Schedule: `page_update({ publish_at: "2026-06-01 09:00:00", status: 0 })` — auto-publishes at that time

## QA checklist

- [ ] Home page shows recent posts
- [ ] Each post has cover image
- [ ] Categories work (visit /category/xxx)
- [ ] Tags work (visit /tag/xxx)
- [ ] Newsletter signup tested
- [ ] SEO meta on all posts
- [ ] Mobile reading experience smooth
- [ ] Reading time displayed

## Don't

- ❌ Don't add header/footer sections to individual blog posts — inherit from landing
- ❌ Don't hardcode post lists — use products_filter style for dynamic
- ❌ Don't forget alt text on images (SEO + accessibility)
