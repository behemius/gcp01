# Google Parameters

variable "gcp_project" {
    default = "behemius"
}
variable "gcp_region" {
    default = "europe-west3"
}
variable "gcp_zone" {
    default = "europe-west3-a"
}

# Resources parameters

variable "count_instances" {
    default = 3  
}
variable "instance_name" {
    default = "mysql0"
}
variable "machine_type" {
    default = "g1-small"   
}
variable "disk_size" {
    default = 10
}
variable "node_ip_part" {
    default = "10.156.10"
  
}
variable "router_ip" {
    default = "10.156.10.100"
  
}


