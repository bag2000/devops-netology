locals {
  web_name = "netology-develop-platform-web-c${var.vms_resources["web"]["cpu"]}-m${var.vms_resources["web"]["memory"]}-f${var.vms_resources["web"]["core_fraction"]}-p${var.vm_web_preemptible}"
  db_name  = "netology-develop-platform-db-c${var.vms_resources["db"]["cpu"]}-m${var.vms_resources["db"]["memory"]}-f${var.vms_resources["db"]["core_fraction"]}-p${var.vm_db_preemptible}"
}
