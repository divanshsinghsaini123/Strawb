import { HttpTypes } from "@medusajs/types"
import { clx } from "@modules/common/components/ui"
import React from "react"

type OptionSelectProps = {
  option: HttpTypes.StoreProductOption
  current: string | undefined
  updateOption: (title: string, value: string) => void
  title: string
  disabled: boolean
  "data-testid"?: string
}

const OptionSelect: React.FC<OptionSelectProps> = ({
  option,
  current,
  updateOption,
  title,
  "data-testid": dataTestId,
  disabled,
}) => {
  const filteredOptions = Array.from(
    new Set((option.values ?? []).map((v) => v.value))
  )

  return (
    <div className="flex flex-col gap-y-3 font-iner">
      <span className="text-sm font-normal text-black font-iner">{title}</span>
      <div
        className="flex flex-wrap gap-2"
        data-testid={dataTestId}
      >
        {filteredOptions.map((v) => {
          const isSelected = v === current
          return (
            <button
              onClick={() => updateOption(option.id, v)}
              key={v}
              className={clx(
                "min-w-[44px] px-4 py-2 text-sm font-normal rounded-full transition-all duration-150 border font-iner",
                {
                  "bg-black text-white border-black": isSelected,
                  "bg-white text-black border-gray-300 hover:border-black": !isSelected,
                }
              )}
              disabled={disabled}
              data-testid="option-button"
            >
              {v}
            </button>
          )
        })}
      </div>
    </div>
  )
}

export default OptionSelect
