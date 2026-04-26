# Chapter 3 - Getting Started with Terraform

**Providers block**: the block that has internal details for cloud API interactions

```
Terraform -> Terraform Provider -> Target API
```

**Terraform configuration**: basically `.tf` files, the files where you describe the infra in Terraform

## Common Terraform Blocks

- `terraform`
- `provider`
- `resource`
- `variable`
- `output`
- `locals`
- `module`

**Nested blocks**: the blocks inside a block

## `terraform init` (`-upgrade`)

- Downloads all configuration scripts related to the declared providers and versions.
- Creates `.terraform` dir (loads the binary for the version given)
- Creates `.terraform.lock.hcl` (specifies providers (not modules!) exact version used)
- `-upgrade`: overrides locked versions.

## `terraform validate`

- Checks for terraform configuration error

## `terraform fmt` (`-recursive`)

- Consistent formatting and linting.
- `-recursive`: will format beyond subfolders

## `terraform apply`

- First creates execution plan
- Manual intervention: need to type `yes` to carry on
- Some parameters will be 'known after apply', as they will be known only after the resources are created

## `.terraform` Directory

Stores most recent backend setup and its associated credentials. Should **NOT** be committed to any version control tools.

## State Management

- `terraform.tfstate`: acts as the memory, stores all details about resources so it can update and destroy going forward
- `terraform state list`: advanced state management; `list` arg will list out all resources created with the current configuration

## `backend` Block

- To store and manage `terraform.tfstate` files in dedicated storage/directory (say for collaboration purposes)
- Defaults to local, which is the current working directory
- Cannot contain variables, locals and data sources.

```hcl
terraform {
    backend "<backend-type>" {
        ...
    }
}
```

### Partial Configuration

Injects variables at runtime, useful if you want to have multi-env setups:

```bash
terraform init -backend-config="key=DEV/data/"
terraform init -backend-config="region=us-east-1"
```

## Version Constraints

- `required_version` nested block: for Terraform CLI version.
- `required_providers` nested block: for cloud version constraint.

## Terraform Providers

List of Terraform providers: <https://registry.terraform.io/browse/providers>

### Provider Badges

- **Official providers**: created and maintained by HashiCorp (ALWAYS begins with `hashicorp/<provider_name>`, e.g. `hashicorp/aws`, `hashicorp/kubernetes`, `hashicorp/helm`)
- **Partners**: Written by third party companies (e.g. OCI, Alibaba Cloud)
- **Community**: individual/group maintainers, no badge.
- **Archived**: No longer maintained by either HashiCorp or community, due to APIs deprecation or interest declines

### Required Providers

- **local name** (e.g. `"aws"`): it is a convention to use the cloud provider as the local name, tho you can technically use any names
- **source**: address for Terraform to download resources (e.g. `"hashicorp/aws"`)

```
hostname/namespace/localname -> registry.terraform.io (default)/hashicorp/aws
```

Hence if we only defined the local name under required providers, it is implicitly defined that the hostname will be `registry.terraform.io` and namespace will be `hashicorp`.

```hcl
provider "aws" {
    region = ...
    access_key = ...
    secret_key = ...
}
```

Region, access key and secret key can also be defined under environment variables.

`required_providers` source: `hashicorp/random` -> dummy configuration, no need provider block.

## Resource Block

```hcl
resource <resource_type> <resource_local_name> {
    <attribute_name> = ...
    <attribute_name> {
        ...
    }
}
```

To refer to other configuration values: `<resource_type>.<resource_name>.<attribute_name>`.

## Resources Meta-Arguments

- `depends_on`: define it in module A and set its values to refer module B. Means B needs to be setup first before A
- `count`: creates identical resource with the same definition
- `for_each`: loops through list, refer the key and value as `each.key` and `each.value`
- `provider`: meta argument with `alias` keyword, then refer it to `provider.alias` (e.g. `aws.west`, meaning two `"aws"` providers, with one of them has an alias of `west` which has different configuration (such as different region))
- `lifecycle` (boolean):
    - `create_before_destroy`: create the new resource first before destroying
    - `prevent_destroy`: prevent accidental deletion
    - `ignore_changes`: ignore future changes, probably because some resources are expected to change but should not result in recreating or updating resources
    - `replace_triggered_by`: trigger resource recreation whenever attributes are changed
- `provisioner`

## Data Sources

`data {}`: to fetch real-time data about **EXISTING** infrastructure, such as AMI ID, VPC ID, etc.

Referenced with `data.<resource_type>.<local_name>`.

## Variables

`variable {}`: to set values BEFORE infrastructures are created.

- Can be set inline: `terraform apply -var='az_list=["us-east-1a","us-east-1b"]'`
- Can be defined in `.tfvars` or `.tfvars.json` file, then referenced with `-var-file=myvar.tfvars`
- Can be looked up from env with `TF_VAR_<variable_name>`
- **Precedence**: env, `.tfvars`, `.tfvars.json`, `*.auto.tfvars` or `*.auto.tfvars.json`, `-var` and `-var-file`
- Referenced with `var.<NAME>`

## Output Values

`output {}`: expose information to other Terraform configuration, like a `return` statement.

Referenced with `module.<child_module>.<output_name>`.

## Locals

`locals {}`: to use same expression multiple times.

Referenced with `local.<NAME>`.

## Core Workflow

1. **Write**: write the code
2. **Plan**: preview the change
3. **Apply**: deploy the change
