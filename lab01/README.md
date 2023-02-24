# Порядок выполнения

> Oracle VM VirtualBox

## Создание виртуальных машин

0. Скачать образ Ubuntu Server: [Жмяк](https://ubuntu.com/download/server)
1. Открыть окошко создания: `Ctrl+N` или через менюшку `Machine`
2. Установить имя вирутальной машины и путь к образу системы:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220580245-b8520aa0-fceb-444f-9311-c0650634c39c.png" width=50% />
    </p>
3. Установить параметры учетной записи на свое усмотрение:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220581590-cf227813-2ca8-4d43-80ef-acabf729d7fc.png" width=50% />
    </p>
4. Установать размер оперативной памяти и число ядер (`2 Гб` и `2 ядра` хватает):
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220585182-82008ed2-78b6-40b1-8d80-f621e7a19513.png" width=50% />
    </p>
5. Установить размер виртуального жесткого диска (`10 Гб` хватает):
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220585839-c6ddc3fb-889e-4409-88e7-4f1cb7fc07f2.png" width=50% />
    </p>
6. Проверить введенную информацию и завершить создание кнопкой `Finish`:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220586238-7ac44a05-b7f3-4218-8298-f1ae402d98d1.png" width=50% />
    </p>
7. Повторить пункты 1-6 для создания второй виртуальной машины (`vm2`).

## Настройка сети

> **Проводить до запуска машин, точнее, до установки системы на машины, чтобы не страдать, ибо при установке все настраивается автоматически**

1. Создать DHCP-сервер для будущей внутренней сети (`Internal network`) между виртуальными машинами (выполнять в терминале хостовой **НЕ**виртуальной машины), (подробнее: [Источник 1](https://54m4ri74n.medium.com/building-an-internal-network-in-virtualbox-d0a4974882d0)):
        
        # создать
        $ vboxmanage dhcpserver add --netname intnet --ip 10.10.10.1 --netmask 255.255.255.0 --lowerip 10.10.10.2 --upperip 10.10.10.212 --enable
        # проверить
        $ vboxmanage list dhcpservers
        NetworkName:    intnet
        Dhcpd IP:       10.10.10.1
        LowerIPAddress: 10.10.10.2
        UpperIPAddress: 10.10.10.212
        NetworkMask:    255.255.255.0
        Enabled:        Yes
        Global Configuration:
          minLeaseTime:     default
          defaultLeaseTime: default
          maxLeaseTime:     default
          Forced options:   None
          Suppressed opts.: None
            1/legacy: 255.255.255.0
        Groups:               None
        Individual Configs:   None
2. Настроить подключение первой машины к сети интернет (`Settings -> Network -> Adapter 1`, из выпадающего списка `Bridged Adapter`):
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220590741-7d3ccd05-f834-47c7-8c3d-51b881c1e60f.png" width=50% />
    </p>
3. Настроить подключение первой машины к внутренней сети (там же `Adapter 2`, из выпадающего списка `Internal Network`, в поле `Name` ввести имя DHCP-сервера, указанного при создании командой после `--netname`, в инструкции `intnet`, имя по умолчанию):
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220591821-6b2d8b6b-3f8d-4607-9dd5-84929a06b432.png" width=50% />
    </p>
4. Нажать `OK`, завершив настройку первой машины.
5. Повторить пункты 2-4 для второй машины (да, по условию на второй машине не должно быть соединения с интернетом, но нам необходимо установить apache, потом адаптер для подключения к сети интернет мы отключим)

## Установка систем

1. Запустить машину (можно сразу две), нажав `Start`
2. Если высвечивается ошибка, еще раз выбрать образ и `Mount and Retry Boot`:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220594027-5e0502f6-154b-4156-9f76-63a5072dd569.png" width=50% />
    </p>
3. Выбрать `Try or Install Ubuntu Server`:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220594680-38413aa6-ef39-4652-bb2d-f8b829892e95.png" width=50% />
    </p>
4. Язык:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220595035-d6ec43be-1edc-4d3b-99ef-4259a95f825e.png" width=50% />
    </p>
5. Обновление установщика (можно не обновлять):
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220595410-b8e1e20b-b14c-4004-b7d4-8601e77936fb.png" width=50% />
    </p>
6. Настройки клавиатуры:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220595566-96a4bbbc-d1b5-4d38-aaef-1156e2603a3f.png" width=50% />
    </p>
7. Тип установки:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220595793-a2ea4e44-1410-479f-b1b9-0fdd746fd271.png" width=50% />
    </p>
8. Если настройка сети была проведена, здесь должны появиться сетевые интерфейсы уже с ip-адресами
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220596067-2d9e96c8-4333-4e29-993e-08e939d9c753.png" width=50% />
    </p>
9. Прокси оставляем пустым:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220596310-ad435ba9-d3ed-4ebe-b171-7f747f6d3149.png" width=50% />
    </p>
10. Адрес зеркала оставляем:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220596557-b0592b94-9c2c-49b3-a6f7-7f960b372ed8.png" width=50% />
    </p>
11. Настройки диска оставляем:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220596858-ba74491e-508c-4e78-98ad-6c10e547b906.png" width=50% />
    </p>
12. Проверяем, подтверждаем:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220601999-3b7d22b3-e97c-4616-8c0b-b2f0d9325733.png" width=50% />
    </p>
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220602147-ad998b77-dc2a-4aa5-b644-5e5636ce9661.png" width=50% />
    </p>
13. Настройки профиля:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220602519-86244d3f-e83c-4c47-bdb8-0c3545e46c8b.png" width=50% />
    </p>
14. OpenSSH можно устанавливать, можно нет:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220603034-e237e027-118d-4f6f-b52a-c52c45130ec4.png" width=50% />
    </p>
15. Допольнительные пакеты не ставим:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220605895-c3986ff4-420c-411b-8300-1540f38dbaa7.png" width=50% />
    </p>
16. Ждем установки до сообщения `sabiquity/Late/run` и нажимаем `Reboot Now`:
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220608054-58cfc9ab-79db-4cae-9ffb-04c9ca24c40e.png" width=50% />
    </p>
17. Ждем сообщения, что он не может отмонтировать образ установщика, и в `Devices -> Optical Drives` убираем галочку с образа установщика.
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220608423-e3e84ad4-4bcd-45f4-b36b-ba71907aa744.png" width=50% />
    </p>
18. Повтояем все для второй машины и заходим в обе системы

## Установка и настройка Apache

> [Источник 2](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-20-04-ru)

0. Заходим во вторую виртуальную машину (далее просто `vm2`), введя логин и пароль, после входа выводится информация о системе в том числе и ip-адреса по каждому из настроенных сетевых интерфейсов (на верхнем рисунке `192.168.1.15` для моста и `10.10.10.3` для внутренней сети), также настроенные сетевые интерфейсы можно посмотреть с помощью команды `ip a` (нижний рисунок):
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220645400-a382c45f-b4d8-42a3-90e9-437691d72bb3.png" width=50% />
    </p>
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220650551-0af24128-7058-48dd-bfaf-5ad5a2ee517a.png" width=50% />
    </p>

1. Обновляем списки пакетов:

        $ sudo apt update

2. Устанавливаем apache:

        $ sudo apt install apache2

3. Настраиваем межсетевой экран и запускаем apache:

        # получить список
        $ sudo ufw app list
        Available applications:
        Apache
        Apache Full
        Apache Secure
        OpenSSH

        # разрешить трафик для apache на порту 80
        $ sudo ufw allow Apache
        Rules updated
        Rules updated (v6)

        # включить ufw
        $ sudo ufw enable
        Firewall is active and enabled on system startup

        # проверить
        $ sudo ufw status
        Status: active

        To                         Action      From
        --                         ------      ----                
        Apache                     ALLOW       Anywhere                           
        Apache (v6)                ALLOW       Anywhere (v6)

4. Проверяем, что веб-сервер был запущен:

       $ sudo systemctl status apache2
       ● apache2.service - The Apache HTTP Server
        Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
        Active: active (running) since Thu 2023-02-22 14:38:15 UTC; 8min ago
        ...

5. Теперь из браузера хостовой машины должна по адресу `http://192.168.1.15/` должна быть доступна стартовая страница Apache:

    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/220659419-870239db-a301-4bf5-b594-28b7040e6d3a.png" width=90% />
    </p>

6. Можно отключить адаптер, отвечающий за сетевой мост, после этого с хоста не будет доступа к стартовой странице

## Установка и настройка nginx

> [Источник 3](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04-ru)

0. Аналогично пункту 0 предыдущего раздела (`192.168.1.14` для моста и `10.10.10.2` для внутренней сети)

1. Обновляем списки пакетов:

        $ sudo apt update

2. Устанавливаем nginx:

        $ sudo apt install nginx

3. Настраиваем межсетевой экран и запускаем nginx:

        # получить список
        $ sudo ufw app list
        Available applications:
          Nginx Full
          Nginx HTTP
          Nginx HTTPS
          OpenSSH

        # разрешить трафик для nginx на порту 80 без шифрования
        $ sudo ufw allow 'Nginx HTTP'
        Rules updated
        Rules updated (v6)

        # включить ufw
        $ sudo ufw enable
        Firewall is active and enabled on system startup

        # проверить
        $ sudo ufw status
        Status: active

        To                         Action      From
        --                         ------      ----               
        Nginx HTTP                 ALLOW       Anywhere                              
        Nginx HTTP (v6)            ALLOW       Anywhere (v6)

4. Проверяем, что веб-сервер был запущен:

       $ sudo systemctl status nginx
       ● nginx.service - A high performance web server and a reverse proxy server
          Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
          Active: active (running) since Fri 2020-04-20 16:08:19 UTC; 3 days ago
            Docs: man:nginx(8)
          ...

5. Теперь из браузера хостовой машины должна по адресу `http://192.168.1.14/` должна быть доступна стартовая страница nginx:

    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/221179625-3b8e1f98-fd51-4ee3-a1f9-b9c68ebfaa06.png" width=90% />
    </p>

## Выполнение задания

1. Отключить адаптер сетевого моста на `vm2`, лучше выключив машину, чтобы интерфейс не отображался в `ip a` (настроенные интерфейсы представлены на двух нижних рисунках пункта):
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/221199125-9f6aef18-c560-4d09-a257-908a8f7a1bd2.png" width=50% />
    </p>

    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/221199932-88cfdfa1-da25-4905-b5f9-ece4adfd7739.png" width=50% />
    </p>

    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/221199631-8eb33a26-6385-46db-baed-0082de1a780d.png" width=50% />
    </p>
    
2. Изменить содержимое файла настроек nginx `/etc/nginx/nginx.conf` на:

        events { }
    
        http {
            server {
                listen 80;

                location / {
                    proxy_pass http://10.10.10.3/;
                }
            }
        }

3. Применить конфигурацию:
    
        $ sudo nginx -s reload
        
4. Теперь при обращении к `vm1` по ip `http://192.168.1.14/` должна возращаться стартовая страница Apache с `vm2`:
    
    <p align="center">
      <img src="https://user-images.githubusercontent.com/61819948/221203040-c64455fc-4682-453c-9218-e54cdd0f350e.png" width=90% />
    </p>

5. 🥳 Лаба сделана 🥳
# Теория по типу сетевых соединений
