# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
   внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
1. Ссылку на репозиторий с исходной конфигурацией терраформа.  

---


**Решение:**

Так как на AWS у меня нет возможности привязать не российскую банковскую карту, то задание выполнял в YC.

Конфигурационные файлы Terraform \
[main.tf](./src/main.tf) \
[versions.tf](./src/versions.tf)

```console
vagrant@vagrant:~$ curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
vagrant@vagrant:~$ yc -version
Yandex Cloud CLI 0.97.0 linux/amd64

vagrant@vagrant:~$ yc init
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'default' with new settings
 [2] Create a new profile
Please enter your numeric choice: 1
.
.
.
.
vagrant@vagrant:~$ yc resource-manager cloud list
+----------------------+------------+----------------------+
|          ID          |    NAME    |   ORGANIZATION ID    |
+----------------------+------------+----------------------+
| b1g68do2k0bc9bhhraom | netologivm | bpfvh26u0v0g3f2rnple |
+----------------------+------------+----------------------+

vagrant@vagrant:~$ yc resource-manager folder list
+----------------------+-----------+--------+--------+
|          ID          |   NAME    | LABELS | STATUS |
+----------------------+-----------+--------+--------+
| b1gavpp1ds7gdjdn4jkb | terraform |        | ACTIVE |
+----------------------+-----------+--------+--------+

vagrant@vagrant:~$ export PATH=$PATH:/path/to/terraform

vagrant@vagrant:~$ yc iam service-account create --name devops
id: ajeh8n5obod57lcri82e
folder_id: b1gavpp1ds7gdjdn4jkb
created_at: "2022-10-26T14:28:06.573131573Z"
name: devops

vagrant@vagrant:~$ yc iam service-account list --folder-id b1gavpp1ds7gdjdn4jkb
+----------------------+--------+
|          ID          |  NAME  |
+----------------------+--------+
| ajeh8n5obod57lcri82e | devops |
+----------------------+--------+

export YC_TOKEN=`yc iam create-token`

vagrant@vagrant:~/terraform$ yc compute image get-latest-from-family centos-7 --folder-id standard-images
id: fd88d14a6790do254kj7
folder_id: standard-images
created_at: "2022-06-20T10:44:47Z"
name: centos-7-v20220620
description: centos 7
family: centos-7
storage_size: "2076180480"
min_disk_size: "10737418240"
product_ids:
  - f2euv1kekdgvc0jrpaet
status: READY
os:
  type: LINUX
pooled: true

vagrant@vagrant:~/terraform$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.81.0...
- Installed yandex-cloud/yandex v0.81.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

vagrant@vagrant:~/terraform$ terraform validate
Success! The configuration is valid.

vagrant@vagrant:~/terraform$ terraform apply -auto-approve

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_vm_1 = "51.250.80.146"
internal_ip_address_vm_1 = "192.168.10.31"

vagrant@vagrant:~/terraform$ terraform destroy -auto-approve
Destroy complete! Resources: 3 destroyed.
```
---