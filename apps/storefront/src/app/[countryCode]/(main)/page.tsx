import { Metadata } from "next"
import { listProducts } from "@lib/data/products"
import { getRegion } from "@lib/data/regions"
import { listCategories, getCategoryByHandle } from "@lib/data/categories"
import { getCollectionByHandle } from "@lib/data/collections"
import ProductPreview from "@modules/products/components/product-preview"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

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
      fields: "*variants.calculated_price,*images",
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
      fields: "*variants.calculated_price,*images",
      limit: 15,
    },
  })

  return (
    <div className="content-container py-8 space-y-16">
      {/* SECTION 1: Best Sellers (Main Products) */}
      <section className="space-y-6">
        <div className="flex items-center justify-between border-b pb-4" style={{ borderColor: "var(--strawb-border)" }}>
          <div>
            <h2 className="text-2xl font-bold tracking-tight text-black">Best Sellers 🍓</h2>
            <p className="text-xs text-gray-500 mt-1">Our most loved handcrafted pieces</p>
          </div>
          <LocalizedClientLink
            href={bestSellersCollection ? `/collections/${bestSellersCollection.handle}` : "/store"}
            className="text-xs font-semibold uppercase tracking-wider text-black hover:text-red-600 transition-colors flex items-center gap-1"
          >
            View all →
          </LocalizedClientLink>
        </div>

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
      </section>

      {/* SECTION 2: Browse by Category */}
      {filteredCategories.length > 0 && (
        <section className="space-y-6 py-4">
          <div className="border-b pb-4" style={{ borderColor: "var(--strawb-border)" }}>
            <h2 className="text-2xl font-bold tracking-tight text-black">Browse by Category</h2>
            <p className="text-xs text-gray-500 mt-1">Explore by styles and pieces</p>
          </div>

          <div className="grid grid-cols-2 small:grid-cols-3 medium:grid-cols-4 gap-4">
            {filteredCategories.map((cat) => (
              <LocalizedClientLink
                key={cat.id}
                href={`/categories/${cat.handle}`}
                className="group relative overflow-hidden rounded-xl border bg-white p-6 text-center hover:border-black hover:shadow-md transition-all duration-200 flex flex-col items-center justify-center min-h-[120px]"
                style={{ borderColor: "var(--strawb-border)" }}
              >
                <span className="text-base font-semibold text-black group-hover:text-red-600 transition-colors">
                  {cat.name}
                </span>
                {cat.description && (
                  <span className="text-xs text-gray-500 mt-1 line-clamp-1">
                    {cat.description}
                  </span>
                )}
                <span className="mt-3 text-[11px] font-semibold text-gray-400 group-hover:text-black uppercase tracking-wider transition-colors">
                  Explore →
                </span>
              </LocalizedClientLink>
            ))}
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
