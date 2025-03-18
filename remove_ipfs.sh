#!/bin/bash

# Останавливаем сервис IPFS, если он запущен
systemctl stop ipfs 2>/dev/null || echo "IPFS сервис не запущен"

# Отключаем автозагрузку
systemctl disable ipfs 2>/dev/null || echo "IPFS сервис не включен в автозагрузку"

# Удаляем файл сервиса
[ -f /etc/systemd/system/ipfs.service ] && rm /etc/systemd/system/ipfs.service && echo "Файл сервиса IPFS удален"

# Перезагружаем конфигурацию systemd
systemctl daemon-reload

echo "IPFS сервис остановлен и удален из автозагрузки"
echo "Примечание: IPFS бинарный файл и данные не удалены, вы можете сделать это позже вручную" 