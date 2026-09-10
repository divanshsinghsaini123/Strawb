import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

type EmptyCartMessageProps = {
  customer?: HttpTypes.StoreCustomer | null
}

const EmptyCartMessage = ({ customer }: EmptyCartMessageProps) => {
  return (
    <div
      className="py-12 sm:py-20 px-4 flex flex-col items-center justify-center text-center font-iner w-full max-w-2xl mx-auto"
      data-testid="empty-cart-message"
    >
      <h1 className="text-3xl sm:text-4xl md:text-[44px] font-normal text-black tracking-tight mb-8">
        Your cart is empty
      </h1>

      <LocalizedClientLink
        href="/store"
        className="inline-flex items-center justify-center bg-[#F5C842] hover:brightness-95 transition-all text-black font-normal text-sm sm:text-base px-8 py-3 rounded-md shadow-xs"
        data-testid="continue-shopping-button"
      >
        Continue shopping
      </LocalizedClientLink>

      {!customer && (
        <div className="mt-14 sm:mt-16 flex flex-col items-center">
          <h2 className="text-xl sm:text-2xl font-normal text-black mb-2">
            Have an account?
          </h2>
          <p className="text-sm sm:text-base text-gray-700">
            <LocalizedClientLink
              href="/account"
              className="underline underline-offset-4 text-black hover:opacity-80"
              data-testid="empty-cart-login-link"
            >
              Log in
            </LocalizedClientLink>{" "}
            to check out faster.
          </p>
        </div>
      )}
    </div>
  )
}

export default EmptyCartMessage
