resource "minio_s3_bucket" "tfstate" {
  bucket         = "yourname-${var.projektname}-tfstate"
  acl            = "private"
  object_locking = false
}

