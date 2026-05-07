# Chapter 5b - Version Pinning Operators

Terraform supports various operators for version constraints:

| Operator | Description                                                  |
|:--------:|--------------------------------------------------------------|
| `=`      | Equal to a specific version                                  |
| `!=`     | Not equal to a specific version                              |
| `>`      | Greater than a specific version                              |
| `>=`     | Greater than or equal to a specific version                  |
| `<`      | Less than a specific version                                 |
| `<=`     | Less than or equal to a specific version                     |
| `~>`     | **Pessimistic constraint** — only allow patch upgrades (`fixed.fixed.*`) if defined as `major.minor.patch`, otherwise the rightmost part can increment (e.g. `fixed.*`) |
