resource "cloudflare_workers_script" "s3_worker" {
  account_id  = var.account_id
  script_name = "s3-cloudflare-worker"

  # Use the compiled JS file from your build step
  content_file   = "${path.module}/../../s3-cloudflare-worker/dist/worker.js"
  content_sha256 = filesha256("${path.module}/../../s3-cloudflare-worker/dist/worker.js")
  main_module    = "worker.js"
  compatibility_date = "2024-11-01"

  # Bind environment variables and secrets.
  # Plain text variables (exposed in code):
  bindings = [
    {
      name = "WORKER_VERSION"
      text = var.worker_version     
      type = "plain_text"
    },
    {
      name = "API_ORIGIN"
      text = var.api_origin          
      type = "plain_text"
    },
    {
      name = "CLOUDFLARE_WORKER_AWS_ACCESS_KEY_ID"
      text = var.cf_worker_aws_access_key_id
      type = "secret_text"           
    },
    {
      name = "CLOUDFLARE_WORKER_AWS_SECRET_ACCESS_KEY"
      text = var.cf_worker_aws_secret_access_key
      type = "secret_text"
    },
    {
      name = "BASIC_AUTH_USERNAME"
      text = var.basic_auth_username
      type = "secret_text"
    },
    {
      name = "BASIC_AUTH_PASSWORD"
      text = var.basic_auth_password
      type = "secret_text"
    }
  ]
}

resource "cloudflare_workers_route" "s3_route" {
  zone_id     = var.zone_id
  pattern     = "example.com/*"          
  script_name = cloudflare_workers_script.s3_worker.script_name
}
