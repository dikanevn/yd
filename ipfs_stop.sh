#!/bin/bash

# Скрипт для остановки IPFS демона

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Проверка, запущен ли IPFS демон
if ! pgrep -x "ipfs" > /dev/null
then
    echo "IPFS демон не запущен"
    exit 0
fi

# Остановка IPFS демона
echo "Остановка IPFS демона..."
pkill -f ipfs

# Ожидание остановки демона
echo "Ожидание остановки IPFS демона..."
sleep 3

# Проверка, остановился ли демон
if ! pgrep -x "ipfs" > /dev/null
then
    echo "IPFS демон успешно остановлен"
else
    echo "Ошибка: IPFS демон не остановился. Попробуйте принудительно завершить процесс:"
    echo "pkill -9 -f ipfs"
    exit 1
fi 