import { Metadata } from "next"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

export const metadata: Metadata = {
  title: "Gifting Guide — Strawb",
  description:
    "Find the perfect gift for your loved ones. Curated gift ideas from Strawb.",
}

type BlogPost = {
  id: string
  handle: string
  title: string
  summary?: string
  thumbnail?: string
  published_at?: string
  tags?: string[]
}

async function getBlogPosts(): Promise<BlogPost[]> {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL}/store/content/blog-post`,
      {
        headers: {
          "x-publishable-api-key":
            process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
        },
        next: { revalidate: 60 },
      }
    )
    if (!res.ok) return []
    const data = await res.json()
    return data?.items || data?.posts || data?.data || []
  } catch {
    return []
  }
}

export default async function GiftingBlogPage() {
  const posts = await getBlogPosts()

  return (
    <div className="content-container py-10">
      {/* Header */}
      <div className="mb-10">
        <h1
          className="text-3xl font-semibold mb-2"
          style={{ color: "var(--strawb-black)" }}
        >
          Gifting Guide 🎁
        </h1>
        <p style={{ color: "var(--strawb-gray)" }} className="text-sm">
          Thoughtful gift ideas from the Strawb team — curated with love.
        </p>
      </div>

      {posts.length === 0 ? (
        <div
          className="text-center py-24 text-sm"
          style={{ color: "var(--strawb-gray)" }}
        >
          <p>No blog posts yet. Add your first post in the Medusa admin → Content section.</p>
          <p className="mt-2">
            Create a content collection named{" "}
            <code className="bg-gray-100 px-1 rounded">gifting</code> with
            fields: title, handle, summary, thumbnail, published_at.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 small:grid-cols-2 medium:grid-cols-3 gap-6">
          {posts.map((post) => (
            <LocalizedClientLink
              key={post.id}
              href={`/blogs/gifting/${post.handle}`}
              className="group rounded-lg overflow-hidden border transition-shadow hover:shadow-md"
              style={{ borderColor: "var(--strawb-border)", backgroundColor: "#FFFFFF" }}
            >
              {/* Thumbnail */}
              {post.thumbnail && (
                <div className="aspect-video overflow-hidden bg-gray-100">
                  <img
                    src={post.thumbnail}
                    alt={post.title}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                </div>
              )}
              <div className="p-4">
                {/* Tags */}
                {post.tags && post.tags.length > 0 && (
                  <div className="flex gap-2 mb-2 flex-wrap">
                    {post.tags.map((tag) => (
                      <span
                        key={tag}
                        className="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full"
                        style={{
                          backgroundColor: "#FFF0F0",
                          color: "var(--strawb-red)",
                        }}
                      >
                        {tag}
                      </span>
                    ))}
                  </div>
                )}
                <h2
                  className="font-semibold text-base leading-snug mb-2 group-hover:underline"
                  style={{ color: "var(--strawb-black)" }}
                >
                  {post.title}
                </h2>
                {post.summary && (
                  <p
                    className="text-xs line-clamp-2"
                    style={{ color: "var(--strawb-gray)" }}
                  >
                    {post.summary}
                  </p>
                )}
                {post.published_at && (
                  <p
                    className="text-[10px] mt-3"
                    style={{ color: "var(--strawb-gray)" }}
                  >
                    {new Date(post.published_at).toLocaleDateString("en-IN", {
                      year: "numeric",
                      month: "long",
                      day: "numeric",
                    })}
                  </p>
                )}
              </div>
            </LocalizedClientLink>
          ))}
        </div>
      )}
    </div>
  )
}
