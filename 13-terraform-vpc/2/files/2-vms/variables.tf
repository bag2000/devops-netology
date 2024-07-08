# General
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "service_account_id" {
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

variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

variable "vpc_name" {
  type        = string
  default     = "netology_vpc"
  description = "VPC network name"
}

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

variable "vms_resources_cores" {
  type        = number
  default     = 2
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance_group"
}

variable "vms_resources_memory" {
  type        = number
  default     = 2
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance_group"
}

variable "vms_boot_disk_mode" {
  type        = string
  default     = "READ_WRITE"
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance_group"
}

variable "vms_boot_disk_img_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance_group"
}

variable "preemptible" {
  type        = bool
  default     = true
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance"
}

variable "vms_username" {
  type        = string
  default     = "ubuntu"
  description = "Username"
}

variable "network_settings" {
  type        = string
  default     = "STANDARD"
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance_group"
}

variable "scale_policy" {
  type        = number
  default     = 2
  description = "https://terraform-provider.yandexcloud.net/Resources/compute_instance_group"
}