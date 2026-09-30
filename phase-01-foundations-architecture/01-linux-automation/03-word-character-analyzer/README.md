<!-- =========================================================================
   PROJECT: IW Cyber Ops — Arsenal Vault (Systems & Automation Engineering)
   AUTHOR: Muhammad Imran Wakeel | IW Cyber Ops (@iwcyberops)
   TRACK: 42-Month Systems & Cyber Operations Research
   MODULE: Phase 01 — Month 01: Linux Automation & Lab Engineering
   DOCUMENT: Tool 03 — Lexical Stream & Character Frequency Analyzer
   ========================================================================= -->

# 📊 Tool 03: Lexical Stream & Character Frequency Analyzer -v1

> **IW Cyber Ops Arsenal | Phase 01: Foundations & Systems Architecture**  
> *Author: Muhammad Imran Wakeel (@iwcyberops)*  
> *Track: Lexical Stream Parsing, Pattern Classification & Forensic File Profiling*

---

## 1. System Architecture & Lexical Classification Pipeline

The **Word/Character Analyzer** is a Bash-based static analysis utility designed to perform granular, byte-by-byte lexical parsing of text streams. It categorizes character distributions into discrete statistical bins (Alphabets, Numbers, Punctuation/Symbols, Whitespace, and Non-Printable/Other bytes) while computing macro-level file metrics (Lines and Words).

```
                         [ TARGET FILE INGESTION: $1 ]
                                       │
                                       ▼
                       { Argument & File Existence Check }
                          ├── (Missing / Invalid) ──> Display Error & Exit 1
                          └── (Valid File)        ──┐
                                                    ▼
                                  [ while IFS= read -r -n1 c ]
                                       │
                                       ▼ (Byte-by-Byte Stream)
                        ┌──────────────────────────────┐
                        │ case Character Pattern Match │
                        └──────────────┬───────────────┘
                                       │
         ┌──────────────┬──────────────┼──────────────┬──────────────┐
         ▼              ▼              ▼              ▼              ▼
     [ [a-zA-Z] ]    [ [0-9] ]     [ Symbols ]     [ " " ]         [ * ]
      ((char++))     ((num++))    ((symbol++))   ((space++))    ((other++))
         │              │              │              │              │
         └──────────────┴──────────────┼──────────────┴──────────────┘
                                       │
                                       ▼
                 [ Aggregate Metrics: wc -l / wc -w via stdin ]
                                       │
                                       ▼
                    [ ANSI Colorized Formatted Terminal HUD ]
```

---

## 2. Low-Level Shell Mechanics & Parser Internals

### 1. Single-Byte Stream Extraction (`read -r -n1`)
```bash
while IFS= read -r -n1 c; do ... done < "$1"
```
* **`-n 1`:** Forces `read` to consume exactly **one byte/character per iteration**, allowing real-time character inspection without waiting for line-break delimiters.
* **`IFS=`:** Nullifies the Internal Field Separator to prevent the shell parser from stripping whitespace characters (such as `" "`, `\t`).
* **`-r`:** Disables backslash interpretation, ensuring raw characters (such as `\`) are processed literally.

---

### 2. Lexical Pattern Classifiers (`case ... in`)
The script matches each individual character against defined POSIX glob brackets:

| Pattern Expression | Target Character Class | Internal Accumulator |
| :--- | :--- | :---: |
| **`[0-9]`** | Decimal numeric digits (`0` through `9`) | `((num++))` |
| **`[a-zA-Z]`** | Lowercase and uppercase ASCII alphabets | `((char++))` |
| **`[\!\@\#\$\%...]`** | Escaped ASCII punctuation and mathematical symbols | `((symbol++))` |
| **`" "`** | Standard ASCII space character (0x20) | `((space++))` |
| **`*`** | Catch-all for tabs, newlines (`\n`), and non-printable control bytes | `((other++))` |

---

### 3. Subshell-Free File Metrics (`wc` via Redirection)
```bash
printf "%-12s %d\n" "Lines:" "$(wc -l < "$1")"
printf "%-12s %d\n" "Words:" "$(wc -w < "$1")"
```
* Passing `$1` via **Input Redirection (`< "$1"`)** forces `wc` to read from standard input (`stdin`), outputting **only the raw numerical count** without appending the filename to the output string.

---

### 4. Tabulated ANSI Color Formatting
```bash
printf "\033[1;36m%-12s %d\033[0m\n" "Letters:" "$char"
```
* **`\033[1;36m`:** Formats text in **Bold Cyan**.
* **`%-12s`:** Left-aligns the label across a fixed width of 12 characters.
* **`%d`:** Formats the accumulator variable as a decimal integer.
* **`\033[0m`:** Resets all graphic attributes back to default terminal styling.

---

## 3. Installation & Usage Guide

### Step 1: Make Script Executable
```bash
chmod +x word_char_analyzer.sh
```

### Step 2: Analyze a Target File
```bash
./word_char_analyzer.sh sample_target.txt
```

### Example Terminal Output
```text
-------------------------------------------
Lines:       15
Words:       142
Letters:     780
Numbers:     34
Symbols:     48
Spaces:      128
Others:      15
-------------------------------------------
```

---

## 4. Tactical Relevance & Cyber Operations Application

```
┌────────────────────────────────────────────────────────────────────────┐
│                   TACTICAL CYBER OPS USE CASES                         │
├──────────────────────────┬─────────────────────────────────────────────┤
│ 1. Password Complexity   │ Auditing wordlists or credential dumps for  │
│    Validation            │ entropy requirements (symbols, numbers)     │
│ 2. Shellcode / Payload   │ Detecting obfuscated payloads by tracking   │
│    Anomaly Detection     │ abnormal symbol-to-letter ratios            │
│ 3. Log Forensics         │ Profiling corrupted, binary, or non-ASCII   │
│                          │ byte distributions in compromised logs      │
└──────────────────────────┴─────────────────────────────────────────────┘
```

---

<!-- =========================================================================
   [IW CYBER OPS] - INTERNAL RESEARCH USE ONLY
   Repository: https://github.com/iwcyberops/IW-Arsenal
   ========================================================================= -->
