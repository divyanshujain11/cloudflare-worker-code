resource "cloudflare_ruleset" "waf_custom" {
  zone_id     = var.zone_id
  name        = "Custom WAF rules"
  description = "Custom rules for bots, scrapers, and sensitive paths"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      ref         = "challenge_suspicious_bots"
      description = "Challenge low-score bots and obvious scrapers"
      enabled     = true
      expression  = <<EOT
        (not cf.client.bot and
        (lower(http.user_agent) contains "curl" or
        lower(http.user_agent) contains "python-requests" or
        cf.bot_management.score lt 30))
        EOT
      action = "managed_challenge"
    },
    {
      ref         = "protect_admin_login"
      description = "Challenge login/admin paths from high-risk countries"
      enabled     = true
      expression  = <<EOT
        (http.request.uri.path contains "/login" or
        http.request.uri.path contains "/admin") and
        ip.src.country in {"CN" "RU" "KP" "IR"} and
        not cf.client.bot
        EOT
      action = "managed_challenge"
    },
    {
      ref         = "block_ads_abuse"
      description = "Block abuse on /ads and /tracking endpoints"
      enabled     = true
      expression = <<EOT
        (http.request.uri.path starts_with "/ads" or
        http.request.uri.path starts_with "/tracking") and
        not cf.client.bot
        EOT
      action = "block"
    }
  ]
}