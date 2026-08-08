import { Metadata } from "next"
import { listProducts } from "@lib/data/products"
import { getRegion } from "@lib/data/regions"
import { listCategories, getCategoryByHandle } from "@lib/data/categories"
import { getCollectionByHandle } from "@lib/data/collections"
import ProductPreview from "@modules/products/components/product-preview"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Image from "next/image"

export const metadata: Metadata = {
  title: "Strawb — Handcrafted Jewelry & Accessories",
  description:
    "Shop Strawb's handcrafted jewelry and accessories. Free shipping on orders above ₹999.",
}

// Categories to exclude from "Browse by category"
const EXCLUDED_CATEGORY_NAMES = ["homepage", "new launches", "best sellers"]

export default async function Home(props: {
  params: Promise<{ countryCode: string }>
}) {
  const params = await props.params
  const { countryCode } = params

  const region = await getRegion(countryCode)

  if (!region) {
    return null
  }

  // 1. Fetch Best Sellers Collection / Products
  const bestSellersCollection = await getCollectionByHandle("best-sellers").catch(() => null)

  const {
    response: { products: bestSellersProducts },
  } = await listProducts({
    regionId: region.id,
    queryParams: {
      collection_id: bestSellersCollection?.id ? [bestSellersCollection.id] : undefined,
      fields: "*variants.calculated_price,*variants.inventory_quantity,*variants.manage_inventory,*variants.allow_backorder,*images",
      limit: 20,
    },
  })

  // 2. Fetch Categories (Exclude Homepage, New Launches, Best Sellers)
  const allCategories = await listCategories().catch(() => [])
  const filteredCategories = (allCategories || []).filter((cat) => {
    const name = cat.name.toLowerCase().trim()
    return !EXCLUDED_CATEGORY_NAMES.includes(name)
  })

  // 3. Fetch New Launches Category / Products
  const newLaunchesCat = await getCategoryByHandle(["new-launches"]).catch(() => null)

  const {
    response: { products: newLaunchesProducts },
  } = await listProducts({
    regionId: region.id,
    queryParams: {
      category_id: newLaunchesCat?.id ? [newLaunchesCat.id] : undefined,
      fields: "*variants.calculated_price,*variants.inventory_quantity,*variants.manage_inventory,*variants.allow_backorder,*images",
      limit: 15,
    },
  })

  return (
    <div className="content-container py-8 space-y-20">
      {/* SECTION 1: Best Sellers (Main Products) */}
      <section className="space-y-6">
        {/* <div className="border-b pb-4" style={{ borderColor: "var(--strawb-border)" }}>
          <h2 className="text-2xl font-bold tracking-tight text-black">Best Sellers 🍓</h2>
          <p className="text-xs text-gray-500 mt-1">Our most loved handcrafted pieces</p>
        </div> */}

        <div
          className="grid grid-cols-2 small:grid-cols-3 medium:grid-cols-4 gap-x-4 gap-y-8"
          data-testid="best-sellers-list"
        >
          {bestSellersProducts.slice(0, 20).map((product) => (
            <ProductPreview
              key={product.id}
              product={product}
              region={region}
            />
          ))}
        </div>

        {/* View All Button at Bottom of Section 1 */}
        <div className="flex justify-center pt-4">
          <LocalizedClientLink
            href={bestSellersCollection ? `/collections/${bestSellersCollection.handle}` : "/store"}
            className="px-8 py-3 border border-black hover:bg-black hover:text-white text-black text-xs font-semibold uppercase tracking-wider rounded-md transition-colors inline-block"
          >
            View all
          </LocalizedClientLink>
        </div>
      </section>

      {/* SECTION 2: Browse by Category (White Background Card Container) */}
      {filteredCategories.length > 0 && (
        <section className="-mx-4 small:-mx-8 bg-white py-12 px-4 small:px-8 border-y" style={{ borderColor: "var(--strawb-border)" }}>
          <div className="max-w-full mx-auto space-y-8">
            <h2 className="text-3xl font-normal tracking-tight text-black">
              Browse by category
            </h2>

            <div className="grid grid-cols-1 small:grid-cols-3 gap-6">
              {filteredCategories.map((cat) => {
                // Determine image for category (from products or placeholder)
                const categoryImage =
                  (cat as any)?.thumbnail ||
                  (cat.products && cat.products[0]?.thumbnail) ||
                  (cat.products && cat.products[0]?.images?.[0]?.url) ||
                  null

                return (
                  <LocalizedClientLink
                    key={cat.id}
                    href={`/categories/${cat.handle}`}
                    className="group flex flex-col gap-3"
                  >
                    {/* Vertical Portrait Card Container */}
                    <div className="relative w-full aspect-[3/4] overflow-hidden rounded-[24px] bg-gray-100 shadow-xs group-hover:shadow-md transition-all duration-300">
                      {categoryImage ? (
                        <Image
                          src={categoryImage}
                          alt={cat.name}
                          fill
                          className="object-cover object-center group-hover:scale-105 transition-transform duration-500"
                          sizes="(max-width: 768px) 100vw, 33vw"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center bg-gray-100 text-gray-400 font-semibold text-lg">
                          {cat.name}
                        </div>
                      )}
                    </div>

                    {/* Category Title + Arrow below image */}
                    <div className="flex items-center gap-1">
                      <span className="text-base font-normal text-black group-hover:underline">
                        {cat.name}
                      </span>
                      <span className="text-base font-normal text-black group-hover:translate-x-1 transition-transform">
                        →
                      </span>
                    </div>
                  </LocalizedClientLink>
                )
              })}
            </div>
          </div>
        </section>
      )}

      {/* SECTION 3: New Launches */}
      <section className="space-y-6">
        <div className="flex items-center justify-between border-b pb-4" style={{ borderColor: "var(--strawb-border)" }}>
          <div>
            <h2 className="text-2xl font-bold tracking-tight text-black">New Launches ✨</h2>
            <p className="text-xs text-gray-500 mt-1">Freshly crafted additions to our collection</p>
          </div>
          <LocalizedClientLink
            href={newLaunchesCat ? `/categories/${newLaunchesCat.handle}` : "/store"}
            className="text-xs font-semibold uppercase tracking-wider text-black hover:text-red-600 transition-colors flex items-center gap-1"
          >
            View all →
          </LocalizedClientLink>
        </div>

        <div
          className="grid grid-cols-2 small:grid-cols-3 medium:grid-cols-4 gap-x-4 gap-y-8"
          data-testid="new-launches-list"
        >
          {newLaunchesProducts.slice(0, 15).map((product) => (
            <ProductPreview
              key={product.id}
              product={product}
              region={region}
            />
          ))}
        </div>

        {/* View All Button at Bottom of New Launches Section */}
        <div className="flex justify-center pt-4">
          <LocalizedClientLink
            href={newLaunchesCat ? `/categories/${newLaunchesCat.handle}` : "/store"}
            className="px-8 py-3 bg-black hover:bg-gray-800 text-white text-xs font-semibold uppercase tracking-wider rounded-md transition-colors inline-block"
          >
            View all New Launches
          </LocalizedClientLink>
        </div>
      </section>
    </div>
  )
}
