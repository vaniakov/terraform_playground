resource "null_resource" "show_env" {
  provisioner "local-exec" {
    command = "env"
  }
}
