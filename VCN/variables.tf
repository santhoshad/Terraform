variable "region" {
  type        = string
  description = "OCI region"
  default = "ap-mumbai-1"
}

variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
  default = "ocid1.tenancy.oc1..aaaaaaaavc76ja77ynos2lfgdfwbbten7l25irg2wpm4asuyighwsbsdyj6a"
}

variable "vcn_cidr" {
  type        = string
  description = "CIDR block for the VCN"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}
 