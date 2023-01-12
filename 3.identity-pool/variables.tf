variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "okta_display_name" {
  description = "Display name of the Okta identity provider"
  type = string
}

variable "okta_description" {
  description = "Description of the Okta identity provider"
  type = string
}

variable "okta_issuer_uri" {
  description = "Issuer URI of the Okta identity provider"
  type = string
}

variable "okta_jwks_uri" {
  description = "JWKS URI of the Okta identity provider"
  type = string
}
