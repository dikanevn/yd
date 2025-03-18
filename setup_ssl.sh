#!/bin/bash

# Проверка запуска от имени root
if [ "$(id -u)" -ne 0 ]; then
    echo "Этот скрипт нужно запускать от имени root"
    exit 1
fi

# Установка Certbot для Let's Encrypt
apt-get update
apt-get install -y certbot python3-certbot-nginx

# Получение SSL сертификата через Let's Encrypt
# Для успешного выполнения необходимо, чтобы домен уже указывал на этот сервер
certbot --nginx -d yapster-dimensions.xyz -d www.yapster-dimensions.xyz --non-interactive --agree-tos --email admin@yapster-dimensions.xyz

# Проверка конфигурации и перезапуск Nginx
nginx -t && systemctl restart nginx

echo "HTTPS настроен для домена yapster-dimensions.xyz"
echo "Сертификаты будут автоматически обновляться через systemd таймер certbot"

# Проверка статуса сертификата
certbot certificates

echo "Настройка HTTPS завершена!" 