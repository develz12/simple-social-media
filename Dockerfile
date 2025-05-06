FROM ubuntu:22.04

# Install dependencies
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y apache2 \
    php \
    npm \
    php-xml \
    php-mbstring \
    php-curl \
    php-mysql \
    php-gd \
    unzip \
    nano \
    curl \
    git

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Buat direktori proyek dan copy semua file
RUN mkdir -p /var/www/sosmed
WORKDIR /var/www/sosmed
ADD . /var/www/sosmed

# Pastikan folder cache Laravel ada dan bisa ditulis
RUN mkdir -p bootstrap/cache && \
    chown -R www-data:www-data /var/www/sosmed && \
    chmod -R 775 bootstrap/cache

# Tambahkan konfigurasi Git safe directory (untuk mencegah error Git "dubious ownership")
RUN git config --global --add safe.directory /var/www/sosmed

# Copy konfigurasi virtual host Apache
ADD sosmed.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf && a2ensite sosmed.conf

# Jalankan script install Laravel
RUN chmod +x install.sh && ./install.sh

# Set ownership dan permission terakhir
RUN chown -R www-data:www-data /var/www/sosmed && \
    chmod -R 755 /var/www/sosmed

EXPOSE 8000
CMD php artisan serve --host=0.0.0.0 --port=8000

