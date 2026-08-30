# Chapter 7a - Debugging and Troubleshooting Terraform

## Configuration Errors

- `override.tf`: resource written in this file will overwrite the configuration in main terraform files
- `terraform validate`:
    - Syntactically checks code correctness defined in the configuration file. Does **not** access any remote services/provider APIs
    - Stops validating once it catches an error

---

## Variable-related Issues

### Type Constraint

- You can enforce typing using `type` argument in the variable block
- `terraform plan` / `terraform apply` will fail if there are incorrect types in the input variable values

### Input Validation

- Can add a `validation` block inside the variable block:

```hcl
variable "example" {
    type = string
    validation {
        condition     = ...
        error_message = "..."
    }
}
```

- All conditions need to return `TRUE` to pass the validation, otherwise `error_message` will be thrown

### Variable Precedence (low to high)

1. Environment variables (`TF_VAR_*`) — **LOWEST**
2. `terraform.tfvars`
3. `terraform.tfvars.json`
4. `*.auto.tfvars` or `*.auto.tfvars.json` (alphabetical precedence)
5. `-var=...` or `-var-file=...` — **HIGHEST**

---

## State-related Issues

### Configuration Drift (Most Common)

- Users may go to management console directly and apply changes there
- To solve this you can either:
    - Roll back and change via Terraform later, or
    - Use `terraform import <resource.id>` then fill in the resource block until the plan shows zero changes

- If you delete the resources manually, you can:
    - Remove this resource selectively from the state file to make Terraform untrack it (`terraform state rm <resource>`), or
    - Just delete the relevant code

### State Conflict

- Terraform safeguards parallel changes using **state locks**
- This means only 1 concurrent change can be applied
- You can encounter state lock during the following:
    - Multiple people doing `terraform apply`
    - Interrupted `terraform apply`
- Can do `terraform force-unlock <ID>`:

```
terraform force-unlock a2324f3-x872-09fs-b216-g87ed071284
```

---

## Migrating State from One Backend to Another

- Terraform supports migration between backends or local to remote backend
- Steps:
    1. First backup `terraform.tfstate`
    2. Update the backend configuration to the new backend
    3. Run `terraform init -migrate-state` — type `yes` to copy the state to the new backend
    4. State is now migrated to the new backend
