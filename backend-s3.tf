terraform {
  backend "s3" {
    bucket = "my-tf-test-bucket-3d4b9be1"
    key    = "dev/teraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
