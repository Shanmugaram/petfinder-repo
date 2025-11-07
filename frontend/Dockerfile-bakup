# frontend/Dockerfile (Angular production served via nginx)
# Stage 1 - build
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY . .
# build Angular (production)
#RUN npx ng build --configuration production
RUN npx ng build

# Stage 2 - nginx
FROM nginx:stable-alpine AS prod
COPY --from=build /app/dist /usr/share/nginx/html
# Remove default nginx config if you want custom routes (optional)
# COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
