import { Metadata } from "next"

import { listCartOptions, retrieveCart } from "@lib/data/cart"
import { retrieveCustomer } from "@lib/data/customer"
import { getBaseURL } from "@lib/util/env"
import { StoreCartShippingOption } from "@medusajs/types"
import AnnouncementBar, { AnnouncementItem } from "@modules/layout/components/announcement-bar"
import CartMismatchBanner from "@modules/layout/components/cart-mismatch-banner"
import Footer from "@modules/layout/templates/footer"
import Nav from "@modules/layout/templates/nav"
import FreeShippingPriceNudge from "@modules/shipping/components/free-shipping-price-nudge"

export const metadata: Metadata = {
  metadataBase: new URL(getBaseURL()),
}

async function getAnnouncements(): Promise<AnnouncementItem[]> {
  try {
    const backendUrl = process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000"
    const apiKey = process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || ""
    const res = await fetch(`${backendUrl}/content/announcement-bar/items`, {
      headers: {
        "x-publishable-api-key": apiKey,
      },
      next: { revalidate: 60 },
    })

    if (!res.ok) return []
    const data = await res.json()
    const items = data?.content_items || data?.items || []

    return items
      .map((item: any) => {
        const text =
          item.metadata?.value ||
          item.metadata?.title ||
          item.title ||
          item.body ||
          ""
        const isLink =
          item.metadata?.islink === true ||
          item.metadata?.islink === "true" ||
          item.metadata?.isLink === true ||
          item.metadata?.isLink === "true"
        const url = item.metadata?.url || null
        return {
          text,
          href: isLink && url ? url : null,
        }
      })
      .filter((m: AnnouncementItem) => m.text)
  } catch {
    return []
  }
}

export default async function PageLayout(props: { children: React.ReactNode }) {
  const [customer, cart, announcements] = await Promise.all([
    retrieveCustomer(),
    retrieveCart(),
    getAnnouncements(),
  ])

  let shippingOptions: StoreCartShippingOption[] = []

  if (cart) {
    const { shipping_options } = await listCartOptions()
    shippingOptions = shipping_options
  }

  return (
    <>
      <AnnouncementBar initialMessages={announcements} />
      <Nav />
      {customer && cart && (
        <CartMismatchBanner customer={customer} cart={cart} />
      )}

      {cart && (
        <FreeShippingPriceNudge
          variant="popup"
          cart={cart}
          shippingOptions={shippingOptions}
        />
      )}
      {props.children}
      <Footer />
    </>
  )
}
