# variables.tf
#
variable "name" {
  type = "string"
  description = "Resource group name"
}

variable "location" {
  type = "string"
  description = "Resource group location"
  default = "Australia Southeast"
}

variable "tags" {
  type = "map"
  description = "Tags for resource group"
}