# Chapter 8b - More on CIDR and Subnets

## Usable Hosts Formula

```
Usable hosts = 2^(32 - prefix) - 2
```

The `-2` is because: first address = network address, last address = broadcast address.

| Prefix | Host bits | Total | Usable |
|--------|-----------|-------|--------|
| `/8`   | 24        | 16M   | 16M-2  |
| `/12`  | 20        | 1M    | 1M-2   |
| `/16`  | 16        | 65536 | 65534  |
| `/20`  | 12        | 4096  | 4094   |
| `/24`  | 8         | 256   | 254    |
| `/28`  | 4         | 16    | 14     |

> **NOTE:** AWS reserves 5 addresses per subnet (not 2). But for the Terraform exam, the standard formula (minus 2) is what they test.

---

## cidrhost(prefix, hostnum)

Just picks a specific host IP from a network. Counts from the start.

```hcl
cidrhost("10.0.0.0/8", 0)   = "10.0.0.0"
cidrhost("10.0.0.0/8", 1)   = "10.0.0.1"
cidrhost("10.0.0.0/8", 2)   = "10.0.0.2"
cidrhost("10.0.0.0/8", 256) = "10.0.1.0"   # overflows into next octet
```

---

## cidrnetmask(prefix)

Converts the `/` number into dotted subnet mask. Direct conversion, no calculation.

```
/8  -> 255.0.0.0        (8 bits on)
/12 -> 255.240.0.0      (12 bits on)
/16 -> 255.255.0.0      (16 bits on)
/24 -> 255.255.255.0    (24 bits on)
/28 -> 255.255.255.240  (28 bits on)
```

Each `255` = 8 bits fully on. Partial octets are where it gets tricky. For `/12`:

```
First 8 bits  = 11111111 = 255
Next 4 bits   = 11110000 = 240
Remaining     = 00000000 = 0, 0
-> 255.240.0.0
```

---

## cidrsubnet(prefix, newbits, netnum)

**KEY RULE:** final prefix = original prefix + newbits

`newbits` is **NOT** the final prefix — it's what you **ADD**.

### Example 1: `cidrsubnet("10.0.0.0/16", 8, 1)` = `"10.0.1.0/24"`

1. Start with `/16` — the network is `10.0.x.x`
2. Add 8 newbits → now it's `/24` — the network is `10.0.X.x` (only last octet for hosts)
3. Those 8 new bits give you `2^8 = 256` possible subnets (numbered 0–255)
4. `netnum = 1` picks subnet #1

```
netnum 0 -> 10.0.0.0/24
netnum 1 -> 10.0.1.0/24   <-- this one
netnum 2 -> 10.0.2.0/24
netnum 3 -> 10.0.3.0/24
...
```

### Example 2: `cidrsubnet("10.0.0.0/16", 4, 3)` = `"10.0.48.0/20"`

1. `/16 + 4 = /20`
2. 4 new bits → `2^4 = 16` possible subnets
3. Each `/20` subnet = 4,094 usable hosts
4. Subnet #3 starts at `10.0.48.0`
   Each subnet jumps by 16 in the third octet: `0, 16, 32, 48, 64...`

**How to get the jump size:**

The third octet is 8 bits. Bits are ordered left-to-right, most significant first:

```
Bit position:  [1]  [2]  [3]  [4]  [5]  [6]  [7]  [8]
Value:         2^7  2^6  2^5  2^4  2^3  2^2  2^1  2^0
               128  64   32   16   8    4    2    1
```

`newbits` borrows from the **LEFT**, the **REMAINING** bits on the **RIGHT** determine jump size.

```
Third octet with newbits=4: [X X X X] [_ _ _ _]
                             borrowed  remaining
- Borrowed (4 bits) -> 2^4 = 16 possible subnets
- Remaining (8-4=4 bits) -> 2^4 = 16 jump size

Third octet with newbits=6: [X X X X X X] [_ _]
                             borrowed      remaining
- Borrowed (6 bits) -> 2^6 = 64 possible subnets
- Remaining (8-6=2 bits) -> 2^2 = 4 jump size
```

### Exam Shortcut

1. **Final prefix** = original + newbits → e.g. `/16 + 6 = /22`
2. **Jump size** = `2^(8 - newbits)` → e.g. `2^(8-6) = 2^2 = 4`
3. **Starting octet** = `netnum × jump size` → e.g. `3 × 4 = 12`
4. **Answer** → e.g. `10.0.12.0/22`

### Example 3: `cidrsubnet("10.0.0.0/16", 6, 3)` = `"10.0.12.0/22"`

1. `/16 + 6 = /22`
2. Jump size = `2^(8-6) = 2^2 = 4`
3. `3 × 4 = 12`
4. → `10.0.12.0/22`

```
netnum 0  -> 0 × 4 = 0   -> 10.0.0.0/22
netnum 1  -> 1 × 4 = 4   -> 10.0.4.0/22
netnum 2  -> 2 × 4 = 8   -> 10.0.8.0/22
netnum 3  -> 3 × 4 = 12  -> 10.0.12.0/22   <-- this one
...
netnum 63 -> 63 × 4 = 252 -> 10.0.252.0/22
```

---

## cidrsubnets(prefix, newbits...)

Same as `cidrsubnet` but does **MULTIPLE** at once, placed back to back with no gaps.

```hcl
cidrsubnets("10.0.0.0/16", 8, 8, 8) = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
```

Equivalent to calling `cidrsubnet` three times with netnum 0, 1, 2.

When `newbits` differ, Terraform places them back-to-back (each starts where the previous ended). Finding the IP is the hard part. Here's the method:

### Step 1 — Get the SIZE of each subnet in addresses

```
Size = 2^(32 - final_prefix)
```

### Step 2 — Stack them

First starts at address #0, each next = previous start + previous size.

### Step 3 — Convert address number to IP

Since base is `10.0.0.0/16`, the `"10.0"` is fixed. The address number fills the 3rd and 4th octets:

```
Third octet  = address / 256   (integer division)
Fourth octet = address mod 256 (remainder)
```

### Worked Example: `cidrsubnets("10.0.0.0/16", 4, 8, 12)`

**Step 1 — sizes:**

```
Subnet 1: /16+4  = /20 -> 2^(32-20) = 2^12 = 4096 addresses
Subnet 2: /16+8  = /24 -> 2^(32-24) = 2^8  = 256 addresses
Subnet 3: /16+12 = /28 -> 2^(32-28) = 2^4  = 16 addresses
```

**Step 2 — stack:**

```
Subnet 1: starts at #0
Subnet 2: starts at #4096    (0 + 4096)
Subnet 3: starts at #4352    (4096 + 256)
```

**Step 3 — convert to IP:**

```
Subnet 1: #0    -> 0 / 256    = 0  remainder 0  -> 10.0.0.0
Subnet 2: #4096 -> 4096 / 256 = 16 remainder 0  -> 10.0.16.0
Subnet 3: #4352 -> 4352 / 256 = 17 remainder 0  -> 10.0.17.0
```

**Final answer:**

```
["10.0.0.0/20", "10.0.16.0/24", "10.0.17.0/28"]
```
