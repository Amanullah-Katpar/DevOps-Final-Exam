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

COPY package*.json ./
RUN npm install --omit=dev

COPY --from=builder /app/dist ./dist
COPY index.js ./

RUN mkdir -p /app/logs && chown -R node:node /app

USER node

EXPOSE 5000

CMD ["node", "index.js"]
