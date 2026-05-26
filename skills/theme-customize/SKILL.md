---
name: theme-customize
description: Customize Dbio store theme — colors, typography, spacing, design tokens. Use when user wants to change look-and-feel, apply a preset, or adjust theme tokens.
---

# Theme Customization

Use when user wants to change colors, fonts, spacing, or overall visual style.

## Step 1: Discover presets

```
theme_list_presets()
```

Returns a list of curated themes (e.g. "minimal-dark", "warm-food", "coastal", "bold-tech").

If user describes a style ("I want it to feel warm and friendly"), suggest matching preset.

## Step 2: Apply preset

```
theme_apply_preset({ preset: "warm-food" })
```

This overwrites all theme tokens. Confirm with user before applying if they have custom tokens already.

## Step 3: Fine-tune tokens

After preset, adjust specific tokens:

```
theme_update_tokens({
  tokens: {
    "--color-primary": "#d4621c",
    "--color-bg": "#fff8f0",
    "--font-display": "Playfair Display",
    "--radius-card": "12px"
  }
})
```

### Common tokens

```
Color:
  --color-primary, --color-secondary, --color-accent
  --color-bg, --color-surface, --color-text, --color-text-muted
  --color-border, --color-success, --color-error

Typography:
  --font-display    (headings)
  --font-body       (paragraphs)
  --font-mono       (code)
  --text-base       (root font-size, e.g. "16px")

Spacing:
  --space-1, --space-2, --space-4, --space-8 (in rem)

Border:
  --radius-card, --radius-button, --radius-input

Shadow:
  --shadow-sm, --shadow-md, --shadow-lg
```

All token keys use `--` prefix (CSS custom property style).

## Step 4: Preview

Suggest user visit their site URL (`get_urls()` returns the live URL) to preview changes. Changes apply instantly (no rebuild).

## Reset

To reset to default: `theme_apply_preset({ preset: "default" })`.

## Don't

- ❌ Don't write custom CSS in template_html — Dbio CSS compiler strips `flex-wrap`, `grid`, `clamp()`, `max-width` from template_css. Use inline `style` attributes instead.
- ❌ Don't combine multiple presets — apply one, then customize tokens.
- ❌ Don't hardcode colors in section content — always reference tokens for consistency.
