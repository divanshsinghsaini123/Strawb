import { getProductPrice } from "@lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Thumbnail from "../thumbnail"

export default async function ProductPreview({
  product,
  isFeatured,
  region: _region,
}: {
  product: HttpTypes.StoreProduct
  isFeatured?: boolean
  region: HttpTypes.StoreRegion
}) {
  const { cheapestPrice } = getProductPrice({ product })

  const isOnSale =
    cheapestPrice?.price_type === "sale" &&
    cheapestPrice?.original_price !== cheapestPrice?.calculated_price

  const isSoldOut =
    !product.variants?.some((v) =>
      v.inventory_quantity == null ? true : v.inventory_quantity > 0
    )

  return (
    <LocalizedClientLink href={`/products/${product.handle}`} className="group">
      <div data-testid="product-wrapper">
        {/* Image container with badge overlay */}
        <div className="relative overflow-hidden rounded-xl bg-gray-100" style={{ aspectRatio: "1/1" }}>
          <Thumbnail
            thumbnail={product.thumbnail}
            images={product.images}
            size="square"
            isFeatured={isFeatured}
            className="!rounded-xl !shadow-none !bg-transparent !p-0"
          />

          {/* Sale / Sold Out Badge */}
          {isSoldOut ? (
            <span
              className="absolute bottom-3 left-3 text-white text-xs font-bold px-2 py-1 rounded-sm"
              style={{ backgroundColor: "var(--strawb-red)" }}
            >
              Sold out
            </span>
          ) : isOnSale ? (
            <span className="absolute bottom-3 left-3 text-white text-xs font-bold px-2 py-1 rounded-sm bg-black">
              Sale
            </span>
          ) : null}
        </div>

        {/* Product Info */}
        <div className="mt-3 space-y-1">
          {/* Title */}
          <p
            className="text-sm font-normal"
            style={{ color: "var(--strawb-black)" }}
            data-testid="product-title"
          >
            {product.title}
          </p>

          {/* Prices */}
          {cheapestPrice && (
            <div className="flex items-center gap-2 text-sm">
              {isOnSale && (
                <span
                  className="line-through text-xs"
                  style={{ color: "var(--strawb-gray)" }}
                  data-testid="original-price"
                >
                  {cheapestPrice.original_price}
                </span>
              )}
              <span
                className="font-semibold"
                style={{ color: isOnSale ? "var(--strawb-black)" : "var(--strawb-gray)" }}
                data-testid="price"
              >
                {cheapestPrice.calculated_price}
              </span>
            </div>
          )}
        </div>

        {/* Add to Cart Button */}
        <button
          className="mt-3 w-full border text-sm py-2 px-4 rounded transition-all duration-150"
          style={{
            borderColor: isSoldOut ? "var(--strawb-light-gray)" : "var(--strawb-black)",
            color: isSoldOut ? "var(--strawb-gray)" : "var(--strawb-black)",
            backgroundColor: "transparent",
            cursor: isSoldOut ? "not-allowed" : "pointer",
          }}
          disabled={isSoldOut}
        >
          {isSoldOut ? "Sold out" : "Add to cart"}
        </button>
      </div>
    </LocalizedClientLink>
  )
}
