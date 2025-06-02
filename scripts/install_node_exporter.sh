#!/bin/bash

# Установка Node Exporter
VERSION="1.6.1"
ARCH="amd64" # Для Raspberry Pi используйте armv7

# Скачивание и распаковка
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-${ARCH}.tar.gz
tar xvf node_exporter-*.tar.gz
cd node_exporter-*/

# Копирование бинарника
sudo cp node_exporter /usr/local/bin/
sudo chown root:root /usr/local/bin/node_exporter

# Создание systemd сервиса
sudo cat <<SERVICE_EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
SERVICE_EOF

# Создание пользователя
sudo useradd -rs /bin/false node_exporter

# Запуск сервиса
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Проверка статуса
echo "Установка завершена. Статус сервиса:"
sudo systemctl status node_exporter
