variable "aws_region" {
  default =  "ap-southeast-1"
}

variable "vpc_cidr" {
  default  = "192.168.0.0/16"
}

variable "pub_subnet_cidr" {
  default = "192.168.0.0/24"
}

variable "pri_subnet_cidr" {
  default = "192.168.1.0/24"
}

## choose one of the images and remove the other
variable "image" {
#ubuntu  default = "ami-09a4a9ce71ff3f20b"
  default = "ami-01b02e6dd3efebd61"
}

variable "type" {
  default  = "t2.micro"
}

variable "public_sshkey" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6tpDDI53B/UfZjpYxUieFZ6lcsfBwoX9xw0AriZEew4ym1KBUgv3+7crgIJTSwqMEJJDsL5Blb7lJAbRo4ezdePZESGHURTf44ZksTQ7hfSCKh/fIjQL5i3fjw2VQjrNF5llnAXAZefKenLR7T87Iz6+EC7tZxTFDVQ+mGA4YU6ffThm3HWqDgSBlNM5G40nsV573944EsKXGx90S0mM8ApDl7dPtm7VUu1EaGyvGz/1p8aEEO2Yp1TzGYTGf8+nJVkiIICe33+xs1nMOCfCDPJwatvi9AEn3xyG17nF+sIVcXseKTQvXPyM+jEhC0mAL8rEUbmp9ZtYw2zQoWrliG/s8HkgJA3VjNxglqOe00bLZk/Uua8DN13uzv81f3kyAdA16rsS+wEbfbc/TC75BTSwYaNH/+gfqN4a1HPP2JJ5XnS92SURZqLXYBy4jugAng96DprymQZ6VIdRoZAxKu8azIwPDu4sVau28fhwuqk1biVqGQ4ItV3BeXigqdhnBcOkTmm6c1nCfSuZMTEn2XgTd97qNPZcOJZJilxqP7EaLMhoaEUKuVW5j8Dvg5AbEacbDslc98mlZjIhf/1Q0RYyU4CeQF1Dk1NfQe83zDAn3mKItdY2j6NKcOQpgyrmi8dgAWA3KdWvuKAlcfpdOzxUdEi8YSDvqzJNI17074w== root@ansible"
}
