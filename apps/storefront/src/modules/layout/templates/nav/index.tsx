import { Suspense } from "react"
import { listLocales } from "@lib/data/locales"
import { getLocale } from "@lib/data/locale-actions"
import { listRegions } from "@lib/data/regions"
import { StoreRegion } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import CartButton from "@modules/layout/components/cart-button"
import SideMenu from "@modules/layout/components/side-menu"
import HeaderNav from "./header-nav"

export default async function Nav() {
  const [regions, locales, currentLocale] = await Promise.all([
    listRegions().then((regions: StoreRegion[]) => regions),
    listLocales(),
    getLocale(),
  ])

  return (
    <HeaderNav
      sideMenu={
        <SideMenu regions={regions} locales={locales} currentLocale={currentLocale} />
      }
      rightActions={
        <>
          {/* Region / Currency Indicator (e.g. India | INR ₹) */}
          <div className="hidden small:flex items-center text-sm text-gray-800 font-medium mr-2">
            <span>India | INR ₹</span>
            <svg className="w-4 h-4 ml-1 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
            </svg>
          </div>

          {/* Search Icon */}
          <LocalizedClientLink
            href="/store"
            className="hover:opacity-70 transition-opacity p-1 text-black"
            aria-label="Search"
          >
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
          </LocalizedClientLink>

          {/* Account Icon */}
          <LocalizedClientLink
            href="/account"
            className="hover:opacity-70 transition-opacity p-1 text-black"
            data-testid="nav-account-link"
            aria-label="Account"
          >
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
          </LocalizedClientLink>

          {/* Cart Icon */}
          <Suspense
            fallback={
              <LocalizedClientLink href="/cart" aria-label="Cart" className="hover:opacity-70 transition-opacity p-1 text-black">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                  <line x1="3" y1="6" x2="21" y2="6" />
                  <path d="M16 10a4 4 0 0 1-8 0" />
                </svg>
              </LocalizedClientLink>
            }
          >
            <CartButton />
          </Suspense>
        </>
      }
    />
  )
}
