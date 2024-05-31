# FOPS-10 Поляков Роман

# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
  
**Ответ**  
  
[Манифест Deployment](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.2/files/deploy-busy-multi-netology.yaml)  
[Манифест PV](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.2/files/pv-local.yaml)  
[Манифест PVC](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.2/files/pvc-local.yaml)  
  
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
  
3. Удаляем Deployment, PVC и смотрим, что стало с PV
```
adm2@srv1:~/kuber/2.2$ kubectl delete -f deploy-busy-multi-netology.yaml 
deployment.apps "busy-multi-dep" deleted

adm2@srv1:~/kuber/2.2$ kubectl delete -f pvc-local.yaml 
persistentvolumeclaim "task-pv-claim" deleted

adm2@srv1:~/kuber/2.2$ kubectl get pv
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
task-pv-volume   10Mi       RWO            Retain           Released   default/task-pv-claim   manual         <unset>                          11m
```
  
4. Проверяем наличие папки test и log файла  
```
adm2@ntlg-microk8s:/test$ ls
log.txt
adm2@ntlg-microk8s:/test$ cat log.txt
waiting for 5 sec
waiting for 5 sec
waiting for 5 sec
waiting for 5 sec
```  
  
5. Пояснение   
При удалении Deployment и PVC, PV сохраниться и перейдет в состояние Released, данные на нем остануться. Для того чтобы PV повторно использовать придется пересоздать и PV и PVC.  
Deploy обращается к PV через PVC. PVC в свою очередь является только запросом на получение volume, по этому после его удаления данные сохраняться, а PV превратиться в "пустышку".  
При удалении PV, данные тоже сохраняться. Для того, чтобы данные удалялись, нужно изменить persistentVolumeReclaimPolicy на Delete  
------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
  
**Ответ**  
[Манифест Deployment](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.2/files/deploy-multi-netology.yaml)  
[Манифест PVC](https://github.com/bag2000/devops-netology/blob/main/12-kuber/2.2/files/pvc-nfs.yaml) 
  
1.1 Для решения данной задачи, развернул на отдельной виртуальной машине nfs сервер. Установил этот [nfs provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner).  
```
adm2@srv1:~/kuber/2.2$ kubectl get po
NAME                                              READY   STATUS    RESTARTS   AGE
nfs-subdir-external-provisioner-69c574889-w5jrx   1/1     Running   0          17h
adm2@srv1:~/kuber/2.2$ kubectl get sc
NAME         PROVISIONER                                     RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-client   cluster.local/nfs-subdir-external-provisioner   Delete          Immediate           true                   17h
```
  
1.2 Конфигурация провизора при установке  
```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.12.140 \
    --set nfs.path=/var/nfs
```  
  
2 NFS до записи  
```
adm2@srv1:/var/nfs$ ls
adm2@srv1:/var/nfs$
```
  
3. Создаем Deployment и pvc  
  
```
adm2@srv1:~/kuber/2.2$ kubectl apply -f pvc-nfs.yaml 
persistentvolumeclaim/nfs-claim created

adm2@srv1:~/kuber/2.2$ kubectl apply -f deploy-multi-netology.yaml 
deployment.apps/multi-dep created

dm2@srv1:~/kuber/2.2$ kubectl get deploy
NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
multi-dep                         1/1     1            1           7m35s
nfs-subdir-external-provisioner   1/1     1            1           17h

adm2@srv1:~/kuber/2.2$ kubectl get pvc
NAME        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
nfs-claim   Bound    pvc-b9f0fa01-88c4-4b2c-b7f7-f460cbad4953   1Mi        RWX            nfs-client     <unset>                 90s

adm2@srv1:~/kuber/2.2$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-b9f0fa01-88c4-4b2c-b7f7-f460cbad4953   1Mi        RWX            Delete           Bound    default/nfs-claim   nfs-client     <unset>
```
  
4. Заходим в multitool, создаем файл  
```
adm2@srv1:~/kuber/2.2$ kubectl exec -it deploy/multi-dep -- sh
/ # 

# echo hi from me > /logs/hi.txt
/ # ls /logs/
hi.txt
/ # cat /logs/hi.txt 
hi from me
/ #
```
  
5. Проверяем наличие файла на nfs сервере  
```
adm2@srv1:/var/nfs$ ls
default-nfs-claim-pvc-b9f0fa01-88c4-4b2c-b7f7-f460cbad4953

adm2@srv1:/var/nfs$ cd default-nfs-claim-pvc-b9f0fa01-88c4-4b2c-b7f7-f460cbad4953/

adm2@srv1:/var/nfs/default-nfs-claim-pvc-b9f0fa01-88c4-4b2c-b7f7-f460cbad4953$ ls
hi.txt

adm2@srv1:/var/nfs/default-nfs-claim-pvc-b9f0fa01-88c4-4b2c-b7f7-f460cbad4953$ cat hi.txt
hi from me
```
  
------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.