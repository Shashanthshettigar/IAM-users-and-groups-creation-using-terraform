output "employees_preview" {
  value = local.employees
}

output "departments_found" {
  value = local.departments
}





output "initial_passwords" {
  description = "Auto-generated initial console passwords (user must change on first login)"
  value = {
    for k, v in aws_iam_user_login_profile.this : k => v.password
  }
  sensitive = true
}
