# confluent-cloud-terraform

## Overview
A project to explore how to use terraform to manage Confluent Cloud infrastructure. 

## Prerequisite

### Confluent Cloud account
I signed up for free account for testing at the moment. There is $400 credit to get started and you can find more promo code around the internet.

### Cloud API Key with necessary permission

The recommended set up is
- Create a service account with `OrganizationAdmin` role
- Create API key for the account by choosing 'Granular access' so we can associate API key with an account

This cloud API Key can be used by terraform to manage Environments, Clusters, Accounts, and Roles.

### Passing API key to terraform
API key can be passed to terraform as variables to `confluent` provider as following
```
provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = var.confluent_cloud_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var
}
```
And, we can pass these values via CLI, other resources, or `terraform.tfvars`/`.auto.tfvars`

Or, set them as environment variables like this
```
$ export CONFLUENT_CLOUD_API_KEY="<API Key>"
$ export CONFLUENT_CLOUD_API_SECRET="<API Secret>"
```
Then, we can leave out the key/secret in terraform like this
```
provider "confluent" {
}
```

## What it does?

### 1. `environment-cluster`
This is the starting point where the environment and cluster are created.

It starts from creating 
- Environment `Staging`
- Cluster `inventory`
- Service Account `app-manager`

Then, assigning the role `CloudClusterAdmin` to `app-manager` and create an API key associated with this account. This API key will be used in terraform that managing cluster level such as topic creation.

Since the API key is hidden and can't be seen in the UI, to give the key to the owner of `app-manager`, it needs to print from terraform command. After applying the change sucessfully, run the following command
```
$ terraform output resource-ids
```
Take note of the cluster ID, REST endpoint, API key, and API secret for later use.

### 2. `topic`
This terraform code is to create topic `orders` in the cluster `inventory` created earlier.

It needs API key from `app-manager` who has `CloudClusterAdmin` role because surprisingly `OrganizationAdmin` doens't have permission to manage the cluster.

Similar to Cloud API key, the Kafka API key and necessary variables can be passed as variables to `confluent` provider or as environment variables
```
provider "confluent" {
  kafka_id            = var.kafka_id            # optionally use KAFKA_ID env var
  kafka_rest_endpoint = var.kafka_rest_endpoint # optionally use KAFKA_REST_ENDPOINT env var
  kafka_api_key       = var.kafka_api_key       # optionally use KAFKA_API_KEY env var
  kafka_api_secret    = var.kafka_api_secret    # optionally use KAFKA_API_SECRET env var
}
```
By this way, the terraform code will manage only 1 cluster. 

These variables can be passed directly to `confluent_kafka_topic` so the terraform code can manage multiple cluster in the same code.
```
resource "confluent_kafka_topic" "orders" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name         = "orders"
  rest_endpoint      = confluent_kafka_cluster.basic-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}
```

Please note that using only Kafka API key with `CloudClusterAdmin` is enough to manage the cluster, no Cloud API from `OrganizationAdmin` role.

### 3. `identity-pool`
This terraform code is to set up Okta as one of the identity provider for Confluent Cloud. We can create multiple identity pools based on filter and assign role to each pool.

In this example, it creates an identity provider via the following variables
```
resource "confluent_identity_provider" "okta" {
  display_name = var.okta_display_name
  description  = var.okta_description
  issuer       = var.okta_issuer_uri
  jwks_uri     = var.okta_jwks_uri
}
```
Confluent needs to know mainly the issuer and jwks URI so it can authenticate with Okta server

For identity pool, `Kafka API` is created for any user who has `radius-kafka-api` as `audience` and has scope `kafkaAPIRead`. Then, it's assigned a few roles to be able to read and write `orders` topic

## Reference
- [Confluent Terraform Provider Documentation](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs)
- [Confluent Terraform Provider GitHub](https://github.com/confluentinc/terraform-provider-confluent)
    - [Examples](https://github.com/confluentinc/terraform-provider-confluent/tree/master/examples/configurations)
- 