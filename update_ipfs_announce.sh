#!/bin/bash

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Создание файла с настройками
echo '["/ip4/37.208.73.246/tcp/4001", "/ip4/37.208.73.246/udp/4001/quic-v1"]' > /home/dikanevn/u1/yd/announce.json

# Применение настроек
ipfs config --json Addresses.Announce "$(cat /home/dikanevn/u1/yd/announce.json)"

# Проверка настроек
echo "Текущие настройки анонсирования:"
ipfs config Addresses.Announce

echo "IPFS настроен для анонсирования внешнего IP-адреса 37.208.73.246" 