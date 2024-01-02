variable "tag1" {
  description = "Deployed By Tag"
  type        = string
  default     = "Terraform"
}

variable "tag2" {
  description = "BU Tag"
  type        = string
  default     = "IT"
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

