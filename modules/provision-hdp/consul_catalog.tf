/*resource "consul_service" "app" {
  address = "localhost"
  node    = local.ambari_dns
  #address = local.ambari_ips
  #id      = "ambari"
  name    = "Ambari Server"
  port    = 8080
  tags    = ["AMBARI", "HDP"]
}*/

/*resource "consul_catalog_entry" "app" {
  address = "localhost"
  node    = local.ambari_dns

  service {
    address = local.ambari_ips
    id      = "ambari"
    name    = "Ambari Server"
    port    = 8080
    tags    = ["AMBARI", "HDP"]
  }
}*/

