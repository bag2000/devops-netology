# FOPS-10 Поляков Роман

# Домашнее задание к занятию «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8s).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым GitHub-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров nginx и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
  
**Ответ**  
  
[Манифест Deployment]()  
[Манифест ConfigMap]()  
[Манифест Service]()  
  
1. Заходим в multitool
```
adm2@srv1:~/kuber/2.3$ kubectl exec -it deploy/nginx-multitool-dep -c multitool -- bash
```  
  
2. Проверяем доступность nginx  
```
adm2@srv1:~/kuber/2.3$ kubectl exec -it deploy/nginx-multitool-dep -c multitool -- bash
nginx-multitool-dep-6cf6b89584-wfnvg:/# curl nginx-multitool-svc:9090
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
  
------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
  
**Ответ**  
  
[Манифест Deployment]()  
[Манифест ConfigMap]()  
[Манифест Service]()  
[Манифест Ingress]()  
1. Генерируем сертификат  
```
adm2@srv1:~/kuber/2.3$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server-key.pem -out server.pem -subj "/CN=example.com/O=example.com"
Generating a RSA private key
..............................+++++
......................................................................................................................................................................................................................................................................................................................................................................+++++
writing new private key to 'server-key.pem'
-----
```  
  
2. Создаем секрет  
```
adm2@srv1:~/kuber/2.3$ kubectl create secret tls tls-secret --key server-key.pem --cert server.pem
secret/tls-secret created
```  
  
3. После создания Deploy, Service, Ingress и ConfigMap провряем доступность по https  
```
adm2@srv1:~/kuber/2.3$ curl https://example.com -k
<!DOCTYPE html> <html> <head> <title>Welcome to Netology</title> </head> <body> <h1>Hello, Netology!</h1> </body> </html>
```  
  
------

### Правила приёма работы

1. Домашняя работа оформляется в своём GitHub-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------