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
    <div className="flex flex-col gap-y-2">
      <span className="text-xs font-medium text-gray-700">Select {title}</span>
      <div
        className="flex flex-wrap gap-3"
        data-testid={dataTestId}
      >
        {filteredOptions.map((v) => {
          const isSelected = v === current
          return (
            <button
              onClick={() => updateOption(option.id, v)}
              key={v}
              className={clx(
                "px-5 py-2.5 text-xs font-normal rounded border transition-all duration-150 flex-1 min-w-[100px] text-center",
                {
                  "border-blue-500 text-black bg-white shadow-sm ring-1 ring-blue-500": isSelected,
                  "border-gray-200 text-gray-800 bg-white hover:border-gray-400": !isSelected,
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
