import { clx } from "@modules/common/components/ui"
import { getProductPrice } from "@lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"

export default function ProductPrice({
  product,
  variant,
}: {
  product: HttpTypes.StoreProduct
  variant?: HttpTypes.StoreProductVariant
}) {
  const { cheapestPrice, variantPrice } = getProductPrice({
    product,
    variantId: variant?.id,
  })

  const selectedPrice = variant ? variantPrice : cheapestPrice

  if (!selectedPrice) {
    return <div className="block w-32 h-8 bg-gray-100 animate-pulse my-2" />
  }

  const isOnSale = selectedPrice.price_type === "sale"

  return (
    <div className="flex items-center gap-x-3 my-2 font-iner flex-wrap">
      {isOnSale && (
        <span
          className="text-base text-gray-500 line-through"
          data-testid="original-product-price"
          data-value={selectedPrice.original_price_number}
        >
          {selectedPrice.original_price}
        </span>
      )}
      <span
        className="text-2xl font-bold tracking-tight text-black"
        data-testid="product-price"
        data-value={selectedPrice.calculated_price_number}
      >
        {selectedPrice.calculated_price}
      </span>
      {isOnSale && (
        <span className="text-xs font-semibold text-white bg-black px-2.5 py-1 rounded-full">
          Sale
        </span>
      )}
    </div>
  )
}
