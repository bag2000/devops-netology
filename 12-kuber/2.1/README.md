# FOPS-10 Поляков Роман

# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.
  
**Ответ**  
  
[Манифест Deployment](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.1/files/deploy-busy-multi-netology.yaml)  
1. Заходим в Pod multitool  
```
adm2@srv1:~/kuber/2.1$ kubectl exec -it deploy/busy-multi-dep -c multitool -- sh
/ # 
```
  
2. Проверяем запись в расшареный файл  
```
/ # cat /logs/log.txt
waiting for 5 sec
waiting for 5 sec
waiting for 5 sec
waiting for 5 sec
/ # 
```
  
------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.
  
**Ответ**  
  
[Манифест DaemonSet](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.1/files/daemonset-multitool-netology.yaml)  
1. Заходим в Pod multitool  
```
adm2@srv1:~/kuber/2.1$ kubectl exec -it daemonset/multi-dae -c multitool -- sh
/ #
```
  
2. Читаем syslog с хоста  
```
/ # tail -3 /logs/syslog 
May 27 12:42:21 ntlg-microk8s systemd[1]: run-containerd-runc-k8s.io-04a303124612ad4a77590a3d953f605173bd8fcb478d204a15ebfc7f2d9aaeb4-runc.DSihtp.mount: Deactivated successfully.
May 27 12:42:24 ntlg-microk8s systemd[1]: run-containerd-runc-k8s.io-2dbf515811f6e6e7b2f74b5d0eb8a14480c91bb0a5f0212666170796ce4d305c-runc.5Odzcf.mount: Deactivated successfully.
May 27 12:42:26 ntlg-microk8s systemd[1]: run-containerd-runc-k8s.io-2dbf515811f6e6e7b2f74b5d0eb8a14480c91bb0a5f0212666170796ce4d305c-runc.mO9OdV.mount: Deactivated successfully.
/ # 
```
  
------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------