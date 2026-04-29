variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "force_destroy" {
  description = "Delete all objects when the bucket is destroyed (useful for ephemeral test buckets)."
  type        = bool
  default     = true
}

variable "object_lock_enabled" {
  description = <<-EOT
    Enable S3 Object Lock on the bucket. Must be set at creation time; cannot be changed later.
    Required if any objects in the bucket will use object_lock_mode.
  EOT
  type    = bool
  default = false
}

# ── Versioning ────────────────────────────────────────────────────────────────

variable "versioning_enabled" {
  description = "Enable S3 versioning on the bucket. Required for replication and object lock."
  type        = bool
  default     = true
}

# ── Tags ──────────────────────────────────────────────────────────────────────

variable "tags" {
  description = "Tags to apply to the bucket."
  type        = map(string)
  default     = {}
}

# ── Lifecycle – expiration ────────────────────────────────────────────────────

variable "expiration_days" {
  description = <<-EOT
    Delete current-version objects this many days after creation.
    null (default) = no expiration rule applied.
  EOT
  type    = number
  default = null
}

# ── Lifecycle – storage class transitions ────────────────────────────────────

variable "storage_class_transitions" {
  description = <<-EOT
    Lifecycle transitions for current-version objects.
    Each entry moves objects to storage_class after the given number of days.

    Common storage_class values:
      STANDARD_IA      – infrequent access (>= 30 days)
      ONEZONE_IA       – single-AZ infrequent access (>= 30 days)
      INTELLIGENT_TIERING
      GLACIER_IR       – Glacier Instant Retrieval (>= 90 days)
      GLACIER          – Glacier Flexible Retrieval (>= 90 days)
      DEEP_ARCHIVE     – Glacier Deep Archive (>= 180 days)
  EOT
  type = list(object({
    days          = number
    storage_class = string
  }))
  default = []
}

# ── Replication ───────────────────────────────────────────────────────────────

variable "replication" {
  description = <<-EOT
    S3 Cross-Region (or Same-Region) Replication configuration.
    null (default) = replication disabled.

    role_arn           – IAM role ARN with s3:ReplicateObject permissions.
    destination_bucket – ARN of the destination bucket (must have versioning enabled).
    storage_class      – Storage class to use in the destination (default: STANDARD).
  EOT
  type = object({
    role_arn           = string
    destination_bucket = string
    storage_class      = optional(string, "STANDARD")
  })
  default = null
}
