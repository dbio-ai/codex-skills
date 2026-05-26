---
name: ecom-product
description: Create products with images, categories, brands, variants on Dbio e-commerce store. Use when user wants to add products to their ecomm store — single product, bulk import, or with AI-generated images.
---

# Product Creation (Ecommerce)

Use when adding products to an active store.

## Single product

```
product_create({
  name: "Cà phê sữa đá",
  price: 35000,
  sale_price: 30000,                    // optional
  product_type: "physical",             // physical | digital | service | tour | room | ticket
  status: 1,
  description: "<p>HTML mô tả chi tiết</p>",
  short_description: "Cafe truyền thống VN",
  category_names: ["Đồ uống", "Cafe"],  // backend matches or creates per-store
  brand_name: "ABC Cafe",               // optional
  tags: ["best-seller", "signature"],
  attribute_specs: [                    // optional, for variants
    { attribute_name: "Size", value_names: ["S", "M", "L"] }
  ]
})
```

## Pricing

- `price` and `sale_price` in store's currency (NO conversion — store decides)
- For VND: integer (e.g. `35000` = 35,000 ₫)
- For USD: decimal (e.g. `9.99`)
- `sale_price` < `price` triggers discount badge on UI

## Product types

| Type | Use for |
|---|---|
| `physical` | Tangible goods (default) |
| `digital` | Downloads, ebooks, software |
| `service` | Appointments, consulting |
| `tour` | Tour packages |
| `room` | Hotel rooms, rentals |
| `ticket` | Event tickets |

## Images

Two ways:

### A. Generate with AI
```
media_generate_image({
  prompt: "Vietnamese iced coffee glass, condensed milk, ice cubes, brown wood table, natural lighting, food photography, 4K",
  count: 1, aspect: "1:1"
})
// Returns media_id → use in product_image()
```

### B. Upload existing
```
media_upload({ ... })       // returns media_id
product_image({ product_id, media_id, position: 0 })
```

Recommend 3-4 images per product:
1. Hero — clean background
2. Lifestyle — in use
3. Detail — close-up
4. Variations — different angles/colors

## Variants (size, color, material)

Pass `attribute_specs` at create time. Backend creates variants automatically.

For per-variant pricing/stock, use `product_variant_update` after creation.

For variant images: `product_variant_image({ variant_id, media_id })`.

## Bulk creation

For 5+ products, batch them:
1. Generate all images first (parallel `media_generate_image` calls)
2. Then `product_create` for each
3. Confirm with user every 5 products

## Field name gotchas

- ✅ `category_names: ["..."]` (array of strings) — backend resolves
- ❌ `category_ids: [123]` — don't use, agents shouldn't know shard IDs
- ✅ `brand_name: "..."` — backend resolves
- ❌ `brand_id: 456` — same reason
- ✅ `attribute_specs: [{ attribute_name, value_names }]`
- ❌ `attributes: [...]` — wrong field name

## After creating products

Trigger `bio-design` to add a products section to the landing page, OR suggest user check `/products` page on their site.
