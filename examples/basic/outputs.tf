output "bucket_id" {
  description = "ID of the created S3 bucket"
  value       = module.downloads.bucket_id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = module.downloads.bucket_arn
}

output "downloaded_files" {
  description = "Map of downloaded files"
  value       = module.downloads.downloaded_files
}