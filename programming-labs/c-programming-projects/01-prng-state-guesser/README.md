<!-- =========================================================================
   PROJECT: IW Cyber Ops — Arsenal Labs (Systems & Applied Engineering)
   AUTHOR: Muhammad Imran | IW Cyber Ops (@iwcyberops)
   TRACK: C Systems & Binary Foundations
   MODULE: C Core Programming & Algorithmic Controls
   DOCUMENT: Lab 01 — PRNG State Engine & Interactive Guessing Logic
   ========================================================================= -->

# 🎯 Lab 01: PRNG State Engine & Interactive Guessing Logic

> **IW Cyber Ops Arsenal | Systems & Binary Foundations**  
> *Author: Muhammad Imran (@iwcyberops)*  
> *Track: C Programming, Pseudo-Random State Seeding & Branching Logic*

---

## 1. System Architecture & Flowchart

The binary implements an interactive console application that seeds the C standard pseudo-random number generator (PRNG), maps the generated value to a constrained discrete range $[1, 100]$, and enforces a fixed 10-attempt loop with dynamic score calculations.

```
       [ Start ]
           │
           ▼
   [ Fetch time(0) ] ───> [ Seed srand() ]
                               │
                               ▼
                    [ Generate rand() % 100 + 1 ]
                               │
                ┌──────────────┴──────────────┐
                ▼                             │
    [ Initialize Attempts = 1 ]               │
    [ Initialize Score    = 10 ]              │
                │                             │
    ┌───────────► ◄─────────────────────┐     │
    │           │                       │     │
    │   [ Input: scanf("%d") ]          │     │
    │           │                       │     │
    │   { Valid (1 <= guess <= 100)? }  │     │
    │     ├── NO  ──> [ i-- (Rollback) ]┘     │
    │     └── YES ──┐                         │
    │               ▼                         │
    │       { guess == target? }              │
    │         ├── YES ─> [ Display Score & Break ] ──> [ Exit 0 ]
    │         └── NO  ─┐                      │
    │                  ▼                      │
    │          [ Higher / Lower Hint ]        │
    │          [ Attempts Counter Check ]     │
    │                  │                      │
    │       { Attempt == 10 Reach? }          │
    │         ├── YES ─> [ Score 0 & Break ] ─┘
    │         └── NO  ─> [ Loop Next (i++) ] ─┘
```

---

## 2. Low-Level Mechanics & C Primitives

### 1. Standard Streams & I/O Buffering (`<stdio.h>`)
* `printf()` writes formatted byte buffers to `stdout`.
* `scanf("%d", &guess)` reads structured formatted integer input from `stdin` and writes directly to the memory address (`&guess`) of the local stack variable.

### 2. PRNG Seeding Mechanics (`<stdlib.h>` & `<time.h>`)
* `time(0)` queries the kernel via the `gettimeofday`/`time` system call and returns the current **Unix Epoch Timestamp** (seconds elapsed since January 1, 1970).
* `srand(seed)` initializes the internal state register of the C runtime Linear Congruential Generator (LCG).
* `rand() % 100 + 1` maps the generated 32-bit integer `$[0, \text{RAND\_MAX}]$` to the normalized interval `$[1, 100]$` via the modulo arithmetic operator.

### 3. Loop Counter Rollback Logic
```c
else {
    printf("Please Enter a number between 1 to 100: ");
    i--; // Rollback counter to prevent penalizing invalid input bounds
}
```
If an out-of-bounds integer is supplied, the loop control variable `i` is explicitly decremented, neutralizing the iteration increment and ensuring only valid attempts consume turns.

---

## 3. Cryptographic & Security Analysis

> [!WARNING]
> ### 🔴 PRNG Time-Seed Predictability Vulnerability
> 
> * **Flaw:** The program relies on `srand(time(0))` to initialize entropy.
> * **Mechanism:** `time(0)` provides coarse-grained resolution of only **1-second increments**.
> * **Exploitation Vector:** If an adversary captures the system timestamp ($T_{\text{epoch}}$) of binary execution (e.g., by syncing over NTP or reading the server's HTTP `Date` response header), the adversary can feed the identical $T_{\text{epoch}}$ value into their own local instance of `srand()`.
> * **Impact:** The resulting `rand()` output becomes **100% deterministic**. An attacker can calculate the exact target number instantly on turn #1 with zero trial-and-error. Standard `rand()` is purely algorithmic (Linear Congruential) and lacks cryptographic entropy.

---

## 4. Compilation & Deployment

Compile using GNU C Compiler (`gcc`) with standard warning flags:

```bash
# Compile source into ELF binary
gcc -Wall -Wextra prng_guesser.c -o prng_guesser

# Set execution rights & launch binary
chmod +x prng_guesser
./prng_guesser
```

---

<!-- =========================================================================
   [IW CYBER OPS] - INTERNAL RESEARCH USE ONLY
   Repository: https://github.com/iwcyberops/IW-Knowledge-Base
   ========================================================================= -->
   
