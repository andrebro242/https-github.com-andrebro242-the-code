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

    mkdir vm-setup
    cd vm-setup

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
          image_id = "fd89in2pfe5etl0n8k3r"  # ID образа Ubuntu 20.04 LTS
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

    resource "yandex_compute_instance" "vmzabbix" {
      name         = "vmzabbix"
      zone         = var.zone
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

    resource "yandex_compute_instance" "vmelk2" {
      name         = "vmelk2"
      zone         = var.zone
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

    resource "yandex_compute_instance" "vmkibana" {
      name         = "vmkibana"
      zone         = var.zone
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

    resource "yandex_compute_instance" "vmbastion" {
      name         = "vmbastion"
      zone         = var.zone
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
файл terraform.tfvars:

    service_account_key_file = "path/to/your/service/account/key/file.json"  # путь к файлу ключа служебного аккаунта в Yandex Cloud.
    folder_id                = "your-folder-id"                              # идентификатор папки в Yandex Cloud.
    image_id                 = "fd89in2pfe5etl0n8k3r"                        # ID образа Ubuntu 20.04 LTS                               


3. Создание виртуальных машин с помощью Terraform:

Запустим инициализацию Terraform:

    terraform init

Проверим план изменений:

    terraform plan

Применим изменения для создания виртуальных машин:

    terraform apply

4. Установка Nginx,zabbix агентов и filebeat на web сервера vm1 и vm2 с использованием Ansible:

а.Создадим каталог проекта:

    mkdir my_ansible_project
    cd my_ansible_project

б.Созд необходимых директорий:

    mkdir files templates

в.Создание файлов сценариев Ansible:

    touch ansible_nginx_playbook.yml ansible_zabbix_playbook.yml ansible_filebeat_playbook.yml

г.Создание файлов шаблонов:

    touch templates/index.html.j2 templates/zabbix_agentd.conf.j2 templates/filebeat.yml.j2

Помещаем файлы конфигурации, если они есть, в директорию files.
Допустим, есть файл конфигурации Nginx под названием nginx.conf, который мы хотим скопировать на целевые хосты. В таком случае, помещаем этот файл в директорию files нашего проекта:

    cp /path/to/nginx.conf files/

д.Отредактируем файлы сценариев Ansible:

Файлы ansible_nginx_playbook.yml, ansible_zabbix_playbook.yml, ansible_filebeat_playbook.yml :

ansible_nginx_playbook.yml:

    ---
    - hosts: vm1
      become: true
      vars:
        vm1_ip: "YOUR_VM1_IP_ADDRESS"
      tasks:
        - name: Install Nginx
          apt:
            name: nginx
            state: present
        - name: Copy index.html file
          template:
            src: index.html.j2
            dest: /var/www/html/index.html
        - name: Ensure Nginx is running
          systemd:
            name: nginx
            state: started
            enabled: yes

    - hosts: vm2
      become: true
      vars:
        vm2_ip: "YOUR_VM2_IP_ADDRESS"
      tasks:
        - name: Install Nginx
          apt:
            name: nginx
            state: present
        - name: Copy index.html file
          template:
            src: index.html.j2
            dest: /var/www/html/index.html
        - name: Ensure Nginx is running
          systemd:
            name: nginx
            state: started
            enabled: yes

Теперь создадим playbook для установки и настройки Zabbix агентов:

ansible_zabbix_playbook.yml:

    ---
    - hosts: vm1
      become: true
      vars:
        vm1_ip: "YOUR_VM1_IP_ADDRESS"
      tasks:
        - name: Install Zabbix Agent
          apt:
            name: zabbix-agent
            state: present
        - name: Copy Zabbix Agent configuration file
          template:
            src: zabbix_agentd.conf.j2
            dest: /etc/zabbix/zabbix_agentd.conf
          notify: restart zabbix-agent

    - hosts: vm2
      become: true
      vars:
        vm2_ip: "YOUR_VM2_IP_ADDRESS"
      tasks:
        - name: Install Zabbix Agent
           apt:
            name: zabbix-agent
            state: present
        - name: Copy Zabbix Agent configuration file
          template:
            src: zabbix_agentd.conf.j2
            dest: /etc/zabbix/zabbix_agentd.conf
          notify: restart zabbix-agent

    handlers:
       - name: restart zabbix-agent
         service:
            name: zabbix-agent
            state: restarted

И, наконец, создадим playbook для установки и настройки Filebeat:

ansible_filebeat_playbook.yml:

    ---
    - hosts: vm1
      become: true
      vars:
        vm1_ip: "YOUR_VM1_IP_ADDRESS"
      tasks:
        - name: Install Filebeat
          apt:
            name: filebeat
            state: present
        - name: Copy Filebeat configuration file
          template:
            src: filebeat.yml.j2
            dest: /etc/filebeat/filebeat.yml
          notify: restart filebeat

    - hosts: vm2
      become: true
      vars:
        vm2_ip: "YOUR_VM2_IP_ADDRESS"
      tasks:
        - name: Install Filebeat
          apt:
            name: filebeat
            state: present
        - name: Copy Filebeat configuration file
          template:
            src: filebeat.yml.j2
            dest: /etc/filebeat/filebeat.yml
          notify: restart filebeat

    handlers:
      - name: restart filebeat
        service:
          name: filebeat
          state: restarted


е.Заполняем файлы шаблонов:

 templates/index.html.j2, templates/zabbix_agentd.conf.j2, templates/filebeat.yml.j2, чтобы в них содержались необходимые настройки.

    index.html.j2 и добавим следующий HTML-код:

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

zabbix_agentd.conf.j2:

        Server=YOUR_ZABBIX_SERVER_IP_OR_FQDN                       # IP ZABBIX_SERVER
        ServerActive=YOUR_ZABBIX_SERVER_IP_OR_FQDN                 # IP ZABBIX_SERVER
        Hostname={{ ansible_hostname }}

filebeat.yml.j2:

        filebeat.inputs:
        - type: log
          enabled: true
          paths:
            - /var/log/nginx/access.log
            - /var/log/nginx/error.log

        output.elasticsearch:
          hosts: ["YOUR_ELASTICSEARCH_HOST:9200"]

ж.Создаем файл инвентаря Ansible:

    touch ansible_inventory.ini

Редактируем файл ansible_inventory.ini, добавляя информацию о хостах:

    [vm1]
    vm1 ansible_host=YOUR_VM1_IP_OR_FQDN        

    [vm2]
    vm2 ansible_host=YOUR_VM2_IP_OR_FQDN       

Заменим YOUR_VM1_IP_OR_FQDN и YOUR_VM2_IP_OR_FQDN на реальные IP-адреса или полные доменные имена виртуальных машин.

з.Запустим Ansible playbook:

    ansible-playbook -i ansible_inventory.ini ansible_nginx_playbook.yml
    ansible-playbook -i ansible_inventory.ini ansible_zabbix_playbook.yml
    ansible-playbook -i ansible_inventory.ini ansible_filebeat_playbook.yml

Это запустит каждый из playbook для соответствующих хостов из ansible_inventory.ini

5. Ansible playbook для выполнения установки Docker и загрузки образа Zabbix, MariaDB, настройки базы данных, а также настройки брандмауэра с помощью nftables:

        ---
        - hosts: vmzabbix
          gather_facts: no
          vars:
            zabbix_server_ip: "YOUR_ZABBIX_SERVER_IP_OR_FQDN"      # фактический IP-адрес или доменное имя Zabbix сервера.
          tasks:
            - name: Install Docker
              apt:
                name: "{{ item }}"
                state: present
              loop:
                - docker.io
                - docker-compose
              become: yes

            - name: Start and enable Docker service
              systemd:
                name: docker
                state: started
                enabled: yes
              become: yes

            - name: Pull Zabbix Docker image
              docker_image:
                name: zabbix/zabbix-6.4:latest
              become: yes

            - name: Install MariaDB server
             apt:
                name: "{{ item }}"
                state: present
              loop:
                - zabbix-server-mysql				 
                - zabbix-frontend-php				 
                - zabbix-apache-conf				 
                - zabbix-sql-scripts				
                - zabbix-agent					
                - mariadb-common
                - mariadb-server-10.6
                - mariadb-client-10.6
              become: yes

            - name: Start and enable MariaDB service
              systemd:
                name: mariadb
                state: started
                enabled: yes
              become: yes

            - name: Configure MariaDB root password
              expect:
                command: mysql_secure_installation
                responses:
                  'Enter current password for root (enter for none):': '\r'
                      'Set root password? [Y/n]': 'y\r'
                  'New password:': '12345678\r'
                  'Re-enter new password:': '12345678\r'
                  'Remove anonymous users? [Y/n]': 'y\r'
                  'Disallow root login remotely? [Y/n]': 'y\r'
                  'Remove test database and access to it? [Y/n]': 'y\r'
                  'Reload privilege tables now? [Y/n]': 'y\r'
              become: yes

            - name: Create Zabbix database and user
              mysql_db:
                name: zabbix
                state: present
                collation: utf8mb4_bin
              become: yes

            - name: Create Zabbix database user
              mysql_user:
                name: zabbix
                password: 12345678
                priv: "zabbix.*:ALL"
                host: localhost
                state: present
                become: yes

            - name: Import Zabbix database schema
              shell: zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p12345678 zabbix
              become: yes

            - name: Set DBPassword in Zabbix server config
              lineinfile:
                path: /etc/zabbix/zabbix_server.conf
                regexp: '^DBPassword='
                line: 'DBPassword=12345678'
              become: yes

            - name: Restart Zabbix server
              service:
                name: zabbix-server
                state: restarted
              become: yes

            - name: Configure nftables rules
              template:
                src: nftables_zabbix_rules.nft.j2
                dest: /etc/nftables.conf
              notify: restart nftables
              become: yes

        handlers:
          - name: restart nftables
            service:
              name: nftables
              state: restarted
            become: yes
Этот playbook устанавливает Zabbix и MariaDB, устанавливает необходимые пакеты, настраивает MariaDB и Zabbix, а также настраивает брандмауэр с помощью nftables.Может потребоваться настроить параметры Docker-контейнера Zabbix.

В файл ansible_inventory.ini вставим : 

    vmzabbix ansible_host=YOUR_VMZABBIX_IP          # IP vmzabbix

6.Установка и настройка Elasticsearch

Добавим в inventory.ini

    [vmelk2]
    your_vm_ip_or_domain ansible_user=your_ssh_user

Где your_vm_ip_or_domain - это IP-адрес или доменное имя виртуальной машины, а your_ssh_user - это имя пользователя SSH для подключения к машине.

плейбук Ansible с учетом настройки nftables для разрешения доступа к портам Elasticsearch:

    ---
    - hosts: vmelk2
      become: yes
      tasks:
        - name: Install Docker
          apt:
            name: "{{ item }}"
            state: present
          loop:
            - docker.io
            - docker-compose

        - name: Start and enable Docker service
          systemd:
            name: docker
            state: started
            enabled: yes

        - name: Create directory for Elasticsearch data
          file:
            path: /var/lib/elasticsearch
            state: directory

        - name: Set vm.max_map_count for Elasticsearch
          sysctl:
            name: vm.max_map_count
            value: 262144
            state: present

        - name: Configure nftables rules for Elasticsearch
          template:
            src: nftables_elasticsearch_rules.nft.j2
            dest: /etc/nftables.conf
          notify: restart nftables

        - name: Run Elasticsearch container
          docker_container:
            name: elasticsearch
            image: docker.elastic.co/elasticsearch/elasticsearch:7.15.1
            state: started
            restart_policy: always
            volumes:
              - /var/lib/elasticsearch:/usr/share/elasticsearch/data
            ports:
              - "9200:9200"
              - "9300:9300"
            environment:
              - "discovery.type=single-node"

    handlers:
      - name: restart nftables
        systemd:
          name: nftables
          state: restarted

Настройки nftables хранятся в шаблоне nftables_elasticsearch_rules.nft.j2, который мы создадим в директории с playbook'ом. шаблона:

    # nftables_elasticsearch_rules.nft.j2
    table inet filter {
        chain input {
            type filter hook input priority 0;
            tcp dport 9200 accept;
            tcp dport 9300 accept;
        }
    }

Этот шаблон создает правила nftables для разрешения входящего трафика на порты 9200 и 9300, которые используются Elasticsearch. 

7. Плейбук Ansible для установки и настройки Kibana на виртуальной машине vmkibana в Yandex.Cloud с использованием Docker и соединением с Elasticsearch:

    ---
    - hosts: vmkibana
      gather_facts: no
      vars:
        vmkibana_ip: "YOUR_VMKIBANA_IP_ADDRESS"
      tasks:
        - name: Install Docker and Docker Compose
          apt:
            name: "{{ item }}"
            state: present
          loop:
            - docker.io
            - docker-compose
          become: yes

        - name: Start and enable Docker service
          systemd:
            name: docker
            state: started
            enabled: yes
          become: yes

        - name: Create a directory for Kibana configuration
          file:
            path: /etc/kibana
            state: directory
          become: yes

        - name: Copy Kibana configuration file
          copy:
            src: kibana.yml
            dest: /etc/kibana/kibana.yml
          become: yes

        - name: Create Docker Compose file for Kibana
          copy:
            content: |
              version: '3'
              services:
                kibana:
                  image: docker.elastic.co/kibana/kibana:8.2.0
                  container_name: kibana
                  ports:
                    - "5601:5601"
                  volumes:
                    - /etc/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml
                  environment:
                    - ELASTICSEARCH_HOSTS=http://{{ elasticsearch_host }}:9200
          dest: /root/docker-compose-kibana.yml
          become: yes

            - name: Start Kibana service with Docker Compose
              command: docker-compose -f /root/docker-compose-kibana.yml up -d
              become: yes
            - name: Configure nftables rules
              template:
                src: nftables_kibana_rules.nft.j2
                dest: /etc/nftables.conf
              notify: restart nftables
              become: yes

        handlers:
          - name: restart nftables
            systemd:
              name: nftables
              state: restarted
            become: yes


В этом плейбуке:
Устанавливается Docker и Docker Compose.
Создается каталог для конфигурации Kibana.
Конфигурационный файл Kibana (kibana.yml) копируется в каталог /etc/kibana/.
Создается файл Docker Compose для запуска Kibana с указанием версии образа и настроек соединения с Elasticsearch.
Запускается служба Kibana с помощью Docker Compose.

Создаем: шаблон файла nftables_kibana_rules.nft.j2:

    table inet filter {
      chain input {
        type filter hook input priority 0;
        # Добавим здесь необходимые правила для разрешения доступа к Kibana порту (обычно 5601)
        tcp dport 5601 accept;     
        # Другие правила, если необходимо
      }
    }

Также создаем файл kibana.yml и поместим его в директорию с плейбуком:

    server.host: "0.0.0.0"
    elasticsearch.hosts: ["http://{{ elasticsearch_host }}:9200"]

Заменим {{ elasticsearch_host }} на IP-адрес или DNS-имя сервера Elasticsearch.



