provider "aws" {
  region                   = "eu-west-1"
  shared_config_files      = ["~/.aws/conf"]
  shared_credentials_files = ["~/.aws/credentials"]
}