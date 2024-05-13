# FOPS-10 - Поляков Роман

# Домашнее задание к занятию «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

**Ответ**  
[Манифест-POD](https://github.com/bag2000/devops-netology/blob/main/12-kuber/1.2/files/pod-hellow-world.yaml)  
  
Вывод в браузере:  
```
Hostname: hello-world

Pod Information:
	-no pod information available-

Server values:
	server_version=nginx: 1.12.2 - lua: 10010

Request Information:
	client_address=127.0.0.1
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://192.168.12.246:8080/

Request Headers:
	accept=text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7  
	accept-encoding=gzip, deflate  
	accept-language=ru,en;q=0.9  
	cache-control=max-age=0  
	connection=keep-alive  
	cookie=authMode=token; username=default  
	host=192.168.12.246:8080  
	if-modified-since=Tue, 16 Apr 2024 14:29:59 GMT  
	if-none-match=&quot;661e8b67-267&quot;  
	upgrade-insecure-requests=1  
	user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 YaBrowser/24.4.0.0 Safari/537.36  

Request Body:
	-no body in request-
```  
  
Вывод команды **kubectl get pods**  
```
adm2@srv1:~/kuber$ kubectl get pods
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          2m20s
```  
------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).
  
**Ответ**  
[Манифест-POD](https://github.com/bag2000/devops-netology/blob/main/12-kuber/1.2/files/pod-netology-web.yaml)  
[Манифест-Service](https://github.com/bag2000/devops-netology/blob/main/12-kuber/1.2/files/service-netology-web.yaml)  
  
Вывод в браузере:  

```
Hostname: netology-web

Pod Information:
	-no pod information available-

Server values:
	server_version=nginx: 1.12.2 - lua: 10010

Request Information:
	client_address=127.0.0.1
	method=GET
	real path=/health
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://192.168.12.246:8080/health

Request Headers:
	accept=text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7  
	accept-encoding=gzip, deflate  
	accept-language=ru,en;q=0.9  
	cache-control=max-age=0  
	connection=keep-alive  
	cookie=authMode=token; username=default  
	host=192.168.12.246:8080  
	upgrade-insecure-requests=1  
	user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 YaBrowser/24.4.0.0 Safari/537.36  

Request Body:
	-no body in request-
```  
  
Вывод команды **kubectl get pods**  
```
adm2@srv1:~/kuber$ kubectl get pods
NAME           READY   STATUS    RESTARTS   AGE
hello-world    1/1     Running   0          10m
netology-web   1/1     Running   0          3m18s
```  
  
Вывод команды **kubectl get svc**  
```
adm2@srv1:~/kuber$ kubectl get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP    6d7h
netology-svc   ClusterIP   10.152.183.126   <none>        8080/TCP   5m25s
```  
------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------

### Критерии оценки
Зачёт — выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку — задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.