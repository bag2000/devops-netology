# General
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

variable "zone_a" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "netology_vpc"
  description = "VPC network name"
}

variable "img_id" {
  type        = string
  default     = "fd8a28k7fnc9u68s45g5"
  description = "image for boot"
}

variable "preemptible" {
  type        = bool
  default     = true
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance"
}

variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

variable "vms_ssh_root_key_path" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

variable "vms_resources" {
    type = map(map(string))
    default = {
        public  = {
            cpu           = 2
            memory        = 1
            core_fraction = 5
        },
        private  = {
            cpu           = 2
            memory        = 1
            core_fraction = 5
        },
        meta = {
            serial_port_enable = 1
            username           = "ubuntu"
        }
    }
    description = "number of CPU cores, memory in gigabytes, performance for a core as a percent and metadata"
}

# Public
variable "public_subnet_name" {
  type        = string
  default     = "public_subnet"
  description = "VPC network name"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "public_vm_name" {
  type        = string
  default     = "public-vm"
  description = "Name puplic vm"
}

variable "public_vm_nat" {
  type        = bool
  default     = true
  description = "provide a public address, for instance, to access the internet over NAT"
}

variable "public_vm_ip" {
  type        = string
  default     = "192.168.10.254"
  description = "provide a public ip address"
}

# Private
variable "private_subnet_name" {
  type        = string
  default     = "private_subnet"
  description = "VPC network name"
}

variable "private_egress_gw_name" {
  type        = string
  default     = "private-eg-gw"
  description = "Gateway network name"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_vm_name" {
  type        = string
  default     = "private-vm"
  description = "Name puplic vm"
}

variable "private_vm_nat" {
  type        = bool
  default     = false
  description = "provide a public address, for instance, to access the internet over NAT"
}

# variable "private_vm_ip" {
#   type        = string
#   default     = "192.168.10.254"
#   description = "provide a public ip address"
# }