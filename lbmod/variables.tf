variable "rg_name" {
  description = "Resource Group Name"
  type        = string

}

variable "loc_name" {
  description = "Azure Location"
  type        = string

}

variable "lb_name" {
  description = "Load Balancer Name"
  type        = string
}

variable "lbip_name" {
  description = "Load Balancer Public IP Name"
  type        = string
}

variable "lb_nic1" {
  description = "Load Balancer NIC1"
  type        = string
}

variable "vn_name" {
  description = "Virtual Network Name"
  type        = string
}
