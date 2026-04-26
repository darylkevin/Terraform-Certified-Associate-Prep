# Chapter 4b - State Managements

`terraform state [subcommand] <state_options> <ARGUMENTS>`

Used to manage state externally and make some adjustments to accommodate changes made outside Terraform.

---

## `terraform state list`

```
terraform state list <options> <RESOURCE_ADDRESS>
```

- `-state = path to state file`, defaults to `.tfstate` in pwd
- `-id = filter by id`
- If `resource_address` is specified, will only list the resource on that address
- Resource address format: `resource_type.resource_name`

---

## `terraform state show`

```
terraform state show RESOURCE_ADDRESS
```

- `RESOURCE_ADDRESS` is required, not optional
- `-state = path to state file`, defaults to `.tfstate` in pwd

---

## `terraform state mv`

```
terraform state mv <move_options> SOURCE_RESOURCE_ADDRESS SOURCE_DESTINATION_ADDRESS
```

Example: `terraform state mv aws_iam_user.testuser aws_iam_user.preprod_user`

**Before changes:**
```hcl
resource "aws_iam_user" "test_user" {
  name = "test-aws-user"
  path = "/test/"
  . . .
}
```

**After changes:**
```hcl
resource "aws_iam_user" "preprod_user" {
  name = "test-aws-user"
  path = "/test/"
  . . .
}
```

- `-dry-run` to test before actual changes. Will report all resources in the state matching the source address

---

## `terraform state rm`

```
terraform state rm <remove_options> RESOURCE_ADDRESS
```

- Removes (and hence no longer keeps track of) the given resource address
- When doing `terraform destroy` for example, this resource will not be removed
- Resource needs to be created again to be in sync

---

## `terraform state replace-provider`

```
terraform state replace-provider FROM_PROVIDER TO_PROVIDER
```

- `-auto-approve`: will not prompt for approval

---

## `terraform state pull`

```
terraform state pull
```

Retrieves the current state.

---

## `terraform state push`

```
terraform state push <push_options> PATH_TO_REMOTE_BACKEND
```

- Manually uploads a local state file
- Terraform automatically checks for changes that are secure
- `-force` - disables checks but **not recommended**
- **OVERWRITES EXISTING REMOTE STATE WITH LOCAL VERSION** — must be used very carefully
