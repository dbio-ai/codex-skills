---
name: landing-cta
description: Optimize landing page CTAs (call-to-action), lead capture forms, and conversion flow on Dbio. Use when user wants to improve conversions, add signup/contact forms, or refine hero/CTA copy on a landing page.
---

# Landing Page CTA Optimization

Use when user wants to improve a landing page's conversion — clearer CTAs, better lead capture, hero refinement.

## Prerequisites

- Active store + bio page being edited
- Page type usually `single_page` landing, but works on any bio with hero/cta sections

## CTA principles

### 1. One primary CTA per page

Multiple CTAs = decision paralysis = lower conversion. Pick ONE primary action, repeat it 2-4 times down the page:
- Hero: primary CTA
- Mid-page: same CTA, different copy variant
- Footer/sticky: primary CTA again

Secondary CTA (e.g. "Learn more") OK, but visually de-emphasized.

### 2. CTA copy formula

`[Verb] + [specific outcome]`

- ✅ "Đặt bàn ngay" / "Get started free" / "Book a demo"
- ❌ "Submit" / "Click here" / "Learn more" (too vague)

Bonus: add urgency or value
- "Đặt bàn — giữ chỗ 30s"
- "Start free — no credit card"

### 3. CTA placement

Update via `section_upsert`:

```
section_upsert({
  page_id, position: 1, section_type: "hero",
  variant: "split",
  content: {
    title: "Cafe Sài Gòn xưa, hương vị nay",
    subtitle: "Pha thủ công mỗi ngày, không hương liệu công nghiệp",
    cta_text: "Đặt bàn ngay",
    cta_link: "#contact",          // OR "/contact" if multi-page
    cta_style: "primary"
  }
})
```

For sticky CTA on scroll: add `section_type: "cta"` with `variant: "floating"`.

## Lead capture form

Add a contact/signup section:

```
section_upsert({
  page_id, section_type: "contact", variant: "form",
  content: {
    title: "Để lại thông tin, chúng tôi liên hệ trong 1h",
    fields: [
      { name: "name", label: "Họ tên", type: "text", required: true },
      { name: "phone", label: "SĐT", type: "tel", required: true },
      { name: "message", label: "Lời nhắn", type: "textarea" }
    ],
    submit_text: "Gửi",
    success_message: "Cảm ơn! Chúng tôi sẽ liên hệ trong 1h.",
    notification_email: "owner@store.vn"   // where submissions go
  }
})
```

Submissions saved to `customers` table + email notification to owner.

## A/B test CTAs (manual)

Dbio doesn't have built-in A/B test yet. Manual approach:
1. Publish version A
2. Track metrics for 1 week (use `platform_stats`)
3. Edit hero CTA copy → version B
4. Track another week
5. Compare conversion rate

## Hero variants by use case

| Use case | Hero variant | Key fields |
|---|---|---|
| SaaS / product | `split` or `centered` | title, subtitle, cta_text, hero_image |
| Restaurant | `restaurant` | + open_hours, rating, address |
| Tour / travel | `tour` | + duration, group_size, difficulty |
| Event landing | `centered` + `background_image` | + date, location, ticket_cta |
| Bio link | `minimal` | title, tagline, avatar |
| Course | `split` | + duration, price, level |

## Trust signals near CTA

Reduce friction by adding social proof near primary CTA:
- Testimonial snippet
- Customer logos
- "Trusted by 500+ businesses"
- Rating/reviews count

Add via separate `testimonials` or `trust_badges` section ABOVE the CTA.

## Mobile CTA

- Use sticky bottom CTA on mobile (variant `floating`)
- Tap target: min 44px height
- Phone CTA on F&B/service: `cta_link: "tel:+84..."` opens dialer

## Don't

- ❌ Don't use 3+ different CTAs ("Book", "Call", "Sign up", "Learn more" all at once)
- ❌ Don't put CTA before the value prop — user needs context first
- ❌ Don't auto-open contact form on page load (annoying)
