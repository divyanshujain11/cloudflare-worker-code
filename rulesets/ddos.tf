resource "cloudflare_ruleset" "http_ddos" {
  zone_id     = var.zone_id
  name        = "HTTP DDoS Protection - Terraform managed"
  description = "Overrides for Cloudflare L7 DDoS managed ruleset"
  kind        = "zone"
  phase       = "ddos_l7"

  rules = [
    {
      ref         = "ddos_l7_default_override"
      description = "Zone-wide DDoS overrides"
      expression  = "true"
      action      = "execute"
      action_parameters = {
        id = "4d21379b4f9f4bb088e0729962c8b3cf"
        overrides = {
          action            = "block"
          sensitivity_level = "default"
        }
      }
      enabled = true
    }
  ]
}