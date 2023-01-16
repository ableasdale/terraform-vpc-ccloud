# terraform-vpc-ccloud

Setting up a VPC in Terraform and peering it with Confluent Cloud

## Getting Started

This project works on the assumption that the AWS CLI is already running and is configured on your machine.

Install Terraform

```bash
brew install terraform
```

## Simple test

The first project will create a `t2.micro` instance running Ubuntu 22.04 with the name `ableasdale-ubuntu-instance` in the `eu-west-2` region.

```bash
cd ec2-instance-simple
terraform init
```

After initialization, run `terraform plan` then `terraform apply` to create the instance.

### Attempt to ssh to the instance

```bash
ssh -i yourkey.pem ubuntu@PUBLIC_IP_ADDR
```

When you're done, run `terraform destroy` to clean-up.

## Create a VPC

The `custom-vpc` directory will create a VPC with Public and Private subnets and will install a Bastion host in the first AZ in the public subnet

### Attempt to ssh to the instance

```bash
ssh -i yourkey.pem ec2-user@PUBLIC_IP_ADDR
```

## TODO - need aws cli?  confluent cli?  Visual Studio plugins?

## Initialize and run the project

```bash
terraform init
```

You should see:

```

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "4.46.0"...
- Finding confluentinc/confluent versions matching "1.23.0"...
- Installing hashicorp/aws v4.46.0...
- Installed hashicorp/aws v4.46.0 (signed by HashiCorp)
- Installing confluentinc/confluent v1.23.0...
- Installed confluentinc/confluent v1.23.0
[...]
Terraform has been successfully initialized!
```

## Walkthrough of the `.tf` files

| Filename | Description |
|---|---|
| `providers.tf` | A list of the "providers" that we will use for this project (AWS and Confluent) |


## Troubleshooting

```
❯ terraform plan
╷
│ Error: Inconsistent dependency lock file
│
│ The following dependency selections recorded in the lock file are inconsistent with the current configuration:
│   - provider registry.terraform.io/hashicorp/random: required by this configuration but no version is selected
│
│ To update the locked dependency selections to match a changed configuration, run:
│   terraform init -upgrade
```