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
