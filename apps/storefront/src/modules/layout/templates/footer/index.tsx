import { listCollections } from "@lib/data/collections"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Image from "next/image"

export default async function Footer() {
  const { collections } = await listCollections({
    fields: "id, handle, title",
  })

  return (
    <footer
      className="w-full border-t mt-16"
      style={{ borderColor: "var(--strawb-border)", backgroundColor: "#FFFFFF" }}
    >
      <div className="content-container py-12">
        {/* Top section */}
        <div className="flex flex-col small:flex-row justify-between gap-10 mb-10">
          {/* Brand */}
          <div className="flex flex-col gap-4">
            <LocalizedClientLink href="/">
              <Image
                src="/logo_main.avif"
                alt="Strawb"
                width={100}
                height={32}
                style={{ objectFit: "contain" }}
              />
            </LocalizedClientLink>
            <p className="text-xs max-w-[240px]" style={{ color: "var(--strawb-gray)" }}>
              Handcrafted jewelry &amp; accessories. Made with love in Mumbai. 🍓
            </p>
            {/* Social Icons */}
            <div className="flex items-center gap-4 mt-1">
              {/* Instagram */}
              <a
                href="https://www.instagram.com/strawb.in"
                target="_blank"
                rel="noreferrer"
                aria-label="Instagram"
                className="hover:opacity-70 transition-opacity"
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="2" y="2" width="20" height="20" rx="5" ry="5" />
                  <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z" />
                  <line x1="17.5" y1="6.5" x2="17.51" y2="6.5" />
                </svg>
              </a>
              {/* WhatsApp */}
              <a
                href="https://wa.me/919999999999"
                target="_blank"
                rel="noreferrer"
                aria-label="WhatsApp"
                className="hover:opacity-70 transition-opacity"
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z" />
                </svg>
              </a>
            </div>
          </div>

          {/* Links */}
          <div className="grid grid-cols-2 small:grid-cols-3 gap-8 text-sm">
            {/* Shop */}
            <div className="flex flex-col gap-3">
              <span className="font-semibold text-xs uppercase tracking-wider" style={{ color: "var(--strawb-black)" }}>
                Shop
              </span>
              <ul className="flex flex-col gap-2" style={{ color: "var(--strawb-gray)" }}>
                <li>
                  <LocalizedClientLink href="/store" className="hover:text-black transition-colors">
                    All Products
                  </LocalizedClientLink>
                </li>
                {collections?.slice(0, 4).map((c) => (
                  <li key={c.id}>
                    <LocalizedClientLink
                      href={`/collections/${c.handle}`}
                      className="hover:text-black transition-colors"
                    >
                      {c.title}
                    </LocalizedClientLink>
                  </li>
                ))}
                <li>
                  <LocalizedClientLink href="/blogs/gifting" className="hover:text-black transition-colors">
                    Gifting Guide
                  </LocalizedClientLink>
                </li>
              </ul>
            </div>

            {/* Help */}
            <div className="flex flex-col gap-3">
              <span className="font-semibold text-xs uppercase tracking-wider" style={{ color: "var(--strawb-black)" }}>
                Help
              </span>
              <ul className="flex flex-col gap-2" style={{ color: "var(--strawb-gray)" }}>
                <li>
                  <a href="https://wa.me/919999999999" target="_blank" rel="noreferrer" className="hover:text-black transition-colors">
                    Contact Us
                  </a>
                </li>
                <li>
                  <LocalizedClientLink href="/account" className="hover:text-black transition-colors">
                    My Account
                  </LocalizedClientLink>
                </li>
                <li>
                  <a href="#" className="hover:text-black transition-colors">
                    Shipping Policy
                  </a>
                </li>
                <li>
                  <a href="#" className="hover:text-black transition-colors">
                    Refund Policy
                  </a>
                </li>
              </ul>
            </div>

            {/* Connect */}
            <div className="flex flex-col gap-3">
              <span className="font-semibold text-xs uppercase tracking-wider" style={{ color: "var(--strawb-black)" }}>
                Connect
              </span>
              <ul className="flex flex-col gap-2" style={{ color: "var(--strawb-gray)" }}>
                <li>
                  <a href="https://www.instagram.com/strawb.in" target="_blank" rel="noreferrer" className="hover:text-black transition-colors">
                    Instagram
                  </a>
                </li>
                <li>
                  <a href="https://wa.me/919999999999" target="_blank" rel="noreferrer" className="hover:text-black transition-colors">
                    WhatsApp
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* Bottom bar */}
        <div
          className="border-t pt-6 flex flex-col small:flex-row items-center justify-between gap-3 text-xs"
          style={{ borderColor: "var(--strawb-border)", color: "var(--strawb-gray)" }}
        >
          <span>© {new Date().getFullYear()} Strawb. All rights reserved.</span>
          <span>Made with ❤️ in Mumbai</span>
        </div>
      </div>
    </footer>
  )
}
