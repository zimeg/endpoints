variable "domain" {
  description = "Root path for serving requests"
  type        = string
  default     = "api.o526.net"
}

variable "hosted_zone_id" {
  description = "Existing hosted zone for domain"
  type        = string
}
