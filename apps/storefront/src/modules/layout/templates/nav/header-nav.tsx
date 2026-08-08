"use client"

import { useState, useEffect, ReactNode } from "react"
import Image from "next/image"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

export default function HeaderNav({
  sideMenu,
  rightActions,
}: {
  sideMenu: ReactNode
  rightActions: ReactNode
}) {
  const [isScrolled, setIsScrolled] = useState(false)

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 20) {
        setIsScrolled(true)
      } else {
        setIsScrolled(false)
      }
    }
    window.addEventListener("scroll", handleScroll, { passive: true })
    return () => window.removeEventListener("scroll", handleScroll)
  }, [])

  return (
    <div className="sticky top-0 inset-x-0 z-50">
      <header
        className={`relative mx-auto border-b transition-all duration-300 ${isScrolled
            ? "h-16 bg-[#F9F9F9]/95 backdrop-blur-md shadow-xs border-gray-200"
            : "h-24 bg-[#F9F9F9] border-transparent"
          }`}
        style={{ backgroundColor: "var(--strawb-bg, #F9F9F9)" }}
      >
        <nav className="content-container flex items-center justify-between w-full h-full">
          {/* Left: Menu Button FIRST, then Strawb Logo */}
          <div className="flex items-center gap-x-6">
            {/* Menu Drawer Button (Icon only) */}
            {sideMenu}

            {/* Strawb Logo */}
            <LocalizedClientLink
              href="/"
              data-testid="nav-store-link"
              className="flex items-center transition-transform duration-300"
              style={{
                transform: isScrolled ? "scale(0.82)" : "scale(1)",
                transformOrigin: "left center",
              }}
            >
              <Image
                src="/logo_main.avif"
                alt="Strawb"
                width={150}
                height={45}
                priority
                style={{ objectFit: "contain" }}
              />
            </LocalizedClientLink>
          </div>

          {/* Right: Currency / Region Selector + Icons */}
          <div className="flex items-center gap-x-5">
            {rightActions}
          </div>
        </nav>
      </header>
    </div>
  )
}
