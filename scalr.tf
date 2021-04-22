terraform {
  backend "remote" {
    hostname = "79b369b21fae.test-env.scalr.com"
    organization = "env-svrcnchebt61e30"

    workspaces {
      name = "test-module"
    }
  }
}
