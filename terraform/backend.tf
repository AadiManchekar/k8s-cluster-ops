terraform {
  backend "s3" {
    bucket = "k8s-cluster-ops-2yi7dx-backend-bucket"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
}
