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

resource "confluent_kafka_cluster" "simple_cluster" {
    display_name = "ableasdale-tf-simple-cluster"
    availability = "SINGLE_ZONE"
    cloud = "AWS"
    region = "us-east-2"
    basic {}
    environment {
        id = "env-1w6q6"
    }
    lifecycle {
        prevent_destroy = false
    }
}