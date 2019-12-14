provider "google" {
    project = "${var.gcp_project}"
    region = "${var.gcp_region}"
    zone = "${var.gcp_zone}"
}

resource "google_compute_instance" "mysql_node1" {
    name = "${var.instance_name}1"
    machine_type = "${var.machine_type}"
     
    scheduling {
        automatic_restart   = true
    }
    
    boot_disk {
        initialize_params {
            image = "centos-8"
            size = "${var.disk_size}"
            type = "pd-standard"
        }
    }

    network_interface {
        network = "default"
        network_ip = "${var.node_ip_part}.1"
        access_config {
          // Ephemeral IP
        }
    }
    tags = ["mysql-cluster"]
    metadata_startup_script = "${data.template_file.node1_install}"
}

resource "google_compute_instance" "mysql_node" {
    count = "${var.count_instances - 1}"

    name = "${var.instance_name}${count.index + 2}"
    machine_type = "${var.machine_type}"
     
    scheduling {
        automatic_restart   = true
    }
    
    boot_disk {
        initialize_params {
            image = "centos-8"
            size = "${var.disk_size}"
            type = "pd-standard"
        }
    }

    network_interface {
        network = "default"
        network_ip = "${var.node_ip_part}.${count.index + 2}"
        access_config {
          // Ephemeral IP
        }
    }
    tags = ["mysql-cluster"]
    metadata_startup_script = "${data.template_file.node_install}"
}

resource "google_compute_instance" "mysql_router" {
    name = "mysql-router"
    machine_type = "${var.machine_type}"
     
    scheduling {
        automatic_restart   = true
    }
    
    boot_disk {
        initialize_params {
            image = "centos-8"
            size = "${var.disk_size}"
            type = "pd-standard"
        }
    }

    network_interface {
        network = "default"
        network_ip = "${var.router_ip}"
        access_config {
          // Ephemeral IP
        }
    }
    tags = ["mysql-cluster"]
    metadata_startup_script = "${data.template_file.router_install}"
}

resource "google_compute_firewall" "mysql_cluster" {
  name    = "mysql-cluster"
  network = "default"

  allow {
    protocol = "tcp"
  }
  allow {
      protocol = "udp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["mysql-cluster"]
}

data "template_file" "node1_install" {
  template = "${file("node1_install.sh")}"
  vars = {
    nodes = "${var.count_instances}"
  }
}
data "template_file" "node_install" {
  template = "${file("node_install.sh")}"
}

data "template_file" "router_install" {
  template = "${file("router_install.sh")}"
}