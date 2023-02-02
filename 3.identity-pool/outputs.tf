output "resource-ids" {
    value = <<-EOT
Identity Provider ${confluent_identity_provider.okta.display_name}
    ID:          ${confluent_identity_provider.okta.id}
    Description: ${confluent_identity_provider.okta.description}
    Issuer URI:  ${confluent_identity_provider.okta.issuer}
    JWKS URI:    ${confluent_identity_provider.okta.jwks_uri}

    Identity Pool ${confluent_identity_pool.kafka-api-read.display_name}
        ID:             ${confluent_identity_pool.kafka-api-read.id}
        Description:    ${confluent_identity_pool.kafka-api-read.description}
        Identity Claim: ${confluent_identity_pool.kafka-api-read.identity_claim}
        Filter:         ${confluent_identity_pool.kafka-api-read.filter}
    
    Identity Pool ${confluent_identity_pool.kafka-api-write.display_name}
        ID:             ${confluent_identity_pool.kafka-api-write.id}
        Description:    ${confluent_identity_pool.kafka-api-write.description}
        Identity Claim: ${confluent_identity_pool.kafka-api-write.identity_claim}
        Filter:         ${confluent_identity_pool.kafka-api-write.filter}
    
    Identity Pool ${confluent_identity_pool.kafka-cluster-admin.display_name}
        ID:             ${confluent_identity_pool.kafka-cluster-admin.id}
        Description:    ${confluent_identity_pool.kafka-cluster-admin.description}
        Identity Claim: ${confluent_identity_pool.kafka-cluster-admin.identity_claim}
        Filter:         ${confluent_identity_pool.kafka-cluster-admin.filter}

Kafka Cluster ${data.confluent_kafka_cluster.inventory.display_name}
    ID:                 ${data.confluent_kafka_cluster.inventory.id}
    Bootstrap Endpoint: ${data.confluent_kafka_cluster.inventory.bootstrap_endpoint}

Binding Roles ${confluent_role_binding.kafka-api-write-role.principal}
    CRN pattern: ${confluent_role_binding.kafka-api-write-role.crn_pattern}
    Role Name: ${confluent_role_binding.kafka-api-write-role.role_name}

Binding Roles ${confluent_role_binding.kafka-api-read-role.principal}
    CRN pattern: ${confluent_role_binding.kafka-api-read-role.crn_pattern}
    Role Name: ${confluent_role_binding.kafka-api-read-role.role_name}

Binding Roles ${confluent_role_binding.kafka-api-read-group-role.principal}
    CRN pattern: ${confluent_role_binding.kafka-api-read-group-role.crn_pattern}
    Role Name: ${confluent_role_binding.kafka-api-read-group-role.role_name}
    
Binding Roles ${confluent_role_binding.kafka-cluster-admin-role.principal}
    CRN pattern: ${confluent_role_binding.kafka-cluster-admin-role.crn_pattern}
    Role Name: ${confluent_role_binding.kafka-cluster-admin-role.role_name}

EOT
}