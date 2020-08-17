terraform {
  backend "remote" {
    hostname = "bc8160fa9062.test-env.scalr.com"
    organization = "env-svrcnchebt61e30"
    workspaces {
      name = "scalr_shared_state"
    }
  }
}

output "const" {
  value = "secret:98798234265243"
}
