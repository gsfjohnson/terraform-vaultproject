### MANDATORY ###

variable "owner_tag" {
  description = "Who owns the instance."
}

variable "environment_tag" {
  description = "Whether instance is production, test, development, etc."
}

variable "fund_tag" {
  description = "Fund for instance."
}

variable "org_tag" {
  description = "Org for instance."
}

variable "application_tag" {
  description = "Application tag."
  default = "Hashicorp-Vault"
}

variable "clientdepartment_tag" {
  description = "Customer"
}

### Vault configuration

variable "download-url" {
  description = "URL to download Vault"
  default = "https://releases.hashicorp.com/vault/0.5.2/vault_0.5.2_linux_amd64.zip"
}

variable "config" {
  description = "Configuration (text) for Vault"
}

variable "extra-install" {
  description = "Extra commands to run in the install script"
  default = ""
}

### AWS EC2 configuration

variable "aws_keyname" {
  description = "SSH keypair name to use."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-west-2"
}

variable "aws_availability_zone" {
  description = "AWS AZ to launch servers."
  default = "us-west-2b"
}

variable "org_cidr_blocks"{
  description = "Organization CIDRs"
}

variable "aws_sg_name" {
  description = "Name of security group to use in AWS."
  default = "app-hashicorp-vault"
}

variable "aws_instance_ami" {
  description = "Instance Amazon Machine Image ID"
  default = "ami-d2c924b2"
}

variable "aws_instance_type" {
  default = "t2.nano"
}

## AWS Route 53

variable "aws_r53_zone_id" {
  description = "AWS Route53 Zone ID, e.g. Z1XPTMOSAOMS"
}

variable "aws_r53_zone_domain" {
  description = "AWS Route53 Zone Domain, e.g. example.org"
}

variable "aws_r53_record_name" {
  description = "Hostname to use in Zone, e.g. vault"
}
