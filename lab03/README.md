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
# настройки в одноименном файле
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







