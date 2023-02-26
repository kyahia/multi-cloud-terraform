# Setup
This template is designed to create the following structure in AWS, GCP and AZURE:
1. a Virtual Private Netowrk.
2. 1 Public Subnet & 1 Private subnet
3. a Network Address Translator associated with an Elastic IP.
4. 2 instances on the private Subnet serving static on port 80
5. A load Balancer targetting the Instances
6. An Alarm triggered if the Load Balancer receives more than 10 requests per minute.
7. Output values of the Load Balancers DNS/publicIP for visiting the websites.

# Infrastructure deployement
For deploying the required infrastructure, follow these steps:
1. Make sure to have Azure CLI installed & logged-in on your machine, download the GCP JSON credentials file on the root directory of this project & copy access keys from AWS IAM
2. Open terraform.tfvars file & enter the credentials for each provider
3. Run "terraform init" to initialize the providers
4. Run "terraform plan" to check the resources deployment
5. Run "terraform apply" & enter "yes" when prompted to launch the deployement

# File structure for multicloud infrastructure
The global infrastructure is composed of three modules at the provider level (AWS, GCP, AZURE); i.e Each infrastructure is define within module in the project:
1. aws_solution: contain the solution for the infrastructure with aws cloud provider
2. gcp_solution: contain the solution for the infrastructure with gcp cloud provider
3. azure_solution: contain the solution for the infrastructure with azure cloud provider

Each of these solution are composed of submodules :
- Networking : to create the Private Network, Subnets & adequate configuration of routes & security groups/rules
- Compute : to create the Virtual Machines & firewalls
- Monitoring : to set the alarm based on the Load Balancer activity