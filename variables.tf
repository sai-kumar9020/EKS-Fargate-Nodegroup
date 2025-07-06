variable "region" {
    description = "Region"
    type = string
    default = "ap-northeast-3"

}

variable "vpc_cidr" {
    description = "VPC cidr range"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet" {
    description = "public subnets descriptions"
    type = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet" {
    description = "private subnets descriptions"
    type = list(string)
    default     = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "availability_zone" {
    description = "Availability Zones"
    type = list(string)
    default     = ["ap-northeast-3a", "ap-northeast-3b"]
}

variable "name" {
  description = "Name to be used on VPC created"
  type        = string
  default     = "demo6" 
}

variable "db_username" {
  description = "Name of the db_username"
  type        = string
  default     = "admin"
}

variable "database_name" {
  description = "Name of the db_name"
  type        = string
  default     = "test"
}

variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}