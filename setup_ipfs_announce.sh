#!/bin/bash

# Установка пути к IPFS
export IPFS_PATH=/home/dikanevn/u1/yd/.ipfs

# Настройка анонсирования внешнего IP
ipfs config --json Addresses.Announce '["/ip4/37.208.73.246/tcp/4001", "/ip4/37.208.73.246/udp/4001/quic-v1"]'

# Перезапуск IPFS демона для применения изменений
ipfs shutdown
sleep 2
ipfs daemon --enable-gc &

echo "IPFS настроен для анонсирования внешнего IP-адреса 37.208.73.246"
echo "Теперь ваш контент должен быть доступен через публичные шлюзы IPFS" 