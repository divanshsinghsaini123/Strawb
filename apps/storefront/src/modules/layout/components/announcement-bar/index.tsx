"use client"

import { useState, useEffect } from "react"

type AnnouncementItem = {
  text: string
  href: string | null
}

const DEFAULT_MESSAGES: AnnouncementItem[] = [
  { text: "Welcome🍓", href: null }
]

export default function AnnouncementBar() {
  const [messages, setMessages] = useState<AnnouncementItem[]>(DEFAULT_MESSAGES)
  const [current, setCurrent] = useState(0)
  const [animating, setAnimating] = useState(false)

  // Fetch announcements from medusa-plugin-content CMS
  useEffect(() => {
    async function fetchAnnouncements() {
      try {
        const backendUrl = process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000"
        const apiKey = process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || ""
        const res = await fetch(`${backendUrl}/content/announcement-bar/items`, {
          headers: {
            "x-publishable-api-key": apiKey,
          },
        })
        if (res.ok) {
          const data = await res.json()
          const items = data?.content_items || data?.items || []
          if (items.length > 0) {
            const fetchedMessages: AnnouncementItem[] = items
              .map((item: any) => {
                const text =
                  item.metadata?.value ||
                  item.metadata?.title ||
                  item.title ||
                  item.body ||
                  ""
                const isLink =
                  item.metadata?.islink === true ||
                  item.metadata?.islink === "true" ||
                  item.metadata?.isLink === true ||
                  item.metadata?.isLink === "true"
                const url = item.metadata?.url || null
                return {
                  text,
                  href: isLink && url ? url : null,
                }
              })
              .filter((m: AnnouncementItem) => m.text)

            if (fetchedMessages.length > 0) {
              setMessages(fetchedMessages)
            }
          }
        }
      } catch {
        // Fallback to default messages on fetch error
      }
    }
    fetchAnnouncements()
  }, [])

  const goTo = (index: number) => {
    if (!messages.length) return
    setAnimating(true)
    setTimeout(() => {
      setCurrent(index)
      setAnimating(false)
    }, 200)
  }

  const prev = () => {
    if (!messages.length) return
    goTo((current - 1 + messages.length) % messages.length)
  }

  const next = () => {
    if (!messages.length) return
    goTo((current + 1) % messages.length)
  }

  useEffect(() => {
    if (!messages.length) return
    const timer = setInterval(() => {
      next()
    }, 4000)
    return () => clearInterval(timer)
  }, [current, messages.length])

  const msg = messages[current] || messages[0]

  if (!msg || !msg.text) {
    return null
  }

  return (
    <div
      className="w-full text-white text-xs font-semibold uppercase tracking-wider py-2 px-4 flex items-center justify-between select-none relative z-50 overflow-hidden"
      style={{ backgroundColor: "var(--strawb-red)", height: "36px" }}
      data-testid="announcement-bar"
    >
      {/* Left Chevron */}
      <button
        onClick={prev}
        aria-label="Previous announcement"
        className="hover:opacity-75 transition-opacity px-1 text-white font-bold text-sm"
      >
        ‹
      </button>

      {/* Message Text / Link */}
      <div
        className={`transition-all duration-200 ease-in-out text-center truncate mx-2 ${animating ? "opacity-0 scale-95" : "opacity-100 scale-100"
          }`}
      >
        {msg.href ? (
          <a
            href={msg.href}
            target="_blank"
            rel="noreferrer"
            className="hover:underline flex items-center justify-center gap-1"
          >
            {msg.text}
          </a>
        ) : (
          <span>{msg.text}</span>
        )}
      </div>

      {/* Right Chevron */}
      <button
        onClick={next}
        aria-label="Next announcement"
        className="hover:opacity-75 transition-opacity px-1 text-white font-bold text-sm"
      >
        ›
      </button>
    </div>
  )
}
