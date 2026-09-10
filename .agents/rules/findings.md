# Findings & Discoveries

## Storefront (Next.js + Medusa)

### 1. Button Component Overrides Custom Styles
**File:** `src/modules/common/components/ui/index.tsx`

The shared `Button` component's `primary` variant hardcodes `bg-black text-white hover:bg-gray-800 rounded-md` in the `clsx` call **before** the consumer `className` prop. Because Tailwind applies equal-specificity classes in source order, custom classes like `text-black` or `bg-white` passed via `className` are **silently ignored**.

**Fix:** Use a plain `<button>` element when you need full style control (e.g. product page Add to Cart / Buy it Now buttons).

---

### 2. `useEffect` Option Init + `router.replace()` = State Reset Bug
**File:** `src/modules/products/components/product-actions/index.tsx`

**Pattern that breaks:**
```tsx
// ❌ BAD — triggers infinite loop of: option change → URL sync → Suspense refetch → state reset
const [options, setOptions] = useState({})

useEffect(() => {
  setOptions(optionsAsKeymap(product.variants[0].options))
}, [product.variants])

useEffect(() => {
  router.replace(pathname + "?" + params.toString())
}, [selectedVariant, isValidVariant])
```

When the user picks a variant option:
1. `setOptions` runs → `selectedVariant` changes
2. The URL sync `useEffect` calls `router.replace()`
3. Next.js App Router triggers a soft re-render of the Suspense boundary
4. `ProductActionsWrapper` (async server component inside `<Suspense>`) re-fetches and remounts `ProductActions`
5. The `useEffect` on `product.variants` runs again → **resets options to default**

**Fix:** Replace `useEffect` init with a **lazy `useState` initializer**, and **remove `router.replace()` entirely**:
```tsx
// ✅ GOOD — set once at mount, never reset
const [options, setOptions] = useState<Record<string, string | undefined>>(
  () => {
    if (product.variants?.length > 0) {
      return optionsAsKeymap(product.variants[0].options) ?? {}
    }
    return {}
  }
)
```

---

### 3. Payment Session `context` Field Causes 400 Error
**Endpoint:** `POST /store/payment-collections/:id/payment-sessions`

Medusa's store API does **not** accept a top-level `context` field in the request body. Sending it produces:
```
Error setting up the request: Invalid request: Unrecognized fields: 'context'
```

**Fix:** Remove any `context` key from the payment session creation payload. Only pass `provider_id` and optionally `data`.

---

### 4. Shipping "Continue to Payment" Button Stays Disabled
**Cause:** Shipping options are missing or not linked to the region in Medusa Admin.

**Checklist to debug:**
- Go to Medusa Admin → Settings → Shipping → confirm the shipping option has `enabled_in_store: true`
- Confirm the shipping option's region matches the cart's region
- Confirm `fulfillment_set` is linked to the correct `service_zone` with the country

---

### 5. `useActionState` Not Available in React 18 / Next.js 14
The `useActionState` hook is React 19+. This project uses **React 18 + Next.js 14**, so it throws:
```
TypeError: react__WEBPACK_IMPORTED_MODULE_9__.useActionState is not a function
```

**Fix:** Use `useFormState` from `react-dom` instead:
```tsx
// ❌ React 19 only
import { useActionState } from "react"

// ✅ Works in React 18 + Next.js 14
import { useFormState } from "react-dom"
```

---

### 6. Product Page Layout — Reference Site Dimensions
Reference: [https://strawb.in/products/bamboo-bangle](https://strawb.in/products/bamboo-bangle)

- **Grid ratio:** 8:4 (`small:col-span-8` image, `small:col-span-4` info)
- **Container padding:** `py-4`, not `py-8`. Use `gap-6` between columns, not `gap-10`.
- **Image gallery:** Main image `aspect-[5/4]`, secondary images 2-per-row `aspect-[1/1]`, gap `3`
- **Price order:** strikethrough original → sale price → black "Sale" pill badge
- **Option pills:** `rounded-full`, `text-sm`, `min-w-[44px]`. Selected = `bg-black text-white`. Unselected = `bg-white text-black border-gray-300`
- **Buttons:** Full-width, `h-14`, **no border-radius (square)**. Add to Cart = white bg + black `1px` border. Buy it Now = `#F5C842` yellow. Both use **black text**, no hover effect.
- **Quantity box:** `w-40 h-11`, flat (no border-radius), with internal `border-r` / `border-l` dividers between `−` / count / `+`.
- **Right column gap:** `gap-y-4` between sections, sticky `top-20`.

---

### 7. `Container` UI Component Adds `rounded-lg p-4` by Default
**File:** `src/modules/common/components/ui/index.tsx`

The `Container` component applies `bg-white rounded-lg p-4` automatically. When used in `ImageGallery`, pass overriding classes in `className` to remove unwanted rounding or padding.

---

### 8. Font: Iner (not Inter)
The project uses a custom font called **"Iner"** (not the common "Inter"). It is loaded from Google Fonts and applied via:
```css
.font-iner {
  font-family: "Iner", sans-serif;
}
```
Applied as a Tailwind utility class: `font-iner`.

---

### 9. Cart, Checkout & Order Completed Layout Spacing & Card Padding
**Files:** `src/modules/cart/templates/index.tsx`, `src/app/[countryCode]/(checkout)/checkout/page.tsx`, `src/modules/order/templates/order-completed-template.tsx`, `src/modules/order/templates/order-details-template.tsx`

The default Medusa starter template hardcoded `gap-x-40` (160px) and `py-6`/`py-10` (with `px-0`) on container columns and cards. When paired with a non-white body background (`--strawb-bg: #F5F5F5`), the unpadded white boxes appeared broken with text touching the outer boundaries.

**Fix:**
- Replace `gap-x-40` with `gap-8 lg:gap-12 items-start`
- Change `py-6` or `py-10` to `p-6 small:p-8 rounded-xl border border-gray-200/80 shadow-sm` (or `p-6 small:p-10` for order confirmation)
- Scale headings to `text-xl small:text-2xl font-semibold` and apply `font-iner`
