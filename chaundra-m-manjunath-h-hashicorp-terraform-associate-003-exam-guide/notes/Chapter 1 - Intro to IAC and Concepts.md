# Chapter 1 - Intro to IAC and Concepts

- **Declarative** -> declare the final state as much as possible
- **Imperative** -> Step by step process of the logic

Terraform is **Declarative**.

- Good idea to use Version Control to rollback and collaboration
- **Idempotency**: Same result regardless how many times you apply the Terraform

Terraform is mainly day 1 task (provisioning of infras), tho recently it supports day 2 operations as well for configuration management.

Terraform blocks: first `{}`, like `terraform`, `provider`, `variable`, `resource`, `output`

Interesting IAC tools apart from Terraform:
- <https://www.pulumi.com/>

IAC is also good at eliminating Configuration Drift, you just apply it again in case something goes wrong

To auto-approve `terraform apply` (without typing interaction), use `--auto-approve` flag
