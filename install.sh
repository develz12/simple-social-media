#!/bin/bash
set -e  # Stop script jika ada error

# Install Node.js dependencies
npm install

# Build frontend (gunakan ini jika kamu memang perlu dev server)
npm run dev &

# Install PHP dependencies
composer install

# Setup environment
cp -n .env.example .env || true
php artisan key:generate

# Ubah konfigurasi databae
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=172.17.0.2/' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/' .env

# Migrasi dan seed database
php artisan migrate --force
php artisan db:seed --force

# Buat symbolic link ke storage
php artisan storage:link

# Jalankan server Laravel
exec php artisan serve --host=0.0.0.0 --port=8000

