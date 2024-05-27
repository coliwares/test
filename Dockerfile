# Stage 1: Build the application
FROM node:alpine AS my-app-build
WORKDIR /app
COPY . .
RUN npm ci && npm run build --prod

# Stage 2: Serve the application using Nginx
FROM nginx:alpine

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the built application files from the previous stage
COPY --from=my-app-build /app/dist/pokedex-app/browser /usr/share/nginx/html

# Expose port 80 for incoming traffic
EXPOSE 80