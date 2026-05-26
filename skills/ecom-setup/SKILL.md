---
name: ecom-setup
description: Set up an e-commerce store on Dbio — full pipeline of products, categories, brands, sections, checkout. Use when user wants to build an online shop, sell products, restaurant ordering, or convert existing site to e-commerce.
---

# E-commerce Setup

Use when building or configuring an e-commerce store (`store_type: ecomm`).

## Prerequisites

- Store created with `store_type: ecomm` (or `tags` including `shop`, `food`, etc.)
- `store_select` already active

If user has a `single_page` or `multi_page` store: ask if they want to convert to `ecomm` (requires recreating store, NOT in-place upgrade).

## Recommended flow

### 0. Try template_browse FIRST

Before manual setup, trigger `template-search` skill:
```
template_browse({
  query: "<niche> online store",
  store_type: "ecomm",
  industry: "<inferred>",
  features: ["cart", "checkout"]
})
```

If a matching template exists → clone it via `template_clone_store` → skip to step 5 for customization.

### 1. Add products first

Trigger `ecom-product` skill. Suggest at least 3-5 products before designing the landing page (so product sections have data).

### 2. Categories & brands (auto-managed)

Don't ask user for category IDs. When creating products, pass `category_names: ["Đồ uống", "Cafe"]` and `brand_name: "ABC"`. Backend matches or creates per-store.

### 3. Landing page

Trigger `bio-design`. For e-commerce, ensure these sections:
- `hero` with cta to shop
- `products` section with `product_ids` (curated) OR `products_preset: 'featured'` / `'latest'` / `'on_sale'`
- `cta` "View all products" linking to `/products`

Default product card shows: image, title, price, sale_price, "Add to cart". Configure via `show_add_to_cart: true`.

### 4. System pages

These exist by default — no need to create:
- `/products` — product listing
- `/products/:slug` — product detail
- `/cart`, `/checkout` — checkout flow

To customize, use `page_create` for `about`, `contact`, `faq`. See `page_schema()` for available page types.

### 5. Currency & payment

- Currency set at store level (`stores.currency`).
- Payment methods configured per platform automatically:
  - dbio.ai → Stripe (cards, Apple Pay, Google Pay)
  - dbio.vn → SePay (VietQR bank transfer) + Stripe
- User configures payment account in dashboard, not via MCP.

### 6. Bank transfer card (VN market)

For VN ecomm, add a `contact` page with bank QR section:
- `section_type: 'content', variant: 'custom'`
- Use VietQR sample image: `s3.dbio.ai/templates/vn/qr-bank-sample.png`

### 7. Inventory

Stock managed via `product_update({ stock_quantity, stock_status })`. InventoryDO handles atomic decrement at checkout.

### 8. Coupons (optional)

Create via `coupon_create({ code, discount_type, discount_value })`. Show on cart page.

## QA checklist before publish

- [ ] At least 3 products with images
- [ ] Landing has products section
- [ ] Menu has `/products` link with `type: 'link'`
- [ ] `/contact` page has phone, email, address
- [ ] Currency matches user expectation
- [ ] Payment method configured (check via dashboard, MCP can't do this)
