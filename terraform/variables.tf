variable "instance_count" {
  default = 3
}
variable "aws_region" { 
  type        = string
  default     =  "us-east-1"
  description = "The AWS region to use for resources"
}
