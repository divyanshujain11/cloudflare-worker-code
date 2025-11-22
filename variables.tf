variable "environment" {
  type    = string
  default = "uat"
}

variable "uat_zone_id" {
  type    = string
  default = "a883d7a2b16b60376389450461b2364f"
}

variable "prod_zone_id" {
  type    = string
  default = "a883d7a2b16b60376389450461b2364f"
}

variable "uat_route_pattern" {
  type    = string
  default = "uat-app.hayloarc.com/*"
}

variable "prod_route_pattern" {
  type    = string
  default = "app.hayloarc.com/*"
}

variable "uat_bucket_name" {
  type = string
  default = "uat-app.hayloarc.com"
}

variable "prod_bucket_name" {
  type = string
  default = "app.hayloarc.com"
}

variable "s3_region" {
  type    = string
  default = "us-east-1"
}
