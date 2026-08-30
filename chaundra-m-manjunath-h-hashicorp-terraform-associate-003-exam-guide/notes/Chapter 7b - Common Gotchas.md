# Chapter 7b - Common Gotchas

## 1. Avoid lists where possible

- Terraform uses **index** to map list elements
- Meaning `["a", "b", "c"]` is mapped to `index[0]`, `index[1]`, `index[2]`
- If changed to `["a", "c"]`, Terraform will: **DELETE** `index[2]` and rename `index[1]` from `"b"` to `"c"`
- Imagine `a`, `b`, `c` are IAM users with their own permissions — this operation will be fatal

**Solution:** Use `for_each = toset(["a", "b", "c"])` — it uses the value as the reference instead of the index.

---

## 2. Be careful when using `-target`

- `-target` will not only target the resource but also its **dependents** (resources that depend on it)
- Therefore, if we have `aws_eip` which depends on `aws_instance`, then `terraform destroy -target="aws_instance.test"` will delete both the instance **and** the elastic IP

---

## 3. Pin your versions

- Pin versions of **modules**, **providers**, and **Terraform itself**
- Prevents compatibility issues during `terraform init -upgrade`
