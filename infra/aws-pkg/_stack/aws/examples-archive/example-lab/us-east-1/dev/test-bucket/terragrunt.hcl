include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  # unit_type: test_bucket
  source = "${include.root.locals.modules_dir}/aws_s3_bucket"
}

# ---------------------------------------------------------------------------
# Per-unit parameter overrides via <your-pkg>.yaml config_params.
# Add entries under "<your-pkg>/_stack/aws/<region>/<env>/test-bucket" to set:
#
#   bucket_name: my-project-test-bucket     # globally unique; defaults to <project_prefix>-test-bucket
#   force_destroy: true                     # allow bucket deletion even if non-empty
#   versioning_enabled: true                # default: true
#   object_lock_enabled: false              # must be set at bucket creation; default: false
#   expiration_days: 90                     # null = no expiration (default)
#   storage_class_transitions:             # default: [] (no transitions)
#     - days: 30
#       storage_class: STANDARD_IA
#     - days: 90
#       storage_class: GLACIER
# ---------------------------------------------------------------------------

locals {
  bucket_name = try(
    include.root.locals.unit_params.bucket_name,
    "${include.root.locals.unit_params.project_prefix}-${include.root.locals.p_unit}"
  )
  force_destroy             = try(include.root.locals.unit_params.force_destroy, true)
  object_lock_enabled       = try(include.root.locals.unit_params.object_lock_enabled, false)
  versioning_enabled        = try(include.root.locals.unit_params.versioning_enabled, true)
  expiration_days           = try(include.root.locals.unit_params.expiration_days, null)
  storage_class_transitions = try(include.root.locals.unit_params.storage_class_transitions, [])
  replication               = try(include.root.locals.unit_params.replication, null)
}

inputs = {
  bucket_name               = local.bucket_name
  force_destroy             = local.force_destroy
  object_lock_enabled       = local.object_lock_enabled
  versioning_enabled        = local.versioning_enabled
  expiration_days           = local.expiration_days
  storage_class_transitions = local.storage_class_transitions
  replication               = local.replication
  tags                      = include.root.locals.common_tags
}
