import { HttpTypes } from "@medusajs/types"
import { Container } from "@modules/common/components/ui"
import Image from "next/image"

type ImageGalleryProps = {
  images: HttpTypes.StoreProductImage[]
}

const ImageGallery = ({ images }: ImageGalleryProps) => {
  if (!images || images.length === 0) {
    return null
  }

  const mainImage = images[0]
  const remainingImages = images.slice(1)

  return (
    <div className="flex flex-col gap-3 w-full">
      {/* 1. Main First Image (Big) */}
      <Container
        key={mainImage.id}
        className="relative aspect-[4/3] small:aspect-[5/4] w-full overflow-hidden bg-ui-bg-subtle"
        id={mainImage.id}
      >
        {!!mainImage.url && (
          <Image
            src={mainImage.url}
            priority={true}
            className="absolute inset-0 object-cover"
            alt="Product main image"
            fill
            sizes="(max-width: 768px) 100vw, 66vw"
          />
        )}
      </Container>

      {/* 2. Remaining Images (2 per row in grid) */}
      {remainingImages.length > 0 && (
        <div className="grid grid-cols-2 gap-3 w-full">
          {remainingImages.map((image, index) => {
            return (
              <Container
                key={image.id}
                className="relative aspect-[1/1] w-full overflow-hidden bg-ui-bg-subtle"
                id={image.id}
              >
                {!!image.url && (
                  <Image
                    src={image.url}
                    priority={index < 2}
                    className="absolute inset-0 object-cover"
                    alt={`Product image ${index + 2}`}
                    fill
                    sizes="(max-width: 768px) 50vw, 33vw"
                  />
                )}
              </Container>
            )
          })}
        </div>
      )}
    </div>
  )
}

export default ImageGallery
