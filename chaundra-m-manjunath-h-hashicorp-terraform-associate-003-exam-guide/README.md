# Terraform Associate — Mock Exam Suite

## What's Here

### Mock Exams
| Mock | Questions | Source | Type |
|------|-----------|--------|------|
| Mock 1 | 50 | EBook (Chandra & Manjunath, Packt 2024) | Text-parsed |
| Mock 2 | 57 | EBook (Chandra & Manjunath, Packt 2024) | Text-parsed |
| Mock 3 | 55 | PDF (IP Specialist, 2023) Q1–55 | PDF-parsed |
| Mock 4 | 55 | PDF (IP Specialist, 2023) Q56–110 | PDF-parsed |
| Mock 5 | 55 | PDF (IP Specialist, 2023) Q111–165 | PDF-parsed |
| Mock 6 | 55 | PDF (IP Specialist, 2023) Q166–220 | PDF-parsed |
| Mock 7 | 55 | PDF (IP Specialist, 2023) Q221–275 | PDF-parsed |
| Mock 8 | 19 | PDF (IP Specialist, 2023) Q276–294 | PDF-parsed |
| **Total** | **401** | | |

Open `mock-exams/mock-exam-ui.html` in any browser — no server needed.

### External Mock Links (for future scraping)
Stored in `mock-exams/others/links.txt`:
1. https://examos.io/free-practice-exam/terraform-associate-ta-004 — 15 free TA-004 questions
2. https://www.savemycert.com/mocks/terraform-associate/ — 3 full 004 mocks (57q each, account required)
3. https://certempire.com/practice-tests/free-terraform-associate-004-practice-questions/ — 20 free qs visible, 359 total behind paywall
4. https://www.exams4success.com/terraform-associate-004/practice-questions — 359 questions, partial free access

---

## 003 → 004 Transition

### Timeline
- **Jan 7, 2026**: 003 retired
- **Jan 8, 2026**: 004 launched (aligned to Terraform 1.12)

### What Your 003 Book Already Covers

The [Chandra & Manjunath 003 book](hashicorp-terraform-associate-003-exam.pdf) **Chapter 10 ("Miscellaneous Topics")** covers these 004-relevant topics:
- ✅ Input validations (`validation {}` block)
- ✅ Preconditions and postconditions (with code examples)
- ✅ `check {}` block (with code examples)
- ✅ CLI workspaces
- ✅ Dynamic blocks
- ✅ Provisioners
- ✅ Handling sensitive data (`sensitive = true`, Vault)

### What's Truly New (Not in Your 003 Book)

| Topic | What It Is |
|-------|------------|
| **`ephemeral {}` block** | Values that never persist to state or plan files — for short-lived secrets/tokens |
| **Write-only arguments** | Provider-level args you can set but never read back; reading returns null |
| **`moved {}` block** | Refactors state by telling Terraform "this resource moved to this new address" |
| **`removed {}` block** | Tells Terraform "stop tracking this resource but don't destroy it" |
| **`import {}` block** | Modern replacement for CLI `terraform import` — declarative import in HCL |
| **`create_before_destroy`** | Lifecycle rule for zero-downtime replacements — not covered in depth in the 003 book |
| **HCP Terraform projects** | Formal organizational grouping above workspaces — the 003 book only touches permissions, not projects as exam topic |
| **Deprecated command awareness** | `terraform taint` → `-replace`, `terraform refresh` → `-refresh-only` |

### Recommended Study Resources (Free)

1. [Official HashiCorp 004 Learning Path](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-study-004)
2. [Official Exam Content List 004](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)
3. [Official Sample Questions 004](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-questions-004)
4. [Custom Conditions Tutorial](https://developer.hashicorp.com/terraform/tutorials/configuration-language/custom-conditions)
5. [Ephemeral Values Docs](https://developer.hashicorp.com/terraform/language/v1.12.x/manage-sensitive-data)
6. [Medium: 004 Guide by Hakan Bayraktar](https://hbayraktar.medium.com/hashicorp-terraform-associate-004-exam-guide-6dc04486c8c4) — covers everything incl. practice questions
7. [Whizlabs 004 Prep Guide](https://www.whizlabs.com/blog/hashicorp-terraform-associate-004-prep-guide/)

### Recommended Paid Practice
- [Udemy: Bryan Krausen 004 Practice Exams](https://www.udemy.com/course/new-hashicorp-certified-terraform-associate-004-cert-exams/) — industry standard

### Estimated Prep Time (003 → 004)
~2 weeks focused on the 4 truly new topics above + HCP Terraform projects, assuming strong 003 foundation.