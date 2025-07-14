# Distributed Order Fulfillment System (DOFS)

## Overview

A production-grade, event-driven serverless system for order fulfillment using AWS Lambda, Step Functions, DynamoDB, SQS, and API Gateway. CI/CD is managed via AWS CodePipeline and Terraform.

## Architecture

See the included architecture diagram and folder structure.

## Prerequisites

- AWS CLI configured
- Terraform installed
- Python 3.9+
- GitHub repository (for CI/CD)

## Setup

1. Clone the repo and install dependencies.
2. Zip each lambda function and place the zip in the respective folder.
3. Update Terraform variables as needed.
4. Run: