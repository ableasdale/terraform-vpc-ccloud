terraform {
    required_providers {
        confluent = {
            source = "confluentinc/confluent"
            version = "1.23.0"
        }
    }
}

provider "confluent" {
    # Set through env vars as:
    # CONFLUENT_CLOUD_API_KEY="CLOUD-KEY"
    # CONFLUENT_CLOUD_API_SECRET="CLOUD-SECRET"
}

resource "confluent_kafka_cluster" "standard_cluster" {
    display_name = "ableasdale-tf-standard-cluster"
    availability = "MULTI_ZONE"
    cloud = "AWS"
    region = "us-east-2"
    standard {}
    environment {
        id = "env-1w6q6"
    }
    lifecycle {
        prevent_destroy = false
    }
}