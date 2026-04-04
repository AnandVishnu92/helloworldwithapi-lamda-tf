.PHONY: help init plan apply destroy fmt validate test clean

help:
	@echo "Available commands:"
	@echo "  make init      - Initialize Terraform working directory"
	@echo "  make plan      - Generate and show an execution plan"
	@echo "  make apply     - Apply the Terraform configuration"
	@echo "  make destroy   - Destroy the infrastructure"
	@echo "  make fmt       - Format Terraform configuration files"
	@echo "  make validate  - Validate the Terraform configuration"
	@echo "  make test      - Test the deployed API"
	@echo "  make clean     - Clean up generated files"

init:
	terraform init

plan: package
	terraform plan -out=tfplan

apply: package
	terraform apply tfplan

destroy:
	terraform destroy

fmt:
	terraform fmt -recursive

validate:
	terraform validate

package:
	zip -j lambda_function.zip index.py

test:
	@API_ENDPOINT=$$(terraform output -raw api_endpoint); \
	echo "Testing API endpoint: $$API_ENDPOINT"; \
	curl -s "$$API_ENDPOINT" | jq .

clean:
	rm -f lambda_function.zip tfplan
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate terraform.tfstate.*
