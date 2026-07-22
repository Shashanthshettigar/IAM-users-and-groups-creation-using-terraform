locals {
  # Decode the raw CSV into a list of maps (one map per row)
  employees_raw = csvdecode(file("${path.module}/${var.csv_path}"))

  # Re-key by a unique, IAM-safe username: firstname.lastname (lowercase)
  employees = {
    for emp in local.employees_raw :
    "${lower(emp.FirstName)}.${lower(emp.LastName)}" => emp
  }

  # List of distinct departments found in the CSV (used later for groups)
  departments = distinct([for emp in local.employees_raw : emp.Department])
}