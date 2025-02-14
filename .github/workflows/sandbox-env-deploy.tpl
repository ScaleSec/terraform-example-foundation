name: "Execute Sandbox Env Terraform Config"
on:
  push:
    branches: [main]
    paths:
      - 2-environments/sandbox/*.tf*
      - 2-environments/sandbox-env.tfvars
      - 2-environments/modules/env_baseline/*.tf*
      - .github/workflows/sandbox-env-deploy.yml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - id: checkout
        name: Checkout
        uses: actions/checkout@v2
      - id: 'auth'
        name: 'Authenticate to Google Cloud'
        uses: 'google-github-actions/auth@v0.5.0'
        with:
          token_format: 'access_token'
          workload_identity_provider: WIF_PROVIDER_ID
          service_account: SERVICE_ACCOUNT
      - id: 'apply'
        name: 'Terraform Apply - Sandbox Env'
        uses: docker://gcr.io/cloud-foundation-cicd/cft/developer-tools:1.0
        with:
          entrypoint: /bin/bash
          args: -c "export GOOGLE_OAUTH_ACCESS_TOKEN=${{ steps.auth.outputs.access_token }} && cd 2-environments/sandbox/baseline && terraform init && terraform apply -var-file=env-baseline.tfvars -var-file=sandbox-env.tfvars -auto-approve"
