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
  default     = "example-downloads-bucket"
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix"
  type        = string
  default     = "downloads-example-"
}

variable "tags" {
  description = "A map of tags to assign to the bucket"
  type        = map(string)
  default     = {
    Environment = "example"
    Project     = "DevOps-Tools"
  }
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