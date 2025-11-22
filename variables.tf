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
variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS access key for worker"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for worker"
  type        = string
  sensitive   = true
}

variable "basic_auth_username" {
  description = "Basic auth username"
  type        = string
  sensitive   = true
}

variable "basic_auth_password" {
  description = "Basic auth password"
  type        = string
  sensitive   = true
}

variable "worker_version" {
  description = "Version tag/commit SHA for worker"
  type        = string
}

variable "api_origin" {
  description = "Origin URL your worker calls"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token for provider authentication"
  type        = string
  sensitive   = true
}

variable "zone_id" {
  description = "Zone ID to apply rulesets"
  type        = string
}
