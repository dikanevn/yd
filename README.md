# Сервер для отдачи изображений и метаданных

Этот проект содержит конфигурацию и скрипты для настройки простого веб-сервера на базе Nginx, который отдаёт PNG изображения и JSON файлы с метаданными.

## Структура проекта

- `png/` - директория с PNG изображениями
- `uri/` - директория с JSON файлами метаданных
- `setup_nginx.sh` - скрипт для настройки Nginx
- `setup_domain.sh` - скрипт для настройки домена
- `setup_ssl.sh` - скрипт для настройки HTTPS с Let's Encrypt
- `finalize_setup.sh` - скрипт для финальной настройки и перезагрузки сервера
- `u1.js` - скрипт для генерации JSON файлов метаданных
- `u2.js` - скрипт для копирования PNG изображений

## Быстрая настройка сервера

1. Установите Nginx (если не установлен):
   ```bash
   apt-get update && apt-get install -y nginx
   ```

2. Запустите скрипт настройки Nginx:
   ```bash
   chmod +x setup_nginx.sh
   ./setup_nginx.sh
   ```

3. Проверьте доступность файлов:
   ```bash
   # Проверка изображений
   curl -I http://localhost/png/1.png
   
   # Проверка JSON метаданных
   curl -I http://localhost/uri/1.json
   ```

## Настройка домена и HTTPS

### Проверка готовности DNS

Прежде чем продолжить настройку, убедитесь, что DNS записи обновились и указывают на ваш сервер:

```bash
# Проверка DNS записей для домена
dig yapster-dimensions.xyz +short
nslookup yapster-dimensions.xyz

# Проверка должна вернуть IP-адрес вашего сервера: 46.8.232.55
```

Если DNS записи еще не обновились, подождите. Обновление может занять до 24 часов.

### Настройка DNS записей

Для домена `yapster-dimensions.xyz` необходимо обновить DNS записи, указав на ваш сервер:

1. Создайте A-запись для `yapster-dimensions.xyz` и `www.yapster-dimensions.xyz`, указывающую на IP-адрес вашего сервера `46.8.232.55`

```
yapster-dimensions.xyz.     IN    A    46.8.232.55
www.yapster-dimensions.xyz. IN    A    46.8.232.55
```

2. Рекомендуемые записи DNS для улучшения безопасности:
   ```
   yapster-dimensions.xyz.  IN    CAA   0 issue "letsencrypt.org"
   yapster-dimensions.xyz.  IN    TXT   "v=spf1 -all"
   ```

### Настройка домена

После обновления DNS-записей:

1. Запустите скрипт настройки домена:
   ```bash
   chmod +x setup_domain.sh
   ./setup_domain.sh
   ```

2. Настройте HTTPS с Let's Encrypt:
   ```bash
   chmod +x setup_ssl.sh
   ./setup_ssl.sh
   ```

3. Выполните финальную настройку и перезагрузите сервер:
   ```bash
   chmod +x finalize_setup.sh
   ./finalize_setup.sh
   ```
   Этот скрипт проверит настройки Nginx, права доступа и перезагрузит сервер.

## Генерация файлов метаданных и изображений

1. Генерация JSON файлов метаданных:
   ```bash
   node u1.js
   ```

2. Копирование изображений:
   ```bash
   node u2.js
   ```

## Доступ к файлам

Ваши файлы доступны по следующим URL:
- Изображения: https://yapster-dimensions.xyz/png/номер.png  
  Например: https://yapster-dimensions.xyz/png/1.png
- Метаданные: https://yapster-dimensions.xyz/uri/номер.json  
  Например: https://yapster-dimensions.xyz/uri/1.json

## Обработка ошибок

Если возникают проблемы с доступом к файлам, проверьте:

1. Права доступа:
   ```bash
   chmod -R 755 /root/yd/png/ /root/yd/uri/
   ```

2. Правильность конфигурации:
   ```bash
   nginx -t
   ```

3. Логи ошибок:
   ```bash
   cat /var/log/nginx/error.log
   ```

## Обновление сертификатов

Сертификаты Let's Encrypt действительны 90 дней. Certbot создаёт systemd-таймер для автоматического обновления, но вы также можете обновить сертификаты вручную:

```bash
certbot renew
``` 