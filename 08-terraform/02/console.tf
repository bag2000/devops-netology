##Этот файл для 7 задания!!
locals {

  test_list = ["develop", "staging", "production"]

  test_map = {
    admin = "John"
    user  = "Alex"
  }

  servers = {
    develop = {
      cpu   = 2
      ram   = 4
      image = "ubuntu-21-10"
      disks = ["vda", "vdb"]
    },
    stage = {
      cpu   = 4
      ram   = 8
      image = "ubuntu-20-04"
      disks = ["vda", "vdb"]
    },
    production = {
      cpu   = 10
      ram   = 40
      image = "ubuntu-20-04"
      disks = ["vda", "vdb", "vdc", "vdd"]
    }
  }
  
  # Ответ на задание 7-4
  # John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks"
  answer = "${local.test_map["admin"]} is admin for production server based on OS ${local.servers["stage"]["image"]} with ${local.servers["stage"]["cpu"]} vcpu, ${local.servers["stage"]["ram"]} ram and ${length(local.servers["stage"]["disks"])} virtual disks"
}
