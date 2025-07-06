
terraform {
  backend "s3" {
    bucket       = "uc-eks-farget-node-group-hybrid"
    key          = "uc-eks-farget-node-group-hybrid"
    region       = "ap-northeast-3"
    encrypt      = true
    use_lockfile = true
  }
}