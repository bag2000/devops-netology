###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "img_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image for boot"
}

variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk=number, core_fraction=number, preemptibl=bool, platform_id=string, serial_port=number, username=string, nat=bool}))
  default = [ {
    vm_name       = "main",
    cpu           = 2,
    ram           = 1,
    disk          = 8,
    core_fraction = 5,
    preemptibl    = true,
    platform_id   = "standard-v1",
    serial_port   = 1
    username      = "ubuntu",
    nat           = true
  },
  {
    vm_name       = "replica",
    cpu           = 4,
    ram           = 2,
    disk          = 10,
    core_fraction = 20,
    preemptibl    = true,
    platform_id   = "standard-v1",
    serial_port   = 1
    username      = "ubuntu",
    nat           = true    
  }  
   ]
}

variable "storage_name" {
  type        = string
  default     = "storage"
  description = "storage VM name"
}

variable "disk_type" {
  type        = string
  default     = "network-hdd"
  description = "disk type"
}