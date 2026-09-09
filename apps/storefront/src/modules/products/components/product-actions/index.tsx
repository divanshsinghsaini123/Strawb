"use client"

import { addToCart } from "@lib/data/cart"
import { useIntersection } from "@lib/hooks/use-in-view"
import { HttpTypes } from "@medusajs/types"
import { Button } from "@modules/common/components/ui"
import OptionSelect from "@modules/products/components/product-actions/option-select"
import { isEqual } from "lodash"
import { useParams } from "next/navigation"
import { useMemo, useRef, useState } from "react"
import ProductPrice from "../product-price"
import MobileActions from "./mobile-actions"
import { useRouter } from "next/navigation"

type ProductActionsProps = {
  product: HttpTypes.StoreProduct
  region: HttpTypes.StoreRegion
  disabled?: boolean
}

const optionsAsKeymap = (
  variantOptions: HttpTypes.StoreProductVariant["options"]
) => {
  return variantOptions?.reduce((acc: Record<string, string>, varopt) => {
    if (varopt.option_id) acc[varopt.option_id] = varopt.value
    return acc
  }, {})
}

export default function ProductActions({
  product,
  disabled,
}: ProductActionsProps) {
  const router = useRouter()
  const countryCode = useParams().countryCode as string

  // Lazy initializer — sets the first variant's options immediately on mount.
  // Using a useEffect here caused the options to reset whenever Next.js
  // re-rendered (e.g. after router.replace or Suspense refetch).
  const [options, setOptions] = useState<Record<string, string | undefined>>(
    () => {
      if (product.variants && product.variants.length > 0) {
        return optionsAsKeymap(product.variants[0].options) ?? {}
      }
      return {}
    }
  )

  const [isAdding, setIsAdding] = useState(false)
  const [quantity, setQuantity] = useState(1)

  const selectedVariant = useMemo(() => {
    if (!product.variants || product.variants.length === 0) return undefined
    return product.variants.find((v) =>
      isEqual(optionsAsKeymap(v.options), options)
    )
  }, [product.variants, options])

  const setOptionValue = (optionId: string, value: string) => {
    setOptions((prev) => ({ ...prev, [optionId]: value }))
  }

  const isValidVariant = useMemo(() => {
    return product.variants?.some((v) =>
      isEqual(optionsAsKeymap(v.options), options)
    )
  }, [product.variants, options])

  const inStock = useMemo(() => {
    if (!selectedVariant) return false
    if (!selectedVariant.manage_inventory) return true
    if (selectedVariant.allow_backorder) return true
    return (selectedVariant.inventory_quantity ?? 0) > 0
  }, [selectedVariant])

  const actionsRef = useRef<HTMLDivElement>(null)
  const inView = useIntersection(actionsRef, "0px")

  const handleAddToCart = async (shouldRedirectToCheckout = false) => {
    if (!selectedVariant?.id) return null

    setIsAdding(true)

    await addToCart({
      variantId: selectedVariant.id,
      quantity,
      countryCode,
    })

    setIsAdding(false)

    if (shouldRedirectToCheckout) {
      router.push(`/${countryCode}/checkout`)
    }
  }

  const inventoryQty = selectedVariant?.inventory_quantity ?? 0
  const isLowStock =
    selectedVariant?.manage_inventory &&
    !selectedVariant?.allow_backorder &&
    inventoryQty > 0 &&
    inventoryQty <= 5

  const isButtonDisabled = !inStock || !selectedVariant || !!disabled || isAdding || !isValidVariant

  return (
    <>
      <div className="flex flex-col gap-y-4 font-iner" ref={actionsRef}>
        {/* Pricing */}
        <ProductPrice product={product} variant={selectedVariant} />

        {/* Taxes & Shipping Info */}
        <p className="text-xs text-gray-500 font-iner">
          Taxes included.{" "}
          <span className="underline cursor-pointer">Shipping</span> calculated
          at checkout.
        </p>

        {/* Low Stock Badge */}
        {isLowStock && (
          <div className="flex items-center gap-2 text-xs text-orange-700 w-fit font-iner">
            <span className="w-2.5 h-2.5 rounded-full bg-orange-400 inline-block" />
            Low stock: {inventoryQty} left
          </div>
        )}

        {/* Variant Options */}
        {(product.options ?? []).length > 0 && (
          <div className="flex flex-col gap-y-5">
            {(product.options ?? []).map((option) => (
              <OptionSelect
                key={option.id}
                option={option}
                current={options[option.id]}
                updateOption={setOptionValue}
                title={option.title ?? ""}
                data-testid="product-options"
                disabled={!!disabled || isAdding}
              />
            ))}
          </div>
        )}

        {/* Quantity Selector */}
        <div className="flex flex-col gap-y-1.5">
          <span className="text-sm font-normal text-black font-iner">
            Quantity
          </span>
          <div className="flex items-center border border-gray-300 w-40 h-11 bg-white">
            <button
              className="w-11 h-full flex items-center justify-center text-gray-700 hover:bg-gray-50 text-base disabled:opacity-30 disabled:cursor-not-allowed transition-colors border-r border-gray-300"
              onClick={() => setQuantity((prev) => Math.max(1, prev - 1))}
              disabled={quantity <= 1 || isAdding}
            >
              −
            </button>
            <span className="text-sm font-medium text-black font-iner flex-1 text-center">
              {quantity}
            </span>
            <button
              className="w-11 h-full flex items-center justify-center text-gray-700 hover:bg-gray-50 text-base disabled:opacity-30 disabled:cursor-not-allowed transition-colors border-l border-gray-300"
              onClick={() => setQuantity((prev) => prev + 1)}
              disabled={isAdding}
            >
              +
            </button>
          </div>
        </div>

        {/* Delivery notice */}
        <p className="text-[10px] font-medium tracking-widest text-gray-500 uppercase font-iner">
          DELIVERY AVAILABLE AT YOUR PINCODE IN 2-3 DAYS
        </p>

        {/* Add to Cart Button */}
        <Button
          onClick={() => handleAddToCart(false)}
          disabled={isButtonDisabled}
          className="w-full h-14 bg-white hover:bg-gray-50 text-black border border-black font-normal text-sm transition-colors font-iner"
          style={{ borderRadius: "0px" }}
          isLoading={isAdding}
          data-testid="add-product-button"
        >
          {!inStock || !isValidVariant ? "Out of stock" : "Add to cart"}
        </Button>

        {/* Buy It Now Button */}
        <Button
          onClick={() => handleAddToCart(true)}
          disabled={isButtonDisabled}
          className="w-full h-14 bg-[#F5C842] hover:bg-[#e8b82e] text-black font-normal text-sm transition-colors font-iner border-0"
          style={{ borderRadius: "0px" }}
          isLoading={isAdding}
        >
          Buy it now
        </Button>

        {/* Founder's Note */}
        {product.description && (
          <div className="mt-2 pt-4 border-t border-gray-200 space-y-2">
            <h3 className="text-base font-bold text-black font-iner">
              Founder&apos;s note :
            </h3>
            <div
              className="text-sm text-gray-700 leading-relaxed font-normal font-iner space-y-2"
              dangerouslySetInnerHTML={{ __html: product.description }}
            />
          </div>
        )}

        <MobileActions
          product={product}
          variant={selectedVariant}
          options={options}
          updateOptions={setOptionValue}
          inStock={inStock}
          handleAddToCart={() => handleAddToCart(false)}
          isAdding={isAdding}
          show={!inView}
          optionsDisabled={!!disabled || isAdding}
        />
      </div>
    </>
  )
}
