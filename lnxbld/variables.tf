variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}

variable "loc_name" {
  description = "Azure Location"
  type        = string
}

variable "lnx_name" {
  description = "Linux VM Name"
  type        = string
}

variable "lnx_nic" {
  description = "Linux VM NIC1"
  type        = string
}

variable "admin_password" {
  description = "Admin Password"
  type        = string
}

variable "tag1" {
  description = "Deployed By Tag"
  type        = string

}
variable "tag2" {
  description = "BU Tag"
  type        = string
}

variable "vm_count" {
  description = "Count"
  type        = number
}

variable "subnet" {
  description = "virtual subnet 1 name"
  type        = string
}
