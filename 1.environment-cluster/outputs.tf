output "resource-ids" {
    value = <<-EOT
Environment: ${confluent_environment.staging.display_name}
    ID: "${confluent_environment.staging.id}"

    Kafka Cluster: ${confluent_kafka_cluster.standard.display_name}
        ID:            "${confluent_kafka_cluster.standard.id}"
        REST endpoint: "${confluent_kafka_cluster.standard.rest_endpoint}"

Service Accounts: ${confluent_service_account.app-manager.display_name}
    ID:         "${confluent_service_account.app-manager.id}"
    API Key:    "${confluent_api_key.app-manager-kafka-api-key.id}"
    API Secret: "${confluent_api_key.app-manager-kafka-api-key.secret}"
  
 EOT
     sensitive = true
 }