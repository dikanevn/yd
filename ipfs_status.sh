#!/bin/bash

# Скрипт для проверки статуса IPFS демона

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Проверка, запущен ли IPFS демон
if pgrep -x "ipfs" > /dev/null
then
    echo "IPFS демон запущен"
    
    # Получение PID процесса
    IPFS_PID=$(pgrep -x "ipfs")
    echo "PID: $IPFS_PID"
    
    # Проверка доступности API
    if curl -s -f -m 2 http://localhost:5001/api/v0/id > /dev/null
    then
        echo "API доступен: http://localhost:5001/api/v0/"
    else
        echo "API недоступен"
    fi
    
    # Проверка доступности Gateway
    if curl -s -f -m 2 http://localhost:8080/ipfs/QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn > /dev/null
    then
        echo "Gateway доступен: http://localhost:8080/ipfs/"
    else
        echo "Gateway недоступен"
    fi
    
    # Получение информации о ноде
    echo "Информация о ноде:"
    ipfs id | grep -E "ID|Addresses"
else
    echo "IPFS демон не запущен"
    exit 1
fi 