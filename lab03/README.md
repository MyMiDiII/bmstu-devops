# Лабораторная работа №3

## Установки

```bash
# vm1
sudo apt install nginx

# установка prometheus
sudo apt install prometheus
# https://github.com/prometheus/prometheus/releases
wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz
tar xf prometheus-2.43.0.linux-amd64.tar.gz
sudo cp prometheus promtool /usr/local/bin
sudo mkdir /etc/prometheus /var/lib/prometheus
sudo cp prometheus.yml /etc/prometheus
useradd --no-create-home --home-dir / --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# настройки в одноименном файле
sudo vim /etc/systemd/system/prometheus.service

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl status prometheus

# vm2
# установка grafana
wget https://dl.grafana.com/oss/release/grafana_9.4.3_amd64.deb
sudo dpkg -i grafana_9.4.3_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server

# чтобы правильно работали пути:
sudo vim /etc/grafana/grafana.ini
# раскомментить строку и изменить
# root_url = http://176.118.165.63:3131/grafana
#              <ip_базиса>:<80-ый порт вашей вм>
sudo systemctl restart grafana-server

# изменить настройки nginx:
sudo vim /etc/nginx/nginx.conf
# данная настройка уже есть в файле nginx.conf в lab02,
# но для второй лабы она не нужна
# location /grafana {
#   rewrite  ^/grafana/(.*) /$1 break;
#   proxy_set_header Host $http_host; # если ошибка origin not allowed
#   proxy_pass http://localhost:3000/;
# }
# теперь по адресу ip:порт/grafana выдается страница входа grafana

# vm1 и vm2
# установка node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xf node_exporter-1.5.0.linux-amd64.tar.gz
cd node_exporter-1.5.0.linux-amd64/
sudo cp node_exporter /usr/local/bin/
sudo useradd --no-create-home --home-dir / --shell /bin/false node_exporter

# настройки в одноименном файле
sudo vim /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter

# vm1
# настройки в одноименном файле (то, что до alertmanager)
sudo vim /etc/prometheus/prometheus.yml
sudo systemctl reload prometheus
```

## Настройка Grafana
![GrafanaConf1](https://user-images.githubusercontent.com/61819948/229065490-ee2e9519-d446-4cd1-809f-681cef22d360.png)

![GrafanaConf2](https://user-images.githubusercontent.com/61819948/229065664-ed825764-8f15-4f4c-93e3-e7af61d6dec2.png)

![GrafanaConf3](https://user-images.githubusercontent.com/61819948/229065758-b2de0f3f-41be-4b8f-86b6-fe50f2cb5ac2.png)

![GrafanaConf4](https://user-images.githubusercontent.com/61819948/229065784-49f6c90d-7142-4d2c-b291-fc2de219edb3.png)

![GrafanaConf5](https://user-images.githubusercontent.com/61819948/229065811-826e6810-ea93-4350-9778-d7a86760dae7.png)

![GrafanaConf6](https://user-images.githubusercontent.com/61819948/229065834-cde4b8e5-a04d-402e-aa99-4205698c808e.png)

![GrafanaConf7](https://user-images.githubusercontent.com/61819948/229065861-93177507-5543-4eda-a717-dc352c9700c1.png)

![GrafanaConf8](https://user-images.githubusercontent.com/61819948/229065880-b9477d25-a1c0-4093-a175-18c0ae721120.png)

## Установка cron

```bash
# вроде он по умолчанию установлен, но на всякий
sudo apt update
sudo apt install cron
# старт при запуске системы
sudo systemctl enable cron
```

## Сбор метрик nginx с помощью node_exporter

> Сначала выполнялся сбор размера директории prometheus-а, разницы нет, кроме добавления флагов к запуску node_exporter, которые представлены в следующем разделе

Настройки nginx vm1, чтобы не мешало основной работе:

```bash
# ...
http {
  server {
    location / {
      stub_status on;
      allow 127.0.0.1;
      deny all;
    }
  }
}
```

Для vm2 (если хотите, чтобы для vm2 тоже работало, + тогда нужно в vm2 также добавить скрипты):

```bash
location /status {
      stub_status on;
    }
```

Не забыть перезапусть nginx:

```bash
sudo nginx -s reload
# проверка (vm1)
curl http://localhost:80/
###
Active connections: 1 
server accepts handled requests
 11 11 11 
Reading: 0 Writing: 1 Waiting: 0
###
```

Далее сбор:

```bash
# создать директорию для сбора
sudo mkdir /var/lib/node_exporter/

# настройки в одноименном файле
sudo vim /usr/local/bin/nginx-status.sh

# ПРАВА!!!
sudo chmod ugo+x /usr/local/bin/nginx-status.sh

# добавить в cron
sudo crontab -e
###
* * * * * nginx-status.sh
###

# Сначала я выполняла сбор размера директории, если еще не делали
# обновите /etc/systemd/system/node_exporter.service
```

### График соединений

Пример настройки одного значения соединения (остальные аналогично):

![GrafanaGraph1](https://user-images.githubusercontent.com/61819948/229067617-8963f9ee-d169-4f13-93f2-d7e4a50f482e.png)

Легенда:

![GrafanaGraph2](https://user-images.githubusercontent.com/61819948/229067635-c890b001-a9b6-41a7-a3bf-3b9ca02e12cf.png)

Для заполнения (fill opacity):

![GrafanaGraph3](https://user-images.githubusercontent.com/61819948/229067652-942a6d74-9978-4050-a3ee-7ca7aef127cf.png)

Пример для *величины в секунду*:

![GrafanaGraph4](https://user-images.githubusercontent.com/61819948/229067667-249504c2-9a2d-4589-b15e-32269f85de73.png)

## Сбор размера директории

```bash
# Создание файла задачи crontab
# ОБЯЗАТЕЛЬНО С SUDO, чтобы были права на создание файлов
sudo crontab -e
# выбираем редактор (vim ❤️ -> 2)
###
no crontab for user - using an empty one

Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.basic
  3. /usr/bin/vim.tiny
  4. /bin/ed

Choose 1-4 [1]: 2
###
# Добавляем строку в открытый файл и сохраняем
* * * * * directory-size.sh /var/lib/prometheus
###

# настройки в одноименном файле
sudo vim /usr/local/bin/directory-size.sh

# даем всем (чтобы не париться) права на выполнение
sudo chmod ugo+x /usr/local/bin/directory-size.sh

# КРОН работает

# настройка node_exporter
sudo vim /etc/systemd/system/node_exporter.service
# дополнить строку флагами:
###
ExecStart=/usr/local/bin/node_exporter --collector.textfile --collector.textfile.directory=/var/lib/node_exporter
###
sudo systemctl daemon-reload
sudo systemctl start node_exporter # restart если уже запущен
sudo systemctl status node_exporter
```

### Настройка grafana для чтения размера директории

Добавляем новую панель

С помощью bilder-а в нижней части экрана получаем метрику:

![PromDir0](https://user-images.githubusercontent.com/61819948/229068969-9ccb8d9f-fa18-4bf6-901d-0640d5570ca4.png)

Или код:

```bash
node_directory_size_bytes{directory="/var/lib/prometheus"}
```

Настройка с параметрами (для легенды):

![PromDir1](https://user-images.githubusercontent.com/61819948/229069022-2416ea89-2aa1-42a6-9aae-59242e5fea82.png)

Название графика:

![PromDir2](https://user-images.githubusercontent.com/61819948/229069045-e7ed9550-f49f-44e0-8206-656dcaab437c.png)

Настройки легенды:

![PromDir3](https://user-images.githubusercontent.com/61819948/229069078-6664ec6e-cb65-4e64-8d64-603672d326d8.png)

Итого:

![PromDir4](https://user-images.githubusercontent.com/61819948/229069106-4a460abc-4308-44d5-8f61-3811d968173c.png)

## Alert Manager

```bash
wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
tar xf alertmanager-0.25.0.linux-amd64.tar.gz
cd alertmanager-0.25.0.linux-amd64/
sudo cp alertmanager /usr/local/bin/
sudo mkdir /etc/alertmanager /var/lib/alertmanager
sudo cp alertmanager.yml /etc/alertmanager
sudo useradd --no-create-home --home-dir / --shell /bin/false alertmanager
sudo chown -R alertmanager:alertmanager /var/lib/alertmanager
```

Сервис:

```bash
# настройки в одноименном файле
sudo vim /etc/systemd/system/alertmanager.service

sudo systemctl daemon-reload
sudo systemctl start alertmanager
sudo systemctl status alertmanager
```

Настройки:

Бот → `/start`

[TelepushBot](https://t.me/MiddlemanBot)

Ответом → токен.

```bash
# настройки в одноименном файле
sudo vim /etc/alertmanager/alertmanager.yml
```

```bash
# настройки в одноименном файле
sudo vim /etc/prometheus/nginx-alerts.yml
```

```bash
# добавить то, что для alertmanager, если не добавляли
sudo vim /etc/prometheus/prometheus.yml
```

```bash
# перезапускаем
sudo systemctl restart alertmanager.service
sudo systemctl status alertmanager.service

sudo systemctl restart prometheus.service
sudo systemctl status prometheus.service
```
