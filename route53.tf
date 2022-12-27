resource "aws_route53_record" "rabbitmq-record" {
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONEID
  name    = "rabbitmq-dev.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONENAME}"
  type    = "A"
  ttl     = 10
  records = [aws_spot_instance_request.rabbitmq.private_ip]
}
