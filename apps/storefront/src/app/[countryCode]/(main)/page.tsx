import { Metadata } from "next"
import { listProducts } from "@lib/data/products"
import { getRegion } from "@lib/data/regions"
import ProductPreview from "@modules/products/components/product-preview"

export const metadata: Metadata = {
  title: "Strawb — Handcrafted Jewelry & Accessories",
  description:
    "Shop Strawb's handcrafted jewelry and accessories. Free shipping on orders above ₹999.",
}

export default async function Home(props: {
  params: Promise<{ countryCode: string }>
}) {
  const params = await props.params
  const { countryCode } = params

  const region = await getRegion(countryCode)

  if (!region) {
    return null
  }

  const {
    response: { products },
  } = await listProducts({
    regionId: region.id,
    queryParams: {
      fields: "*variants.calculated_price",
      limit: 24,
    },
  })

  return (
    <div className="content-container py-8">
      <div
        className="grid grid-cols-2 small:grid-cols-3 medium:grid-cols-4 gap-x-4 gap-y-8"
        data-testid="products-list"
      >
        {products.map((product) => (
          <ProductPreview
            key={product.id}
            product={product}
            region={region}
          />
        ))}
      </div>
    </div>
  )
}
