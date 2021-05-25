output "es_endpoint" {
  value = "${aws_elasticsearch_domain.default.endpoint}"
}

output "kibana_endpoint" {
  value = "${aws_elasticsearch_domain.default.kibana_endpoint}"
}
