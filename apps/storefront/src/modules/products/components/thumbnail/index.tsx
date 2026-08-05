import { Container, clx } from "@modules/common/components/ui"
import Image from "next/image"
import React from "react"
import PlaceholderImage from "@modules/common/icons/placeholder-image"

type ThumbnailProps = {
  thumbnail?: string | null
  images?: { url?: string }[] | null
  size?: "small" | "medium" | "large" | "full" | "square"
  isFeatured?: boolean
  className?: string
  "data-testid"?: string
}

const Thumbnail: React.FC<ThumbnailProps> = ({
  thumbnail,
  images,
  size = "small",
  isFeatured,
  className,
  "data-testid": dataTestid,
}) => {
  const initialImage = thumbnail || images?.[0]?.url
  const secondaryImage = images && images.length > 1 ? images[1]?.url : null

  return (
    <Container
      className={clx(
        "relative w-full overflow-hidden p-0 bg-ui-bg-subtle shadow-none rounded-xl group transition-all duration-300",
        className,
        {
          "aspect-[11/14]": isFeatured,
          "aspect-[9/16]": !isFeatured && size !== "square",
          "aspect-[1/1]": size === "square",
          "w-[180px]": size === "small",
          "w-[290px]": size === "medium",
          "w-[440px]": size === "large",
          "w-full": size === "full",
        }
      )}
      data-testid={dataTestid}
    >
      <ImageOrPlaceholder
        image={initialImage}
        secondaryImage={secondaryImage}
        size={size}
      />
    </Container>
  )
}

const ImageOrPlaceholder = ({
  image,
  secondaryImage,
  size,
}: Pick<ThumbnailProps, "size"> & { image?: string; secondaryImage?: string | null }) => {
  if (!image) {
    return (
      <div className="w-full h-full absolute inset-0 flex items-center justify-center bg-gray-100 rounded-xl">
        <PlaceholderImage size={size === "small" ? 16 : 24} />
      </div>
    )
  }

  return (
    <div className="w-full h-full relative overflow-hidden rounded-xl">
      {/* Primary Image */}
      <Image
        src={image}
        alt="Thumbnail"
        className={clx(
          "absolute inset-0 object-cover object-center w-full h-full rounded-xl transition-all duration-500 ease-in-out",
          {
            "group-hover:opacity-0 group-hover:scale-105": secondaryImage,
            "group-hover:scale-105": !secondaryImage,
          }
        )}
        draggable={false}
        quality={75}
        sizes="(max-width: 576px) 280px, (max-width: 768px) 360px, (max-width: 992px) 480px, 800px"
        fill
      />

      {/* Secondary Image (Hover Effect) */}
      {secondaryImage && (
        <Image
          src={secondaryImage}
          alt="Thumbnail hover"
          className="absolute inset-0 object-cover object-center w-full h-full rounded-xl opacity-0 group-hover:opacity-100 group-hover:scale-105 transition-all duration-500 ease-in-out"
          draggable={false}
          quality={75}
          sizes="(max-width: 576px) 280px, (max-width: 768px) 360px, (max-width: 992px) 480px, 800px"
          fill
        />
      )}
    </div>
  )
}

export default Thumbnail
