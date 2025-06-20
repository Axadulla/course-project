FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    unzip git zip libonig-dev libxml2-dev libzip-dev curl \
    && docker-php-ext-install pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

COPY . .

CMD php -S 0.0.0.0:8080 -t public
