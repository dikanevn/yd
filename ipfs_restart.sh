#!/bin/bash

# Скрипт для перезапуска IPFS демона

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Остановка IPFS демона, если он запущен
if pgrep -x "ipfs" > /dev/null
then
    echo "Остановка IPFS демона..."
    pkill -f ipfs
    
    # Ожидание остановки демона
    echo "Ожидание остановки IPFS демона..."
    sleep 3
    
    # Проверка, остановился ли демон
    if pgrep -x "ipfs" > /dev/null
    then
        echo "Ошибка: IPFS демон не остановился. Принудительное завершение..."
        pkill -9 -f ipfs
        sleep 2
    fi
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
    echo "IPFS демон успешно перезапущен"
    echo "Для доступа к файлам используйте: http://localhost:8080/ipfs/YOUR_CID"
else
    echo "Ошибка: IPFS демон не запустился"
    exit 1
fi 