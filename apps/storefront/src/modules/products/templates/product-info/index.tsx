import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

type ProductInfoProps = {
  product: HttpTypes.StoreProduct
}

const ProductInfo = ({ product }: ProductInfoProps) => {
  return (
    <div id="product-info" className="flex flex-col gap-y-2 font-iner">
      {/* Breadcrumb / Collection */}
      <LocalizedClientLink
        href="/"
        className="text-xs text-gray-500 hover:text-black transition-colors font-iner"
      >
        {product.collection ? product.collection.title : "Home page"}
      </LocalizedClientLink>

      {/* Product Title */}
      <h1
        className="text-3xl font-bold tracking-tight text-black font-iner"
        data-testid="product-title"
      >
        {product.title}
      </h1>
    </div>
  )
}

export default ProductInfo
