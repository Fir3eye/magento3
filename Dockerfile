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
    ctype \
    dom \
    hash \
    iconv \
    intl \
    mbstring \
    openssl \
    simplexml \
    xml \
    xmlreader \
    xmlwriter \
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

# Install Elasticsearch
RUN apt-get update && apt-get install -y gnupg wget \
    && wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list \
    && apt-get update && apt-get install -y elasticsearch
# Configure Elasticsearch
RUN echo "xpack.security.enabled: false" >> /etc/elasticsearch/elasticsearch.yml

# Start Elasticsearch
CMD ["elasticsearch"]

# Configure Elasticsearch
RUN echo "xpack.security.enabled: false" >> /etc/elasticsearch/elasticsearch.yml

# Expose Elasticsearch port
EXPOSE 9200

# Enable Apache modules and set document root
RUN a2enmod rewrite && \
    a2enmod headers && \
    a2enmod expires && \
    a2enmod ssl && \
    a2ensite default-ssl

# Set ServerName directive
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Download and install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set environment variables
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Copy Magento source code from the local machine to the image
COPY . /var/www/html

# Install Magento dependencies
WORKDIR /var/www/html

RUN chmod -R 777 /var/www/html/var
RUN chown -R www-data:www-data /var/www/html


# Enable Apache SSL module
RUN a2enmod ssl

# Install ssl-cert package
RUN apt-get update && apt-get install -y ssl-cert

# Generate snakeoil certificate
RUN make-ssl-cert generate-default-snakeoil --force-overwrite

# Restart Apache
RUN service apache2 restart



# Expose ports
EXPOSE 80
EXPOSE 443

# Start Apache
CMD ["apache2-foreground"]
