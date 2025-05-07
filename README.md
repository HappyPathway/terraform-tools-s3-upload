# Terraform Downloads Module

This Terraform module manages downloading various DevOps tools and optionally storing them in an S3 bucket.

## Features

- Downloads DevOps tools like Terraform, Terragrunt, Checkov, Trivy, Cosign, and Nexus-IQ agent
- Flexible configuration using a list of download objects
- Supports centralized version management using locals
- Conditionally creates S3 bucket with best practices or uses an existing bucket
- Platform and architecture agnostic

## Usage

```hcl
provider "aws" {
  region = "us-west-2"
}

locals {
  versions = {
    terraform      = "1.0.0"
    terragrunt     = "0.35.0"
    checkov        = "2.0.0"
    trivy          = "0.20.0"
    cosign         = "1.7.0"
    nexus_iq_agent = "1.0.0"
  }
}

module "downloads" {
  source = "path/to/module"

  downloads = [
    {
      name        = "terraform",
      url         = "https://releases.hashicorp.com/terraform/${local.versions.terraform}/terraform_${local.versions.terraform}_${var.platform}_${var.arch}.zip",
      path_prefix = "terraform",
      output_path = "./downloads",
      download    = true
    },
    {
      name        = "terragrunt",
      url         = "https://github.com/gruntwork-io/terragrunt/releases/download/v${local.versions.terragrunt}/terragrunt_${var.platform}_${var.arch}",
      path_prefix = "terragrunt",
      output_path = "./downloads",
      download    = true
    },
    // Add other tools as needed
  ]
  
  # Platform configuration
  platform = "linux"
  arch     = "amd64"
  
  # S3 Bucket configuration
  create_bucket = true
  bucket_prefix = "downloads-example-"
  
  tags = {
    Environment = "example"
    Project     = "DevOps-Tools"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| downloads | List of downloads to process | list(object) | [] | no |
| platform | Platform for which to download binaries (linux or darwin) | string | "linux" | no |
| arch | Architecture for which to download binaries (amd64, arm64, etc.) | string | "amd64" | no |
| create_bucket | Whether to create the S3 bucket | bool | true | no |
| bucket_name | Name of the S3 bucket to create | string | null | no |
| bucket_prefix | Creates a unique bucket name beginning with the specified prefix | string | "downloads-" | no |
| tags | A map of tags to assign to the bucket | map(string) | {} | no |
| force_destroy | Whether all objects should be deleted from the bucket for clean destroy | bool | false | no |
| encryption_enabled | Whether bucket encryption should be enabled | bool | true | no |
| versioning_enabled | Whether bucket versioning should be enabled | bool | true | no |
| lifecycle_rules | List of lifecycle rules to configure | list(any) | [] | no |

## Download Object Structure

Each download object in the `downloads` list supports the following attributes:

| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| name | Name of the download (required) | string | - |
| url | URL to download from | string | "" |
| path_prefix | Prefix for the S3 object key | string | "" |
| output_path | Local path where downloads are stored | string | "./downloads" |
| download | Whether to download this item | bool | true |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | ID of the created S3 bucket |
| bucket_arn | ARN of the created S3 bucket |
| downloaded_files | Map of downloaded files |

## Example: Centralized Version Management

We recommend using a local variable for version management:

```hcl
locals {
  versions = {
    terraform      = "1.7.5"
    terragrunt     = "0.53.8"
    checkov        = "2.5.6"
    trivy          = "0.45.1"
    cosign         = "2.2.2"
    nexus_iq_agent = "1.170.0-01"
  }
}
```

## License

MIT