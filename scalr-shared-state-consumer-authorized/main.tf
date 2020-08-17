# acc: acc2 env: default user: i.kov***@scalr.com
terraform {
  backend "remote" {
    hostname = "bc8160fa9062.test-env.scalr.com"
    organization = "env-svrcnchebt61e30"
    workspaces {
      name = "scalr_shared_state_consumer_authorized"
    }
  }
}

# read remote state from different account
data "terraform_remote_state" "shared_state" {
  backend = "remote"

  config = {
    hostname = "bc8160fa9062.test-env.scalr.com"
      organization = "env-svrcnchebt61e30"
      workspaces = { name = "scalr_shared_state" }
  }
}


output "test_remote_state_upd2" {
  value = data.terraform_remote_state.shared_state.outputs.const
}
