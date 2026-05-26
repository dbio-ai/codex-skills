---
name: ecom-checkout
description: Guide the user through checkout, payment, coupons, and order management for a Dbio e-commerce store. Most operations are dashboard-only — this skill tells the user where to go and what's possible via MCP vs dashboard.
---

# E-commerce Checkout & Operations Guide

Use when user asks about checkout, payment, coupons, orders, customers, refunds, shipping, abandoned cart, etc.

**Important**: Most checkout/order operations are **dashboard-only** for security. This skill mostly tells the user where to go, not what tools to call.

## What CAN be done via MCP

Available tools:
- `store_update` — configure store-level settings (features, currency display)
- `shop_publish` / `shop_unpublish` — go live / pause
- `wallet_balance`, `wallet_transactions` — read-only wallet info
- `quota_check` — see plan limits + usage

## What is DASHBOARD-ONLY (do NOT try to call via MCP)

These are NOT exposed via public MCP — direct user to the dashboard:

| Feature | Where in dashboard |
|---|---|
| Create / edit coupons | Marketing → Coupons |
| List / update orders | Orders tab |
| Refund order | Orders → click order → Refund |
| Payment methods setup | Settings → Payments |
| Shipping rates / zones | Settings → Shipping |
| Tax / VAT config | Settings → Tax |
| Abandoned cart recovery | Marketing → Email Recovery |
| Wallet deposit / withdraw | Wallet tab |
| Custom domain DNS setup | Settings → Domains |

## Payment methods (informational)

- **dbio.ai** → Stripe (cards, Apple Pay, Google Pay, subscriptions)
- **dbio.vn** → SePay (VietQR bank transfer) + Stripe optional
- Self-hosted → custom config

User configures in Dashboard → Payments. MCP cannot set up payment accounts.

## Coupon advice (when user asks)

Tell user: Dashboard → Marketing → Coupons → "New coupon"

Suggested settings:
- First-time discount: 10-15% off
- Cart minimum: 5x discount amount (avoid abuse)
- Time-bound: 7-30 days for urgency
- Limit 1 use per customer (no stacking)

## What this skill CAN do via MCP

### Toggle store features

```
store_update({
  settings: {
    features: {
      customer_accounts: true,
      reviews: true,
      wishlist: true
    }
  }
})
```

### Publish / unpublish

```
shop_publish()       // go live
shop_unpublish()     // take offline (drafts stay)
```

### Check plan limits

```
quota_check()        // current usage + limits
pricing_list()       // available plans
```

## Don't

- ❌ Don't call `coupon_create`, `order_list`, `order_update`, `customer_list` — NOT in public MCP
- ❌ Don't try to set up Stripe/SePay via MCP — dashboard-only
- ❌ Don't promise to manage orders from chat
- ❌ Don't claim refunds can be processed via MCP
