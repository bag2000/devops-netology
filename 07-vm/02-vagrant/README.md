# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов

Паттерны — это способ построения (структуризации) программного кода специальным образом. На практике они используются программистами для того, чтобы решить какую-нибудь проблему, устранить определенную «боль» разработчика. 
В этом случае предполагается, что существует некоторый перечень общих формализованных проблем (а это так и есть), причем данные проблемы встречаются относительно часто. 
И вот здесь-то на сцену и выходят паттерны, которые как раз таки и предоставляют способы решения этих проблем.

Преимущество применения паттернов IaaС на практике это возможность единожды описав инфраструктуру многократно её воспроизводить, производить развёртывние идентичных сервера/сред для тестирования/разработки, масштабирование при необходимости. 
Следующим преимуществом является автоматизация рутинных действий что приводит к снижению трудозатрат на их выполнение - как следствие повышается скорость разработки, выявления и устранения дефектов за счёт более раннего их обнаружения и тестирования на этапе сборки.
Автоматизация поставки - позволяет сократить время от этапа разработки до внедрения.
Паттерны IaaC позволяют стандартизировать развёртывание инфраструктуры, что снижает вероятность появления ошибок или отклонений связанных с человеческим фактором.

Применение на практике IaaC паттернов позволяет ускорить процесс разработки, снизить трудозатраты на поиск и устранение дефектов, организовать непрерывную поставку продукта

- Какой из принципов IaaC является основополагающим?

Идемпотентность операций - свойство сценария/операции позволяющее многократно получать/воспроизводить одно и то же состояние объекта (среды) что и при первом применении, т.е. не зависимо от того сколько раз будет проигран сценарий, результат всегда будет идентичен результату полученному в первый раз.


## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?

Не требует установки агентов на клиентах, использует SSH или WinRM соединение.
Низкий порог входа, поддержка декларативного и императивного подхода, описание конфигурации - «плейбуки» вформате YAML
Поддерживает широкий набор модулей позволяющих управлять конфигурацией как ОС, так и различным ПО и сетевым оборудованием.
Ansible Galaxy - публичный репозиторий, в котором размещается огромное количество готовых ролей Ansible.

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

На мой взгляд более надёжный push - позволяет определить когда, кдуа и какую конфигурацию отправить, так же позволяет проконтролировать результат применения.

## Задача 3

Установить на личный компьютер:

- VirtualBox

```
PS C:\Program Files\Oracle\VirtualBox> .\VBoxManage.exe --version
7.0.12r159484
```

- Vagrant

```
PS C:\> vagrant --version
Vagrant 2.3.4

```

- Ansible

```bash
adm2@srv1:~$ ansible --version
ansible [core 2.15.6]
  config file = None
  configured module search path = ['/home/adm2/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/adm2/.local/lib/python3.10/site-packages/ansible
  ansible collection location = /home/adm2/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.10.12 (main, Jun 11 2023, 05:26:28) [GCC 11.4.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True

```

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.

```
C:\Vagrant>vagrant up
Bringing machine 'srv1.netology' up with 'virtualbox' provider...
==> srv1.netology: Importing base box 'bento/ubuntu-20.04'...
==> srv1.netology: Matching MAC address for NAT networking...
==> srv1.netology: Checking if box 'bento/ubuntu-20.04' version '202309.09.0' is up to date...
==> srv1.netology: Setting the name of the VM: srv1.netology
==> srv1.netology: Clearing any previously set network interfaces...
==> srv1.netology: Preparing network interfaces based on configuration...
    srv1.netology: Adapter 1: nat
    srv1.netology: Adapter 2: hostonly
==> srv1.netology: Forwarding ports...
    srv1.netology: 22 (guest) => 20011 (host) (adapter 1)
    srv1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> srv1.netology: Running 'pre-boot' VM customizations...
==> srv1.netology: Booting VM...
==> srv1.netology: Waiting for machine to boot. This may take a few minutes...
    srv1.netology: SSH address: 127.0.0.1:2222
    srv1.netology: SSH username: vagrant
    srv1.netology: SSH auth method: private key
    srv1.netology: Warning: Connection reset. Retrying...
    srv1.netology:
    srv1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    srv1.netology: this with a newly generated keypair for better security.
    srv1.netology:
    srv1.netology: Inserting generated public key within guest...
    srv1.netology: Removing insecure key from the guest if it's present...
    srv1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> srv1.netology: Machine booted and ready!
==> srv1.netology: Checking for guest additions in VM...
==> srv1.netology: Setting hostname...
==> srv1.netology: Configuring and enabling network interfaces...
==> srv1.netology: Mounting shared folders...
    srv1.netology: /vagrant => C:/Vagrant
==> srv1.netology: Running provisioner: ansible...
Windows is not officially supported for the Ansible Control Machine.
Please check https://docs.ansible.com/intro_installation.html#control-machine-requirements
Vagrant gathered an unknown Ansible version:


and falls back on the compatibility mode '1.8'.

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode
    srv1.netology: Running ansible-playbook...
The Ansible software could not be found! Please verify
that Ansible is correctly installed on your host system.

If you haven't installed Ansible yet, please install Ansible
on your host system. Vagrant can't do this for you in a safe and
automated way.
Please check https://docs.ansible.com for more information.
```

- Зайти внутрь ВМ

```ba
C:\Vagrant>vagrant ssh
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-162-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat 11 Nov 2023 07:20:06 PM UTC

  System load:  0.0                Processes:             132
  Usage of /:   11.9% of 30.34GB   Users logged in:       0
  Memory usage: 23%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1: 192.168.56.11


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
vagrant@srv1:~$ hostname -f
srv1.netology
```