# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.
  
**Ответ**  
  
[Манифест Deployment Frontend](https://kubernetes.io/docs/concepts/services-networking/service/)  
[Манифест Deployment Backend](https://kubernetes.io/docs/concepts/services-networking/service/)  
[Манифест Service Frontend](https://kubernetes.io/docs/concepts/services-networking/service/)  
[Манифест Service Backend](https://kubernetes.io/docs/concepts/services-networking/service/)  
  
1. Создаем отдельный Pod с приложением curl  
```
adm2@srv1:~/kuber/1.5$ kubectl run mycurlpod --image=curlimages/curl -i --tty --rm -- sh
If you don't see a command prompt, try pressing enter.
```
  
2. Проверяем доступность frontend  
```
~ $ curl frontend-svc
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
  
3. Проверяем доступность backend  
```
~ $ curl backend-svc
WBITT Network MultiTool (with NGINX) - backend-dep-577878f84-h2cv8 - 10.1.150.17 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```
  
------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.
  
**Ответ**  
  
[Манифест Ingress](https://kubernetes.io/docs/concepts/services-networking/service/)  
  
1. Узнаем ip ноды  
```
adm2@srv1:~/kuber/1.5$ kubectl get nodes -o wide
NAME            STATUS   ROLES    AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
ntlg-microk8s   Ready    <none>   15d   v1.29.4   192.168.12.246   <none>        Ubuntu 22.04.4 LTS   5.15.0-107-generic   containerd://1.6.28
```
  
2. Для учебного тестирования, прописываем домен example.com к полученному выше ip (192.168.12.246)  
```
adm2@srv1:~/kuber/1.5$ cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 srv1
192.168.12.246 example.com
```
  
3. Проверяем доступность frontend  
```
adm2@srv1:~/kuber/1.5$ curl example.com
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
  
4. Проверяем доступность backend  
```
adm2@srv1:~/kuber/1.5$ curl example.com/api
WBITT Network MultiTool (with NGINX) - backend-dep-577878f84-h2cv8 - 10.1.150.17 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```
  
------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------