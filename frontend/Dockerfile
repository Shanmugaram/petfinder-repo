# frontend/Dockerfile (Angular production served via nginx)

# ---------- Stage 1: Build ----------
FROM node:20-alpine AS build
WORKDIR /app

# Copy dependency files and install dependencies
COPY package*.json ./
RUN npm install -g @angular/cli@17.3.0
RUN npm ci || npm install

# Copy source files
COPY . .

# Create dummy environment.prod.ts (only inside Docker)
RUN mkdir -p src/environments && echo "export const environment = { production: true };" > src/environments/environment.prod.ts

# Build Angular using npx ng or globally installed CLI
RUN ng build || npx ng build

# ---------- Stage 2: Serve via NGINX ----------
FROM nginx:stable-alpine AS prod

# Copy built Angular app from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: replace NGINX default config
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

