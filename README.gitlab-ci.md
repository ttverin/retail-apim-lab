# GitLab CI/CD Guide

This repository supports GitLab CI/CD using:
- `.gitlab-ci.yml`
- `.gitlab/ci/terraform.yml`
- `.gitlab/ci/function-deploy.yml`

## Pipeline Layout

Stages:
1. `terraform_validate`
2. `terraform_plan`
3. `terraform_apply`
4. `function_package`
5. `function_deploy`

### Terraform jobs
Defined in `.gitlab/ci/terraform.yml`:
- `terraform_validate`: `terraform init`, `terraform fmt -check -recursive`, `terraform validate`
- `terraform_plan`: creates `infra/tfplan` artifact
- `terraform_apply`: applies `tfplan` on `main` branch push

### Function jobs
Defined in `.gitlab/ci/function-deploy.yml`:
- `function_package`: builds `apis/product-api`, creates `function.zip`
- `function_deploy`: deploys zip with Azure CLI (`az functionapp deployment source config-zip`)

## Required GitLab CI/CD Variables

Set these in **Settings -> CI/CD -> Variables**.

### Azure auth (used by function deploy)
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

### Deployment target
- `AZURE_RESOURCE_GROUP`
- `FUNCTION_APP_NAME` (recommended)

If `FUNCTION_APP_NAME` is not set, the deploy job tries to resolve the first Function App in `AZURE_RESOURCE_GROUP`.

### Terraform auth (required for azurerm backend/provider)
Terraform in CI expects standard `ARM_*` environment variables:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`

## Trigger Behavior

From current `rules`:
- Validate + plan run on `push`, `merge_request_event`, and manual (`web`)
- Apply runs on `main` branch push
- Function package/deploy run on manual (`web`) and `main` branch push

## Safe Usage Recommendations

- Keep `terraform_apply` as a protected branch job only.
- Mark Azure secrets as **masked** and **protected**.
- Use manual pipelines (`Run pipeline`) for infrastructure changes when testing.
- Set a fixed `FUNCTION_APP_NAME` to avoid deploying to the wrong app.

## Optional Hardening

- Add `when: manual` for `terraform_apply`.
- Add path-based rules so function jobs run only when `apis/product-api/**` changes.
- Add separate variables/environments for `dev` and `prod`.

