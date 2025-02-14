name: "Execute Bootstrap Terraform Config"
on:
  push:
    branches: [main]
    paths:
      - 0-bootstrap/*.tf*
      - 0-bootstrap/modules/workload_identity_federation/*.tf*
      - .github/workflows/bootstrap-deploy.yml
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
      - id: 'apply_bootstrap'
        name: 'Terraform Apply - Bootstrap'
        uses: docker://gcr.io/cloud-foundation-cicd/cft/developer-tools:1.0
        with:
          entrypoint: /bin/bash
          args: -c "export GOOGLE_OAUTH_ACCESS_TOKEN=${{ steps.auth.outputs.access_token }} && cd 0-bootstrap/ && terraform init && terraform apply -var-file=bootstrap.tfvars -auto-approve"
