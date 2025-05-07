locals {
  # Define a set of Morpheus binaries to be downloaded
  # Create a set of download configurations for each binary
  downloads = concat(
    var.downloads
  )
}

module "downloader" {
  # Iterate over each download configuration
  for_each    = tomap({ for download in local.downloads : download.name => download if download.download })
  source      = "HappyPathway/downloader/url"
  url         = each.value.url
  output_path = "${each.value.output_path}/${each.key}"
  cleanup     = false
}


resource "aws_s3_object" "morpheus_rpms" {
  for_each   = tomap({ for download in local.downloads : download.name => download })
  bucket     = module.external_dependencies.assets_bucket_name
  key        = "${each.value.path_prefix}/${each.key}"
  source     = "${each.value.output_path}/${each.key}"
  depends_on = [module.downloader]
}
