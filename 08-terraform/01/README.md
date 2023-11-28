## Домашнее задание к занятию «Введение в Terraform»

2. Изучите файл .gitignore. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?  
personal.auto.tfvars  
  
3. Выполните код проекта. Найдите в state-файле секретное содержимое созданного ресурса random_password, пришлите в качестве ответа конкретный ключ и его значение.  
"result": "0ZG1asWpWvm6k9z4"  
  
4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла main.tf. Выполните команду terraform validate. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.  
  
resource "docker_image" {  
All resource blocks must have 2 labels (type, name).  
Все ресурсы должны иметь тип и название. В нашем случае есть тип - docker_image, но нет имени. Добавляем имя nginx.  
  
resource "docker_container" "1nginx" {  
A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.  
Имя должно начинаться с буквы или символа подчеркивания и может содержать только буквы, цифры, знаки подчеркивания и тире. Убираем 1.  
  
name  = "example_${random_password.random_string_FAKE.resulT}"  
A managed resource "random_password" "random_string_FAKE" has not been declared in the root module.  
Управляемый ресурс "random_password" "random_string_FAKE" не был объявлен в корневом модуле. _FAKE лишнее.  
  
name  = "example_${random_password.random_string.resulT}"  
This object has no argument, nested block, or exported attribute named "resulT". Did you mean "result"?  
У этого объекта нет аргумента, вложенного блока или экспортируемого атрибута с именем "resulT". Вы имели в виду "result"? Исправляем resulT на result  
  
5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды docker ps.  
```
resource "docker_image" "nginx"{
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 8000
  }
}
```
  
```
root@srv1:/home/adm2/terraform# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                       NAMES
c2215d9bbbd8   a6bd71f48f68   "/docker-entrypoint.…"   16 seconds ago   Up 14 seconds   0.0.0.0:8000->80/tcp                        example_0ZG1asWpWvm6k9z4
```
  
6. Замените имя docker-контейнера в блоке кода на hello_world. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду terraform apply -auto-approve. Объясните своими словами, в чём может быть опасность применения ключа -auto-approve. В качестве ответа дополнительно приложите вывод команды docker ps.  
  
-auto-approve Пропускает интерактивное утвержение плана. Нет возможности посмотреть, а главное отменить изменения. И соответственно, можно потерять данные.  

```
root@srv1:/home/adm2/terraform# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                       NAMES
c6c1d2b784c9   a6bd71f48f68   "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   0.0.0.0:8000->80/tcp                        hello_world
```
  
7. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.  
```
root@srv1:/home/adm2/terraform# cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.5.7",
  "serial": 11,
  "lineage": "f4f1d650-91b0-87e6-a7a9-e5a302bde44c",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
  
8. Объясните, почему при этом не был удалён docker-образ nginx:latest. Ответ обязательно подкрепите строчкой из документации terraform провайдера docker. (ищите в классификаторе resource docker_image) 
   
keep_locally - Если true, то изображение Docker не будет удалено при операции уничтожения. Если это значение равно false, изображение будет удалено из локального хранилища docker при операции уничтожения.
  
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.  