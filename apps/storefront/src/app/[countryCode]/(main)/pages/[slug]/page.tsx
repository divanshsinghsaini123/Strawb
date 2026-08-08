import { Metadata } from "next"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

type CMSPage = {
  id: string
  slug: string
  title: string
  heading?: string
  content?: string
  published_at?: string
}

async function getPage(slug: string): Promise<CMSPage | null> {
  try {
    const backendUrl = process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000"
    const apiKey = process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || ""
    const res = await fetch(`${backendUrl}/content/pages/items/${slug}`, {
      headers: {
        "x-publishable-api-key": apiKey,
      },
      next: { revalidate: 60 },
    })

    if (!res.ok) return null
    const data = await res.json()
    const item = data?.content_item || data?.item || data?.data
    if (!item) return null

    return {
      id: item.id,
      slug: item.slug || item.metadata?.slug || slug,
      title: item.title || item.metadata?.heading || item.metadata?.title || "Page",
      heading: item.metadata?.heading || item.title,
      content: item.body || item.content || item.metadata?.content || item.metadata?.body,
      published_at: item.published_at,
    }
  } catch {
    return null
  }
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>
}): Promise<Metadata> {
  const { slug } = await params
  const page = await getPage(slug)
  return {
    title: page ? `${page.title} — Strawb` : "Strawb",
  }
}

export default async function StaticCMSPage({
  params,
}: {
  params: Promise<{ slug: string; countryCode: string }>
}) {
  const { slug } = await params
  const page = await getPage(slug)

  if (!page) {
    return (
      <div className="content-container py-20 text-center">
        <h1 className="text-2xl font-bold mb-2">Page Not Found</h1>
        <p style={{ color: "var(--strawb-gray)" }}>The requested page could not be found.</p>
        <LocalizedClientLink href="/" className="text-sm mt-4 inline-block hover:underline" style={{ color: "var(--strawb-red)" }}>
          ← Back to Home
        </LocalizedClientLink>
      </div>
    )
  }

  return (
    <div className="content-container py-12 max-w-4xl mx-auto">
      {/* Title */}
      <h1 className="text-3xl font-bold text-black mb-6">
        {page.heading || page.title}
      </h1>

      {/* Page Body */}
      {page.content ? (
        <div
          className="prose prose-sm max-w-none leading-relaxed text-gray-800 space-y-4"
          dangerouslySetInnerHTML={{ __html: page.content }}
        />
      ) : (
        <p className="text-gray-500">No content available for this page.</p>
      )}
    </div>
  )
}
