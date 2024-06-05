# FOPS-10 Поляков Роман

# Домашнее задание к занятию «Управление доступом»

### Цель задания  

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.
------

### Чеклист готовности к домашнему заданию
1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.
------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания
1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).
------

### Задание 1. Создайте конфигурацию для подключения пользователя
1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
2. Настройте конфигурационный файл kubectl для подключения.
3. Создайте роли и все необходимые настройки для пользователя.
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.
------
  
**Ответ**
  
[Манифест Role](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.4/files/role-netology-1.yaml)  
[Манифест RoleBinding](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.4/files/rolebinding-netology-1.yaml) 
  
1. Включаем rbac на microk8s, создаем и подписываем сертификат, создаем пользователя test и контекст test  
```
microk8s enable rbac

openssl genrsa -out test.key 2048
openssl req -new -key test.key -out test.csr -subj "/CN=test/O=ops"
openssl x509 -req -in test.csr -CA /var/snap/microk8s/current/certs/ca.crt -CAkey /var/snap/microk8s/current/certs/ca.key -CAcreateserial -out test.crt -days 500

kubectl config set-credentials test --client-certificate=test.crt --client-key=test.key --embed-certs=true
kubectl config set-context test --cluster=my --user=test
```
  
2. Переключаем контекст  
```
adm2@srv1:~/kuber/2.4$ kubectl config use-context test
Switched to context "test".


adm2@srv1:~/kuber/2.4$ kubectl config get-contexts
CURRENT   NAME   CLUSTER   AUTHINFO   NAMESPACE
          my     my        admin      default
*         test   my        test
```
  
3. После создания [Role](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.4/files/role-netology-1.yaml) и [RoleBinding](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.4/files/rolebinding-netology-1.yaml) , проверяем права доступа
  
```
adm2@srv1:~/kuber/2.4$ kubectl get po
Error from server (Forbidden): pods is forbidden: User "test" cannot list resource "pods" in API group "" in the namespace "default"


adm2@srv1:~/kuber/2.4$ kubectl logs nginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
...


adm2@srv1:~/kuber/2.4$ kubectl describe pod nginx
Name:             nginx
Namespace:        default
Priority:         0
Service Account:  default
Node:             ntlg-microk8s/192.168.12.246
Start Time:       Wed, 05 Jun 2024 12:20:54 +0300
...
```
  
### Правила приёма работы
1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
------
