provider "google" {
    project = "${var.gcp_project}"
    region = "${var.gcp_region}"
    zone = "${var.gcp_zone}"
}

resource "google_compute_instance" "vm_instance" {
    count = "${var.count_instances}"

    name = "${var.instance_name}${count.index}"
    machine_type = "${var.machine_type}"
     
    scheduling {
        automatic_restart   = true
    }
    
    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-9"
            size = "10"
            type = "pd-standard"
        }
    }

    network_interface {
        network = "default"
        access_config {
          // Ephemeral IP
        }
    }
}