variable "count_srvs" {
  description = "Количество серверов"
  type        = string
  default     = "1"
}

variable "srv_cores" {
  description = "Количество ядер процессора"
  type        = string
  default     = "2"
}

variable "srv_memory" {
  description = "Доступная оперативная память"
  type        = string
  default     = "2"
}

variable "cloud_zone" {
  description = "Зона облака"
  type        = string
  default     = "ru-central1-a"
}

variable "os_id" {
  description = "ID образа ОС"
  type        = string
  default     = "fd8nru7hnggqhs9mkqps"
}

variable "allow_ports" {
  description = "Список открытых портов для сервера"
  type        = list
  default     = ["22"]
}