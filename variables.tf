variable "env" {
  description = "Ambiente"
  type        = string
}

variable "vpc" {
  description = "vpc"
  type = string
}

variable "private-net1" {
  description = "private-net1"
  type        = string
}

variable "private-net2" {
  description = "private-net2"
  type        = string
}

variable "public-net1" {
  description = "public-net1"
  type        = string
}

variable "public-net2" {
  description = "public-net2"
  type        = string
}

variable "ami" {
  description = "ubuntu"
  type        = string
}

variable "instance_type" {
  description = "t2-micro"
  type        = string
}
