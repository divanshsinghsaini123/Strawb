import { Metadata } from "next"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

type BlogPost = {
  id: string
  handle: string
  title: string
  summary?: string
  content?: string
  thumbnail?: string
  published_at?: string
  tags?: string[]
  author?: string
}

async function getBlogPost(handle: string): Promise<BlogPost | null> {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL}/content/gifting/items/${handle}`,
      {
        headers: {
          "x-publishable-api-key":
            process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
        },
        next: { revalidate: 60 },
      }
    )
    if (!res.ok) return null
    const data = await res.json()
    const item = data?.content_item || data?.item || data?.post || data?.data
    if (!item) return null

    return {
      id: item.id,
      handle: item.metadata?.handle || item.slug || item.handle || handle,
      title: item.metadata?.title || item.title || "Untitled",
      summary: item.metadata?.summary || item.summary,
      content: item.body || item.content || item.metadata?.body || item.metadata?.content,
      thumbnail: typeof item.metadata?.thumbnail === "string" ? item.metadata?.thumbnail : item.metadata?.thumbnail?.url || item.thumbnail,
      published_at: item.published_at || item.metadata?.published_at,
      tags: item.tags || item.metadata?.tags,
      author: item.creator?.name || item.metadata?.author || item.author,
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
  const post = await getBlogPost(slug)
  return {
    title: post ? `${post.title} — Strawb Gifting Guide` : "Post not found — Strawb",
    description: post?.summary || "Thoughtful gift ideas from Strawb.",
  }
}

export default async function GiftingPostPage({
  params,
}: {
  params: Promise<{ slug: string; countryCode: string }>
}) {
  const { slug } = await params
  const post = await getBlogPost(slug)

  if (!post) {
    return (
      <div className="content-container py-20 text-center">
        <p style={{ color: "var(--strawb-gray)" }}>Post not found.</p>
        <LocalizedClientLink href="/blogs/gifting" className="text-sm mt-4 inline-block hover:underline" style={{ color: "var(--strawb-red)" }}>
          ← Back to Gifting Guide
        </LocalizedClientLink>
      </div>
    )
  }

  return (
    <div className="content-container py-10 max-w-3xl mx-auto">
      {/* Back */}
      <LocalizedClientLink
        href="/blogs/gifting"
        className="text-xs mb-6 inline-flex items-center gap-1 hover:underline"
        style={{ color: "var(--strawb-gray)" }}
      >
        ← Gifting Guide
      </LocalizedClientLink>

      {/* Hero Image */}
      {post.thumbnail && (
        <div className="rounded-xl overflow-hidden mb-8 aspect-video bg-gray-100">
          <img
            src={typeof post.thumbnail === "string" ? post.thumbnail : (post.thumbnail as any)?.url}
            alt={post.title}
            className="w-full h-full object-cover"
          />
        </div>
      )}

      {/* Tags */}
      {Array.isArray(post.tags) && post.tags.length > 0 && (
        <div className="flex gap-2 mb-4 flex-wrap">
          {post.tags.map((tag) => (
            <span
              key={typeof tag === "string" ? tag : (tag as any)?.label || tag}
              className="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full"
              style={{ backgroundColor: "#FFF0F0", color: "var(--strawb-red)" }}
            >
              {typeof tag === "string" ? tag : (tag as any)?.label || tag}
            </span>
          ))}
        </div>
      )}

      {/* Title */}
      <h1 className="text-2xl small:text-3xl font-semibold leading-snug mb-4" style={{ color: "var(--strawb-black)" }}>
        {post.title}
      </h1>

      {/* Meta */}
      <div className="flex items-center gap-4 mb-8 text-xs" style={{ color: "var(--strawb-gray)" }}>
        {post.author && <span>By {post.author}</span>}
        {post.published_at && (
          <span>
            {new Date(post.published_at).toLocaleDateString("en-IN", {
              year: "numeric",
              month: "long",
              day: "numeric",
            })}
          </span>
        )}
      </div>

      {/* Content */}
      {post.content ? (
        <div
          className="prose prose-sm max-w-none"
          style={{ color: "var(--strawb-black)" }}
          dangerouslySetInnerHTML={{ __html: post.content }}
        />
      ) : post.summary ? (
        <p style={{ color: "var(--strawb-gray)" }}>{post.summary}</p>
      ) : (
        <p style={{ color: "var(--strawb-gray)" }}>No content yet.</p>
      )}

      {/* Founder's note */}
      <div
        className="mt-12 border-t pt-8 flex items-start gap-3"
        style={{ borderColor: "var(--strawb-border)" }}
      >
        <div
          className="w-8 h-8 rounded-full flex items-center justify-center text-white text-xs font-bold flex-shrink-0"
          style={{ backgroundColor: "var(--strawb-red)" }}
        >
          VT
        </div>
        <div>
          <p className="text-xs font-semibold mb-1" style={{ color: "var(--strawb-black)" }}>
            Vibin Thomas · Founder, Strawb
          </p>
          <p className="text-xs" style={{ color: "var(--strawb-gray)" }}>
            Every Strawb piece is made thinking of someone special. 🍓
          </p>
        </div>
      </div>
    </div>
  )
}
