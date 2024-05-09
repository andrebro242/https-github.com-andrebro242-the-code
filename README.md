Процесс установки и настройки виртуальных машин с помощью Terraform и установки Nginx на них с использованием Ansible.
1. Подготовка окружения:

Установка Terraform:

Добавим репозиторий HashiCorp GPG ключа:

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

Добавим репозиторий HashiCorp:

    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

Обновим список пакетов:

    sudo apt-get update

Установим Terraform:

    sudo apt-get install terraform

Установка Ansible:

Установим необходимые зависимости:


    sudo apt-get update
    sudo apt-get install software-properties-common

Добавим репозиторий Ansible:

    sudo apt-add-repository --yes --update ppa:ansible/ansible

Установим Ansible:

    sudo apt-get install ansible


2. Создадим директорию проекта и файлов конфигурации:

    mkdir nginx-vm-setup
    cd nginx-vm-setup

Создадим следующие файлы конфигурации:

    main.tf:

    provider "yandex" {
      service_account_key_file = var.service_account_key_file  # путь к файлу ключа служебного аккаунта в Yandex Cloud.
      folder_id                = var.folder_id                 # идентификатор папки в Yandex Cloud
      zone                     = var.zone
    }

    resource "yandex_compute_instance" "vm1" {
      name         = "vm1"
      zone         = "ru-central1-a"
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2048
      }
      boot_disk {
        initialize_params {
          image_id = var.image_id
          size     = 10
        }
      }
    }

    resource "yandex_compute_instance" "vm2" {
      name         = "vm2"
      zone         = "ru-central1-b"
      platform_id  = "standard-v2"
      resources {
        cores  = 2
        memory = 2048
      }
      boot_disk {
        initialize_params {
          image_id = "fd89in2pfe5etl0n8k3r"  # ID образа Ubuntu 20.04 LTS
          size     = 10
        }
      }
    }


Создадим variables.tf:

    variable "service_account_key_file" {
      description = "Path to the service account key file"
    }

    variable "folder_id" {
      description = "Your Yandex Cloud folder ID"
    }

    variable "zone" {
      description = "Zone for VMs"
      default     = "ru-central1-a"
    }

    variable "image_id" {
      description = "ID of the Yandex Compute image to use"
    }

Ничего не меняем. В этом файле определены только переменные, значения которых будут заданы в файле terraform.tfvars.

    service_account_key_file = "path/to/your/service/account/key/file.json"  # путь к файлу ключа служебного аккаунта в Yandex Cloud.
    folder_id                = "your-folder-id"                              # идентификатор папки в Yandex Cloud.
    image_id                 = "your-image-id"                               # ID образа операционной системы.


3. Создание виртуальных машин с помощью Terraform:

Запустим инициализацию Terraform:

    terraform init

Проверим план изменений:

    terraform plan

Применим изменения для создания виртуальных машин:

    terraform apply

4. Установка и настройка Nginx с использованием Ansible:

Создадим следующие файлы:

 1.ansible_playbook.yml:

    ---
    - hosts: vm1
      become: true
      tasks:
        - name: Install Nginx
          apt:
            name: nginx
            state: present

    - hosts: vm2
      become: true
      tasks:
        - name: Install Nginx
          apt:
            name: nginx
            state: present
    - name: Ensure Nginx is running
      systemd:
        name: nginx
        state: started
        enabled: yes

    - name: Copy index.html file
      template:
        src: index.html.j2
        dest: /var/www/html/index.html

Создадим файл index.html.j2 и добавим следующий HTML-код:

    html

    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to My Website</title>
    </head>
    <body>
        <h1>Hello, world!</h1>
        <p>This is a sample webpage served by Nginx on Yandex Cloud VM.</p>
    </body>
    </html>

2. Файл ansible_inventory.ini:

    [vm1]
    vm1 ansible_host=YOUR_VM3_IP_OR_FQDN

    [vm2]
    vm2 ansible_host=YOUR_VM4_IP_OR_FQDN

Заменим YOUR_VM3_IP_OR_FQDN и YOUR_VM4_IP_OR_FQDN на реальные IP-адреса или полные доменные имена виртуальных машин.

Запустим плейбук Ansible для установки Nginx:

    ansible-playbook -i ansible_inventory.ini ansible_playbook.yml

После завершения этих шагов будут успешно созданы виртуальные машины с установленным Nginx. Останется только проверить, что Nginx работает корректно на каждой из виртуальных машин.
