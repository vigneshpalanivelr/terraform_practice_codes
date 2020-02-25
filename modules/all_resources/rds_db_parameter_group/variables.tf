# variable "enabled" {}
variable "identifier" {}
variable "description" {}
variable "family" {}
variable "tags" { type = "map" }
variable "parameter" { default = [] }
