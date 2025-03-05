#!/bin/bash

# Скрипт для запуска IPFS демона
# Запускает IPFS демон в фоновом режиме

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Проверка, запущен ли уже IPFS демон
if pgrep -x "ipfs" > /dev/null
then
    echo "IPFS демон уже запущен"
    exit 0
fi

# Запуск IPFS демона в фоновом режиме
echo "Запуск IPFS демона..."
nohup ipfs daemon --enable-gc > /dev/null 2>&1 &

# Ожидание запуска демона
echo "Ожидание запуска IPFS демона..."
sleep 5

# Проверка, запустился ли демон
if pgrep -x "ipfs" > /dev/null
then
    echo "IPFS демон успешно запущен"
    echo "Для доступа к файлам используйте: http://localhost:8080/ipfs/YOUR_CID"
else
    echo "Ошибка: IPFS демон не запустился"
    exit 1
fi 