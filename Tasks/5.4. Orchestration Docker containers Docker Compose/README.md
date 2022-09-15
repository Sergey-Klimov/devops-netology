# Домашнее задание к занятию "5.4. Оркестрация группой Docker контейнеров на примере Docker Compose"

   Задача 1
   
   Создать собственный образ операционной системы с помощью Packer.

   Для получения зачета, вам необходимо предоставить:

   Скриншот страницы, как на слайде из презентации (слайд 37).
   
   Решение:
```
   Build 'yandex' finished after 5 minutes 40 seconds.
   
   ==> Wait completed after 5 minutes 40 seconds
         
   ==> Builds finished. The artifacts of successful builds are:
   --> yandex: A disk image was created: centos-7-base (id: fd86c46j5prdok9em4mr) with family name centos
   
   vagrant@vagrant:~/data$ yc compute image list
   +----------------------+---------------+--------+----------------------+--------+
   |          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
   +----------------------+---------------+--------+----------------------+--------+
   | fd86c46j5prdok9em4mr | centos-7-base | centos | f2euv1kekdgvc0jrpaet | READY  |
   +----------------------+---------------+--------+----------------------+--------+
   
   Скриншот страницы: 
   
   https://github.com/Sergey-Klimov/devops-netology/blob/main/Tasks/5.4.%20Orchestration%20Docker%20containers%20Docker%20Compose/5.4%20task%201.png
   
```
   
   Задача 2

   