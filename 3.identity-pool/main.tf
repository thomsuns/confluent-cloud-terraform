terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.24.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

resource "confluent_identity_provider" "okta" {
  display_name = var.okta_display_name
  description  = var.okta_description
  issuer       = var.okta_issuer_uri
  jwks_uri     = var.okta_jwks_uri
}

resource "confluent_identity_pool" "kafka-api" {
  identity_provider {
    id = confluent_identity_provider.okta.id
  }

  display_name   = "Kafka API"
  description    = "Kafka API Okta User"
  identity_claim = "claims.sub"
  filter = "claims.aud=='radius-kafka-api' && 'kafkaAPIRead' in claims.scp"
}

data "confluent_environment" "staging" {
  display_name = "Staging"
}

data "confluent_kafka_cluster" "inventory" {
  environment {
    id = data.confluent_environment.staging.id
  }  
  display_name = "inventory"
}

resource "confluent_role_binding" "kafka-api-write-role" {
  principal = "User:${confluent_identity_pool.kafka-api.id}"
  role_name = "DeveloperWrite"
  crn_pattern = "${data.confluent_kafka_cluster.inventory.rbac_crn}/kafka=${data.confluent_kafka_cluster.inventory.id}/topic=orders"
}

resource "confluent_role_binding" "kafka-api-read-role" {
  principal = "User:${confluent_identity_pool.kafka-api.id}"
  role_name = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.inventory.rbac_crn}/kafka=${data.confluent_kafka_cluster.inventory.id}/topic=orders"
}

resource "confluent_role_binding" "kafka-api-read-group-role" {
  principal = "User:${confluent_identity_pool.kafka-api.id}"
  role_name = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.inventory.rbac_crn}/kafka=${data.confluent_kafka_cluster.inventory.id}/group=thomsuns-consumer-group*"
}
