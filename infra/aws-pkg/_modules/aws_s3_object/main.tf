resource "aws_s3_object" "this" {
  bucket        = var.bucket_name
  key           = var.object_name
  content       = var.content
  content_type  = var.content_type
  storage_class = var.storage_class
  tags          = var.tags
  metadata      = var.metadata

  object_lock_mode              = var.object_lock_mode
  object_lock_retain_until_date = var.object_lock_retain_until_date
}
