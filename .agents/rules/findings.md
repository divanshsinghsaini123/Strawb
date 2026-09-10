# Project Findings & Rules

## Technical & Architecture
1. **Buttons**: Shared `Button` (`ui/index.tsx`) hardcodes `bg-black text-white rounded-md`. For custom styling (e.g. `bg-white text-black`, `#F5C842`), use plain `<button>`.
2. **Variant State Bug**: In `product-actions`, never sync variants with `useEffect` + `router.replace()` (causes infinite refetch/reset loop). Use lazy `useState(() => ...)` and no `router.replace()`.
3. **Payment Sessions**: `POST /store/payment-collections/:id/payment-sessions` fails (400) if `context` is passed. Only send `provider_id` and optionally `data`.
4. **Shipping Setup**: If "Continue to Payment" is disabled, ensure shipping option has `enabled_in_store: true`, region matches cart, and `fulfillment_set` is linked to the country's `service_zone`.
5. **React / Next Hooks**: React 18 / Next 14 compatibility: use `useFormState` from `react-dom`, NOT `useActionState`.
6. **Container Component**: `Container` adds `rounded-lg p-4` by default; override in `className` when nesting.

## Design System & Layout
- **Font**: Custom font is `"Iner"` (`font-iner`), not Inter.
- **Brand Colors**: Strawb Red `#CC0000`, Yellow `#F5C842`, Black `#111111`, Light BG `#F5F5F5` (`--strawb-bg`).
- **Product Page**: 8:4 grid (`small:col-span-8` image, `col-span-4` details, `gap-6`, `py-4`). Main image `aspect-[5/4]`, 2-in-line secondary images `aspect-[1/1]`. Option pills `rounded-full`. Buttons `h-14` square (ATC: white+border; Buy Now: `#F5C842` yellow; text always black, no hover color shift). Quantity box `w-40 h-11` with dividers.
- **Cart, Checkout & Order Completed**: Never use `gap-x-40` or unpadded `py-6`/`py-10`. Use `gap-8 lg:gap-12` and cards with `p-6 small:p-8 rounded-xl border border-gray-200/80 shadow-sm`.
- **Empty Cart**: Pure white background (`bg-white min-h-[65vh]`), centered: "Your cart is empty", yellow button "Continue shopping" (`bg-[#F5C842] rounded-md`), and "Have an account? Log in to check out faster."
- **Branding**: Use Strawb logo (`/logo_main.avif`) in place of generic "Medusa Store" text in layouts and page metadata.
