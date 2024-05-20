# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.
  
**Ответ**  
[Манифест-Deployment](https://github.com/bag2000/devops-netology/blob/main/12-kuber/1.4/files/deploy-netology-1.yaml)  
[Манифест-Service](https://github.com/bag2000/devops-netology/blob/main/12-kuber/1.4/files/service-netology-1.yaml)  
  
1. Создаем отдельный Pod с приложением multitool  
```
adm2@srv1:~/kuber/1.4$ kubectl -n netology run mycurlpod --image=curlimages/curl -i --tty --rm -- sh
If you don't see a command prompt, try pressing enter.
```
  
2. Проверяем доступность nginx  
```
~ $ curl nginx-multitool-svc:9001
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
  
3. Проверяем доступность multitool  
```
~ $ curl nginx-multitool-svc:9002
WBITT Network MultiTool (with NGINX) - nginx-multitool-dep-54997bb668-xcgfh - 10.1.150.30 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
```
  
------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.
  
**Ответ**  
[Манифест-Service](https://github.com/bag2000/devops-netology/blob/main/12-kuber/1.4/files/service-netology-2.yaml)  
  
1. Узнаем ip ноды  
```
adm2@srv1:~/kuber/1.4$ kubectl get nodes -o wide
NAME            STATUS   ROLES    AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
ntlg-microk8s   Ready    <none>   13d   v1.29.4   192.168.12.246   <none>        Ubuntu 22.04.4 LTS   5.15.0-106-generic   containerd://1.6.28
```
  
2. Проверяем доступность nginx  
```
adm2@srv1:~/kuber/1.4$ curl 192.168.12.246:30001
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
  
3. Проверяем доступность multitool  
```
adm2@srv1:~/kuber/1.4$ curl 192.168.12.246:30002
WBITT Network MultiTool (with NGINX) - nginx-multitool-dep-54997bb668-4fh5k - 10.1.150.32 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
```
  
------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
