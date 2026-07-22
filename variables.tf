variable "region" {
  description = "AWS region to deploy IAM resources into"
  type        = string
  default     = "us-east-1"
}

variable "csv_path" {
  description = "Path to the employee CSV file"
  type        = string
  default     = "employees.csv"
}