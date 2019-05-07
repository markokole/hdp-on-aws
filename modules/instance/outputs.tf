output "ambari_instance_id" {
  value = "${aws_instance.ambari.*.id}"
}

output "public_ip" {
  value = "${concat(aws_instance.ambari.*.public_ip, aws_instance.namenode.*.public_ip, aws_instance.datanode.*.public_ip)}"
}

output "public_dns" {
  value = "${concat(aws_instance.ambari.*.public_dns, aws_instance.namenode.*.public_dns, aws_instance.datanode.*.public_dns)}"
}

output "private_dns" {
  value = "${aws_instance.ambari.*.private_dns}"
  value = "${concat(aws_instance.ambari.*.private_dns, aws_instance.namenode.*.private_dns, aws_instance.datanode.*.private_dns)}"
}
