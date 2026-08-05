import { Metadata } from "next"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import { Pagination } from "@modules/store/components/pagination"

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
  thumbnail?: string | { url?: string; id?: string }
  published_at?: string
  tags?: string[] | { label: string; value: string }[]
}

const ITEMS_PER_PAGE = 6

async function getBlogPosts(page: number = 1): Promise<{ posts: BlogPost[]; count: number }> {
  try {
    const offset = (page - 1) * ITEMS_PER_PAGE
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL}/content/gifting/items?limit=${ITEMS_PER_PAGE}&offset=${offset}`,
      {
        headers: {
          "x-publishable-api-key":
            process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
        },
        next: { revalidate: 60 },
      }
    )
    if (!res.ok) return { posts: [], count: 0 }
    const data = await res.json()
    const items = data?.content_items || data?.items || data?.posts || data?.data || []
    const count = data?.count || items.length

    const posts = items.map((item: any) => ({
      id: item.id,
      handle: item.metadata?.handle || item.handle || item.id,
      title: item.metadata?.title || item.title || "Untitled",
      summary: item.metadata?.summary || item.summary,
      thumbnail: item.metadata?.thumbnail || item.thumbnail,
      published_at: item.metadata?.published_at || item.published_at,
      tags: item.metadata?.tags || item.tags,
    }))

    return { posts, count }
  } catch {
    return { posts: [], count: 0 }
  }
}

export default async function GiftingBlogPage(props: {
  searchParams: Promise<{ page?: string }>
}) {
  const searchParams = await props.searchParams
  const currentPage = searchParams.page ? parseInt(searchParams.page) : 1

  const { posts, count } = await getBlogPosts(currentPage)
  const totalPages = Math.ceil(count / ITEMS_PER_PAGE) || 1

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
          <p>No blog posts yet.</p>
        </div>
      ) : (
        <>
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
                      src={typeof post.thumbnail === "string" ? post.thumbnail : post.thumbnail?.url}
                      alt={post.title}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                  </div>
                )}
                <div className="p-4">
                  {/* Tags */}
                  {Array.isArray(post.tags) && post.tags.length > 0 && (
                    <div className="flex gap-2 mb-2 flex-wrap">
                      {post.tags.map((tag) => {
                        const label = typeof tag === "string" ? tag : (tag as any)?.label || tag
                        return (
                          <span
                            key={label}
                            className="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full"
                            style={{
                              backgroundColor: "#FFF0F0",
                              color: "var(--strawb-red)",
                            }}
                          >
                            {label}
                          </span>
                        )
                      })}
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

          {/* Pagination Controls */}
          {totalPages > 1 && (
            <Pagination page={currentPage} totalPages={totalPages} />
          )}
        </>
      )}
    </div>
  )
}
