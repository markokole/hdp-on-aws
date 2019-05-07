provider "aws" {
  region = "${local.region}"
}

locals {
  path_to_generated_aws_properties = "${var.path_in_consul}/${data.consul_keys.app.var.path_to_generated_aws_properties}"

  #cidr_blocks = "${data.consul_keys.system.var.cidr_blocks}/32"
  region             = "${data.consul_keys.app.var.region}"
  type               = "${data.consul_keys.app.var.type}"
  ami                = "${data.consul_keys.app.var.ami}"
  #cidr_blocks        = "${data.consul_keys.app.var.cidr_blocks}"
  cidr_blocks        = "0.0.0.0/0"
  instance_type      = "${data.consul_keys.app.var.instance_type}"
  vpc_id             = "${data.consul_keys.aws.var.vpc_id}"
  subnet_id          = "${data.consul_keys.aws.var.subnet_id}"
  security_groups    = ["${aws_security_group.sg_hdp_terraform.id}"]
  availability_zone  = "${data.consul_keys.aws.var.availability_zone}"

  no_namenodes = "${data.consul_keys.app.var.no_namenodes}"
  no_datanodes = "${data.consul_keys.app.var.no_datanodes}"
  no_instances = "${local.type == "single" ? 1 : 1 + local.no_namenodes + local.no_datanodes}"
  name         = "HDP-${var.cluster_type}"
  name_ambari  = "${local.type == "single" ? "" : "-Ambari"}"
}

/*
resource "null_resource" "write_out" {
  provisioner "local-exec" {
    command = <<EOF
      echo "*********************************************************"
EOF
  }
}
*/
resource "aws_instance" "ambari" {
  depends_on = ["aws_security_group.sg_hdp_terraform"]

  count = "1" #"${local.no_instances}"
  ami = "${local.ami}"
  instance_type = "${local.instance_type}"
  subnet_id = "${local.subnet_id}"
  security_groups = ["${local.security_groups}"]
  availability_zone = "${local.availability_zone}"
  key_name = "mykeypair"
  associate_public_ip_address = "true"
  tags {
    Name = "${local.name}${local.name_ambari}"
  }
  volume_tags {
    Name = "${local.name}-volume"
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = "true"
  }
}

resource "aws_instance" "namenode" {
  depends_on = ["aws_security_group.sg_hdp_terraform"]

  count = "${local.no_namenodes}"
  ami = "${local.ami}"
  instance_type = "${local.instance_type}"
  subnet_id = "${local.subnet_id}"
  security_groups = ["${local.security_groups}"]
  availability_zone = "${local.availability_zone}"
  key_name = "mykeypair"
  associate_public_ip_address = "true"
  tags {
    Name = "${local.name}-namenode-${format("%02d", count.index + 1)}"
  }
  volume_tags {
    Name = "${local.name}-volume"
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = "true"
  }
}

resource "aws_instance" "datanode" {
  depends_on = ["aws_security_group.sg_hdp_terraform"]

  count = "${local.no_datanodes}"
  ami = "${local.ami}"
  instance_type = "${local.instance_type}"
  subnet_id = "${local.subnet_id}"
  security_groups = ["${local.security_groups}"]
  availability_zone = "${local.availability_zone}"
  key_name = "mykeypair"
  associate_public_ip_address = "true"
  tags {
    Name = "${local.name}-datanode-${format("%02d", count.index + 1)}"
  }
  volume_tags {
    Name = "${local.name}-volume"
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = "true"
  }
}
