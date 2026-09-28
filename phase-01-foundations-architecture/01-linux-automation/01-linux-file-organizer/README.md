<!-- =========================================================================
   PROJECT: IW Cyber Ops — Arsenal Vault (Systems & Automation Engineering)
   AUTHOR: Muhammad Imran Wakeel | IW Cyber Ops (@iwcyberops)
   TRACK: 42-Month Systems & Cyber Operations Research
   MODULE: Phase 01 — Month 01: Linux Automation & Lab Engineering
   DOCUMENT: Tool 01 — Automated Linux Filesystem Categorization Engine
   ========================================================================= -->

# 🗂️ Tool 01: Automated Linux Filesystem Categorization Engine

> **IW Cyber Ops Arsenal | Phase 01: Foundations & Systems Architecture**  
> *Author: Muhammad Imran Wakeel (@iwcyberops)*  
> *Track: Shell Automation, Stream Processing & Filesystem Organization*

---

## 1. System Architecture & Operational Flow

The **Linux File Organizer** is a robust Bash automation utility engineered to parse, filter, and organize unstructured directories (such as `~/Downloads` or ingestion drop-zones) into structured, type-specific taxonomies.

```
                         [ TARGET DIRECTORY INGESTION ]
                           (Default: ~/Downloads or $1)
                                       │
                                       ▼
                       { Validate Directory Existence }
                          ├── (Invalid)  ──> Exit 1 (Error)
                          └── (Valid)    ──┐
                                           ▼
                         { Check File & Inode Status }
                            ├── (Empty / Dirs Only) ──> Exit 1
                            └── (Files Present)     ──┐
                                                      ▼
                       [ find -maxdepth 1 -type f -print0 ]
                                       │
                                       ▼ (Null-Delimited Byte Stream: IFS= read -r -d '')
                        ┌──────────────────────────────┐
                        │ case Pattern Evaluation      │
                        │ (Case-Insensitive Match)     │
                        └──────────────┬───────────────┘
                                       │
         ┌──────────────┬──────────────┼──────────────┬──────────────┬──────────────┐
         ▼              ▼              ▼              ▼              ▼              ▼
   [ Documents ]   [ Pictures ]    [ Videos ]     [ Audios ]    [ Archives ]     [ Code ]
    .pdf, .docx     .png, .jpg     .mp4, .mkv     .mp3, .wav    .tar, .zip       .c, .py, .sh
         │              │              │              │              │              │
         └──────────────┴──────────────┼──────────────┴──────────────┴──────────────┘
                                       │
                                       ▼ (mkdir -p + mv)
                          [ Categorized Destination Folders ]
```

---

## 2. Low-Level Shell Mechanics & Core Directives

The script leverages advanced Bash shell options and robust stream-parsing constructs:

### 1. `shopt -s nullglob` (Preventing Wildcard Expansion Bugs)
By default, if a glob pattern (e.g., `"$path"/*`) finds zero matches, Bash returns the literal string `"$path/*"`. `nullglob` forces the shell to expand non-matching globs into an **empty list**, preventing false positive file detections.

### 2. Parameter Fallback Expansion (`${1:-~/Downloads}`)
$$\text{Syntax: } \mathbf{\$\{1:-\sim/\text{Downloads}\}}$$
* If positional argument `$1` is supplied by the operator (e.g., `./file_organizer.sh /tmp/loot`), the script uses `$1`.
* If `$1` is omitted or null, the parameter engine automatically defaults to the user's `~/Downloads` path.

### 3. Null-Delimited Stream Ingestion (`find -print0` + `read -d ''`)
Standard line-by-line reading breaks on filenames containing whitespaces, newlines, or special characters.
* `find "$path" -maxdepth 1 -type f -print0` separates filenames with a **Null Byte (`\0`)**.
* `while IFS= read -r -d '' file` reads until the null terminator (`-d ''`) without word-splitting, ensuring 100% boundary safety.

### 4. Case-Insensitive Pattern Matching (`shopt -s nocasematch`)
Temporarily enables case insensitivity inside the `case` block, ensuring extensions like `.JPG`, `.PNG`, `.PDF`, and `.ZIP` match their lowercase definitions seamlessly.

---

## 3. Extension Classification Matrix

The engine categorizes files across 7 distinct operational directories:

| Category Directory | Target File Extensions |
| :--- | :--- |
| **`Documents/`** | `.txt`, `.pdf`, `.doc`, `.docx`, `.md`, `.odt`, `.rtf`, `.xls`, `.xlsx`, `.ppt` |
| **`Pictures/`** | `.jpg`, `.png`, `.jpeg`, `.bmp`, `.webp`, `.svg`, `.gif`, `.avif` |
| **`Videos/`** | `.mp4`, `.mov`, `.mpeg`, `.mkv`, `.webm`, `.avi`, `.wmv` |
| **`Audios/`** | `.mp3`, `.wav`, `.aiff`, `.flac`, `.alac`, `.aac`, `.ogg`, `.m4a`, `.m4b` |
| **`Archives/`** | `.zip`, `.zipx`, `.rar`, `.7z`, `.tar`, `.tar.gz`, `.tgz`, `.gz`, `.jar`, `.bz2`, `.xz`, `.iso`, `.img` |
| **`Code/`** | `.c`, `.h`, `.cpp`, `.hpp`, `.java`, `.py`, `.rb`, `.php`, `.js`, `.ts`, `.html`, `.css`, `.sql`, `.asm`, `.rs`, `.go`, `.swift`, `.kt`, `.sh`, `.bash` |
| **`Others/`** | Any unmapped or non-standard file extension |

---

## 4. Installation & Execution Guide

### Step 1: Make Script Executable
```bash
chmod +x file_organizer.sh
```

### Step 2: Execute on Default Path (`~/Downloads`)
```bash
./file_organizer.sh
```

### Step 3: Execute on Custom Target Path
```bash
./file_organizer.sh /path/to/unorganized_directory
```

---

## 5. Tactical Relevance & Cyber Ops Application

In digital forensics and offensive staging:
1. **Automated Forensic Staging:** Ingests triage artifacts from target systems and instantly clusters source code, network PCAPs/archives, and memory dumps into segregated analytical domains.
2. **Payload & Wordlist Segregation:** Cleans up centralized C2 and staging directories during active multi-target engagements.

---
<br>

**Maintained & Engineered by IW Cyber Ops | High-Assurance Cyber Operations & Systems Engineering**

<!-- =========================================================================
   [IW CYBER OPS] - INTERNAL RESEARCH USE ONLY
   Repository: https://github.com/iwcyberops/IW-Arsenal
   ========================================================================= -->
