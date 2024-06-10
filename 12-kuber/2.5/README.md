# FOPS-10 Поляков Роман

# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.
  
**Ответ**  
[Чарт](https://github.com/bag2000/devops-netology/tree/main/12-kuber/2.5/files/netology-app)  
  
------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.
  
**Ответ**  
1. Создаем namespace app1 и app2  
```
adm2@srv1:~/kuber/2.5$ kubectl create ns app1
namespace/app1 created

adm2@srv1:~/kuber/2.5$ kubectl create ns app2
namespace/app2 created
```  
  
2. Запускаем версию по умолчанию в namespace app1 (front latest, backend latest, appVersion 1.0.0)  
```
adm2@srv1:~/kuber/2.5$ helm upgrade --install --atomic netology-app1 netology-app/ --namespace app1
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
Release "netology-app1" does not exist. Installing it now.
NAME: netology-app1
LAST DEPLOYED: Mon Jun 10 22:04:09 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None

adm2@srv1:~/kuber/2.5$ kubectl -n app1 get pod
NAME                                  READY   STATUS    RESTARTS   AGE
backend-1-0-0-dep-7697f6dfb5-xdgd5    1/1     Running   0          14s
frontend-1-0-0-dep-74f74948c6-srkcj   1/1     Running   0          14s

adm2@srv1:~/kuber/2.5$ kubectl -n app1 get pod/backend-1-0-0-dep-7697f6dfb5-xdgd5 -o yaml | grep image:
  - image: wbitt/network-multitool:latest
    image: docker.io/wbitt/network-multitool:latest
	
adm2@srv1:~/kuber/2.5$ kubectl -n app1 get pod/frontend-1-0-0-dep-74f74948c6-srkcj -o yaml | grep image:
  - image: nginx:latest
    image: docker.io/library/nginx:latest

adm2@srv1:~/kuber/2.5$ helm -n app1 list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
netology-app1   app1            1               2024-06-10 22:04:09.162406767 +0300 MSK deployed        netology-app-0.1.0      1.0.0
```  
  
3. Запускаем версию 2 в namespace app1 (front 1.22.0, backend latest, appVersion 1.0.1)  
```
adm2@srv1:~/kuber/2.5$ helm upgrade --install --atomic netology-app2 netology-app/ --namespace app1 --set fronted.image.tag=1.22.0 --set appVersion=1.0.1
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
Release "netology-app2" does not exist. Installing it now.
NAME: netology-app2
LAST DEPLOYED: Mon Jun 10 22:15:18 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None

adm2@srv1:~/kuber/2.5$ kubectl -n app1 get pod
NAME                                  READY   STATUS    RESTARTS   AGE
backend-1-0-0-dep-7697f6dfb5-xdgd5    1/1     Running   0          4m45s
backend-1-0-1-dep-7885fd676f-5zppk    1/1     Running   0          9s
frontend-1-0-0-dep-74f74948c6-srkcj   1/1     Running   0          4m45s
frontend-1-0-1-dep-8657959b4b-l964m   1/1     Running   0          9s

adm2@srv1:~/kuber/2.5$ kubectl -n app1 get pod/frontend-1-0-1-dep-8657959b4b-l964m -o yaml | grep image:
  - image: nginx:1.22.0
    image: docker.io/library/nginx:1.22.0
```  
  
4. Запускаем версию 3 в namespace app2 (front latest, backend minimal, appVersion 1.0.2)  
```
adm2@srv1:~/kuber/2.5$ helm upgrade --install --atomic netology-app1 netology-app/ --namespace app2 --set backend.image.tag=minimal --set appVersion=1.0.2
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
Release "netology-app1" does not exist. Installing it now.
NAME: netology-app1
LAST DEPLOYED: Mon Jun 10 22:20:03 2024
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None

adm2@srv1:~/kuber/2.5$ kubectl -n app2 get pod
NAME                                  READY   STATUS    RESTARTS   AGE
backend-1-0-2-dep-64fbb698b9-zzfs5    1/1     Running   0          71s
frontend-1-0-2-dep-59c65b7668-hpzpq   1/1     Running   0          71s

adm2@srv1:~/kuber/2.5$ kubectl -n app2 get pod/backend-1-0-2-dep-64fbb698b9-zzfs5 -o yaml | grep image:
  - image: wbitt/network-multitool:minimal
    image: docker.io/wbitt/network-multitool:minimal
```  
  
### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
