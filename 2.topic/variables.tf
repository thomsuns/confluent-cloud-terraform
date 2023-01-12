variable "kafka_id" {
  description = "Kafka cluster ID"
  type = string
}

variable "kafka_rest_endpoint" {
  description = "Kafka cluster's REST endpoint"
}

variable "kafka_api_key" {
  description = "Kafka API Key to manage the cluster"
  type        = string
  sensitive   = true
}

variable "kafka_api_secret" {
  description = "Kafka API Secret"
  type        = string
  sensitive   = true
}