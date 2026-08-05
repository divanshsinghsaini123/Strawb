import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

type ProductInfoProps = {
  product: HttpTypes.StoreProduct
}

const ProductInfo = ({ product }: ProductInfoProps) => {
  return (
    <div id="product-info" className="flex flex-col gap-y-4">
      {/* Breadcrumb / Collection */}
      <LocalizedClientLink
        href="/"
        className="text-xs text-gray-500 hover:text-black transition-colors"
      >
        {product.collection ? product.collection.title : "Home page"}
      </LocalizedClientLink>

      {/* Product Title */}
      <h1
        className="text-3xl font-bold tracking-tight text-black"
        data-testid="product-title"
      >
        {product.title}
      </h1>

      {/* Description / Founder's Note (HTML format) */}
      {product.description && (
        <div
          className="text-sm leading-relaxed text-gray-700 space-y-2 font-normal"
          data-testid="product-description"
          dangerouslySetInnerHTML={{ __html: product.description }}
        />
      )}
    </div>
  )
}

export default ProductInfo
