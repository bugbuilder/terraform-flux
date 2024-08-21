terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">=1.2.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.62.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "flux" {
  kubernetes = {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
  git = {
    url = "https://github.com/${var.github_org}/${var.github_repository}.git"
    http = {
      username = "git" # This can be any string when using a personal access token
      password = var.github_token
    }
  }
}


provider "github" {
  owner = var.github_org
  token = var.github_token
}