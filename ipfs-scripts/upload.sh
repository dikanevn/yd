#!/bin/bash

# Проверяем, что файл указан
if [ -z "$1" ]; then
  echo "Использование: $0 <путь_к_файлу>"
  exit 1
fi

# Проверяем существование файла
if [ ! -f "$1" ]; then
  echo "Ошибка: Файл $1 не существует"
  exit 1
fi

# Загружаем файл в IPFS
HASH=$(ipfs add -q "$1" | tail -n1)

# Выводим результат
echo "Файл успешно загружен в IPFS"
echo "CID: $HASH"
echo "Доступ по ссылке: http://localhost:8080/ipfs/$HASH"
echo "Для использования в метаданных: ipfs://$HASH"
