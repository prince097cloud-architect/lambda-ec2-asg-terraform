data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "TFE-PROD-GRADE-INFRA"
    workspaces = {
      name = "eks-msk-prod"
    }
  }
}