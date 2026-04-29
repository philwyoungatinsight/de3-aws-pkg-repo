resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = (var.expiration_days != null || length(var.storage_class_transitions) > 0) ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "managed-lifecycle"
    status = "Enabled"

    filter {}

    dynamic "expiration" {
      for_each = var.expiration_days != null ? [var.expiration_days] : []
      content {
        days = expiration.value
      }
    }

    dynamic "transition" {
      for_each = var.storage_class_transitions
      content {
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "this" {
  count  = var.replication != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  role   = var.replication.role_arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    filter {}

    destination {
      bucket        = var.replication.destination_bucket
      storage_class = var.replication.storage_class
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}
