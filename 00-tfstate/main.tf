resource "minio_s3_bucket" "tfstate" {
  bucket         = "yourname-${var.projectname}-tfstate"
  acl            = "private"
  object_locking = false
}

