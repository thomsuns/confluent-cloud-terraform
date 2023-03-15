output "environment_info" {
  value = <<-EOT

Environment: ${confluent_environment.staging.display_name}
    ID: "${confluent_environment.staging.id}"

    Kafka Cluster: ${confluent_kafka_cluster.standard.display_name}
        ID:            "${confluent_kafka_cluster.standard.id}"
        REST endpoint: "${confluent_kafka_cluster.standard.rest_endpoint}"

Schema Registry: ${confluent_schema_registry_cluster.essentials.display_name}
    ID:            ${confluent_schema_registry_cluster.essentials.id}
    REST Endpoint: ${confluent_schema_registry_cluster.essentials.rest_endpoint}
    Resource Name: ${confluent_schema_registry_cluster.essentials.resource_name}

EOT
}

output "app_manager_info" {
  value     = <<-EOT

Service Accounts: ${confluent_service_account.app-manager.display_name}
    ID:         "${confluent_service_account.app-manager.id}"
    API Key:    "${confluent_api_key.app-manager-kafka-api-key.id}"
    API Secret: "${confluent_api_key.app-manager-kafka-api-key.secret}"

 EOT
  sensitive = true
}
