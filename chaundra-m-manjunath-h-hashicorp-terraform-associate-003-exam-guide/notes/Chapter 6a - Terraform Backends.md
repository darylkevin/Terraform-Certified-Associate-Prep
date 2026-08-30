# Chapter 6a - Terraform Backends

Terraform Backends => location where state files are stored

- Can be configured with `backend` block
- Default is **local** backend, simply stores state files in pwd
- Backend configuration is stored under `.terraform/terraform.tfstate`
- Creds can be passed directly via backend block, or via `-backend-config` flag in `terraform init` command, or by using env var (preferred as creds not written in the state file)
- Cannot use input variables, `locals` or data source attributes in backend block

```hcl
terraform {
    backend "s3" { # Here s3 is a backend type, this list is limited and not free text
        bucket = "tf-state-bucket-query"
        key = "dev/accounting/key"
        region = "us-east-1"
    }
}
```

---

## Partial Configuration

If you don't know yet what backend(s) or you want dynamic value, you can use partial configuration by:

- **File**: specify `*.backendname.tfbackend` and refer using `-backend-config`
- **Command key/value pairs**: specify `-backend-config=KEY=VALUE` in `terraform init`
- Therefore possible to have empty backend block (i.e. `terraform { backend "s3" {} }`)

---

## Types of Backends

### 1. Local

- `path`: `terraform.tfstate` file
- `workspace_dir`: path to non-default workspace (optional)
- `-state=<FILENAME>`: overwrites default state filename during **READ**
- `-state-out=<FILENAME>`: overwrites default state filename during **WRITE**
- `-backup=<FILENAME>`: overwrites backup filename local backend will use

### 2. Remote

- Basically for backend config in HCP Terraform cloud
- Can use `cloud{}` block instead of `backend{}` block
- Hostname defaults to `app.terraform.io`

### 3. S3

Common parameters:
- `bucket`
- `key`
- `dynamodb_table` (AWS native relational DB, optional)
- `region`
- `shared_credentials_file`
- `profile`
- `endpoint`
- `access_key` / `secret_key` (if not set, use shared credentials file)
- `dynamodb_endpoint`
- `iam_endpoint`

### 4. HTTP

- Using **GET** (to fetch), **POST** (to update) and **DELETE** (to delete) state files
- HTTP code `200` for success, `423` for locked, `409` for conflict when state file is locked
- `address` (mandatory)
- `update_method` (default POST)
- `lock_address` / `unlock_address`
- `lock_method` / `unlock_method`
- `username` and `password` (HTTP basic authentication)
- `skip_cert_verification`
- `retry_wait_min` / `retry_wait_max` / `retry_max`
- `client_certificate_pem` / `client_private_key_pem` / `client_ca_certificate_pem`

### 5. pg (Postgres v10+)

- `conn_str` (with explicit user:pass)
- Or use `PGUSER` and `PGPASSWORD` env var (or any env started with `PG`)
- Table name will be `states`, each row will be each unique workspace
- `schema_name`: default is `terraform_remote_state`
- If all is set you can skip:
    - `skip_schema_creation`
    - `skip_table_creation`
    - `skip_index_creation`

### 6. Kubernetes

- Utilize k8s secret to manage states (no more than 1MB tho)
- `config_path`: points to kubeconfig file
- `secret_suffix`: secret name will be `tfstate-{workspace-name}-secret_suffix`
- Other labels like: `namespace`, `host`, `username`/`password`, `insecure`, `client_certificate`/`key`, etc.

### 7. Consul

- HCP native tool for identity-based netpol
- `address`: DNS name for Consul server
- `scheme`: HTTP or HTTPS
- `path`: path to key-value store
- `access_token`, `http_auth`, `gzip`, `datacenter`, `lock`, `ca_file`/`key_file`

### 8. Azurerm

- Blob storage by Azure
- `storage_account_name`
- `container_name`
- `key` (mandatory)
- `environment`, `endpoint`, `metadata_host`, `snapshot`

### 9. cos (Cloud Object Storage) - Tencent Cloud

- `TENCENTCLOUD_*` for env vars

### 10. gcs (Google Cloud Storage) - Google Cloud

### 11. oss (Object Storage Service) - Alibaba Cloud
