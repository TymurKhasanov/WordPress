variable "wordpress_replica_count" {
  description = "Number of WordPress replicas to deploy."
  type        = number
  default     = 1
}

variable "wordpress_domain" {
  description = "Domain name for WordPress Ingress."
  type        = string
  default     = "wordpress.localhost"
}

variable "mysql_root_password" {
  description = "MySQL root password stored in Kubernetes secret."
  type        = string
  default     = "root"
  sensitive   = true
}

variable "mysql_database" {
  description = "Name of the MySQL database."
  type        = string
  default     = "wp_database"
}

variable "mysql_user" {
  description = "Username for the MySQL database."
  type        = string
  default     = "wp_user"
}

variable "mysql_password" {
  description = "Password for the MySQL user stored in Kubernetes secret."
  type        = string
  default     = "root"
  sensitive   = true
}

variable "wordpress_namespace" {
  description = "Namespace where the app is running"
  type        = string
  default     = "wordpress"
}
