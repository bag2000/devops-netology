resource "yandex_kms_symmetric_key" "key-a" {
  name              = "example-symetric-key"
  description       = "description for key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

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

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "picture" {
  access_key = var.storage_sa_access_key
  secret_key = var.storage_sa_secret_key
  bucket = var.bucket_name
  key    = "smile.jpg"
  source = "./smile.jpg"
}