# retail-apim-lab

Terraform + Azure Functions lab for a retail API scenario.

## Repository Structure

- `infra/`: Terraform root and reusable modules (`apim`, `function-app`, `service-bus`, `application-gateway`, ...)
- `apis/product-api/`: Node.js Azure Function app
- `scripts/`: helper scripts (for example, queue test message publisher)
- `.github/workflows/`: GitHub Actions pipelines
- `.gitlab/ci/`: GitLab CI pipeline jobs

## CI/CD Options

This repo now supports both platforms:

1. **GitHub Actions**
   - `.github/workflows/terraform.yml`
   - `.github/workflows/function-deploy.yml`

2. **GitLab CI/CD**
   - `.gitlab-ci.yml`
   - `.gitlab/ci/terraform.yml`
   - `.gitlab/ci/function-deploy.yml`

For GitLab setup and variables, see `README.gitlab-ci.md`.

## Notes

- Resource names are often suffix-based (for uniqueness).
- Prefer referencing Terraform outputs and CI variables instead of hardcoding resource names in pipelines.

