FROM php:8.3-fpm-alpine3.20 AS php-fpm

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Copy opcache configuration
COPY docker/php/conf.d/opcache.ini "$PHP_INI_DIR/opcache.ini"

# Install system dependencies
RUN apk --no-cache add \
    vim

RUN apk --no-cache add --virtual .build-deps \
    $PHPIZE_DEPS

# Install PHP extensions
RUN docker-php-ext-install opcache

# Clear build dependencies
RUN apk del .build-deps

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
WORKDIR /var/www
COPY var/www/public ./public/

# Copy existing application directory permissions
RUN chown -R www-data:www-data .

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]