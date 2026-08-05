"use client"

import { useState, useEffect } from "react"

export type AnnouncementItem = {
  text: string
  href: string | null
}

const DEFAULT_MESSAGES: AnnouncementItem[] = [
  { text: "Welcome🍓", href: null }
]

export default function AnnouncementBar({ initialMessages, }: { initialMessages?: AnnouncementItem[] }) {
  const messages = initialMessages && initialMessages.length > 0 ? initialMessages : DEFAULT_MESSAGES
  const [current, setCurrent] = useState(0)
  const [animating, setAnimating] = useState(false)

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
    if (!messages.length || messages.length === 1) return
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
