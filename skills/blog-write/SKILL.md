---
name: blog-write
description: Write blog posts and articles for Dbio — SEO-optimized, well-structured content. Use when user wants to draft a blog post, news article, or tutorial.
---

# Blog Post Writing

Use when user wants to draft a blog post, news article, or any long-form content for a Dbio blog.

## Detect context

1. Call `auth_get_session()` for locale + active store
2. Read store's existing posts (`page_list({ profile_type: 'blog' })`) to match tone/voice
3. Ask user for: topic, target keyword, desired length, tone (if not clear)

## Article structure (default 800-1500 words)

```
1. HOOK (50-100 words)
   - Pattern interrupt: question / surprising stat / story
   - State the problem clearly
   - Promise of value (what reader will gain)

2. BODY (3-6 sections, H2 headers)
   - Each section: 1 main point + example/data + actionable advice
   - Short paragraphs (2-4 sentences)
   - Bullet lists for scannable info
   - Subheadings every 200-300 words

3. CONCLUSION (50-100 words)
   - Recap key takeaways (3 bullets)
   - Single clear next action
   - CTA (subscribe / try / contact)
```

## Title formulas (pick one)

- **How-to**: "How to [achieve outcome] in [time/method]"
- **Listicle**: "[Number] [adjective] [things] for [audience]"
- **Question**: "Should you [action]? Here's the truth"
- **Story**: "What I learned from [experience]"
- **Comparison**: "[X] vs [Y]: which is better for [use case]?"

Length: 50-65 chars (SEO + social sharing optimal).

## SEO essentials

For each post:

```
page_update({
  page_id,
  seo: {
    title: "<H1 title>",                  // 50-60 chars
    description: "<one-paragraph summary>", // 140-160 chars, include keyword + CTA
    og_image: "<cover image URL>",          // 1200x630
    keywords: ["primary", "secondary"]      // 3-5 tags
  }
})
```

In content:
- H1: post title (only 1)
- H2: section headers (3-6)
- H3: sub-sections within H2
- Keyword in: title, first 100 words, 1-2 H2, meta description, image alt text
- Internal links: 2-3 links to other posts/pages on same site
- External links: 1-2 to authoritative sources

## Cover image

Generate with AI:
```
media_generate_image({
  prompt: "<visual concept matching post topic>, blog cover image, 1200x630, clean composition, brand-friendly",
  aspect: "16:9"
})
```

Set as post cover:
```
page_update({ page_id, cover_media_id: <id> })
```

## Body content as portable text

Dbio uses Portable Text for blog body (rich content). Pass to section:

```
section_upsert({
  page_id, section_type: "content", variant: "article-body",
  content: {
    body_html: "<rendered HTML with proper headings, lists, blockquotes>"
    // OR use portable_text format if available
  }
})
```

Note: there's currently a known bug with portable text SSR rendering — prefer HTML for now.

## Voice & tone matrix

| Audience | Voice |
|---|---|
| Technical / dev | Direct, code examples, no fluff |
| Marketing / SMB | Practical, ROI-focused, case studies |
| Lifestyle / consumer | Warm, story-driven, sensory |
| News / journalism | Inverted pyramid (lead with conclusion), source citations |
| Tutorial | Step-by-step, screenshots, "you'll" phrasing |

Match user's locale:
- VI: avoid English jargon when VN equivalent exists; use "bạn" not "anh/chị"
- EN: active voice, contractions OK, second person ("you")

## Reading time

Calculated automatically by Dbio (250 wpm). Show in hero meta. Aim for 5-8 min reads (sweet spot for engagement).

## After writing

- Suggest schedule publish via `page_update({ publish_at: "..." })`
- Suggest social share copy (1 tweet + 1 LinkedIn post)
- Suggest 3-5 related posts to internal-link from this article
- If user has newsletter: suggest email teaser

## Don't

- ❌ Don't keyword-stuff (1-2% density max)
- ❌ Don't use AI-generated text without user review — always offer edits
- ❌ Don't write 3000+ words just for SEO — depth > length
- ❌ Don't promise outcomes the user can't deliver (overclaim)
