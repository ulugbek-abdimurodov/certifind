# syntax=docker/dockerfile:1

# =============================================================================
# Stage 1: Dependencies
# Installs dependencies using package.json and package-lock.json with libc6-compat
# =============================================================================
FROM node:20-alpine AS deps
# libc6-compat provides compatibility for shared libraries required by some Node modules
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on package-lock.json
COPY package.json package-lock.json ./
RUN npm ci

# =============================================================================
# Stage 2: Builder
# Copies installed node_modules and application source files to build Next.js
# =============================================================================
FROM node:20-alpine AS builder
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Support build-time NEXT_PUBLIC_ variables for Next.js client bundles
ARG NEXT_PUBLIC_API_URL=/api/v1
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

# Disable Next.js telemetry during build
ENV NEXT_TELEMETRY_DISABLED=1

# Ensure public directory exists even if empty
RUN mkdir -p public

RUN npm run build

# =============================================================================
# Stage 3: Runner
# Minimal production runtime executing Next.js standalone server as non-root user
# =============================================================================
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"
ENV NEXT_TELEMETRY_DISABLED=1
ENV NEXT_PUBLIC_API_URL=/api/v1

# Create non-root system group and user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 -G nodejs nextjs

# Copy static assets and public directory
COPY --from=builder /app/public ./public

# Set correct permissions for Next.js cache
RUN mkdir -p .next && chown nextjs:nodejs .next

# Copy standalone build output and static assets
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Switch to unprivileged user
USER nextjs:nodejs

EXPOSE 3000

CMD ["node", "server.js"]
