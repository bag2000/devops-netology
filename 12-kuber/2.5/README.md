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
[Чарт]()  
  
------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.
  
1. Создаем namespace app1 и app2  
```
adm2@srv1:~/kuber/2.5$ kubectl create ns app1
namespace/app1 created

adm2@srv1:~/kuber/2.5$ kubectl create ns app2
namespace/app2 created
```  
  
2. Запускаем версию по умолчанию в namespace app1 (1.16.0)  
```
adm2@srv1:~/kuber/2.5$ helm upgrade --install --atomic nginx1 nginx/ --namespace app1
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
Release "nginx1" does not exist. Installing it now.
NAME: nginx1
LAST DEPLOYED: Mon Jun 10 15:45:04 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None

adm2@srv1:~/kuber/2.5$ kubectl -n app1 get deploy/nginx1 -o yaml | grep image:
      - image: nginx:1.16.0

adm2@srv1:~/kuber/2.5$ helm -n app1 list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
nginx1  app1            1               2024-06-10 15:45:04.545733458 +0300 MSK deployed        nginx-0.1.0     1.16.0
```  
  
3. Запускаем версию 2 в namespace app1 (1.22.0)  
```
adm2@srv1:~/kuber/2.5$ helm upgrade --install --atomic nginx2 nginx/ --namespace app1 --set image.tag=1.22.0
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
Release "nginx2" does not exist. Installing it now.
NAME: nginx2
LAST DEPLOYED: Mon Jun 10 16:14:13 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: Non

adm2@srv1:~/kuber/2.5$ kubectl -n app1 get deploy/nginx2 -o yaml | grep image:
      - image: nginx:1.22.0

adm2@srv1:~/kuber/2.5$ helm -n app1 list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
nginx1  app1            2               2024-06-10 16:09:59.916684417 +0300 MSK deployed        nginx-0.1.0     1.16.0     
nginx2  app1            1               2024-06-10 16:14:13.195545293 +0300 MSK deployed        nginx-0.1.0     1.16.0
```  
  
4. Запускаем версию 3 в namespace app2 (1.23.0)  
```
adm2@srv1:~/kuber/2.5$ helm upgrade --install --atomic nginx1 nginx/ --namespace app2 --set image.tag=1.23.0
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
Release "nginx1" does not exist. Installing it now.
NAME: nginx1
LAST DEPLOYED: Mon Jun 10 16:16:41 2024
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None

adm2@srv1:~/kuber/2.5$ kubectl -n app2 get deploy/nginx1 -o yaml | grep image:
      - image: nginx:1.23.0

adm2@srv1:~/kuber/2.5$ helm -n app2 list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/adm2/kuber/example-cluster-kubeconfig.yaml
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
nginx1  app2            1               2024-06-10 16:16:41.910690511 +0300 MSK deployed        nginx-0.1.0     1.16.0
```
  
### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
