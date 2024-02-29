# Creating all the necessary variables
variable "region" {
  description = "AWS provider"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "Pub_Sub1_cidr" {
  description = "Public Subnet 1 cidr"
  type        = string
  default     = "10.0.1.0/24"
}

variable "Pub_Sub1_availability_zone" {
  description = "Public Subnet 1 availability_zone"
  type        = string
  default     = "eu-west-2a"
}

variable "Pub_Sub2_cidr" {
  description = "Public Subnet 2 cidr"
  type        = string
  default     = "10.0.2.0/24"
}

variable "Pub_Sub2_availability_zone" {
  description = "Public Subnet 2 availability_zone"
  type        = string
  default     = "eu-west-2b"
}

variable "Priv_Sub1_cidr" {
  description = "Private Subnet 1 cidr"
  type        = string
  default     = "10.0.3.0/24"
}

variable "Priv_Sub1_availability_zone" {
  description = "Private Subnet 1 availability_zone"
  type        = string
  default     = "eu-west-2a"
}

variable "Priv_Sub2_cidr" {
  description = "Private Subnet 2 cidr"
  type        = string
  default     = "10.0.4.0/24"
}

variable "Priv_Sub2_availability_zone" {
  description = "Private Subnet 2 availability_zone"
  type        = string
  default     = "eu-west-2b"
}

variable "Priv_Sub3_cidr" {
  description = "Private Subnet 3 cidr"
  type        = string
  default     = "10.0.5.0/24"
}

variable "Priv_Sub3_availability_zone" {
  description = "Public Subnet  availability_zone"
  type        = string
  default     = "eu-west-2a"
}

variable "Priv_Sub4_cidr" {
  description = "Private Subnet 4 cidr"
  type        = string
  default     = "10.0.6.0/24"
}

variable "Priv_Sub4_availability_zone" {
  description = "Private Subnet 4 availability_zone"
  type        = string
  default     = "eu-west-2b"
}

variable "ami" {
  description = "t2 micro ami"
  type        = string
  default     = "ami-027d95b1c717e8c5d" #instance eu-west-2 region
}

variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "key pair name"
  type        = string
  default     = "Skytroopers-kp"
}

variable "filename" {
  description = "key pair filename on local computer"
  type        = string
  default     = "Skytroopers-kp"
}
