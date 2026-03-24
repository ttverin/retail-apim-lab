# Deployment Error Fix Summary

## Issue
**Error:** `Failed to perform sync trigger on function app. Function app may have malformed content.`

## Root Cause
Your function app had conflicting v3 and v4 Azure Functions models:
- `index.js` uses modern v4 model (`@azure/functions` with `app.http()`)
- `productFunction/function.json` used legacy v3 model with explicit bindings
- Azure runtime couldn't reconcile both → treated package as malformed

## Fixes Applied

### 1. Removed Legacy v3 Files
- Deleted `apis/product-api/productFunction/function.json` (v3 legacy)
- Deleted `apis/product-api/productFunction/host.json` (duplicate, redundant)

### 2. Added Proper v4 Root Configuration
- Created `apis/product-api/host.json` at root level (v4 standard)
- Contains extension bundle v4 and proper logging config

### 3. Fixed local.settings.json
- Decrypted and corrected runtime: `FUNCTIONS_WORKER_RUNTIME: "node"`
- Added `AzureWebJobsFeatureFlags: "EnableWorkerIndexing"` (v4 requirement)

### 4. Current Correct Structure
```
apis/product-api/
├── host.json                 ← Root config for v4 model
├── local.settings.json       ← Local dev settings
├── package.json              ← Dependencies (@azure/functions v4)
└── productFunction/
    └── index.js              ← Function code with app.http()
```

## Deployment Workflow Issue ⚠️

Your GitHub Actions workflow hardcodes the function app name:
```yaml
app-name: func-product-pj8x7
```

But your Terraform generates names **dynamically**:
- `func-product-{randomsuffix}` from `func-${var.name}-${local.suffix}`
- Suffix changes every `terraform apply`

### Solution
Either:
1. **Update workflow to use parameterized name** (recommended):
   ```yaml
   env:
     FUNCTION_APP_NAME: func-product-${{ secrets.RESOURCE_SUFFIX }}
   ```
   Then pass `RESOURCE_SUFFIX` from Terraform outputs via secrets.

2. **Use fixed suffix in Terraform**:
   ```terraform
   variable "suffix" {
     default = "pj8x7"  # Fixed, not random
   }
   ```

3. **Query deployed function app at runtime**:
   - Use Azure CLI to find function app by resource group before deploying

## Next Steps
1. Run `terraform apply` to deploy infrastructure with the corrected suffix logic
2. Capture the actual `func-product-{suffix}` name from outputs
3. Update workflow `app-name` or add dynamic lookup
4. Re-run GitHub Actions workflow

The function code itself is now correct for v4 model deployment.

