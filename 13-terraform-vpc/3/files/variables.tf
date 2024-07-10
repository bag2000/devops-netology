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

variable "storage_sa_access_key" {
  type        = string
  description = "Storage service account access key"
}

variable "storage_sa_secret_key" {
  type        = string
  description = "Storage service account secret key"
}

variable "bucket_name" {
  type        = string
  default     = "my-netology-pictures"
  description = "Storage name"
}

variable "bucket_read" {
  type        = bool
  default     = true
  description = "Storage read access"
}

variable "bucket_list" {
  type        = bool
  default     = true
  description = "Storage list access"
}

variable "bucket_config_read" {
  type        = bool
  default     = true
  description = "Storage config read access"
}

variable "bucket_max_size" {
  type        = number
  default     = 104857600 # 100 mb
  description = "Storage max size bites"
}