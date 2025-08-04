# Secure AWS Infrastructure with Terragrunt

This repository contains Infrastructure as Code (IaC) using Terragrunt to deploy a secure, production-ready AWS infrastructure with EKS backend and CloudFront frontend architecture.

## Architecture Overview

### Key Components
- **Frontend**: CloudFront distribution with WAF protection
- **Backend**: EKS cluster with secure ALB integration
- **Security**: 
  - WAF for CloudFront and Application protection
  - KMS encryption for sensitive data
  - ACM certificates for HTTPS
  - Custom VPC with private/public subnets
- **Storage**: S3 bucket with encryption
- **DNS**: Route53 for domain management

## Prerequisites

- AWS Account
- Terraform >= 1.0.0
- Terragrunt >= 0.36.0
- AWS CLI configured
- kubectl

## Project Structure
```
.
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   ├── eks/
│   ├── vpc/
│   ├── waf/
│   ├── cloudfront/
│   └── ...
└── root.hcl
```

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/yourusername/aws-enterprise-infra-terragrunt.git
cd aws-enterprise-infra-terragrunt
```

2. Update the root configuration in `root.hcl`

3. Deploy the infrastructure:
```bash
cd environments/dev
make plan
make apply
```

## Module Details

### VPC Module
- Custom VPC with public and private subnets
- NAT Gateways for private subnet connectivity
- VPC Flow Logs enabled

### EKS Module
- Managed EKS cluster
- Node groups with auto-scaling
- OIDC provider integration

### WAF Module
- AWS Managed Rules
- Custom rule sets
- Logging integration with Kinesis Firehose

### CloudFront Module
- SSL/TLS support
- Custom domain integration
- WAF integration

## Security Features

- AWS KMS encryption for all sensitive data
- Security groups with least privilege access
- Network ACLs for additional security
- WAF protection for web applications
- HTTPS enforcement
- Private subnets for workload isolation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or feedback, please open an issue in the