#!/bin/bash

# Script to set up AWS credentials for Terraform deployment
# This script helps configure AWS credentials with proper permissions

echo "🔧 AWS Credentials Setup for Terraform Deployment"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first:"
    echo "   curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'"
    echo "   unzip awscliv2.zip"
    echo "   sudo ./aws/install"
    exit 1
fi

echo "📋 Current AWS configuration:"
aws configure list

echo ""
echo "🔑 To fix the permission errors, you have several options:"
echo ""

echo "Option 1: Use AWS Administrator Access (Easiest)"
echo "   If you have admin access, use those credentials:"
echo "   aws configure"
echo ""

echo "Option 2: Create a new IAM user with proper permissions"
echo "   1. Go to AWS IAM Console"
echo "   2. Create a new user (e.g., 'terraform-user')"
echo "   3. Attach these managed policies:"
echo "      - IAMFullAccess"
echo "      - AWSLambda_FullAccess"
echo "      - AmazonAPIGatewayAdministrator"
echo "      - CloudWatchLogsFullAccess"
echo "   4. Create access keys for the user"
echo "   5. Run: aws configure"
echo ""

echo "Option 3: Use existing credentials with sufficient permissions"
echo "   Switch to a different AWS profile:"
echo "   aws configure --profile admin-profile"
echo "   export AWS_PROFILE=admin-profile"
echo ""

echo "Option 4: Use PowerUserAccess (Recommended for development)"
echo "   Attach 'PowerUserAccess' managed policy to your IAM user"
echo ""

echo "📄 A custom IAM policy has been created: iam-policy.json"
echo "   You can use this if you prefer granular permissions."
echo ""

echo "⚡ Quick test - check your current permissions:"
echo "   aws iam get-user"
echo ""

echo "🚀 Once credentials are configured, run:"
echo "   terraform plan"
echo "   terraform apply"