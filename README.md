# deploy-plugin-on-aws-lambda

A Terraform module to deploy Connery plugins on AWS Lambda.

## Usage

1. Add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to your GitHub repository secrets.

2. Create `/connery-plugin/your-plugin-name/v1/api-key` secret (SecureString) in AWS Systems Manager Parameter Store with the API key for your plugin server.

3. Create `./infrastructure/main.tf` in the root of your plugin repository with the following content:

```hcl
module "plugin-on-aws-lambda" {
  source = "github.com/connery-io/plugin-on-aws-lambda?ref=v0.0.3"

  plugin_name    = "your-plugin-name"
  plugin_version = "v1"
}
```

4. Create `./github/workflows/deploy.yml` in the root of your plugin repository with the following content:

```yaml
name: Deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:

concurrency:
  group: deploy

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: connery-io/deploy-plugin-on-aws-lambda/run-tests@v0.0.3

      - uses: connery-io/deploy-plugin-on-aws-lambda/build-and-deploy@v0.0.3
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-central-1
```
