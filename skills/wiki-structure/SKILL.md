---
name: wiki-structure
description: Structure a knowledge base, documentation site, or help center on Dbio. Use when user wants to build docs, wiki, KB, internal docs, or hierarchical guides.
---

# Wiki / Knowledge Base Structure

Use when user wants to build documentation, knowledge base, help center, or hierarchical guide content.

## Prerequisites

- Store with `store_type: wiki`
- `store_select` active

If user has different store type, suggest creating new wiki store (don't convert).

## Wiki characteristics

- Hierarchical navigation (parent-child pages)
- Sidebar TOC always visible
- Search-heavy (most users land via search, not browse)
- Long-form, often dry content
- Versioning matters (changelogs, version selector)

## Recommended flow

### 1. Try template_browse first

```
template_browse({
  store_type: "wiki",
  tag: "docs",
  limit: 10
})
```

### 2. Plan information architecture

Ask user about:
- What's being documented (product/API/process)
- Audience (devs, end-users, internal team)
- Existing content sources (Google Docs, Notion, markdown files)

Standard wiki IA:
```
/                        — Home (overview + popular articles)
/getting-started/        — Onboarding category
   /quickstart
   /installation
   /first-steps
/guides/                 — How-to guides
   /<topic-1>
   /<topic-2>
/reference/              — API/spec reference
   /<endpoint-1>
   /<endpoint-2>
/changelog/              — Version history
/faq/                    — Frequently asked
```

### 3. Create pages with hierarchy

Wiki pages use `page_create`. Available `profile_type` values (verify with `page_schema()`): `landing`, `blog`, `portfolio`, `service`, `place`, etc. There is no dedicated `wiki` profile_type — use `landing` for category pages and `blog` for individual articles, OR use `page_schema()` to see what the store's `wiki` store_type expects.

```
// Top-level category page
page_create({
  name: "Getting Started",
  slug: "getting-started",
  profile_type: "landing",       // or whatever page_schema recommends
  status: 1
})

// Article page (sub-page)
page_create({
  name: "Quickstart",
  slug: "quickstart",
  profile_type: "blog",          // long-form article
  status: 1
})
```

For parent-child hierarchy: Dbio routes nested pages by slug pattern (`/category/article`). Set the article's slug to include parent path, OR use `page_set_domain` to set custom routes. Check `page_schema()` for the wiki store_type's exact hierarchy mechanism.

⚠️ Call `page_schema()` FIRST to confirm the available profile_types and field contracts for the active wiki store. Schema may evolve.

### 4. Add content sections to each wiki page

Standard wiki page sections:
1. `hero` variant `wiki-header` (title, breadcrumb, last-updated)
2. `content` variant `article-body` (main content, markdown→HTML)
3. (optional) `cta` variant `next-prev` (navigate to next/prev article)

```
section_upsert({
  page_id, section_type: "content", variant: "article-body",
  content: {
    body_html: "<the content>",
    toc: true,                     // auto-generate in-page TOC from H2/H3
    last_updated_at: "2026-05-26"
  }
})
```

### 5. Sidebar TOC

Wiki store auto-generates sidebar from `bio_profiles` hierarchy. Order via `position`:

```
page_update({ page_id, position: 10 })  // lower = higher in sidebar
```

Group section headers (categories) appear automatically based on `parent_id` tree.

### 6. Search configuration

Built-in full-text search on wiki content. No config needed by default. To boost:
- Use H2/H3 in content (search prioritizes headings)
- Add `keywords` to bio metadata
- Set `excerpt` for snippet display

### 7. Versioning (manual)

Dbio doesn't have native version selector yet. Workarounds:
- Slug pattern: `/v1/quickstart`, `/v2/quickstart`
- Or: use separate stores per major version + cross-link

Add to roadmap: native version selector for wiki.

## Markdown content tips

If user has existing markdown, convert via `mdToHtml` pipeline (backend supports). Pass markdown to `body_html` field — backend renders.

For code blocks, use fenced syntax:
````
```typescript
const foo = 'bar';
```
````

Backend auto-applies syntax highlighting.

## Internal linking

Cross-reference between wiki pages:
- Relative links: `/guides/topic-1` (preferred — survives domain changes)
- Backend auto-rewrites if pages renamed (via slug history)

## "Edit this page" link

Add to wiki footer for community contribution (if open-source docs):
```
store_update({
  settings: {
    wiki: {
      edit_url_pattern: "https://github.com/org/docs/edit/main/{slug}.md",
      show_last_updated: true,
      show_authors: false
    }
  }
})
```

## QA checklist

- [ ] Sidebar shows hierarchy correctly
- [ ] Search finds keywords
- [ ] Code blocks render with highlighting
- [ ] In-page TOC works (H2/H3 anchors)
- [ ] Mobile sidebar collapses
- [ ] Breadcrumbs show path
- [ ] Last-updated date visible
- [ ] Internal links don't 404

## Don't

- ❌ Don't add `header`/`footer` sections to individual wiki pages (inherit from landing)
- ❌ Don't create flat structure (no hierarchy) — defeats purpose
- ❌ Don't bury important docs 4+ levels deep
- ❌ Don't forget mobile — wiki sidebar needs hamburger menu
