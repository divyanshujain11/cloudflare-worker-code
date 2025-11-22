resource "cloudflare_workers_route" "app_route" {
  zone_id     = var.zone_id
  pattern     = "example.com/*"
  script_name = cloudflare_workers_script.app.script_name
}
