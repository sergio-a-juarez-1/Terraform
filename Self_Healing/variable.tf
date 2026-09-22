variable "aws_region" {
  type        = string
  description = "Target deployment region mapping infrastructure footprints"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "Compute power tier mapped to sandbox instances"
  default     = "t3.medium"
}

variable "key_name" {
  type        = string
  description = "The registered SSH Key Pair identifier used to authenticate administrative network connection channels"
}
