"use client"

import { useEffect, useRef, useState, useTransition } from "react"
import { useRouter } from "next/navigation"
import Image from "next/image"
import { searchProducts } from "@lib/data/products"
import { getProductPrice } from "@lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Spinner from "@modules/common/icons/spinner"

const POPULAR_SEARCHES = ["Bangles", "Earrings", "Necklace", "Silver", "Butterflies"]

export default function SearchModal() {
  const [isOpen, setIsOpen] = useState(false)
  const [query, setQuery] = useState("")
  const [results, setResults] = useState<HttpTypes.StoreProduct[]>([])
  const [isPending, startTransition] = useTransition()
  const [hasSearched, setHasSearched] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)
  const router = useRouter()

  // Focus input on open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden"
      setTimeout(() => {
        inputRef.current?.focus()
      }, 50)
    } else {
      document.body.style.overflow = "unset"
      setQuery("")
      setResults([])
      setHasSearched(false)
    }

    return () => {
      document.body.style.overflow = "unset"
    }
  }, [isOpen])

  // Close on Escape
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape" && isOpen) {
        setIsOpen(false)
      }
    }
    window.addEventListener("keydown", handleKeyDown)
    return () => window.removeEventListener("keydown", handleKeyDown)
  }, [isOpen])

  // Live search debounced
  useEffect(() => {
    if (!query.trim()) {
      setResults([])
      setHasSearched(false)
      return
    }

    const timer = setTimeout(() => {
      startTransition(async () => {
        const products = await searchProducts({ query })
        setResults(products)
        setHasSearched(true)
      })
    }, 250)

    return () => clearTimeout(timer)
  }, [query])

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (!query.trim()) return
    setIsOpen(false)
    router.push(`/store?q=${encodeURIComponent(query.trim())}`)
  }

  const handleSelectTag = (tag: string) => {
    setQuery(tag)
    inputRef.current?.focus()
  }

  return (
    <>
      {/* Search trigger button in header */}
      <button
        onClick={() => setIsOpen(true)}
        className="hover:opacity-70 transition-opacity p-1 text-black flex items-center justify-center"
        aria-label="Search"
        type="button"
      >
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <circle cx="11" cy="11" r="8" />
          <line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>
      </button>

      {/* Modal Backdrop & Container */}
      {isOpen && (
        <div className="fixed inset-0 z-[100] flex items-start justify-center pt-16 sm:pt-24 px-4 font-iner">
          {/* Backdrop */}
          <div
            className="fixed inset-0 bg-black/40 backdrop-blur-xs transition-opacity duration-200"
            onClick={() => setIsOpen(false)}
          />

          {/* Modal Panel */}
          <div className="relative w-full max-w-2xl bg-white rounded-2xl shadow-2xl overflow-hidden border border-gray-100 z-10 animate-in fade-in zoom-in-95 duration-150">
            {/* Search Input Form */}
            <form onSubmit={handleSubmit} className="relative flex items-center border-b border-gray-100 px-5 py-4">
              <svg
                className="w-5 h-5 text-gray-400 mr-3 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <circle cx="11" cy="11" r="8" strokeWidth="2" />
                <line x1="21" y1="21" x2="16.65" y2="16.65" strokeWidth="2" strokeLinecap="round" />
              </svg>

              <input
                ref={inputRef}
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Search products, bangles, earrings..."
                className="w-full bg-transparent text-base sm:text-lg text-black placeholder-gray-400 focus:outline-none"
              />

              {isPending && (
                <div className="mr-3">
                  <Spinner />
                </div>
              )}

              {query && (
                <button
                  type="button"
                  onClick={() => {
                    setQuery("")
                    inputRef.current?.focus()
                  }}
                  className="p-1 text-gray-400 hover:text-black mr-2"
                  aria-label="Clear query"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              )}

              <button
                type="button"
                onClick={() => setIsOpen(false)}
                className="text-xs font-medium text-gray-500 hover:text-black px-2 py-1 bg-gray-100 rounded-md transition-colors"
              >
                ESC
              </button>
            </form>

            {/* Results / Suggestions Content */}
            <div className="max-h-[60vh] overflow-y-auto p-4 sm:p-6">
              {/* Popular tags when no search input */}
              {!query.trim() && (
                <div>
                  <p className="text-xs uppercase tracking-wider text-gray-400 font-semibold mb-3">
                    Popular searches
                  </p>
                  <div className="flex flex-wrap gap-2">
                    {POPULAR_SEARCHES.map((tag) => (
                      <button
                        key={tag}
                        type="button"
                        onClick={() => handleSelectTag(tag)}
                        className="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 text-black text-sm rounded-full transition-colors"
                      >
                        {tag}
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Loading state */}
              {isPending && !results.length && (
                <div className="py-12 flex flex-col items-center justify-center text-gray-400 text-sm">
                  <Spinner />
                  <span className="mt-3">Searching catalog...</span>
                </div>
              )}

              {/* No results found */}
              {!isPending && hasSearched && results.length === 0 && (
                <div className="py-12 text-center">
                  <p className="text-base text-gray-800 font-medium">
                    No products found for &ldquo;{query}&rdquo;
                  </p>
                  <p className="text-sm text-gray-500 mt-1">
                    Try checking the spelling or searching for different keywords.
                  </p>
                </div>
              )}

              {/* Results list */}
              {results.length > 0 && (
                <div className="space-y-2">
                  <div className="flex items-center justify-between text-xs text-gray-500 px-2 pb-2">
                    <span>{results.length} results found</span>
                    <button
                      type="button"
                      onClick={handleSubmit}
                      className="text-black font-medium hover:underline"
                    >
                      View all in store &rarr;
                    </button>
                  </div>

                  <div className="divide-y divide-gray-100">
                    {results.map((product) => {
                      const { cheapestPrice } = getProductPrice({ product })
                      const isOnSale =
                        cheapestPrice?.price_type === "sale" &&
                        cheapestPrice?.original_price !== cheapestPrice?.calculated_price

                      return (
                        <LocalizedClientLink
                          key={product.id}
                          href={`/products/${product.handle}`}
                          onClick={() => setIsOpen(false)}
                          className="flex items-center gap-4 p-2.5 rounded-xl hover:bg-gray-50 transition-colors group"
                        >
                          {/* Thumbnail */}
                          <div className="relative w-14 h-14 bg-gray-100 rounded-lg overflow-hidden flex-shrink-0">
                            {product.thumbnail ? (
                              <Image
                                src={product.thumbnail}
                                alt={product.title || "Product"}
                                fill
                                sizes="56px"
                                className="object-cover"
                              />
                            ) : (
                              <div className="w-full h-full flex items-center justify-center text-gray-300 text-xs">
                                No img
                              </div>
                            )}
                          </div>

                          {/* Info */}
                          <div className="flex-1 min-w-0">
                            <p className="text-sm font-medium text-black group-hover:text-red-700 transition-colors truncate">
                              {product.title}
                            </p>
                            <div className="flex items-center gap-2 mt-0.5">
                              {isOnSale && (
                                <span className="text-xs text-gray-400 line-through">
                                  {cheapestPrice?.original_price}
                                </span>
                              )}
                              <span className="text-sm font-semibold text-black">
                                {cheapestPrice?.calculated_price || "—"}
                              </span>
                              {isOnSale && (
                                <span className="text-[10px] uppercase font-bold text-white bg-black px-1.5 py-0.5 rounded">
                                  Sale
                                </span>
                              )}
                            </div>
                          </div>

                          {/* Arrow */}
                          <div className="text-gray-400 group-hover:text-black group-hover:translate-x-1 transition-all">
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 5l7 7-7 7" />
                            </svg>
                          </div>
                        </LocalizedClientLink>
                      )
                    })}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  )
}
