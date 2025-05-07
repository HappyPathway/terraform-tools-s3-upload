provider "aws" {
  region = "us-west-2"
}

locals {
  platform = "linux"
  arch     = "amd64"
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
  source = "../.."

  downloads = [
    {
      name        = "terraform",
      url         = "https://releases.hashicorp.com/terraform/${local.versions.terraform}/terraform_${local.versions.terraform}_${local.platform}_${local.arch}.zip",
      path_prefix = "terraform",
      output_path = "./downloads",
      download    = true
    },
    {
      name        = "terragrunt",
      url         = "https://github.com/gruntwork-io/terragrunt/releases/download/v${local.versions.terragrunt}/terragrunt_${local.platform}_${local.arch}",
      path_prefix = "terragrunt",
      output_path = "./downloads",
      download    = true
    },
    {
      name        = "checkov",
      url         = "https://github.com/bridgecrewio/checkov/archive/refs/tags/${local.versions.checkov}.zip",
      path_prefix = "checkov",
      output_path = "./downloads",
      download    = true
    },
    {
      name        = "trivy",
      url         = "https://github.com/aquasecurity/trivy/releases/download/v${local.versions.trivy}/trivy_${local.versions.trivy}_${local.platform}-${local.arch}.tar.gz",
      path_prefix = "trivy",
      output_path = "./downloads",
      download    = true
    },
    {
      name        = "cosign",
      url         = "https://github.com/sigstore/cosign/releases/download/v${local.versions.cosign}/cosign-${local.platform}-${local.arch}",
      path_prefix = "cosign",
      output_path = "./downloads",
      download    = true
    },
    {
      name        = "nexus-iq-agent",
      url         = "https://download.sonatype.com/clm/iq-server/nexus-iq-cli-${local.versions.nexus_iq_agent}.jar",
      path_prefix = "nexus-iq-agent",
      output_path = "./downloads",
      download    = true
    }
  ]

  # S3 Bucket configuration
  create_bucket = true
  bucket_name   = "example-downloads-bucket"
  bucket_prefix = "downloads-example-"

  tags = {
    Environment = "example"
    Project     = "DevOps-Tools"
  }
}