resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.id
  instance_type = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.allow-db.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET[0]
  tags = {
    Name = "${var.component}-${var.ENV}"
  }
}


resource "null_resource" "apply" {
  provisioner "remote-exec" {
    connection {
      host = aws_instance.instance.private_ip
      user = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["SSH_PASS"]
    }
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible==4.1.0",
      "echo localhost component=${var.component} >/tmp/hosts",
      "ansible-pull -i /tmp/hosts -U https://github.com/kesavakadiyala/ansible.git roboshop_project.yml -t ${var.component} -e PAT=${jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["PAT"]} -e ENV=${var.ENV}"
    ]
  }
}

resource "aws_security_group" "allow-db" {
  name        = "Allow-${var.component}-${var.ENV}"
  description = "Allow-${var.component}-${var.ENV}"
  vpc_id = data.terraform_remote_state.vpc.outputs.VPC_ID
  ingress {
    description = "TLS from VPC"
    from_port   = var.PORT
    to_port     = var.PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow-${var.component}-${var.ENV}"
  }
}
