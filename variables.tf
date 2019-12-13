# Google Parameters

variable "gcp_project" {
    default = "behemius"
}
variable "gcp_region" {
    default = "europe-west3"
}
variable "gcp_zone" {
    default = "europe-west3-c"
}

# Resources parameters

variable "count_instances" {
    default = 3  
}

variable "instance_name" {
    default = "mysql0"
}

variable "machine_type" {
    default = "f1-micro"   
}
