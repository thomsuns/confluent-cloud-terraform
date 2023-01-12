terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.24.0"
    }
  }
}

provider "confluent" {
  # cloud_api_key    = var.confluent_cloud_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  # cloud_api_secret = var.confluent_cloud_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var

  kafka_id            = var.kafka_id            # optionally use KAFKA_ID env var
  kafka_rest_endpoint = var.kafka_rest_endpoint # optionally use KAFKA_REST_ENDPOINT env var
  kafka_api_key       = var.kafka_api_key       # optionally use KAFKA_API_KEY env var
  kafka_api_secret    = var.kafka_api_secret    # optionally use KAFKA_API_SECRET env var
}

resource "confluent_kafka_topic" "orders" {
  topic_name       = "orders"
  partitions_count = 6
  config = {
    "max.message.bytes" = 1048588
  }
}
