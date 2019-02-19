variable "username" {
}

variable "password" {
}

variable "domain_name" {
}

variable "region" {
}

variable "tenant_name" {
}

variable "endpoint" {
}

### OTC Specific Settings
variable "external_network" {
  default = "admin_external_net"
}

### Project Settings
variable "project" {
  default = "terraform"
}

variable "subnet_cidr" {
  default = "192.168.10.0/24"
}

variable "ssh_pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dnsip" {
  default = "100.125.4.25"
}

### VM (Instance) Settings
variable "instance_count" {
  default = "1"
}

variable "worker_count" {
  default = "5"
}

variable "flavor_name" {
  default = "s1.medium"
}

variable "image_name" {
  default = "Community_Ubuntu_16.04_TSI_latest"
}

### K8s settings
variable "hyperkubeimage" {
  default = "gcr.io/google-containers/hyperkube:v1.9.3"
}

variable "etcdimage" {
  default = "quay.io/coreos/etcd:v3.2"
}

variable "disk_size_gb" {
  default = "20"
}
