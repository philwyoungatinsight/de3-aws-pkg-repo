terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "${REGION}"

  # AUTH_METHOD controls how credentials are supplied:
  #   "keys"    – explicit access_key / secret_key (stored in secrets file)
  #   "profile" – named AWS CLI profile from ~/.aws/credentials
  #   ""        – default credential chain (env vars, instance profile, etc.)
  access_key = "${AUTH_METHOD}" == "keys"    ? "${ACCESS_KEY}" : null
  secret_key = "${AUTH_METHOD}" == "keys"    ? "${SECRET_KEY}" : null
  profile    = "${AUTH_METHOD}" == "profile" ? "${PROFILE}"    : null

  # Restrict operations to a specific AWS account (safety guard).
  # Set _provider_account_id in config_params to enable.
  allowed_account_ids = "${ACCOUNT_ID}" != "" ? ["${ACCOUNT_ID}"] : null
}
