provider "yandex" {
  cloud_id  = "b1g68do2k0bc9bhhraom"
  folder_id = "b1gavpp1ds7gdjdn4jkb"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-01" {
  name = "terraform01"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
	  name        = "root-vm1"
      type        = "network-nvme"
      size        = "40"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-01.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-01.network_interface.0.nat_ip_address
}
