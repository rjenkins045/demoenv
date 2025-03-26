variable "env" {
  description = "Environment identifier (e.g., demo-env1)"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"  # optional default
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
