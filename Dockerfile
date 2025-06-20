FROM php:8.2-cli

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    zip \
    libpq-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    curl \
    && docker-php-ext-install pdo pdo_pgsql

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Копируем все файлы проекта
COPY . .

# Устанавливаем зависимости без dev, без автоскриптов и запускаем их вручную
RUN composer install --no-dev --optimize-autoloader --no-scripts \
 && composer run-script auto-scripts

# Запуск встроенного PHP-сервера
CMD php -d variables_order=EGPCS -S 0.0.0.0:8080 -t public
