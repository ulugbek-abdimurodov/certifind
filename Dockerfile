# CertiFind frontend image (Next.js standalone server). Built and run by
# deploy/docker-compose.prod.yml as the "frontend" service, behind the nginx proxy.
#
# NEXT_PUBLIC_API_URL is baked into the browser bundle at build time. Empty (the
# default) means same-origin: the browser calls /api/... on the host that served
# the page, which the proxy forwards to the backend.

FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY next.config.ts tsconfig.json next-env.d.ts ./
COPY app app
COPY components components
ARG NEXT_PUBLIC_API_URL=""
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    HOSTNAME=0.0.0.0 \
    PORT=3000
COPY --from=build --chown=node:node /app/.next/standalone ./
COPY --from=build --chown=node:node /app/.next/static ./.next/static
USER node
EXPOSE 3000
CMD ["node", "server.js"]
