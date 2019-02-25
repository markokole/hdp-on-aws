variable "cluster_type" {}

variable "path_in_consul" {
  default   = "test/master/aws/test-instance"
}

variable "s3a_consul" {
  default = "aws/s3a"
}

variable "path_in_consul_hdp" {
  default   = "test/master/aws/"
}

data "consul_keys" "hdp" {
  key {
    name = "type"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/type"
  }
  key {
    name = "no_datanodes"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/no_datanodes"
    default = 0
  }
  key {
    name = "no_namenodes"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/no_namenodes"
    default = "2"
  }
  key {
    name = "hdp_cluster_name"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/cluster_name"
  }
  key {
    name = "ambari_version"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/ambari_version"
  }
  key {
    name = "hdp_version"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/hdp_version"
  }
  key {
    name = "hdp_build_number"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/hdp_build_number"
  }
  key {
    name = "database"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/database"
  }
  key {
    name = "s3a"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/s3a"
    default = "false"
  }
  key {
    name = "ambari_services"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/ambari_services"
  }
  key {
    name = "master_services"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/master_services"
  }
  key {
    name = "slave_services"
    path = "${var.path_in_consul_hdp}${var.cluster_type}/slave_services"
  }
}

data "consul_keys" "s3a" {
  key {
    name = "s3a_access_key"
    path = "${var.s3a_consul}/access_key"
  }

  key {
    name = "s3a_secret_key"
    path = "${var.s3a_consul}/secret_key"
  }
}
