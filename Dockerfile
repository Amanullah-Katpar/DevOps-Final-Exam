# ---------- Stage 1: Build the frontend + install backend deps ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build


# ---------- Stage 2: Lightweight production image ----------
FROM node:20-alpine

WORKDIR /app

# Copy only what's needed to run the server (keeps image small, <200MB)
COPY --chown=node:node package*.json ./
RUN npm install --omit=dev && npm cache clean --force

COPY --chown=node:node --from=builder /app/dist ./dist
COPY --chown=node:node index.js ./

# Create the logs folder and hand ownership to the built-in non-root "node" user
RUN mkdir -p /app/logs && chown -R node:node /app/logs

# Mission 3: drop root privileges, run as the restricted "node" user
USER node

EXPOSE 5000

CMD ["node", "index.js"]
