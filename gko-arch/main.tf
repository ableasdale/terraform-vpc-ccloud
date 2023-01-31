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

resource "confluent_cluster_link" "destination-outbound" {
  link_name = "destination-initiated-cluster-link"
  source_kafka_cluster {
    id                 = confluent_kafka_cluster.dedicated_cluster.id
    bootstrap_endpoint = confluent_kafka_cluster.dedicated_cluster.bootstrap_endpoint
    credentials {
      key    = "********"
      secret = "********" 
    }
  }

  destination_kafka_cluster {
    id            = confluent_kafka_cluster.dedicated_cluster_two.id
    rest_endpoint = confluent_kafka_cluster.dedicated_cluster_two.rest_endpoint
    credentials {
      key    = "********"
      secret = "********"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}