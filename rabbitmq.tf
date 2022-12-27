# Creates SPOT Server
resource "aws_spot_instance_request" "rabbitmq" {
  ami                          = data.aws_ami.myami.image_id
  instance_type                = "t3.micro"
  wait_for_fulfillment         = true
  vpc_security_group_ids       = [aws_security_group.allow_rabbit.id]
  subnet_id                    = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID[0]
  iam_instance_profile         = "b51-admin-role"

  tags = {
    Name = "rabbitmq-${var.ENV}"
  }
}


# Configuration Management for rabbitmq
resource "null_resource" "app" {

  provisioner "remote-exec" {
  connection {
    type     = "ssh"
    user     = jsondecode(data.aws_secretsmanager_secret_version.robot-secrets.secret_string)["SSH_USERNAME"]
    password = jsondecode(data.aws_secretsmanager_secret_version.robot-secrets.secret_string)["SSH_PASSWORD"]
    host     = aws_spot_instance_request.rabbitmq.private_ip
  }
    inline = [
      "ansible-pull -U https://github.com/b51-clouddevops/ansible.git  -e COMPONENT=rabbitmq -e ENV=dev roboshop-pull.yml"
    ]
  }
}