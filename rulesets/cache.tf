resource "cloudflare_ruleset" "cache_rules" {
  zone_id     = var.zone_id
  name        = "App cache rules"
  description = "Cache settings for HTML and static assets"
  kind        = "zone"
  phase       = "http_request_cache_settings"

  # Rule 1: Static assets – aggressive cache
  rules {
    ref         = "cache_static_assets"
    description = "Cache CSS/JS/images/SVG/XML/fonts aggressively"
    enabled     = true

    # Match file extensions (case insensitive)
    expression = <<EOT
http.request.uri.path matches "(?i).*\.(css|js|png|jpg|jpeg|gif|svg|ico|xml|woff2)$"
EOT

    action = "set_cache_settings"

    action_parameters {
      # Cache at Cloudflare edge for 1 day
      edge_ttl {
        mode    = "override_origin"
        default = 86400 # 24h
      }

      # Let browser cache for 4 hours (or set to respect_origin)
      browser_ttl {
        mode   = "override"
        default = 14400 # 4h
      }

      # Good practice extras
      serve_stale {
        disable_stale_while_updating = false
      }
      respect_strong_etags = true
    }
  }

  # Rule 2: HTML / dynamic – low cache, focus on freshness
  rules {
    ref         = "cache_html_dynamic"
    description = "Keep HTML mostly fresh, minimal edge caching"
    enabled     = true

    # Match everything that is NOT static asset extension
    expression = <<EOT
not (http.request.uri.path matches "(?i).*\.(css|js|png|jpg|jpeg|gif|svg|ico|xml|woff2)$")
EOT

    action = "set_cache_settings"

    action_parameters {
      edge_ttl {
        # Either very low or bypass cache; here, small edge cache:
        mode    = "override_origin"
        default = 120 # 2 minutes
      }

      browser_ttl {
        # Browsers will respect origin headers (or you can override to a small value)
        mode = "respect_origin"
      }

      origin_error_page_passthru = false
    }
  }
}
