# devops-netology
DEVSYS-20
First line
Second line

# Будет игнорироваться локальный каталоги .terraform

**/.terraform/*

# Будут игнорироваться файлы .tfstate

*.tfstate
*.tfstate.*

# Будут игнорироваться файлы журнала сбоев

crash.log
crash.*.log
 
# Будут игнорироваться все файлы .tfvars, которые могут содержать конфиденциальные данные, такие как пароль, закрытые ключи и другие секреты.
# Будут игнорироваться изменения в зависимости от окружения.

*.tfvars
*.tfvars.json

# Будут игнорировать файлы переопределения, так как они обычно используются для локального переопределения ресурсов и т.д.
# Будут игнорироваться не зарегистрированые

override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Будут игнорироваться файлы tfplan, вывод плана команды: terraform plan -out=tfplan
# example: *tfplan*

# Будут игнорироваться файлы конфигурации CLI

.terraformrc
terraform.rc

othe line
1
2
3
4
5
6
7
8
9
10

