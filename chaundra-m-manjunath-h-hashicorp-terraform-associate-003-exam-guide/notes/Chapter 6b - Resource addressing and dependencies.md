# Chapter 6b - Resource Addressing and Dependencies

Resource addressing: ways to refer to a particular set of resources. Consists of two parts:
- Module path
- Resource specifications

---

## Module Path

```
module.module_name[module_index]
```

`module.<name_of_module>[<optional_module_index>]`

---

## Resource Specifications

```
resource_type.resource_name[instance_index]
```

`resource_type.<name_of_resource>[<optional_instance_index>]`

- `resource_type`: type of resource being provisioned
- `resource_name`: user-defined value for the resource block
- `instance_index`: to refer to a particular instance if there are multiple instances

**Example:** AWS EC2 (compute module) named `test_instance` with `count = 4`

```
module.compute.aws_instance.test_instance[1]  # Refer to second element
module.compute.aws_instance.test_instance[3]  # Refer to fourth element
```

For key-based, use quotes:

```hcl
resource "aws_instance" "web" {
    for_each = {
        "dev"  = "testinstance"
        "prod" = "prodinstance"
    }
}
```

```
aws_instance.web["dev"]
aws_instance.web["prod"]
```

---

## Resource Dependencies

### Implicit Dependency

Terraform will try its best to infer the dependency if there are multiple resources referenced in other resource blocks.

**Example:** You have two resource blocks, `aws_instance` and `aws_eip`. Terraform will create `aws_instance` first then assign the elastic IP to the instance (inferred).

### Explicit Dependency

In the case Terraform is not able to infer, we need to explicitly specify the dependency using `depends_on`.

Use `depends_on = [resource_type.name]` to explicitly state the dependency.

**Example:**

```hcl
resource "aws_s3_bucket" "appbucket" {}

resource "aws_instance" "test_instance" {
    ...
    depends_on = [aws_s3_bucket.appbucket]
}
```

In this case Terraform will create the bucket first, then create the instance.
