resource "aws_security_group" "sg_hdp_terraform" {
  name        = "sg_hdp_terraform"
  description = "HDP provisioned from Terraform"
  vpc_id      = local.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #cidr_blocks = [local.cidr_blocks]
    self        = "true"
  }

  # ssh
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [local.cidr_blocks]
    description = "ssh"
  }

  # Ambari
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [local.cidr_blocks]
    description = "Ambari http"
  }

  # Namenode http
  ingress {
    from_port = 50070
    to_port   = 50070
    protocol  = "tcp"
    cidr_blocks = [local.cidr_blocks]
    description = "Namenode http"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}