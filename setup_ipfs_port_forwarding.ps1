# Скрипт для настройки проброса портов IPFS
# Запустите этот скрипт от имени администратора

# Удаляем существующие правила проброса порта 4001 (если они есть)
netsh interface portproxy delete v4tov4 listenport=4001 listenaddress=0.0.0.0

# Добавляем новое правило проброса порта
netsh interface portproxy add v4tov4 listenport=4001 listenaddress=0.0.0.0 connectport=4001 connectaddress=172.18.238.144

# Добавляем правило брандмауэра для разрешения входящих соединений на порт 4001
netsh advfirewall firewall add rule name="IPFS Swarm TCP" dir=in action=allow protocol=TCP localport=4001
netsh advfirewall firewall add rule name="IPFS Swarm UDP" dir=in action=allow protocol=UDP localport=4001

# Выводим текущие правила проброса портов для проверки
Write-Host "Текущие правила проброса портов:"
netsh interface portproxy show all

Write-Host "Настройка проброса портов для IPFS завершена."
Write-Host "Теперь ваш IPFS-узел должен быть доступен извне через ваш внешний IP-адрес (37.208.73.246) на порту 4001."
Write-Host "Нажмите любую клавишу для выхода..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 