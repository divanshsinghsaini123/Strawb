"use client"

import { useState, useEffect } from "react"

const messages = [
  { text: "BUY EVERYTHING 🍓", href: null },
  { text: "CLICK TO WHATSAPP 👆 →", href: "https://wa.me/919999999999" },
  { text: "COUPONS AUTO APPLIED AT CHECKOUT", href: null },
  { text: "FREE SHIPPING ON ORDERS ABOVE ₹999", href: null },
]

export default function AnnouncementBar() {
  const [current, setCurrent] = useState(0)
  const [animating, setAnimating] = useState(false)

  const goTo = (index: number) => {
    setAnimating(true)
    setTimeout(() => {
      setCurrent(index)
      setAnimating(false)
    }, 200)
  }

  const prev = () => {
    goTo((current - 1 + messages.length) % messages.length)
  }

  const next = () => {
    goTo((current + 1) % messages.length)
  }

  useEffect(() => {
    const interval = setInterval(next, 4000)
    return () => clearInterval(interval)
  }, [current])

  const msg = messages[current]

  return (
    <div
      className="w-full flex items-center justify-between px-4 py-2 text-white text-xs font-bold uppercase tracking-wide select-none"
      style={{ backgroundColor: "var(--strawb-red)", minHeight: "36px" }}
    >
      {/* Left Arrow */}
      <button
        onClick={prev}
        className="text-white opacity-70 hover:opacity-100 transition-opacity flex-shrink-0 w-6"
        aria-label="Previous message"
      >
        ‹
      </button>

      {/* Message */}
      <div
        className="flex-1 text-center transition-opacity duration-200"
        style={{ opacity: animating ? 0 : 1 }}
      >
        {msg.href ? (
          <a
            href={msg.href}
            target="_blank"
            rel="noreferrer"
            className="hover:underline"
          >
            {msg.text}
          </a>
        ) : (
          <span>{msg.text}</span>
        )}
      </div>

      {/* Right Arrow */}
      <button
        onClick={next}
        className="text-white opacity-70 hover:opacity-100 transition-opacity flex-shrink-0 w-6"
        aria-label="Next message"
      >
        ›
      </button>
    </div>
  )
}
