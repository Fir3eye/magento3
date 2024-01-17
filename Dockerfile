# Use PHP 8.1 FPM image
FROM php:8.1-apache


# Install required dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    unzip \
    curl \
    libicu-dev \
    libxslt-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libmcrypt-dev \
    libxml2-dev \
    libpq-dev \
    libldb-dev \
    libldap2-dev \
    libmemcached-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libonig-dev \
    libzip-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    intl \
    pdo_mysql \
    mysqli \
    opcache \
    soap \
    xsl \
    zip \
    curl \
    pdo \
    pdo_pgsql \
    pgsql \
    ldap \
    sockets


# Enable Apache modules
RUN a2enmod rewrite headers expires ssl

# Set ServerName directive
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf


# Download and install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set environment variables
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
ENV APACHE_DOCUMENT_ROOT /var/www/html


# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Use arguments to pass keys during build
ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY

# Set environment variable for Composer
ENV COMPOSER_AUTH="{\"http-basic\":{\"repo.magento.com\":{\"username\":\"${MAGENTO_PUBLIC_KEY}\",\"password\":\"${MAGENTO_PRIVATE_KEY}\"}}}"

# Copy Magento code into the container
# Skip this if you're using Composer to install Magento
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

 

#RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + 
#RUN find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +


# Disable Two-Factor Authentication
#RUN php bin/magento module:disable Magento_TwoFactorAuth
RUN php bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth

# Install Magento # Use the shell form of the RUN command and provide the absolute path to PHP
#RUN ["/bin/sh", "-c", "/var/www/html/bin/magento setup:install"]
#CMD ["/bin/sh", "-c", "/var/www/html/bin/magento setup:install"]

# Set permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 777 /var/www/html/generated
RUN chmod -R 777 /var/www/html/var
RUN chmod -R 777 /var/www/html/vendor 

# Expose the port Magento is reachable on
EXPOSE 80

# Start the PHP FPM server
CMD ["apache2-foreground"]
