"use client"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import { usePathname } from "next/navigation"

export default function Footer() {
  const pathname = usePathname()

  const links = [
    { label: "Casual Reads", href: "/blogs/gifting", isExternal: false },
    { label: "Contact", href: "https://wa.me/919999999999", isExternal: true },
    { label: "Privacy policy", href: "/pages/privacy-policy", isExternal: false },
    { label: "Refund policy", href: "/pages/refund-policy", isExternal: false },
    { label: "Shipping policy", href: "/pages/shipping-policy", isExternal: false },
    { label: "Terms of Service", href: "/pages/terms-of-service", isExternal: false },
  ]

  return (
    <footer className="w-full bg-white border-t mt-16" style={{ borderColor: "var(--strawb-border)" }}>
      <div className="content-container py-12 flex flex-col items-center text-center gap-6">
        {/* Title */}
        <h3 className="text-base font-bold tracking-widest text-black uppercase">
          FYI
        </h3>

        {/* Navigation Links Row with Animated Underlines & Active State */}
        <div className="flex flex-wrap items-center justify-center gap-x-8 gap-y-4 text-sm font-medium text-gray-800">
          {links.map((link) => {
            const isActive = !link.isExternal && pathname.includes(link.href)

            if (link.isExternal) {
              return (
                <a
                  key={link.label}
                  href={link.href}
                  target="_blank"
                  rel="noreferrer"
                  className="relative py-1 text-gray-800 hover:text-black transition-colors after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 hover:after:w-full after:h-[2px] after:bg-black after:transition-all after:duration-300"
                >
                  {link.label}
                </a>
              )
            }

            return (
              <LocalizedClientLink
                key={link.label}
                href={link.href}
                className={`relative py-1 transition-colors after:content-[''] after:absolute after:bottom-0 after:left-0 after:h-[2px] after:bg-black after:transition-all after:duration-300 ${
                  isActive
                    ? "text-black font-semibold after:w-full"
                    : "text-gray-700 hover:text-black after:w-0 hover:after:w-full"
                }`}
              >
                {link.label}
              </LocalizedClientLink>
            )
          })}
        </div>

        {/* Instagram Icon with Pop & Rotate Hover Animation */}
        <a
          href="https://www.instagram.com/strawb.in"
          target="_blank"
          rel="noreferrer"
          aria-label="Instagram"
          className="text-black hover:text-red-600 hover:scale-125 hover:-rotate-6 transition-all duration-300 my-2 inline-block p-1"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <rect x="2" y="2" width="20" height="20" rx="5" ry="5" />
            <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z" />
            <line x1="17.5" y1="6.5" x2="17.51" y2="6.5" />
          </svg>
        </a>

        {/* Divider */}
        <div className="w-full border-t border-gray-100 my-1" />

        {/* Bottom Tagline with Pulse Heart Animation */}
        <p className="text-xs text-gray-500 font-normal flex items-center justify-center gap-1">
          Made with love{" "}
          <span className="inline-block animate-pulse text-red-500">💗</span>{" "}
          in Mumbai
        </p>
      </div>
    </footer>
  )
}
