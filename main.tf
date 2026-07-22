# Random suffix so bucket names are globally unique (S3 bucket names must be unique across ALL of AWS, not just your account)
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "hr_docs" {
  bucket = "hr-docs-${random_id.bucket_suffix.hex}"

  tags = {
    Department = "HR"
    ManagedBy  = "Terraform"
  }
}

resource "aws_s3_bucket" "marketing_assets" {
  bucket = "marketing-assets-${random_id.bucket_suffix.hex}"

  tags = {
    Department = "Marketing"
    ManagedBy  = "Terraform"
  }
}

resource "aws_s3_bucket" "sales_reports" {
  bucket = "sales-reports-${random_id.bucket_suffix.hex}"

  tags = {
    Department = "Sales"
    ManagedBy  = "Terraform"
  }
}



resource "aws_iam_group" "department_groups" {
  for_each = toset(local.departments)
  name     = "${lower(each.key)}-group"
}









# Engineering -> broad build/deploy access
resource "aws_iam_group_policy_attachment" "engineering" {
  group      = aws_iam_group.department_groups["Engineering"].name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Finance -> billing/cost visibility
resource "aws_iam_group_policy_attachment" "finance" {
  group      = aws_iam_group.department_groups["Finance"].name
  policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}

# Support -> read-only visibility for troubleshooting
resource "aws_iam_group_policy_attachment" "support" {
  group      = aws_iam_group.department_groups["Support"].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Operations -> broad build/deploy access
resource "aws_iam_group_policy_attachment" "operations" {
  group      = aws_iam_group.department_groups["Operations"].name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}








# ---- HR: read-only on hr-docs bucket ----
data "aws_iam_policy_document" "hr_s3" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.hr_docs.arn,
      "${aws_s3_bucket.hr_docs.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "hr_s3" {
  name   = "hr-s3-readonly"
  policy = data.aws_iam_policy_document.hr_s3.json
}

resource "aws_iam_group_policy_attachment" "hr" {
  group      = aws_iam_group.department_groups["HR"].name
  policy_arn = aws_iam_policy.hr_s3.arn
}

# ---- Marketing: read/write on marketing-assets bucket ----
data "aws_iam_policy_document" "marketing_s3" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.marketing_assets.arn,
      "${aws_s3_bucket.marketing_assets.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "marketing_s3" {
  name   = "marketing-s3-readwrite"
  policy = data.aws_iam_policy_document.marketing_s3.json
}

resource "aws_iam_group_policy_attachment" "marketing" {
  group      = aws_iam_group.department_groups["Marketing"].name
  policy_arn = aws_iam_policy.marketing_s3.arn
}

# ---- Sales: read-only on sales-reports bucket ----
data "aws_iam_policy_document" "sales_s3" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.sales_reports.arn,
      "${aws_s3_bucket.sales_reports.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "sales_s3" {
  name   = "sales-s3-readonly"
  policy = data.aws_iam_policy_document.sales_s3.json
}

resource "aws_iam_group_policy_attachment" "sales" {
  group      = aws_iam_group.department_groups["Sales"].name
  policy_arn = aws_iam_policy.sales_s3.arn
}









resource "aws_iam_user" "this" {
  for_each = local.employees
  name     = each.key

  tags = {
    Department = each.value.Department
    Position   = each.value.Position
    JoinedOn   = each.value.DateOfJoining
  }
}

resource "aws_iam_user_group_membership" "this" {
  for_each = local.employees
  user     = aws_iam_user.this[each.key].name

  groups = [
    aws_iam_group.department_groups[each.value.Department].name
  ]
}










resource "aws_iam_user_login_profile" "this" {
  for_each                = local.employees
  user                    = aws_iam_user.this[each.key].name
  password_reset_required = true
  password_length         = 16
}




