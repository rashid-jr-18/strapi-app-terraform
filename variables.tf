variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR for Subnet"
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI for us-east-1"
  default     = "ami-04a81a99f5ec58529"
}
