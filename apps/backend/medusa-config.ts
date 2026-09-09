import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET,
      cookieSecret: process.env.COOKIE_SECRET,
    },
    cookieOptions: {
      sameSite: "lax",
      secure: false,
    },
  },
  modules: [
    {
      resolve: "@medusajs/medusa/payment",
      options: {
        providers: [
          {
            resolve: "@sgftech/payment-razorpay",
            id: "razorpay",
            options: {
              key_id:
                process.env.RAZORPAY_TEST_KEY_ID ??
                process.env.RAZORPAY_ID,
              key_secret:
                process.env.RAZORPAY_TEST_KEY_SECRET ??
                process.env.RAZORPAY_SECRET,
              razorpay_account:
                process.env.RAZORPAY_TEST_ACCOUNT ??
                process.env.RAZORPAY_ACCOUNT,
              automatic_expiry_period: 30,
              manual_expiry_period: 20,
              refund_speed: "normal",
              webhook_secret:
                process.env.RAZORPAY_TEST_WEBHOOK_SECRET ??
                process.env.RAZORPAY_WEBHOOK_SECRET,
            },
          },
        ],
      },
    },
  ],
  plugins: [
    {
      resolve: 'medusa-plugin-content',
      options: {}
    }
    // ... other plugins
  ]
})
