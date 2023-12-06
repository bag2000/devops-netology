variable "vms_resources" {
    type = map(map(string))
    default = {
        web  = {
            cpu           = 2
            memory        = 1
            core_fraction = 5
        },
        db   = {
            cpu           = 2
            memory        = 2
            core_fraction = 20
        }
        meta = {
            serial_port_enable = 1
            username           = "ubuntu"
        }
    }
    description = "number of CPU cores, memory in gigabytes, performance for a core as a percent and metadata"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "type of virtual machine to create"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "specifies if the instance is preemptible"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "provide a public address, for instance, to access the internet over NAT"
}



variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "type of virtual machine to create"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "specifies if the instance is preemptible"
}

variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "provide a public address, for instance, to access the internet over NAT"
}