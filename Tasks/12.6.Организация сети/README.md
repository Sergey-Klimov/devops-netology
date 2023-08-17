# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

### Решение:

Подготовил YC к работе с Terraform:

```bash
vagrant@Terraform:~/terraform$ yc config list
service-account-key:
  id: ajenaov06laen3diatjq
  service_account_id: ajetok0pfehkeu83itqt
  created_at: "2023-08-17T09:59:39.888832964Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----
    /
    /
    /
    /
        -----END PUBLIC KEY-----
  private_key: |
    -----BEGIN PRIVATE KEY-----
    /
    /
    /
    /
    -----END PRIVATE KEY-----
cloud-id: b1g68do2k0bc9bhhraom
folder-id: b1gsnf9jee4ufldor2g2
```

Подготовил Terraform к работе с YC:

```bash
vagrant@Terraform:~/terraform$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.97.0...
- Installed yandex-cloud/yandex v0.97.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Подготовил файлы для Terraform:

[main.tf](./terraform/main.tf), [network.tf](./terraform/network.tf), [outputs.tf](./terraform/outputs.tf), [provider.tf](./terraform/provider.tf), [variables.tf](./terraform/variables.tf)

<details><summary>Выполняем terraform plan</summary>

```bash 
vagrant@Terraform:~/terraform$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.nat-instance will be created
  + resource "yandex_compute_instance" "nat-instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "nat-instance-vm1.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA+vRPc/Nx1Wc4ZKKmxhFN5NGxp4t0hWK7k46mcB8QhYB+3Ln2dJXMFt3KNAAbIYwAJw953Jz2E5st7z/VbPiFEH3fs7zN0cPl/t5E+5rucTGHvduXJyxDr5HTcMMwuLyLhi0Dbh//FGgHqMpOGxi3e7jkdpuSoSaI9spLFpCmh+OVos/AyREm3pOeYYHQY9J5QKwF+2wMZj7SmCevMEihNiWK+GkPNuvaZCP/h8Ff+LSCtzNXQb2ACiXqwPoRaMQoyXUjGHq4mGvV/n1SvgvEl9FgFqaqp7rSTWo6RFNSPPULbeQgU/VRbg1MqT3ZEx+wWUbPO2WMaHlqZDRAnbs/JdRrBCEJ2GJhIn8xgQftNFrXU6lCAmIA4PTFrCQTCGB/D1rM7MhtuVLr12oVTBmo/4cWMrqeqL6D3ItWtdG0V7g8Nai1Nelm0d7TuqYqmmr6lbFBhW9aGhvboKZPOED7ZV7Ad8+p1T5BynarvaPeo/QvkAnWz7EnwjEJ3L3IOdk= vagrant@Terraform
            EOT
        }
      + name                      = "nat-instance-vm1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-c"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80mrhj8fl2oe87o4e1"
              + name        = "root-nat-instance-vm1"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.10.254"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 1
          + memory        = 1
        }
    }

  # yandex_compute_instance.private-vm will be created
  + resource "yandex_compute_instance" "private-vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "private-vm1.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA+vRPc/Nx1Wc4ZKKmxhFN5NGxp4t0hWK7k46mcB8QhYB+3Ln2dJXMFt3KNAAbIYwAJw953Jz2E5st7z/VbPiFEH3fs7zN0cPl/t5E+5rucTGHvduXJyxDr5HTcMMwuLyLhi0Dbh//FGgHqMpOGxi3e7jkdpuSoSaI9spLFpCmh+OVos/AyREm3pOeYYHQY9J5QKwF+2wMZj7SmCevMEihNiWK+GkPNuvaZCP/h8Ff+LSCtzNXQb2ACiXqwPoRaMQoyXUjGHq4mGvV/n1SvgvEl9FgFqaqp7rSTWo6RFNSPPULbeQgU/VRbg1MqT3ZEx+wWUbPO2WMaHlqZDRAnbs/JdRrBCEJ2GJhIn8xgQftNFrXU6lCAmIA4PTFrCQTCGB/D1rM7MhtuVLr12oVTBmo/4cWMrqeqL6D3ItWtdG0V7g8Nai1Nelm0d7TuqYqmmr6lbFBhW9aGhvboKZPOED7ZV7Ad8+p1T5BynarvaPeo/QvkAnWz7EnwjEJ3L3IOdk= vagrant@Terraform
            EOT
        }
      + name                      = "private-vm1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-c"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd88mqi0d02c7jbkest0"
              + name        = "root-private-vm1"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 1
          + memory        = 1
        }
    }

  # yandex_compute_instance.public-vm will be created
  + resource "yandex_compute_instance" "public-vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "public-vm1.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA+vRPc/Nx1Wc4ZKKmxhFN5NGxp4t0hWK7k46mcB8QhYB+3Ln2dJXMFt3KNAAbIYwAJw953Jz2E5st7z/VbPiFEH3fs7zN0cPl/t5E+5rucTGHvduXJyxDr5HTcMMwuLyLhi0Dbh//FGgHqMpOGxi3e7jkdpuSoSaI9spLFpCmh+OVos/AyREm3pOeYYHQY9J5QKwF+2wMZj7SmCevMEihNiWK+GkPNuvaZCP/h8Ff+LSCtzNXQb2ACiXqwPoRaMQoyXUjGHq4mGvV/n1SvgvEl9FgFqaqp7rSTWo6RFNSPPULbeQgU/VRbg1MqT3ZEx+wWUbPO2WMaHlqZDRAnbs/JdRrBCEJ2GJhIn8xgQftNFrXU6lCAmIA4PTFrCQTCGB/D1rM7MhtuVLr12oVTBmo/4cWMrqeqL6D3ItWtdG0V7g8Nai1Nelm0d7TuqYqmmr6lbFBhW9aGhvboKZPOED7ZV7Ad8+p1T5BynarvaPeo/QvkAnWz7EnwjEJ3L3IOdk= vagrant@Terraform
            EOT
        }
      + name                      = "public-vm1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-c"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd88mqi0d02c7jbkest0"
              + name        = "root-public-vm1"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 1
          + memory        = 1
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.nat-route-table will be created
  + resource "yandex_vpc_route_table" "nat-route-table" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + next_hop_address   = "192.168.10.254"
        }
    }

  # yandex_vpc_subnet.subnet-private will be created
  + resource "yandex_vpc_subnet" "subnet-private" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "private"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-c"
    }

  # yandex_vpc_subnet.subnet-public will be created
  + resource "yandex_vpc_subnet" "subnet-public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-c"
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_nat_vm     = (known after apply)
  + external_ip_address_private_vm = (known after apply)
  + external_ip_address_public_vm  = (known after apply)
  + internal_ip_address_nat_vm     = "192.168.10.254"
  + internal_ip_address_private_vm = (known after apply)
  + internal_ip_address_public_vm  = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

</details>

Запускаем terraform apply -auto-approve:

```bash
vagrant@Terraform:~/terraform$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.nat-instance will be created
  + resource "yandex_compute_instance" "nat-instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "nat-instance-vm1.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
.
.
.
.
.
.
.
yandex_compute_instance.private-vm: Creating...
yandex_compute_instance.nat-instance: Still creating... [10s elapsed]
yandex_compute_instance.public-vm: Still creating... [10s elapsed]
yandex_compute_instance.private-vm: Still creating... [10s elapsed]
yandex_compute_instance.nat-instance: Still creating... [20s elapsed]
yandex_compute_instance.public-vm: Still creating... [20s elapsed]
yandex_compute_instance.private-vm: Still creating... [20s elapsed]
yandex_compute_instance.nat-instance: Still creating... [30s elapsed]
yandex_compute_instance.public-vm: Still creating... [30s elapsed]
yandex_compute_instance.private-vm: Still creating... [30s elapsed]
yandex_compute_instance.public-vm: Creation complete after 38s [id=ef3vfq550h2imoekfdqp]
yandex_compute_instance.nat-instance: Still creating... [40s elapsed]
yandex_compute_instance.private-vm: Still creating... [40s elapsed]
yandex_compute_instance.nat-instance: Still creating... [50s elapsed]
yandex_compute_instance.private-vm: Still creating... [50s elapsed]
yandex_compute_instance.nat-instance: Creation complete after 53s [id=ef31lusidsidfgh0pna4]
yandex_compute_instance.private-vm: Still creating... [1m0s elapsed]
yandex_compute_instance.private-vm: Still creating... [1m10s elapsed]
yandex_compute_instance.private-vm: Creation complete after 1m10s [id=ef38fe1fr2qos3q0j2aq]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat_vm = "84.201.170.19"
external_ip_address_private_vm = ""
external_ip_address_public_vm = "84.201.170.169"
internal_ip_address_nat_vm = "192.168.10.254"
internal_ip_address_private_vm = "192.168.20.26"
internal_ip_address_public_vm = "192.168.10.29"
```
Виртуальные машины в Yandex Cloud:

![Yandex cloud](img/vm.png)

Подсети в Yandex Cloud:

![Yandex cloud](img/subnet.png)

Маршрутизация в Yandex Cloud:

![Yandex cloud](img/routing.png)

Проверяем доступность сети с Public:

![Yandex cloud](img/public.png)

Проверяем доступность сети с Private:

![Yandex cloud](img/private.png)

----