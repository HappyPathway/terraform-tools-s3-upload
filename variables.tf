
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
