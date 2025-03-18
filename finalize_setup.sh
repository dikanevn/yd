#!/bin/bash

# Проверка запуска от имени root
if [ "$(id -u)" -ne 0 ]; then
    echo "Этот скрипт нужно запускать от имени root"
    exit 1
fi

echo "Начинаем финальную настройку сервера..."

# Проверка и перезапуск службы Nginx
systemctl status nginx > /dev/null
if [ $? -eq 0 ]; then
    echo "Перезапуск Nginx..."
    systemctl restart nginx
    echo "Nginx успешно перезапущен"
else
    echo "Запуск Nginx..."
    systemctl start nginx
    echo "Nginx запущен"
fi

# Проверка автозапуска Nginx
systemctl is-enabled nginx > /dev/null
if [ $? -ne 0 ]; then
    echo "Включение автозапуска Nginx..."
    systemctl enable nginx
    echo "Автозапуск Nginx включен"
else
    echo "Автозапуск Nginx уже включен"
fi

# Проверка сертификатов, если они уже настроены
if [ -d "/etc/letsencrypt/live/yapster-dimensions.xyz" ]; then
    echo "Проверка сертификатов Let's Encrypt..."
    certbot certificates
    echo "Проверка обновления сертификатов..."
    certbot renew --dry-run
fi

# Проверка прав доступа
echo "Проверка и обновление прав доступа..."
chmod 755 /root
chmod -R 755 /root/yd
chown -R www-data:www-data /root/yd/png /root/yd/uri

# Проверка конфигурации Nginx
echo "Проверка конфигурации Nginx..."
nginx -t

echo "Все настройки завершены. Перезагружаем сервер для применения всех изменений..."
echo "Сервер будет перезагружен через 5 секунд. Нажмите Ctrl+C для отмены."
sleep 5
reboot 