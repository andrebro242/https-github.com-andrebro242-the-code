    terraform {
      required_providers {
        yandex = {
          source = "yandex-cloud/yandex"
        }
      }
    }

    provider "yandex" {
      service_account_key_file = "/home/andrebro242/yandex-cloud/authorized_key (2).json"  # путь к файлу ключа служебного аккаунта в Yandex                                                                                             Cloud.(создать авторизованный ключ)                
      folder_id                = "b1gv9ufasabvaetq03ub"                # идентификатор папки в Yandex Cloud
      zone                     = var.zone
    }

    resource "yandex_compute_instance" "vm1" {
      name         = "vm1"
      zone         = "ru-central1-a"
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2
      }
      boot_disk {
        initialize_params {
          image_id = "fd8j623f06gi15mfk4g6"  # ID образа Ubuntu 20.04 LTS
          size     = 10
        }
      }

      network_interface {
        subnet_id = "e9bd81o1empdeuaqltg2"
      }


      scheduling_policy {
        preemptible = true
      }
    }

    resource "yandex_compute_instance" "vm2" {
      name         = "vm2"
      zone         = "ru-central1-b"
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2
      }
      boot_disk {
        initialize_params {
          image_id = "fd89in2pfe5etl0n8k3r"  # ID образа Ubuntu 20.04 LTS
          size     = 10
        }
      }
      network_interface {
        subnet_id = "e9bd81o1empdeuaqltg2"
      }


      scheduling_policy {
        preemptible = true
      }
    }

    resource "yandex_compute_instance" "vmzabbix" {
      name         = "vmzabbix"
      zone         = var.zone
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2
      }
      boot_disk {
        initialize_params {
          image_id = "fd8j623f06gi15mfk4g6"  # ID образа Ubuntu 20.04 LTS
          size     = 10
        }
      }
      network_interface {
        subnet_id = "e9bd81o1empdeuaqltg2"
      }


      scheduling_policy {
        preemptible = true
      }
    }

    resource "yandex_compute_instance" "vmelk2" {
      name         = "vmelk2"
      zone         = var.zone
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2
      }
      boot_disk {
        initialize_params {
          image_id = "fd8j623f06gi15mfk4g6"  # ID образа Ubuntu 20.04 LTS
          size     = 10
        }
      }
      network_interface {
        subnet_id = "e9bd81o1empdeuaqltg2"
      }


      scheduling_policy {
        preemptible = true
      }
    }

    resource "yandex_compute_instance" "vmkibana" {
      name         = "vmkibana"
      zone         = var.zone
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2
      }
      boot_disk {
        initialize_params {
          image_id = "fd8j623f06gi15mfk4g6"  # ID образа Ubuntu 20.04 LTS
          size     = 10
        }
      }
      network_interface {
        subnet_id = "e9bd81o1empdeuaqltg2"
      }


      scheduling_policy {
        preemptible = true
      }
    }

    resource "yandex_compute_instance" "vmbastion" {
      name         = "vmbastion"
      zone         = var.zone
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2
      }
      boot_disk {
        initialize_params {
          image_id = "fd8j623f06gi15mfk4g6"  # ID образа Ubuntu 20.04 LTS
          size     = 10
        }
      }
      network_interface {
        subnet_id = "e9bd81o1empdeuaqltg2"
      }


      scheduling_policy {
        preemptible = true
      }
    }

