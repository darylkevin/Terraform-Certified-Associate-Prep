# Chapter 5 - Terraform Modules

## Module Classification

Based on entrypoint (where user executes `terraform xxx` command):
- **Root module** -> `variables.tf` as the real values to be passed for the child module
- **Child module** (subfolders) -> `variables.tf` as a template for input type (parameterization)

Based on where the configuration files are stored/installed:
- **Remote module**
- **Local module**

Based on how they are published:
- **Private module** (e.g. HCP Terraform private registry)
- **Public module** (e.g. Terraform Registry)

---

## Key Concepts

- When people talk about "modules" — it typically means a child module (and remote module like those in AWS).
- Run `terraform init` to download the modules if it is a remote module; otherwise `modules.json` will be created in the local filesystem. Can also be used to detach the module after you delete the module folder.
- Run `terraform init -upgrade` to enable Terraform to download the latest changes.
- Always aim for **verified modules** as they are reviewed by HashiCorp directly for compatibility with the Terraform core.
- Child modules inside child modules -> **nested module**.
- Use **relative path** to define a local child module (as absolute path will only work on your PC!).

---

## Module Syntax

```hcl
module "vpc" {   # <-- this is the local name
  source  = "../vpc-module/"   # <-- mandatory
  # If remote: <namespace>/<name>/<provider>, e.g. hashicorp/consul/aws
  # If private: begins with terraform-<provider>-<name>
  version = "version number"
  # To target specific tag, branch, SHA-1 hash:
  # e.g. git::http://host/repo.git?ref=<branch/tag/commithash>
  ...
}
```

---

## Remote Module Sources

Remote modules can come from:
- **Terraform Registry**
- **VCS** (GitHub, GitLab, Bitbucket)
- **HTTP URLs**
- **S3 buckets**
- **GCS buckets**
- etc.

### Key Parameters to Verify a Module in Terraform Registry

- How old is it?
- How active (how many downloads in the last week or month)?
- Versions
- Is it getting frequent commits? (in the case of repository basis)
- Number of contributions, stars, pull requests, issues, etc.

---

## Important Rules

- All values in child modules **cannot** be used by the root modules **except** if they are explicitly outputted (preferably in `outputs.tf`).
- You can also make a **customized module** on top of a module to create another abstraction that would cater to customization needs.

---

## Tools

Easily generate Terraform docs here: <https://terraform-docs.io/>
