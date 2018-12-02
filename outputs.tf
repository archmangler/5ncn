/*output "cluster_master_public_addresses" {
  value = "${aws_instance.cluster_master.*.public_ip}"
}

output "cluster_master_private_addresses" {
  value = "${aws_instance.cluster_master.*.private_ip}"
}
*/
output "cluster_slave_public_addresses" {
  value = "${aws_instance.cluster_slave.*.public_ip}"
}

output "cluster_slave_private_addresses" {
  value = "${aws_instance.cluster_slave.*.private_ip}"
}

/*
output "default_tags_rendered" {
 value="${data.template_file.test.rendered}"
}
*/
