# AWS Cloud Operations & Automation POC

A hands-on AWS infrastructure and automation project demonstrating Terraform, EC2, IAM, S3, CloudWatch, SNS, Lambda, Packer, GitHub Actions, and secure OIDC-based CI authentication.

## Project Objectives

This project demonstrates how AWS infrastructure can be provisioned, monitored, automated, and validated using Infrastructure as Code and CI/CD practices.

The environment includes:

- Terraform-based AWS infrastructure provisioning
- Custom EC2 AMI creation using Packer
- NGINX web server hosted on EC2
- IAM roles instead of hard-coded AWS credentials
- AWS Systems Manager Session Manager for EC2 administration
- Private S3 access from EC2
- CloudWatch monitoring
- SNS event notification
- Lambda-based event processing
- GitHub Actions Terraform CI
- GitHub OIDC authentication to AWS
- S3 remote Terraform state with versioning, encryption, and state locking

## Architecture

```text
                         GitHub
                            |
                      GitHub Actions
                            |
                       OIDC Token
                            |
                            v
                     AWS IAM Role
                            |
                     Terraform CI
                            |
             +--------------+--------------+
             |                             |
             v                             v
       S3 Remote State               AWS Infrastructure
       + State Lock                         |
                                            |
                                   +--------+--------+
                                   |                 |
                                  VPC               S3
                                   |
                              Public Subnet
                                   |
                                  EC2
                                   |
                                NGINX
                                   |
                          CloudWatch Metrics
                                   |
                            CloudWatch Alarm
                                   |
                                  SNS
                                   |
                                Lambda
                                   |
                           CloudWatch Logs
```

Infrastructure as Code
Terraform provisions and manages the AWS infrastructure.
Major resources include:
- VPC
- Public subnets
- Internet Gateway
- Route table
- Security group
- EC2 instance
- IAM roles and instance profile
- S3 bucket
- CloudWatch alarm
- SNS topic
- Lambda function
Terraform configuration is formatted and validated before changes are reviewed.
EC2 and NGINX
The EC2 instance runs Amazon Linux 2023 and hosts an NGINX web server.
Instead of installing NGINX every time the instance starts, Packer is used to create a reusable custom Amazon Machine Image containing NGINX.
Terraform discovers and launches the custom Packer AMI.
IAM and Systems Manager
The EC2 instance uses an IAM instance profile rather than hard-coded AWS credentials.
The instance has controlled access to the project S3 bucket.
AWS Systems Manager Session Manager is used to administer the EC2 instance, allowing SSH port 22 to remain closed.
Monitoring and Automation
CloudWatch monitors EC2 CPU utilization.
When the configured CPU threshold is exceeded:
EC2 CPU
→ CloudWatch Alarm
→ SNS
→ Lambda
→ CloudWatch Logs
The complete event flow was tested by generating CPU load on the EC2 instance and verifying that the CloudWatch alarm triggered the Lambda function through SNS.
Terraform Remote State
Terraform state is stored in a dedicated S3 bucket instead of being committed to Git.
The backend uses:
- S3 server-side encryption
- S3 versioning
- Block Public Access
- Terraform S3 state locking
This allows local Terraform operations and CI to work against the same infrastructure state.
CI/CD
GitHub Actions runs Terraform checks whenever changes are pushed to the main branch.
The workflow performs:
1. Repository checkout
2. Terraform setup
3. terraform fmt -check
4. AWS authentication
5. terraform init
6. terraform validate
7. terraform plan
The pipeline intentionally does not automatically run terraform apply.
Infrastructure changes therefore require review before deployment.
Secure AWS Authentication
GitHub Actions authenticates to AWS using OpenID Connect (OIDC).
No long-lived AWS access key or secret access key is stored in GitHub.
The workflow assumes a dedicated AWS IAM role using temporary credentials.
The IAM trust relationship is restricted to this GitHub repository and the main branch.
Packer
Packer builds a reusable Amazon Linux AMI with NGINX pre-installed.
This demonstrates the separation between:
- Terraform — infrastructure provisioning
- Packer — machine image creation
- GitHub Actions — CI validation
- AWS services — runtime operations and monitoring
Testing Performed
The project was tested by:
- Running terraform fmt
- Running terraform validate
- Running terraform plan
- Verifying NGINX from the EC2 public endpoint
- Connecting to EC2 using Systems Manager
- Uploading an object from EC2 to S3 using the instance IAM role
- Triggering high CPU utilization
- Verifying the CloudWatch alarm
- Verifying SNS delivery to Lambda
- Verifying Lambda execution through CloudWatch Logs
- Building and launching an EC2 instance from the Packer AMI
- Running Terraform through GitHub Actions using AWS OIDC
- Migrating Terraform state from local state to an S3 backend
- Confirming Terraform reports no infrastructure drift
Technologies
- AWS
- Terraform
- Packer
- GitHub Actions
- Git
- Amazon EC2
- Amazon VPC
- Amazon S3
- AWS IAM
- AWS Systems Manager
- Amazon CloudWatch
- Amazon SNS
- AWS Lambda
- NGINX
- Python
- Bash
Key Learning Outcomes
This POC provided practical experience with:
- Infrastructure as Code
- AWS identity and access management
- Least-privilege access
- AWS monitoring and event-driven automation
- Immutable machine images
- Remote Terraform state management
- Terraform state locking
- CI/CD validation
- OIDC federation
- Troubleshooting IAM, Terraform, S3, and CI integration issues