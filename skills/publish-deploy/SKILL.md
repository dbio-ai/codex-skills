---
name: publish-deploy
description: Publish a Dbio store, set up custom domain, manage subdomains. Use when user wants to make their site live, connect a custom domain, or verify DNS.
---

# Publish & Deploy

Use when user wants to publish their site or connect a custom domain.

## Step 1: Publish the store

```
shop_publish()
```

Makes the store + all published pages live. Default URL:
```
{global_code}.dbio.ai     (international platform)
{global_code}.dbio.vn     (Vietnam platform)
```

Get the live URL:
```
get_urls()
```

## Step 2: Publish individual pages

Each page has its own `status`. Set `status: 1` to publish:
```
page_update({ page_id, status: 1 })
// or
page_publish({ page_id })
```

Pages with `status: 0` are drafts (not public).

List drafts:
```
page_list({ status: 0 })
```

## Step 3: List current domains

```
domain_list()
```

Returns subdomain + any custom domains attached.

## Step 4: Add a custom domain

```
domain_add_custom({
  store_id: <active store id>,
  domain: "mycafe.com"     // lowercase, no scheme
})
```

Returns `verification_token` (DNS TXT value).

## Step 5: User adds DNS records

Instruct user to add 2 DNS records at their domain registrar:

```
1. TXT record (for verification):
   Type: TXT
   Name: _dbio-verify.mycafe.com
   Value: <verification_token from step 4>

2. CNAME (for routing):
   Type: CNAME
   Name: @  (or "www")
   Value: domains.dbio.ai
```

Wait 5-30 minutes for DNS propagation (`.vn` TLD can take up to 2 hours).

## Step 6: Verify the domain

```
domain_verify({
  store_id: <active store id>,
  domain: "mycafe.com"
})
```

If DNS TXT propagated, domain becomes active. SSL auto-issued via Cloudflare within minutes.

If verification fails: ask user to wait longer (DNS hasn't propagated) and retry.

Pending custom domains auto-expire after 7 days if unverified.

## Step 7: Set primary domain

If multiple domains, mark which is canonical:
```
domain_set_primary({ store_id, domain: "mycafe.com" })
```

## Step 8: Verify deployment

After publishing, ask user to visit the URL. Common checks:
- All pages load (200, not 404)
- Images render
- Menu links route correctly
- Mobile view OK
- Forms submit (contact, checkout)

## Unpublish

```
shop_unpublish()       // take store offline
```

Or set individual page `status: 0` via `page_update`.

## Remove a domain

Domain removal is **dashboard-only** for safety — instruct user: Dashboard → Settings → Domains → Remove.

## Don't

- ❌ Don't call `domain_purchase`, `domain_search`, `cache_clear` — these are dashboard-only
- ❌ Don't promise instant DNS propagation — say "up to 30 minutes" (`.vn` up to 2h)
- ❌ Don't forget the TXT verification record — domain stays pending without it
- ❌ Don't claim SSL is auto if user's DNS isn't pointed at Dbio yet
