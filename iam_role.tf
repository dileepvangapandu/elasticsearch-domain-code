resource "aws_iam_service_linked_role" "default" {
  count            = var.enabled && var.enable_iam_service_linked_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
  description      = "AWSServiceRoleForAmazonElasticsearchService Service-Linked Role"
}


resource "aws_iam_role" "default" {
  count              = var.enabled ? 1 : 0
  name               = "module.user_label.id"
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  description        = "IAM Role to assume to access the Elasticsearch cluster"

}


data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect = "Allow"
  }
}


data "aws_iam_policy_document" "es_assume_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}





# resource "aws_elasticsearch_domain" "main" {
#   domain_name = var.domain_name

#   # ... other configuration ...

#   access_policies = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "*"
#       },
#       "Action": [
#         "es:ESHttp*"
#       ],
#       "Condition": {
#         "IpAddress": {
#           "aws:SourceIp": [
#             "49.37.158.61"
#           ]
#         }
#       },
#       "Resource": "arn:aws:es:us-east-1:199730966281:domain/esaws/*"
#     }
#   ]
# }
# POLICY
# }
