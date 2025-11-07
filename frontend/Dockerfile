# frontend/Dockerfile (Angular production served via nginx)

# ---------- Stage 1: Build ----------
FROM node:20-alpine AS build
WORKDIR /app

# Copy dependency files and install
COPY package.json package-lock.json* ./
RUN npm ci || npm install

# Copy the rest of the project
COPY . .

# Create a dummy environment.prod.ts to avoid build error
RUN mkdir -p src/environments && echo "export const environment = { production: true };" > src/environments/environment.prod.ts

# Build Angular app (default build)
RUN npx ng build

# ---------- Stage 2: NGINX ----------
FROM nginx:stable-alpine AS prod

# Copy built Angular app from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: custom nginx config (if needed)
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

