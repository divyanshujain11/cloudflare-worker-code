terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.12"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_workers_script" "s3_worker" {
  account_id  = var.account_id
  script_name = "s3-cloudflare-worker"

  content_file   = "${path.module}/../s3-cloudflare-worker/dist/worker.js"
  content_sha256 = filesha256("${path.module}/../s3-cloudflare-worker/dist/worker.js")
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
  count   = var.environment == "uat" ? 1 : 0
  zone_id = var.uat_zone_id
  pattern = var.uat_route_pattern
  script  = cloudflare_workers_script.s3_worker.script_name
}

resource "cloudflare_workers_route" "route_prod" {
  count   = var.environment == "prod" ? 1 : 0
  zone_id = var.prod_zone_id
  pattern = var.prod_route_pattern
  script  = cloudflare_workers_script.s3_worker.script_name
}

module "cache_uat" {
  source  = "./rulesets"
  count   = var.environment == "uat" ? 1 : 0
  zone_id = var.uat_zone_id
}

module "cache_prod" {
  source  = "./rulesets"
  count   = var.environment == "prod" ? 1 : 0
  zone_id = var.prod_zone_id
}
