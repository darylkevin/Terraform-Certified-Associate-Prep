# Stack 1 - Answers

1. No
2. With the help of providers
3. Yes
4. - create_before_destroy
   - prevent_destroy
   - ignore_changes
   - replace_triggered_by
5. - Official providers
   - Partner providers
   - Community providers
   - Archived providers
6. Resources
7. - Write
   - Plan
   - Apply
8. - A cloud {} nested block inside a terraform {} block
   - A backend {} nested block inside a terraform {} block
9. - terraform init
   - terraform plan
   - terraform apply
   - terraform destroy
10. 10
11. app.terraform.io
12. To evaluate the configuration scripts and determine the desired state of the resources; the result is the creation of an execution plan
13. .terraform.lock.hcl
14. - TF_VAR_<variable_name>=<variable_value>
    - For example, TF_VAR_REGION="us-east-1"
15. - terraform state list
    - terraform state show
    - terraform state mv (for move)
    - terraform state rm (for removal)
    - terraform state replace-provider
    - terraform state pull
    - terraform state push
16. Inside the .terraform directory with nested paths for providers and registry.terraform.io such as the following: /.terraform/providers/registry.terraform.io/../..
17. The local backend
18. A terraform {} block
19. The terraform console command
20. The terraform import command
21. The terraform fmt command
22. The depends_on meta-argument
23. The count meta-argument
24. The -force-copy option
25. The -auto-approve option
