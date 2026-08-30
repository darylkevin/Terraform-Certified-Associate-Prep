# Chatper 4 - Basic Workflow Commands

## `terraform init`

```
terraform init <init_options>
```

- Init needs to be run again if provider and module version is changed
- `-input=true` (will get prompt if some inputs for backend are missing)
- `-input=false` (will just error out directly if some inputs for backend are missing)
- `-upgrade` ignores lock file and upgrades modules or providers to match the version constraints in the configuration
- `-lock=false` will disable locking
- `-lock-timeout=<duration>` will release lock for `<duration>` (unit is in seconds?). Defaults to `0` (will keep the lock from the very beginning)
- `-from-module=<location>` - to init module from external source
- `get=false` - disable modules downloading
- `-migrate-state` = migrate state files to new backend

---

## `terraform plan`

```
terraform plan <plan-options>
```

- Just to show the changes, no real-world infrastructure execution
- `-refresh-only` - only to sync with the current state, including those made outside Terraform (like people going to AWS management console directly to do some changes)
- `-refresh=false` - will be quicker but Terraform will not make outside API calls to sync changes
- `-target=<RESOURCE_ADDRESS>` or `-replace=<RESOURCE_ADDRESS>` - to specifically target or replace provided resource that matches the address
- `-detailed-exit-code` - `0`: success with no changes, `1`: error, `2`: success with changes
- `-json`: stdout in json
- `-out=<filename>` - saves result in different file (`filename.tf`)

---

## `terraform apply`

```
terraform apply
```

**2 modes:** auto-plan and saved-plan
- **auto-plan:** will always execute plan again and then ask for prompt to apply
- **saved-plan:** will not execute plan, it will just run the previous plan done (to a file) and apply it. For this reason the plan options cannot be specified

Options:
- `-auto-approve`: skip prompt to continue
- `-compact-warnings`: compact the warnings
- `-state=<PATH>` - refer to different state to execute the apply. Defaults to `.tfstate`
- `-backup=<PATH>` - backup the state before doing apply (which will modify the state file afterwards)

---

## `terraform destroy`

```
terraform destroy
```

- Destroys all resources managed by the configuration
- Equivalent to `terraform apply -destroy`
- Can do `terraform plan -destroy` to see the plan for destroying (with no destroy execution)

---

## `terraform fmt`

```
terraform fmt
```

- Changes will be bold
- `-list=false` - will not list files that are not properly formatted
- `-check` - exit code `0`: all good, `1`: some needs to be formatted
- `-rewrite=false` (used with `check`) - just to check but don't rewrite
- `-diff`: show the diff
- `-recursive`: do the fmt to all subdirectories recursively for all `.tf` files. Default is only on current working directory

---

## `terraform validate`

```
terraform validate
```

- Checks for syntax error and inconsistencies
- Does not call providers or API
- Requires `terraform init` to be executed first

---

## `terraform login` / `terraform logout`

```
terraform login
terraform logout
```

- Defaults to HCP Terraform `app.terraform.io`
- It will retrieve the API token and store to `credentials.tfrc.json`
- Then Terraform will interact with the host using the API token
- For logout, it only removes the local API token; the API token itself needs to be revoked **manually** in the remote server

---

## `terraform console`

```
terraform console
```

- To play around with expression and built-in functions
- If state file is not empty, it will lock the state file during the console operation
- Can point to different state using `-state` flag, such as when you have a separate backend
- To exit, use `Ctrl+C` or `Ctrl+D` or `exit`
- Once exited, lock file for state will be released

---

## `terraform graph`

```
terraform graph
```

- Generates a visual representation of a configuration or execution plan in DOT format
- The output can be converted into an image using tools like Graphviz: `terraform graph | dot -Tsvg > graph.svg`
- Useful for understanding dependencies between resources

---

## `terraform output`

```
terraform output <output_options> OUT_VARNAME
```

- By default will output all outputs if no `OUT_VARNAME` is specified
- If `OUT_VARNAME` is specified, it will only output that
- Need to be careful if outputting sensitive information — do `sensitive = true` in the output block to do masking
- Can output to `-json` or `-raw`
