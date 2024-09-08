FROM php:8.1-fpm
ARG user
ARG uid
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    openssl \
    libzip-dev  \
    libonig-dev  \
    libicu-dev \
    autoconf  \
    pkg-config  \
    libssl-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo mbstring exif pcntl bcmath gd intl
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && chown -R $user:$user /home/$user
RUN apt-get update && apt-get -y install sudo
RUN echo "$user:$user" | chpasswd && adduser $user sudo
WORKDIR /var/www/html
USER $user