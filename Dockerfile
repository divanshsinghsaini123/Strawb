FROM node:20-alpine AS base

WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./
COPY apps/backend/package.json ./apps/backend/
COPY apps/storefront/package.json ./apps/storefront/

# Install dependencies
RUN npm ci

# Copy source files
COPY . .

# Build application
RUN npm run build

# Production image
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

COPY --from=base /app ./

EXPOSE 9000 8000

CMD ["npm", "run", "start"]
