#!/bin/bash

# Script to package and deploy the Hello World API using Terraform

set -e

echo "🚀 Starting deployment of Hello World API with Lambda and Terraform..."

# Step 1: Package Lambda function
echo "📦 Packaging Lambda function..."
zip -j lambda_function.zip index.py

# Step 2: Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Step 3: Validate Terraform configuration
echo "✅ Validating Terraform configuration..."
terraform validate

# Step 4: Plan Terraform deployment
echo "📋 Planning Terraform deployment..."
terraform plan -out=tfplan

# Step 5: Apply Terraform configuration
echo "🚀 Applying Terraform configuration..."
terraform apply tfplan

# Step 6: Show outputs
echo "✨ Deployment complete! Here are your API details:"
terraform output

echo ""
echo "Test your API with:"
echo "  curl $(terraform output -raw api_endpoint)"
