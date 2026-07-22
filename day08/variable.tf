variable "environment" {

    type = string
    default = "test"

}


variable "name" {

    type = string
    default = "shashanth"

}

variable "instance_type" {

  type        = string
  description = "EC2 instance type"
  default     = "t3.small"

}

variable "ami" {

    type = string
    default = "ami-0c02fb55956c7d316"

}

variable "instance_count" {
    type = number
    default = 4
}


variable "public_ip" {
    type = bool
    default = true
}


variable "availability_zone" {
    type =list(string)
    default = ["us-east-1a", "us-east-1b", "us-east-1a"]

}

variable "allowed_cidr" {
    type = set(string)
    default = ["192.168.0.0/16", "172.16.0.0/24", "10.0.0.0/8"]
}

variable "tags" {
    type = map(string)
    default = {
        name = "web-server"
        ENVIRONMENT = "DEV-PROD-TEST"
        OWNER = "SHASHANTH"
        PROJECT = "TERRAFORM"
    }
}

#variable "network_config" {
#    type = tuple([string, string, number])
#    description = "network config for VPC CIDR, subnet CIDR, port number"
#    default = ["10.0.1.0/16", "10.0.0.0/24", 80]
#}

#variable "aws_node_group" {
#    type =object ({
#        instance_type = string
#        min_size = number
#        max_size = number
#        desired_size = number
#        capacity_type = string
#   })
#
#    default = {
#        instance_type = "t3.small"
#       min_size = 2
#        max_size = 8
#        desired_size = 2
#        capacity_type = "SPOT"
#    }
#}


variable "server_config" {
    type = object({
        name = string
        instance_type = string
        monitoring = bool
        storage_gb = number
        backup_enabled = bool
    })
    description = "Complete server configuration object"
    default = {
        name = "web-server"
        instance_type = "t2.micro"
        monitoring = true
        storage_gb = 20
        backup_enabled = false


    }
}    