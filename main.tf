provider "aws" {
    shared_credentials_file             = "~/.aws/credentials"
    profile                             = "default"
    region                              = var.region
    version                             = "2.68"
}

resource "aws_elasticsearch_domain" "default" {
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  advanced_options = var.advanced_options

  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
    iops        = var.ebs_iops
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_at_rest_kms_key_id
  }

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    zone_awareness_enabled   = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

domain_endpoint_options {
    enforce_https = var.enforce_https
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  tags = {
    Domain = "TestDomain"
  }


   vpc_options {
     subnet_ids  = data.aws_subnet_ids.es_subnets.ids
}


}

data "aws_vpc" "vpc" {
   filter {
    name   = "tag:Name"
    values = ["*-dev-app-vpc"]
  }
}


data "aws_subnet_ids" "es_subnets" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["*-dev-db"]
}
}
 

data "aws_security_group" "es-sg" {
  filter {
    name   = "tag:Name"
    values = ["*-compute-sg"]
  }
}




