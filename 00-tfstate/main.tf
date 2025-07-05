resource "minio_s3_bucket" "tfstate" {
  bucket         = "${var.bucket_prefix}-${var.project}-tfstate"
  acl            = "private"
  object_locking = false
}

