variable "name_prefix" {
  description = "Prefix for cloud resource names"
  type        = string
  default     = "jagrit-week7"
}

variable "student_name" {
  description = "Student name displayed on the website"
  type        = string
  default     = "Jagrit Handa"
}

variable "page_message" {
  description = "Message displayed on the website"
  type        = string
  default = "Cloud Services Week 7 - Updated using OpenTofu"
}

variable "project_network" {
  description = "Existing cPouta project network name"
  type        = string
}

variable "image_name" {
  description = "Linux image for the VM"
  type        = string
}

variable "flavor_name" {
  description = "VM size"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_allowed_cidr" {
  description = "IP address allowed to connect using SSH"
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "Enter a valid CIDR address, such as 203.0.113.10/32."
  }
}