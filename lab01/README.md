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

1. Создать DHCP-сервер для будущей внутренней сети (`Internal network`) между виртуальными машинами (выполнять в терминале хостовой **НЕ**виртуальной машины) :
        
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

