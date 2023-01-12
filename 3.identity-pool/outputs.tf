output "resource-ids" {
    value = <<-EOT
Identity Provider ${confluent_identity_provider.okta.display_name}
    ID:          ${confluent_identity_provider.okta.id}
    Description: ${confluent_identity_provider.okta.description}
    Issuer URI:  ${confluent_identity_provider.okta.issuer}
    JWKS URI:    ${confluent_identity_provider.okta.jwks_uri}

    Identity Pool ${confluent_identity_pool.kafka-api.display_name}
        ID:             ${confluent_identity_pool.kafka-api.id}
        Description:    ${confluent_identity_pool.kafka-api.description}
        Identity Claim: ${confluent_identity_pool.kafka-api.identity_claim}
        Filter:         ${confluent_identity_pool.kafka-api.filter}

    Binding Roles ${confluent_role_binding.kafka-api-write-role.principal}
        CRN pattern: ${confluent_role_binding.kafka-api-write-role.crn_pattern}
        Role Name: ${confluent_role_binding.kafka-api-write-role.role_name}
    
    Binding Roles ${confluent_role_binding.kafka-api-read-role.principal}
        CRN pattern: ${confluent_role_binding.kafka-api-read-role.crn_pattern}
        Role Name: ${confluent_role_binding.kafka-api-read-role.role_name}

    Binding Roles ${confluent_role_binding.kafka-api-read-group-role.principal}
        CRN pattern: ${confluent_role_binding.kafka-api-read-group-role.crn_pattern}
        Role Name: ${confluent_role_binding.kafka-api-read-group-role.role_name}

EOT
}