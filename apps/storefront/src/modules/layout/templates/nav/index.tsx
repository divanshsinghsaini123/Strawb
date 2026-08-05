import { Suspense } from "react"
import Image from "next/image"
import { listLocales } from "@lib/data/locales"
import { getLocale } from "@lib/data/locale-actions"
import { listRegions } from "@lib/data/regions"
import { StoreRegion } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import CartButton from "@modules/layout/components/cart-button"
import SideMenu from "@modules/layout/components/side-menu"

export default async function Nav() {
  const [regions, locales, currentLocale] = await Promise.all([
    listRegions().then((regions: StoreRegion[]) => regions),
    listLocales(),
    getLocale(),
  ])

  return (
    <div className="sticky top-0 inset-x-0 z-50">
      <header
        className="relative h-14 mx-auto border-b"
        style={{ backgroundColor: "#FFFFFF", borderColor: "var(--strawb-border)" }}
      >
        <nav className="content-container flex items-center justify-between w-full h-full">
          {/* Left: Hamburger / Side Menu */}
          <div className="flex-1 basis-0 h-full flex items-center">
            <SideMenu regions={regions} locales={locales} currentLocale={currentLocale} />
          </div>

          {/* Center: Strawb Logo */}
          <div className="flex items-center h-full">
            <LocalizedClientLink href="/" data-testid="nav-store-link">
              <Image
                src="/logo_main.avif"
                alt="Strawb"
                width={110}
                height={36}
                priority
                style={{ objectFit: "contain" }}
              />
            </LocalizedClientLink>
          </div>

          {/* Right: Icons */}
          <div className="flex items-center gap-x-4 h-full flex-1 basis-0 justify-end">
            {/* Search Icon */}
            <LocalizedClientLink
              href="/store"
              className="hover:opacity-70 transition-opacity"
              aria-label="Search"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="11" cy="11" r="8" />
                <line x1="21" y1="21" x2="16.65" y2="16.65" />
              </svg>
            </LocalizedClientLink>

            {/* Account Icon */}
            <LocalizedClientLink
              href="/account"
              className="hover:opacity-70 transition-opacity"
              data-testid="nav-account-link"
              aria-label="Account"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                <circle cx="12" cy="7" r="4" />
              </svg>
            </LocalizedClientLink>

            {/* Cart Icon */}
            <Suspense
              fallback={
                <LocalizedClientLink href="/cart" aria-label="Cart" className="hover:opacity-70 transition-opacity">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                    <line x1="3" y1="6" x2="21" y2="6" />
                    <path d="M16 10a4 4 0 0 1-8 0" />
                  </svg>
                </LocalizedClientLink>
              }
            >
              <CartButton />
            </Suspense>
          </div>
        </nav>
      </header>
    </div>
  )
}
