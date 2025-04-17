# Gunakan image dasar Ubuntu 22.04
FROM ubuntu:22.04

# Non-interaktif saat install package
ENV DEBIAN_FRONTEND=noninteractive

# Update dan install semua dependencies yang dibutuhkan Laravel + Apache
RUN apt update -y && \
    apt install -y apache2 \
    php \
    npm \
    php-xml \
    php-mbstring \
    php-curl \
    php-mysql \
    php-gd \
    unzip \
    nano \
    curl

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Buat direktori proyek Laravel
RUN mkdir -p /var/www/sosmed

# Salin semua file dari host ke container
ADD . /var/www/sosmed

# Salin konfigurasi virtual host Apache
ADD sosmed.conf /etc/apache2/sites-available/

# Atur virtual host Apache
RUN a2dissite 000-default.conf && \
    a2ensite sosmed.conf

# Ganti direktori kerja ke folder Laravel
WORKDIR /var/www/sosmed

# Buat folder Laravel penting (jika belum ada) dan atur permission
RUN mkdir -p bootstrap/cache storage && \
    chown -R www-data:www-data bootstrap/cache storage && \
    chmod -R 775 bootstrap/cache storage

# Jalankan script instalasi Laravel
RUN ./install.sh

# Pastikan semua file proyek bisa dibaca dan ditulis oleh Apache
RUN chown -R www-data:www-data /var/www/sosmed && \
    chmod -R 775 /var/www/sosmed

# Buka port 8000
EXPOSE 8000

# Jalankan Laravel server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

