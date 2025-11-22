resource "cloudflare_workers_route" "app_route" {
  zone_id     = var.zone_id
  pattern     = "example.com/*"
  script_name = cloudflare_workers_script.app.script_name
}

locals {
  is_uat   = var.environment == "uat"
  zone_id  = local.is_uat ? var.uat_zone_id : var.prod_zone_id
  route    = local.is_uat ? var.uat_route_pattern : var.prod_route_pattern
  bucket   = local.is_uat ? var.uat_bucket_name : var.prod_bucket_name
}
resource "cloudflare_workers_script" "s3_worker" {
  account_id  = var.account_id
  script_name = "s3-cloudflare-worker"

  content_file   = "${path.module}/../../s3-cloudflare-worker/dist/worker.js"
  content_sha256 = filesha256("${path.module}/../../s3-cloudflare-worker/dist/worker.js")
  main_module    = "worker.js"

  compatibility_date = "2024-10-01"

  bindings = [
    {
      name = "S3_BUCKET_NAME"
      text = local.bucket
      type = "plain_text"
    },
    {
      name = "S3_REGION"
      text = var.s3_region
      type = "plain_text"
    },

    # GitLab secrets (safe)
    {
      name = "CLOUDFLARE_WORKER_AWS_ACCESS_KEY_ID"
      text = var.aws_access_key_id
      type = "secret_text"
    },
    {
      name = "CLOUDFLARE_WORKER_AWS_SECRET_ACCESS_KEY"
      text = var.aws_secret_key
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
    },
  ]
}


resource "cloudflare_workers_route" "route" {
  zone_id     = local.zone_id
  pattern     = local.route
  script_name = cloudflare_workers_script.s3_worker.script_name
}

