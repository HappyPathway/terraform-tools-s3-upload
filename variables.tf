variable downloads {
  description = "List of downloads"
  type = list(object({
    name        = string
    url         = optional(string, "")
    path_prefix = optional(string, "")
    output_path = optional(string, "./downloads")
    download    = optional(bool, true)
  }))
  default = []
}

# Version variables for each tool
variable "terraform_version" {
  description = "Version of Terraform to download"
  type        = string
  default     = "1.7.5"
}

variable "terragrunt_version" {
  description = "Version of Terragrunt to download"
  type        = string
  default     = "0.53.8"
}

variable "checkov_version" {
  description = "Version of Checkov to download"
  type        = string
  default     = "2.5.6"
}

variable "trivy_version" {
  description = "Version of Trivy to download"
  type        = string
  default     = "0.45.1"
}

variable "cosign_version" {
  description = "Version of Cosign to download"
  type        = string
  default     = "2.2.2"
}

variable "nexus_iq_version" {
  description = "Version of Nexus IQ agent to download"
  type        = string
  default     = "1.170.0-01"
}

# Variable to control which platform-specific downloads to use
variable "platform" {
  description = "Platform for which to download binaries (linux or darwin)"
  type        = string
  default     = "linux"
}

variable "arch" {
  description = "Architecture for which to download binaries (amd64, arm64, etc.)"
  type        = string
  default     = "amd64"
}

variable "create_bucket" {
  description = "Whether to create the S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix"
  type        = string
  default     = "downloads-"
}

variable "tags" {
  description = "A map of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "encryption_enabled" {
  description = "Whether or not to enable bucket encryption"
  type        = bool
  default     = true
}

variable "versioning_enabled" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules to configure"
  type        = list(any)
  default     = []
}
