resource "yandex_storage_bucket" "my-netology-pictures" {
  access_key = var.storage_sa_access_key
  secret_key = var.storage_sa_secret_key
  bucket     = var.bucket_name
  anonymous_access_flags {
    read = var.bucket_read
    list = var.bucket_list
    config_read = var.bucket_config_read
  }
  max_size = var.bucket_max_size
}

resource "yandex_storage_object" "picture" {
  access_key = var.storage_sa_access_key
  secret_key = var.storage_sa_secret_key
  bucket = var.bucket_name
  key    = "smile.jpg"
  source = "./smile.jpg"
}