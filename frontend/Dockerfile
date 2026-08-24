FROM node:18-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build -- --configuration production

# Serve
FROM nginx:alpine

COPY --from=build /app/dist/frontend /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.d/30-envsubst-api-url.sh /docker-entrypoint.d/30-envsubst-api-url.sh
RUN chmod +x /docker-entrypoint.d/30-envsubst-api-url.sh

# Overridden at `docker run`/k8s time; this default targets a locally-run backend container.
ENV API_URL=http://localhost:3000/api

EXPOSE 80