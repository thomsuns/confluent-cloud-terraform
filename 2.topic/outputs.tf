output "topic" {
    value = confluent_kafka_topic.orders.topic_name
}

output "topic_config" {
    value = confluent_kafka_topic.orders.config
}