resource "minio_s3_bucket" "tfstate" {
  bucket         = "yourname-${var.project}-tfstate"
  acl            = "private"
  object_locking = false
}

