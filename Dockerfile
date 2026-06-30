# ---------- Stage 1: Build the frontend + install backend deps ----------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Prune devDependencies to leave only production node_modules
RUN npm prune --production && npm cache clean --force

# ---------- Stage 2: Bare Alpine image with Node.js ----------
FROM alpine:3.19

WORKDIR /app

# Install Node.js (no npm or yarn)
RUN apk add --no-cache nodejs

# Copy runtime assets from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY index.js ./

# Create node user/group and logs folder, set ownership
RUN addgroup -g 1000 node && \
    adduser -u 1000 -G node -s /bin/sh -D node && \
    mkdir -p /app/logs && \
    chown -R node:node /app

# Run as restricted node user
USER node

EXPOSE 5000

CMD ["node", "index.js"]
