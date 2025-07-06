
terraform {
  backend "s3" {
    bucket       = "eks-farget-hybrid"
    key          = "eks-farget-hybrid"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true
  }
}