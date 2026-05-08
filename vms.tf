
#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}




resource "yandex_compute_instance" "vm" {
  count = 2

  name = "vm${count.index}"
  platform_id = "standard-v3"

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  } 

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet1.id
    nat                = true
    }
  
  resources {
    cores         = 2
    memory        = 2
    }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
}

#создаем облачную сеть
resource "yandex_vpc_network" "network1" {
  name = "network1"
}

#создаем подсеть 
resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  network_id     = yandex_vpc_network.network1.id
  v4_cidr_blocks = ["172.24.8.0/24"]
  
}


resource "yandex_lb_target_group" "group1" {
  name      = "group1"
  

  dynamic "target" {
    for_each = yandex_compute_instance.vm
    content {
      subnet_id = yandex_vpc_subnet.subnet1.id
      address   = target.value.network_interface.0.ip_address
    }
  }
}


resource "yandex_lb_network_load_balancer" "balancer1" {
  name = "balancer1"

  listener {
    name = "my-llb1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.group1.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}



