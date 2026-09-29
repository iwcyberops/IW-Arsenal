<!-- =========================================================================
   PROJECT: IW Cyber Ops — Arsenal Vault (Systems & Automation Engineering)
   AUTHOR: Muhammad Imran Wakeel | IW Cyber Ops (@iwcyberops)
   TRACK: 42-Month Systems & Cyber Operations Research
   MODULE: Phase 01 — Month 01: Linux Automation & Lab Engineering
   DOCUMENT: Tool 02 — Text to Decimal ASCII Transcoding Engine
   ========================================================================= -->

# 🔢 Tool 02: Text to Decimal ASCII Transcoding Engine

> **IW Cyber Ops Arsenal | Phase 01: Foundations & Systems Architecture**  
> *Author: Muhammad Imran Wakeel (@iwcyberops)*  
> *Track: Character Encoding, Low-Level POSIX Formatting & Data Obfuscation*

---

## 1. System Architecture & Processing Pipeline

The **Text to ASCII Converter** is a lightweight, zero-dependency Bash utility engineered to convert raw string inputs or file streams into sequential **Decimal ASCII Byte Sequences** (Base-10 character codes).

```
                         [ USER INVOCATION / CLI INPUT ]
                                       │
                                       ▼
                       { Argument Count Validation ($#) }
                          ├── ($# == 0) ──> Display Usage & Exit 1
                          └── ($# >= 1) ──┐
                                          ▼
                         { Check If Argument Is File (-f) }
                                          │
                  ┌───────────────────────┴───────────────────────┐
                  ▼ (YES: File Ingestion)                         ▼ (NO: Raw String Ingestion)
       [ while IFS= read -r -n1 c ]                       [ String Array: text="$*" ]
                  │                                               │
                  ▼ (Stream Byte-by-Byte)                         ▼ (Iterate: ${text:i:1})
       ┌──────────────────────────────────────────────────────────────────┐
       │             POSIX ASCII CONVERSION: printf '%d ' "'$c"           │
       └──────────────────────────────────┬───────────────────────────────┘
                                          │
                                          ▼
                         [ Formatted Decimal Output Stream ]
                               Example: "A" ──> 65
```

---

## 2. Low-Level Shell Mechanics & Parser Internals

### 1. The POSIX `printf '%d ' "'$c"` Character Evaluation Trick
The core conversion engine relies on a standardized POSIX `printf` specification:
$$\text{Syntax: } \mathbf{\text{printf '\%d ' "'\$c"}}$$
* **How it works:** In POSIX-compliant shells, when a numeric conversion specifier (`%d`, `%i`, `%o`, `%x`) is supplied with an argument whose **leading character is a single quote (`'`) or double quote (`"`)**, `printf` evaluates the argument as the **underlying numerical ASCII/Unicode value** of the following character.
* **Example:** `printf '%d' "'A"` evaluates `'A` to decimal **`65`**.

---

### 2. Single-Character Stream Ingestion (`read -n1`)
When reading files directly:
```bash
while IFS= read -r -n1 c; do ... done < "$1"
```
* **`-n 1`:** Limits input consumption to exactly **1 character / 1 byte** per iteration, allowing character-by-character processing without waiting for newline delimiters (`\n`).
* **`IFS=`:** Clears the Internal Field Separator to prevent stripping leading/trailing whitespace (spaces, tabs).
* **`-r`:** Disables backslash interpretation, ensuring characters like `\` are preserved literally.

---

### 3. Substring Slicing Iterator (`${text:i:1}`)
When processing CLI arguments:
```bash
for ((i=0; i<${#text}; i++)); do
    c="${text:i:1}"
    printf '%d ' "'$c"
done
```
* **`${#text}`:** Computes total character count in memory without spawning external utilities like `wc -c`.
* **`${text:i:1}`:** Extracts a substring of **length 1** starting at offset index **`i`**.

---

## 3. Installation & Usage Guide

### Step 1: Make Script Executable
```bash
chmod +x text_to_ascii.sh
```

### Step 2: Convert Raw Text Strings Directly
```bash
./text_to_ascii.sh Hello CyberOps
# Output:
# 72 101 108 108 111 32 67 121 98 101 114 79 112 115 
```

### Step 3: Convert File Contents
```bash
echo "ADMIN_ROOT" > payload.txt
./text_to_ascii.sh payload.txt
# Output:
# 65 68 77 73 78 95 82 79 79 84 10 
```

---

## 4. Tactical Relevance & Cyber Operations Focus

```
┌────────────────────────────────────────────────────────────────────────┐
│                   TACTICAL CYBER OPS USE CASES                         │
├──────────────────────────┬─────────────────────────────────────────────┤
│ 1. Payload Obfuscation   │ Translating strings into decimal arrays     │
│                          │ to evade simple pattern-matching WAFs       │
│ 2. Shellcode Extraction  │ Formatting strings into integer byte lists  │
│                          │ for C exploit buffer arrays                 │
│ 3. Protocol Parsing      │ Decoding raw decimal telemetry into human   │
│                          │ readable formats during network inspection  │
└──────────────────────────┴─────────────────────────────────────────────┘
```

---

<!-- =========================================================================
   [IW CYBER OPS] - INTERNAL RESEARCH USE ONLY
   Repository: https://github.com/iwcyberops/IW-Arsenal
   ========================================================================= -->
