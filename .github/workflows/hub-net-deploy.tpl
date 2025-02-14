name: "Execute Hub Network Terraform Config"
on:
  push:
    branches: [main]
    paths:
      - 2-environments/hub/network/*.tf
      - 2-environments/hub/network/common-network.tfvars
      - 2-environments/hub-network.tfvars
      - modules/dedicated_interconnect/*.tf*
      - modules/hierachical_firewall_policy/*.tf*
      - modules/partner_interconnect/*.tf*
      - modules/restricted_shared_vpc/*.tf*
      - modules/shared_vpc/*.tf*
      - modules/transitivity/*.tf*
      - modules/vpn-ha/*.tf*
      - .github/workflows/hub-net-deploy.yml
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
        name: 'Terraform Apply - Hub Net'
        uses: docker://gcr.io/cloud-foundation-cicd/cft/developer-tools:1.0
        with:
          entrypoint: /bin/bash
          args: -c "export GOOGLE_OAUTH_ACCESS_TOKEN=${{ steps.auth.outputs.access_token }} && cd 2-environments/hub/network && terraform init && terraform apply -var-file=hub-network.tfvars -var-file=common-network.tfvars -auto-approve"
