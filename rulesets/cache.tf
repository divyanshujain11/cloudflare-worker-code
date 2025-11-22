resource "cloudflare_ruleset" "cache_rules" {
  zone_id     = var.zone_id
  name        = "App cache rules"
  description = "Cache settings for HTML and static assets"
  kind        = "zone"
  phase       = "http_request_cache_settings"

  rules = [
    {
      ref         = "cache_static_assets"
      description = "Cache CSS/JS/images/SVG/XML/fonts aggressively"
      enabled     = true
      expression  = <<EOT
        http.request.uri.path matches "(?i).*\.(css|js|png|jpg|jpeg|gif|svg|ico|xml|woff2)$"
        EOT
      action              = "set_cache_settings"
      action_parameters = {
        edge_ttl = {
          mode    = "override_origin"
          default = 86400
        }
        browser_ttl = {
          mode    = "override_origin"
          default = 14400
        }
        serve_stale = {
          disable_stale_while_updating = false
        }
        respect_strong_etags = true
      }
    },
    {
      ref        = "cache_html_dynamic"
      description = "Keep HTML mostly fresh"
      enabled    = true
      expression = <<EOT
        not (http.request.uri.path matches "(?i).*\.(css|js|png|jpg|jpeg|gif|svg|ico|xml|woff2)$")
        EOT
      action              = "set_cache_settings"
      action_parameters = {
        edge_ttl = {
          mode    = "override_origin"
          default = 120
        }
        browser_ttl = {
          mode = "respect_origin"
        }
        origin_error_page_passthru = false
      }
    }
  ]
}










