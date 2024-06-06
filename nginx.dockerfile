FROM nginx:alpine

# Set working directory
WORKDIR /var/www

# Copy NGINX configuration file
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy Symfony application public files
COPY var/www/public ./public

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
