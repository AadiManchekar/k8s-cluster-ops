# Define the environment and directories
ENV_FILE=env/.env
TERRAFORM_DIR=terraform
VARS_FILE=../environments/terraform.tfvars

# specify aws profile which was configured
export AWS_PROFILE=k8s-cluster-ops

# Default target
all: apply

# Target to initialize Terraform
init:
	cd $(TERRAFORM_DIR) && terraform init

# Target to apply the Terraform configuration
apply:
	cd $(TERRAFORM_DIR) && terraform apply -var-file=$(VARS_FILE)

# Target to plan the Terraform configuration
plan:
	cd $(TERRAFORM_DIR) && terraform plan -var-file=$(VARS_FILE)

# Target to destroy the infrastructure
destroy:
	cd $(TERRAFORM_DIR) && terraform destroy -var-file=$(VARS_FILE)

# Target to format the Terraform code
fmt:
	cd $(TERRAFORM_DIR) && terraform fmt

# Target to validate the Terraform code
validate:
	cd $(TERRAFORM_DIR) && terraform validate

.PHONY: all init apply plan destroy fmt validate env
