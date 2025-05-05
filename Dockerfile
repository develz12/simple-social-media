FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update -y && apt install -y \
  apache2 \
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

# Tambahkan source code dan konfigurasi
RUN mkdir -p /var/www/sosmed
ADD . /var/www/sosmed
ADD sosmed.conf /etc/apache2/sites-available/

# Konfigurasi Apache
RUN a2dissite 000-default.conf && \
    a2ensite sosmed.conf

# Set working directory
WORKDIR /var/www/sosmed

# Set permission
RUN chown -R www-data:www-data /var/www/sosmed && \
    chmod -R 755 /var/www/sosmed

# Buat install.sh bisa dijalankan
RUN chmod +x install.sh

EXPOSE 8000

# Jalankan install.sh saat container start
CMD ["./install.sh"]

