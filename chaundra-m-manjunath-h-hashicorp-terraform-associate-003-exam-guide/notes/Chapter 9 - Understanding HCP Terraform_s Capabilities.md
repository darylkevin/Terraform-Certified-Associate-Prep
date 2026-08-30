# Understanding HCP Terraform's Capabilities

HashiCorp provides the following editions of Terraform:

- Community
- HCP Terraform (old name: Terraform Cloud) (Free (Up to 500 managed resources), Standard, Plus)
- Terraform Enterprise

## Shortcomings of Terraform Community Edition

- State files are stored locally by default (need version control to collaborate)
- No state file locking by default
- No private modules
- No policy as code
- No GUI
- No SSO
- No production supports

## HCP Terraform Features

- GUI (gives detailed view of the resources managed by Terraform)
- <https://app.terraform.io>
- Remote environment that runs Terraform and securely stores state and secrets
- Has state file history (state files are versioned)
- Can do CI/CD (a push to VCS repository will trigger runs in the respective workspaces)
- Execution can be done locally, remotely (review Terraform runs with colleagues), or agent (in case of private/isolated environments)
- Can publish private modules (naming convention: `terraform-PROVIDER-NAME` (e.g. `terraform-aws-eip`, `terraform-gcp-vault`))
- Send notifications to other systems, such as Slack, or any other service that accepts webhooks
- Run tasks (<https://registry.terraform.io/browse/run-tasks>), RBAC, Policy Enforcement
- Cost estimation (by default it is disabled, need to enable this in the organization's settings)

## HCP Terraform Pricing

- **HCP Free** (up to 500 managed resources, calculated where the resource in a state file is `mode = managed`. Does not count `null_resource` or `terraform_data`)
- **HCP Standard** (pay after 500 managed resources)
- **HCP Plus**
- More details on <https://www.hashicorp.com/products/terraform/pricing>

## Key Concepts of HCP Terraform

- Organization → \[ Project 1, Project 2 \[ Workspace 1, Workspace 2, Workspace 3 \], Project 3 \]
- Workspace in HCP Terraform is **not** the same as Workspace in Terraform CLI

## Permissions

- Define to an organization/project/workspace
- Then you put the users in the organization/project/workspace
- **Fixed permission sets:** admins, write, plan (propose changes), read (view status and config only)
- **Custom permission:** more granular requirement

## Locking Workspaces

- Freeze UI, CLI, API, any automated system, completely freezing production environment

## Sentinel Policies

- **Advisory:** just a warning
- **Soft mandatory:** run is stopped, but can be overridden and continue
- **Hard mandatory:** run is stopped until the user fixes the issue

## Explorer

- To keep track of all your infrastructure objects
- **Types:** Get information about modules, providers, workspaces and terraform versions
- **Use cases:** Details about `top module versions (usage frequency of top modules)` and `top provider versions (usage frequency of top providers)`
- Displays the results in tabular format

## HCP Terraform Demo (page 236-264)

## Migrating to HCP Terraform or Terraform Enterprise

- Fill the `cloud` block under `terraform` block — Mandatory values: `organization`, `workspaces`, and optional arguments: `hostname`, `project`, `name`
- **VCS-integrated workspace:** any pull request to the repository will trigger a **Speculative Plans**. These are plan-only runs, never be applied, will only show the changes that your infrastructure will undergo due to the latest change in the configuration code

## Terraform Enterprise Features
