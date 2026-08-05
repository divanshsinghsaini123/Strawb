"use client"

import { Popover, PopoverPanel, Transition } from "@headlessui/react"
import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import { Fragment } from "react"
import { Locale } from "@lib/data/locales"

const SideMenuItems = [
  { name: "Home", href: "/" },
  { name: "Shop All", href: "/store" },
  { name: "Gifting Guide", href: "/blogs/gifting" },
  { name: "My Account", href: "/account" },
]

type SideMenuProps = {
  regions: HttpTypes.StoreRegion[] | null
  locales: Locale[] | null
  currentLocale: string | null
}

const SideMenu = ({ regions: _regions, locales: _locales, currentLocale: _currentLocale }: SideMenuProps) => {
  return (
    <div className="h-full flex items-center">
      <Popover className="h-full flex items-center">
        {({ open, close }) => (
          <>
            <Popover.Button
              data-testid="nav-menu-button"
              className="flex items-center gap-2 text-sm font-medium text-black hover:opacity-70 transition-opacity focus:outline-none"
              aria-label="Toggle Menu"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <line x1="3" y1="6" x2="21" y2="6" />
                <line x1="3" y1="12" x2="21" y2="12" />
                <line x1="3" y1="18" x2="21" y2="18" />
              </svg>
              <span>Menu</span>
            </Popover.Button>

            {open && (
              <div
                className="fixed inset-0 z-[60] bg-black/40 backdrop-blur-xs transition-opacity"
                onClick={close}
                data-testid="side-menu-backdrop"
              />
            )}

            <Transition
              show={open}
              as={Fragment}
              enter="transition ease-out duration-200 transform"
              enterFrom="-translate-x-full"
              enterTo="translate-x-0"
              leave="transition ease-in duration-150 transform"
              leaveFrom="translate-x-0"
              leaveTo="-translate-x-full"
            >
              <PopoverPanel className="fixed inset-y-0 left-0 w-80 max-w-full bg-white shadow-2xl z-[61] flex flex-col justify-between p-6">
                <div className="flex flex-col gap-6">
                  {/* Top Bar inside Menu */}
                  <div className="flex items-center justify-between border-b pb-4">
                    <span className="font-semibold text-lg text-black">Menu</span>
                    <button
                      data-testid="close-menu-button"
                      onClick={close}
                      className="p-1 text-gray-500 hover:text-black transition-colors"
                      aria-label="Close Menu"
                    >
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18" />
                        <line x1="6" y1="6" x2="18" y2="18" />
                      </svg>
                    </button>
                  </div>

                  {/* Navigation Links */}
                  <ul className="flex flex-col gap-4">
                    {SideMenuItems.map((item) => (
                      <li key={item.name}>
                        <LocalizedClientLink
                          href={item.href}
                          className="text-lg font-medium text-black hover:text-red-600 transition-colors block py-1"
                          onClick={close}
                        >
                          {item.name}
                        </LocalizedClientLink>
                      </li>
                    ))}
                  </ul>
                </div>

                {/* Footer inside menu */}
                <div className="border-t pt-4 text-xs text-gray-500 space-y-1">
                  <p>© {new Date().getFullYear()} Strawb. All rights reserved.</p>
                  <p>Handcrafted in Mumbai 🍓</p>
                </div>
              </PopoverPanel>
            </Transition>
          </>
        )}
      </Popover>
    </div>
  )
}

export default SideMenu
