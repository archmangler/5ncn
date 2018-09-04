Five node cluster of ec2 instances for AWS defined using Terraform IAC.
=======================================================================

Outputs:

- 1 master plus 5 slave EC2 instance nodes running in a VPC on AWS

Usage:

- rename variables.example to variables.tf
- add your AWS credentials to variables.tf
- modify the aws SSH key name to your own
- terraform init
- terraform plan
- terraform apply
- Review the infrastructure deployed to AWS.
