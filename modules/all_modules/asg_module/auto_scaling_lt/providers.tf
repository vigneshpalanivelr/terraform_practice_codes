provider "aws" {
  alias  = "default"
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}