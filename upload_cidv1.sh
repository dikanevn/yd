#!/bin/bash

# Скрипт для загрузки файлов в IPFS с использованием CIDv1

# Проверка наличия аргумента
if [ $# -eq 0 ]; then
    echo "Использование: $0 <путь_к_файлу>"
    exit 1
fi

# Проверка существования файла
if [ ! -f "$1" ]; then
    echo "Ошибка: Файл '$1' не существует."
    exit 1
fi

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Загрузка файла в IPFS с использованием CIDv1
CID=$(ipfs add --cid-version=1 --hash=sha2-256 -q "$1")

if [ $? -ne 0 ]; then
    echo "Ошибка при загрузке файла в IPFS."
    exit 1
fi

# Вывод информации о загруженном файле
echo "CID: $CID"
echo "Доступ по ссылке: http://localhost:8080/ipfs/$CID"
echo "Для использования в метаданных: ipfs://$CID"

# Закрепление файла в IPFS
ipfs pin add "$CID" > /dev/null

# Публикация CID в сети IPFS
ipfs dht provide "$CID" 2>/dev/null || ipfs routing provide "$CID" 2>/dev/null

echo "Файл успешно загружен и закреплен в IPFS." 