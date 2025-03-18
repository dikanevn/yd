#!/bin/bash

# Проверка запуска от имени root
if [ "$(id -u)" -ne 0 ]; then
    echo "Этот скрипт нужно запускать от имени root"
    exit 1
fi

# Создание конфигурации Nginx с поддержкой домена и IP
cat > /etc/nginx/sites-available/yapster-dimensions << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name yapster-dimensions.xyz www.yapster-dimensions.xyz 46.8.232.55;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name yapster-dimensions.xyz www.yapster-dimensions.xyz 46.8.232.55;
    
    # SSL конфигурация
    ssl_certificate /etc/letsencrypt/live/yapster-dimensions.xyz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yapster-dimensions.xyz/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/yapster-dimensions.xyz/chain.pem;
    
    # Оптимизация SSL
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=63072000" always;
    
    # Базовые настройки безопасности
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Настройки для JSON файлов
    location /uri/ {
        alias /root/yd/uri/;
        add_header Cache-Control "public, max-age=3600";
        add_header Access-Control-Allow-Origin "*";
        add_header Access-Control-Allow-Methods "GET, OPTIONS";
        expires 1h;
        default_type application/json;
        
        # Обработка ошибок
        error_page 404 /404.json;
        error_page 403 /403.json;
        
        # Проверка существования файла
        try_files $uri =404;
    }
    
    # Настройки для PNG файлов
    location /png/ {
        alias /root/yd/png/;
        add_header Cache-Control "public, max-age=3600";
        add_header Access-Control-Allow-Origin "*";
        add_header Access-Control-Allow-Methods "GET, OPTIONS";
        expires 1h;
        
        # Обработка ошибок
        error_page 404 /404.png;
        error_page 403 /403.png;
        
        # Проверка существования файла
        try_files $uri =404;
    }
    
    # Маршрут для статических файлов
    location / {
        root /root/yd;
        try_files $uri $uri/ =404;
    }
    
    # Обработка ошибок
    error_page 404 /404.html;
    error_page 403 /403.html;
    error_page 500 502 503 504 /50x.html;
}
EOF

# Активация конфигурации
ln -sf /etc/nginx/sites-available/yapster-dimensions /etc/nginx/sites-enabled/default

# Проверка конфигурации
nginx -t

# Перезапуск Nginx
systemctl restart nginx

echo "Домен yapster-dimensions.xyz и IP 46.8.232.55 настроены в конфигурации Nginx"
echo "Теперь вы можете запустить setup_ssl.sh для настройки HTTPS" 