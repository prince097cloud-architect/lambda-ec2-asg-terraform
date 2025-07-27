terraform {
  backend "remote" {
    organization = "TFE-PROD-GRADE-INFRA"

    workspaces {
      name = "cost-optimization-workspace"
    }
  }
}
