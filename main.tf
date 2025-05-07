# terraform, terragrunt, checkov, trivy, cosign, nexus-iq agent
# might need the nexus-iq agent, not sure yet

locals {
  # Define a set of binaries to be downloaded
  # Create a set of download configurations for each binary

  # Local variable to reference the appropriate bucket ID based on whether we're creating or using an existing bucket
  s3_bucket = var.create_bucket ? aws_s3_bucket.downloads_bucket[0].id : data.aws_s3_bucket.existing_bucket[0].id
}

# Data source to look up an existing bucket when create_bucket is false
data "aws_s3_bucket" "existing_bucket" {
  count  = var.create_bucket ? 0 : 1
  bucket = var.bucket_name
}

module "downloader" {
  # Iterate over each download configuration
  for_each    = tomap({ for download in var.downloads : download.name => download if download.download })
  source      = "HappyPathway/downloader/url"
  url         = each.value.url
  output_path = "${each.value.output_path}/${each.key}"
  cleanup     = false
}

# Conditionally create an S3 bucket with best practices
resource "aws_s3_bucket" "downloads_bucket" {
  count = var.create_bucket ? 1 : 0

  # Use provided bucket name or generate one with prefix
  bucket        = var.bucket_name != null ? var.bucket_name : null
  bucket_prefix = var.bucket_name == null ? var.bucket_prefix : null

  force_destroy = var.force_destroy
  tags          = var.tags
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "downloads_bucket" {
  count  = var.create_bucket && var.encryption_enabled ? 1 : 0
  bucket = aws_s3_bucket.downloads_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning for better data protection
resource "aws_s3_bucket_versioning" "downloads_bucket" {
  count  = var.create_bucket && var.versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.downloads_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

# Public access block for security
resource "aws_s3_bucket_public_access_block" "downloads_bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.downloads_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Apply lifecycle rules if provided
resource "aws_s3_bucket_lifecycle_configuration" "downloads_bucket" {
  count  = var.create_bucket && length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.downloads_bucket[0].id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.status, "Enabled")

      dynamic "expiration" {
        for_each = try(rule.value.expiration, null) != null ? [rule.value.expiration] : []
        content {
          days = try(expiration.value.days, null)
        }
      }

      dynamic "transition" {
        for_each = try(rule.value.transition, [])
        content {
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}

# Upload the downloaded files to the S3 bucket (using local.s3_bucket)
resource "aws_s3_object" "downloads" {
  for_each = tomap({ for download in local.downloads : download.name => download })

  bucket     = local.s3_bucket
  key        = "${each.value.path_prefix}/${each.key}"
  source     = "${each.value.output_path}/${each.key}"
  depends_on = [module.downloader]
}
