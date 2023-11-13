variable "rg_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rg-tfc"
}

variable "loc_name" {
  description = "Azure Location"
  type        = string
  default     = "eastus"
}

variable "v_net" {
  description = "Virtual Network Name"
  type        = string
  default     = "tcf-network"
}

variable "subnet_1" {
  description = "virtual subnet 1 name"
  type        = string
  default     = "web"
}

variable "subnet_2" {
  description = "virtual subnet 2 name"
  type        = string
  default     = "Data"
}

variable "subnet_3" {
  description = "virtual subnet 3 name"
  type        = string
  default     = "JumpBox"
}
