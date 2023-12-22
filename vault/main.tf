provider "vault" {
  address = "http://127.0.0.1:8200"
  token = "hvs.d1t5aD54hDeewp8DC0W4Ldg3"
}

data "vault_generic_secret" "phone_number" {
  path = "secret/app"
}


output "phone_number" {
  value = data.vault_generic_secret.phone_number.data["phone_number"]
  sensitive = true
}

module "server" {
  source    = "./server"
  ami       = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.public_subnets["public_subnet_3"].id
  security_groups = [
    aws_security_group.vpc-ping.id,
    aws_security_group.ingress-ssh.id,
    aws_security_group.vpc-web.id
  ]
}

output "public_ip" {
  value = module.server.public_ip
}

output "public_dns" {
  value = module.server.public_dns
  sensitive = true
}