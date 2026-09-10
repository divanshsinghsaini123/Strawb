import ItemsTemplate from "./items"
import Summary from "./summary"
import EmptyCartMessage from "../components/empty-cart-message"
import SignInPrompt from "../components/sign-in-prompt"
import Divider from "@modules/common/components/divider"
import { HttpTypes } from "@medusajs/types"

const CartTemplate = ({
  cart,
  customer,
}: {
  cart: HttpTypes.StoreCart | null
  customer: HttpTypes.StoreCustomer | null
}) => {
  const hasItems = (cart?.items?.length ?? 0) > 0

  return (
    <div
      className={
        hasItems
          ? "py-8 small:py-12"
          : "bg-white py-12 small:py-24 min-h-[65vh] flex items-center justify-center"
      }
    >
      <div className="content-container font-iner" data-testid="cart-container">
        {hasItems ? (
          <div className="grid grid-cols-1 small:grid-cols-[1fr_380px] gap-8 lg:gap-12 items-start">
            <div className="flex flex-col bg-white p-6 small:p-8 rounded-xl border border-gray-200/80 shadow-sm gap-y-6">
              {!customer && (
                <>
                  <SignInPrompt />
                  <Divider />
                </>
              )}
              <ItemsTemplate cart={cart || undefined} />
            </div>
            <div className="relative">
              <div className="flex flex-col gap-y-8 sticky top-12">
                {cart && cart.region && (
                  <div className="bg-white p-6 small:p-8 rounded-xl border border-gray-200/80 shadow-sm">
                    <Summary cart={cart} />
                  </div>
                )}
              </div>
            </div>
          </div>
        ) : (
          <EmptyCartMessage customer={customer} />
        )}
      </div>
    </div>
  )
}

export default CartTemplate
