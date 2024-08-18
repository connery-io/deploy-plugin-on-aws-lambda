# deploy-plugin-on-aws-lambda

A Terraform module to deploy Connery plugins on AWS Lambda.

## Usage

1. Add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to your GitHub repository secrets.

2. Create `/connery-plugin/your-plugin-name/v1/api-key` secret (SecureString) in AWS Systems Manager Parameter Store with the API key for your plugin server.

3. Create `./infrastructure/main.tf` in the root of your plugin repository with the following content:

```hcl
module "plugin-on-aws-lambda" {
  source = "github.com/connery-io/plugin-on-aws-lambda?ref=v0.0.2"

  plugin_name    = "your-plugin-name"
  plugin_version = "v1"
}
```

4. Create `./github/workflows/main-deploy.yml` in the root of your plugin repository with the following content:

```yaml
name: (main) Deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:

concurrency:
  group: main-deploy-production

jobs:
  test:
    name: Run tests
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm run test

  deploy:
    name: Deploy
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install dependencies
        run: npm install --omit=dev

      - name: Build
        run: npm run build

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-central-1

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Initialize Terraform
        run: terraform -chdir=infrastructure init

      - name: Validate Terraform
        run: terraform -chdir=infrastructure validate

      - name: Plan Terraform
        run: terraform -chdir=infrastructure plan

      - name: Apply Terraform
        run: terraform -chdir=infrastructure apply -auto-approve
```
