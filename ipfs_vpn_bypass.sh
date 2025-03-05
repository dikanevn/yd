#!/bin/bash

# Комплексный скрипт для запуска IPFS с обходом VPN
# Настраивает IPFS, запускает демон и настраивает локальный доступ

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Функция для проверки статуса IPFS демона
check_ipfs_daemon() {
    if pgrep -x "ipfs" > /dev/null
    then
        echo "IPFS демон запущен"
        return 0
    else
        echo "IPFS демон не запущен"
        return 1
    fi
}

# Функция для запуска IPFS демона
start_ipfs_daemon() {
    echo "Запуск IPFS демона..."
    
    # Настройка API для доступа извне WSL
    echo "Настройка API для доступа извне WSL..."
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST", "GET"]'
    
    # Настройка Addresses.API для прослушивания всех интерфейсов
    echo "Настройка API для прослушивания всех интерфейсов..."
    ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
    
    # Настройка Addresses.Gateway для прослушивания всех интерфейсов
    echo "Настройка Gateway для прослушивания всех интерфейсов..."
    ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
    
    # Запуск IPFS демона
    nohup ipfs daemon --enable-gc > /dev/null 2>&1 &
    
    # Ожидание запуска демона
    echo "Ожидание запуска IPFS демона..."
    sleep 5
    
    # Проверка, запустился ли демон
    if check_ipfs_daemon
    then
        echo "IPFS демон успешно запущен"
        return 0
    else
        echo "Ошибка: IPFS демон не запустился"
        return 1
    fi
}

# Функция для проверки доступности локального шлюза
check_local_gateway() {
    echo "Проверка доступности локального шлюза..."
    if curl -s -f -m 5 -L http://localhost:8080/ipfs/QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn > /dev/null
    then
        echo "Локальный шлюз доступен"
        return 0
    else
        echo "Локальный шлюз недоступен"
        return 1
    fi
}

# Основной код

# Проверка статуса IPFS демона
if ! check_ipfs_daemon
then
    # Если демон не запущен, запускаем его
    if ! start_ipfs_daemon
    then
        echo "Не удалось запустить IPFS демон. Выход."
        exit 1
    fi
fi

# Проверка доступности локального шлюза
if ! check_local_gateway
then
    echo "Локальный шлюз недоступен. Возможно, проблема с VPN."
    echo "Попробуйте использовать скрипт ipfs_local_proxy.sh для обхода VPN."
    exit 1
fi

# Вывод информации о доступе к IPFS
echo ""
echo "IPFS успешно запущен и доступен через локальный шлюз!"
echo "Для доступа к файлам используйте: http://localhost:8080/ipfs/YOUR_CID"
echo "Для загрузки файлов используйте скрипт: ./ipfs-scripts/upload_vpn.sh <путь_к_файлу>"
echo ""
echo "Если у вас возникают проблемы с доступом через VPN, используйте скрипт ipfs_local_proxy.sh" 