variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "key_name" {
 description = "AWS key_name."
 type        = string   
}

variable "connection_type" {
    type    = string
}

variable "connection_user" {
    type    = string
}

variable "connection_private_key" {
    type    = string
}

variable "provisioner_file_source" {
    type    = string
}
variable "provisioner_index" {
    type    = string
}
variable "provisioner_info" {
    type    = string
}
variable "provisioner_submit" {
    type    = string
}
variable "sns_email_endpoint" {
    type    = string
}

variable "slack_webhook_url" {
    type   = string
}