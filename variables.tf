# variables.tf
variable "cloudflare_api_token" {
  type        = string
  description = "API token with permission for Workers, Rulesets & Zone settings"
}

variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}
