"use client"

import { addToCart } from "@lib/data/cart"
import { useIntersection } from "@lib/hooks/use-in-view"
import { HttpTypes } from "@medusajs/types"
import { Button } from "@modules/common/components/ui"
import Divider from "@modules/common/components/divider"
import OptionSelect from "@modules/products/components/product-actions/option-select"
import { isEqual } from "lodash"
import { useParams, usePathname, useSearchParams } from "next/navigation"
import { useEffect, useMemo, useRef, useState } from "react"
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
  const pathname = usePathname()
  const searchParams = useSearchParams()

  const [options, setOptions] = useState<Record<string, string | undefined>>({})
  const [isAdding, setIsAdding] = useState(false)
  const countryCode = useParams().countryCode as string

  // Preselect the first available variant's options by default
  useEffect(() => {
    if (product.variants && product.variants.length > 0) {
      const defaultVariant = product.variants[0]
      const variantOptions = optionsAsKeymap(defaultVariant.options)
      setOptions(variantOptions ?? {})
    }
  }, [product.variants])

  const selectedVariant = useMemo(() => {
    if (!product.variants || product.variants.length === 0) {
      return
    }

    return product.variants.find((v) => {
      const variantOptions = optionsAsKeymap(v.options)
      return isEqual(variantOptions, options)
    })
  }, [product.variants, options])

  // update the options when a variant is selected
  const setOptionValue = (optionId: string, value: string) => {
    setOptions((prev) => ({
      ...prev,
      [optionId]: value,
    }))
  }

  //check if the selected options produce a valid variant
  const isValidVariant = useMemo(() => {
    return product.variants?.some((v) => {
      const variantOptions = optionsAsKeymap(v.options)
      return isEqual(variantOptions, options)
    })
  }, [product.variants, options])

  useEffect(() => {
    const params = new URLSearchParams(searchParams.toString())
    const value = isValidVariant ? selectedVariant?.id : null

    if (params.get("v_id") === value) {
      return
    }

    if (value) {
      params.set("v_id", value)
    } else {
      params.delete("v_id")
    }

    router.replace(pathname + "?" + params.toString())
  }, [selectedVariant, isValidVariant])

  // check if the selected variant is in stock
  const inStock = useMemo(() => {
    // If we don't manage inventory, we can always add to cart
    if (selectedVariant && !selectedVariant.manage_inventory) {
      return true
    }

    // If we allow back orders on the variant, we can add to cart
    if (selectedVariant?.allow_backorder) {
      return true
    }

    // If there is inventory available, we can add to cart
    if (
      selectedVariant?.manage_inventory &&
      (selectedVariant?.inventory_quantity || 0) > 0
    ) {
      return true
    }

    // Otherwise, we can't add to cart
    return false
  }, [selectedVariant])

  const actionsRef = useRef<HTMLDivElement>(null)

  const inView = useIntersection(actionsRef, "0px")

  const [quantity, setQuantity] = useState(1)

  // add the selected variant to the cart
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

  // Stock inventory calculation
  const inventoryQty = selectedVariant?.inventory_quantity ?? 0
  const isLowStock = selectedVariant?.manage_inventory && !selectedVariant?.allow_backorder && inventoryQty > 0 && inventoryQty <= 5

  return (
    <>
      <div className="flex flex-col gap-y-5 font-iner" ref={actionsRef}>
        {/* Pricing */}
        <ProductPrice product={product} variant={selectedVariant} />

        {/* Taxes & Shipping Info */}
        <p className="text-xs text-gray-500 font-iner">
          Taxes included. <span className="underline cursor-pointer">Shipping</span> calculated at checkout.
        </p>

        {/* Low Stock Indicator Badge */}
        {isLowStock && (
          <div className="flex items-center gap-2 text-xs text-amber-800 bg-amber-50 border border-amber-200 px-3 py-1.5 rounded-full w-fit font-medium">
            <span className="w-2 h-2 rounded-full bg-amber-500 animate-pulse" />
            Low stock: {inventoryQty} left
          </div>
        )}

        {/* Variant Options (e.g., Color / Make it a stack) */}
        <div>
          {(product.variants?.length ?? 0) > 1 && (
            <div className="flex flex-col gap-y-4">
              {(product.options || []).map((option) => {
                return (
                  <div key={option.id}>
                    <OptionSelect
                      option={option}
                      current={options[option.id]}
                      updateOption={setOptionValue}
                      title={option.title ?? ""}
                      data-testid="product-options"
                      disabled={!!disabled || isAdding}
                    />
                  </div>
                )
              })}
            </div>
          )}
        </div>

        {/* Quantity Selector (- 1 +) */}
        <div className="flex flex-col gap-y-1.5">
          <span className="text-xs font-medium text-gray-700 font-iner">Quantity</span>
          <div className="flex items-center border border-gray-300 rounded-md w-36 h-10 px-3 justify-between bg-white">
            <button
              className="text-gray-500 hover:text-black text-lg disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
              onClick={() => setQuantity((prev) => Math.max(1, prev - 1))}
              disabled={quantity <= 1 || isAdding}
            >
              −
            </button>
            <span className="text-sm font-medium text-black font-iner">{quantity}</span>
            <button
              className="text-gray-500 hover:text-black text-lg disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
              onClick={() => setQuantity((prev) => prev + 1)}
              disabled={isAdding}
            >
              +
            </button>
          </div>
        </div>

        {/* Delivery Timeline Notice */}
        <p className="text-[11px] font-semibold tracking-wider text-gray-500 uppercase font-iner">
          DELIVERY AVAILABLE AT YOUR PINCODE IN 2-3 DAYS
        </p>

        {/* Add to Cart Button (Transparent Outline Button with crisp border & text) */}
        <Button
          onClick={() => handleAddToCart(false)}
          disabled={
            !inStock ||
            !selectedVariant ||
            !!disabled ||
            isAdding ||
            !isValidVariant
          }
          className="w-full h-12 bg-white hover:bg-gray-100 text-black border-2 border-black font-semibold rounded-lg text-sm transition-all shadow-xs"
          isLoading={isAdding}
          data-testid="add-product-button"
        >
          {!selectedVariant && !options
            ? "Select variant"
            : !inStock || !isValidVariant
            ? "Out of stock"
            : "Add to cart"}
        </Button>

        {/* Buy It Now Button (Yellow Accent Button with bold black text) */}
        <Button
          onClick={() => handleAddToCart(true)}
          disabled={
            !inStock ||
            !selectedVariant ||
            !!disabled ||
            isAdding ||
            !isValidVariant
          }
          className="w-full h-12 bg-[#FDE047] hover:bg-[#FACC15] text-black font-bold rounded-lg text-sm transition-all shadow-xs border-0"
          isLoading={isAdding}
        >
          Buy it now
        </Button>

        {/* Founder's Note Section (After Add to Cart / Buy it now) */}
        {product.description && (
          <div className="mt-4 pt-4 border-t border-gray-200 space-y-2">
            <h3 className="text-base font-bold text-black font-iner">Founder's note :</h3>
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
