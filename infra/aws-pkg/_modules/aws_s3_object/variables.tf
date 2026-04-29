variable "bucket_name" {
  description = "Name of the S3 bucket where the object will be stored."
  type        = string
}

variable "object_name" {
  description = "Object key (path) within the bucket."
  type        = string
  default     = "all-config"
}

variable "content" {
  description = "Object content to upload."
  type        = string
}

variable "content_type" {
  description = "Content-Type metadata for the object."
  type        = string
  default     = "application/json"
}

# ── Storage class ─────────────────────────────────────────────────────────────

variable "storage_class" {
  description = <<-EOT
    S3 storage class for this object. AWS default is STANDARD.
    Valid values: STANDARD, REDUCED_REDUNDANCY, ONEZONE_IA, INTELLIGENT_TIERING,
                  GLACIER, DEEP_ARCHIVE, GLACIER_IR, STANDARD_IA.
  EOT
  type    = string
  default = "STANDARD"
}

# ── Tags ──────────────────────────────────────────────────────────────────────

variable "tags" {
  description = "Tags to apply to the object."
  type        = map(string)
  default     = {}
}

# ── Metadata ──────────────────────────────────────────────────────────────────

variable "metadata" {
  description = <<-EOT
    User-defined metadata stored as x-amz-meta-* HTTP headers.
    Keys and values must be ASCII. Total size of all metadata must be <= 2 KB.
    Defaults to the unit's common_tags when set via the terragrunt unit.
  EOT
  type    = map(string)
  default = {}
}

# ── Object Lock ───────────────────────────────────────────────────────────────

variable "object_lock_mode" {
  description = <<-EOT
    Object Lock retention mode. null (default) = no lock applied.
    Requires the bucket to have object_lock_enabled = true.
      GOVERNANCE  – users with special IAM permissions can override.
      COMPLIANCE  – no one (including root) can delete until the retain date.
  EOT
  type    = string
  default = null

  validation {
    condition     = var.object_lock_mode == null || contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_mode)
    error_message = "object_lock_mode must be null, \"GOVERNANCE\", or \"COMPLIANCE\"."
  }
}

variable "object_lock_retain_until_date" {
  description = <<-EOT
    RFC3339 date until which the object is locked, e.g. "2026-12-31T00:00:00Z".
    Required when object_lock_mode is set; ignored when object_lock_mode is null.
  EOT
  type    = string
  default = null
}
