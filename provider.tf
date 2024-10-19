locals (

region "us-east-1"

name "${terraform.workspace)-cluster"

vpc_cidr "10.123.0.0/16"

azs ["us-east-la", "us-east-1b"]

public_subnets ["10.123.1.0/24", "10.123.2.0/24"]

private_subnets ["10.123.3.0/24", "10.123.4.0/24"]

intra subnets -["10.123.5.0/24", "10.123.6.0/24"]

tags = {

Example

}
local.name
provider"aws"{
region "us-east-1"
}
