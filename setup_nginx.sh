#!/bin/bash

# Создание конфигурации Nginx
cat > /etc/nginx/sites-available/png-server << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    server_name _;
    
    # Маршрут для доступа к изображениям через /png/
    location /png/ {
        alias /root/yd/png/;
        add_header Cache-Control "public, max-age=3600";
        add_header Access-Control-Allow-Origin "*";
        expires 1h;
    }
    
    # Маршрут для доступа к JSON файлам через /uri/
    location /uri/ {
        alias /root/yd/uri/;
        add_header Cache-Control "public, max-age=3600";
        add_header Access-Control-Allow-Origin "*";
        expires 1h;
        default_type application/json;
    }
    
    # Маршрут для статических файлов
    location / {
        root /root/yd;
        try_files $uri $uri/ =404;
    }
}
EOF

# Активация конфигурации
ln -sf /etc/nginx/sites-available/png-server /etc/nginx/sites-enabled/default

# Проверка конфигурации
nginx -t

# Дополнительные права для nginx и перезапуск
chmod 755 /root
chmod -R 755 /root/yd
systemctl restart nginx

echo "Nginx настроен и перезапущен" 