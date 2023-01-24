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

resource "confluent_identity_pool" "kafka-api-read" {
  identity_provider {
    id = confluent_identity_provider.okta.id
  }

  display_name   = "Kafka API Read"
  description    = "Okta User with kafkaAPIRead scope"
  identity_claim = "claims.sub"
  filter = "claims.aud=='radius-kafka-api' && 'kafkaAPIRead' in claims.scp"
}

resource "confluent_identity_pool" "kafka-api-write" {
  identity_provider {
    id = confluent_identity_provider.okta.id
  }

  display_name   = "Kafka API Write"
  description    = "Okta User with kafkaAPIWrite scope"
  identity_claim = "claims.sub"
  filter = "claims.aud=='radius-kafka-api' && 'kafkaAPIWrite' in claims.scp"
}

resource "confluent_identity_pool" "kafka-cluster-admin" {
  identity_provider {
    id = confluent_identity_provider.okta.id
  }

  display_name   = "Kafka Cluster Admin"
  description    = "Okta User with kafkaClusterAdmin scope"
  identity_claim = "claims.sub"
  filter = "claims.aud=='radius-kafka-api' && 'kafkaClusterAdmin' in claims.scp"
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
  principal = "User:${confluent_identity_pool.kafka-api-write.id}"
  role_name = "DeveloperWrite"
  crn_pattern = "${data.confluent_kafka_cluster.inventory.rbac_crn}/kafka=${data.confluent_kafka_cluster.inventory.id}/topic=orders"
}

resource "confluent_role_binding" "kafka-api-read-role" {
  principal = "User:${confluent_identity_pool.kafka-api-read.id}"
  role_name = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.inventory.rbac_crn}/kafka=${data.confluent_kafka_cluster.inventory.id}/topic=orders"
}

resource "confluent_role_binding" "kafka-api-read-group-role" {
  principal = "User:${confluent_identity_pool.kafka-api-read.id}"
  role_name = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.inventory.rbac_crn}/kafka=${data.confluent_kafka_cluster.inventory.id}/group=thomsuns-consumer-group*"
}

resource "confluent_role_binding" "kafka-cluster-admin-role" {
  principal = "User:${confluent_identity_pool.kafka-cluster-admin.id}"
  role_name = "CloudClusterAdmin"
  crn_pattern = "${data.confluent_kafka_cluster.inventory.rbac_crn}"
}

