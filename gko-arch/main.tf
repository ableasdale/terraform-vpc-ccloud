terraform {
    required_providers {
        confluent = {
            source = "confluentinc/confluent"
            version = "1.28.0"
        }
    }
}

resource "confluent_kafka_cluster" "dedicated_cluster" {
    display_name = "table24-tf-dedicated-cluster-one"
    availability = "MULTI_ZONE"
    cloud = "AWS"
    region = "us-east-1"
    dedicated {
        cku = "2"
    }
    environment {
        id = "env-568zz"
    }
    lifecycle {
        prevent_destroy = false
    }
}

resource "confluent_kafka_cluster" "dedicated_cluster_two" {
    display_name = "table24-tf-standard-cluster-two"
    availability = "MULTI_ZONE"
    cloud = "AWS"
    region = "us-east-2"
    dedicated {
        cku = "2"
    }
    environment {
        id = "env-568zz"
    }
    lifecycle {
        prevent_destroy = false
    }
}
