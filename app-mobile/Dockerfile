FROM node:20-alpine AS base

WORKDIR /app

# Enable pnpm
RUN corepack enable pnpm

# Install dependencies
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile

ENV NEXT_TELEMETRY_DISABLED 1

# --- dev: hot-reload, source mounted at runtime via docker-compose.override.yml ---
FROM base AS dev
EXPOSE 3000
CMD ["pnpm", "dev"]

# --- production: bakes the source in and serves a built app ---
FROM base AS production

COPY . .

# Provide a default API URL that can be overridden at build/runtime
ARG NEXT_PUBLIC_API_BASE_URL=http://localhost:8000/api/v1
ENV NEXT_PUBLIC_API_BASE_URL=$NEXT_PUBLIC_API_BASE_URL

RUN pnpm run build

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["pnpm", "start"]
