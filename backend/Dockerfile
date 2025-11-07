# backend/Dockerfile (multi-stage)
# Stage 1 - deps
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --production=false

# Stage 2 - build (not compiling TS here, but used to copy files and keep layers)
FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Stage 3 - prod image
FROM node:20-alpine AS prod
WORKDIR /app
ENV NODE_ENV=production

# create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# copy app files and production modules
COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app ./

EXPOSE 3000

# use non-root user
USER appuser

# default command (when not overridden by docker-compose)
CMD ["node", "server.js"]
