<!-- =========================================================================
   PROJECT: IW Cyber Ops — Arsenal Vault (Systems & Automation Engineering)
   AUTHOR: Muhammad Imran Wakeel | IW Cyber Ops (@iwcyberops)
   TRACK: 42-Month Systems & Cyber Operations Research
   MODULE: Phase 01 — Month 01: Linux Automation & Lab Engineering
   DOCUMENT: Tool 04 — Host Telemetry & System Reconnaissance Reporter (v1)
   ========================================================================= -->

# 🖥️ Tool 04: Host Telemetry & System Reconnaissance Reporter 

> **IW Cyber Ops Arsenal | Phase 01: Foundations & Systems Architecture**  
> *Author: Muhammad Imran Wakeel (@iwcyberops)*  
> *Track: System Profiling, Kernel Ingress Reconnaissance & Host Telemetry*

---

## 1. System Architecture & Telemetry Ingestion Pipeline

The **System Information Reporter (v1)** is an automated host triage and environment profiling engine. It queries kernel pseudo-filesystems (`/etc/os-release`), hardware abstraction interfaces (`hostnamectl`, `lscpu`), and memory/network status utilities to render a centralized, colorized **Host Situational Awareness Dashboard**.

```
                         [ INITIATE HOST RECONNAISSANCE ]
                                       │
         ┌──────────────┬──────────────┼──────────────┬──────────────┬──────────────┐
         ▼              ▼              ▼              ▼              ▼              ▼
    [ SYSTEM ]      [ USER ]        [ CPU ]        [ MEMORY ]    [ STORAGE ]    [ NETWORK ]
   /etc/os-release  whoami          lscpu          free -h       df -h /        ip -br addr
   uname -r         id -u           nproc          RAM usage     Root usage     hostname -I
   hostnamectl      id -g           Topology       Buffers       Free space     MAC address
         │              │              │              │              │              │
         └──────────────┴──────────────┼──────────────┴──────────────┴──────────────┘
                                       │
                                       ▼
                       [ Stream Carving: cut / awk / tr ]
                                       │
                                       ▼
                   [ Formatted ANSI Colorized Telemetry HUD ]
```

---

## 2. Low-Level Subsystem Query Mechanics

### 1. Operating System & Kernel Telemetry
* **Distribution Identification:**
  ```bash
  cat /etc/os-release | grep -Ei "^(name)" | cut -d "=" -f2 | tr -d '"'
  ```
  Parses the standard system identification file without relying on external packages like `lsb_release`.
* **Kernel & Architecture:**
  * `uname -s` & `uname -r` extract the active kernel type and release build (critical for identifying kernel vulnerability baselines).
  * `hostnamectl` extracts hardware chassis, architecture, and virtualization firmware metadata.

---

### 2. Privilege & Identity Context
* `whoami` captures the effective username.
* `id -u` and `id -g` resolve the numerical **UID** and **GID** (UID `0` confirms superuser/root execution privileges).

---

### 3. Compute & CPU Architecture
* `lscpu` queries `/sys/devices/system/cpu/` to extract processor model and physical core counts.
* `nproc` computes the total number of active processing threads available to the scheduler.

---

### 4. Memory & Storage Metrics
* **RAM Allocation:** `free -h | awk '/^Mem:/ {print $2, $3, $7}'` extracts Total, Used, and Available memory metrics directly from `/proc/meminfo`.
* **Root Filesystem Usage:** `df -h / | awk 'NR==2 {print $1, $2, $3, $4, $5}'` isolates the primary mount partition, total disk block capacity, and available free space.

---

### 5. Network Stack & Interface Reconnaissance
* **Interface Resolution:** `ip -br addr | awk '$1 != "lo" {print $1}'` filters out the loopback adapter (`lo`) to isolate physical and virtual network interfaces.
* **IP & MAC Mapping:** `hostname -I` extracts assigned IPv4/IPv6 addresses, while `ip -br link` resolves the Layer 2 hardware MAC address.

---

## 3. Installation & Execution Guide

### Step 1: Grant Execution Permissions
```bash
chmod +x sysinfo_reporter.sh
```

### Step 2: Run Host Profiler
```bash
./sysinfo_reporter.sh
```

---

## 4. Example Output Dashboard

```text
==================================
     Linux System Information     
==================================

SYSTEM
----------------------------------
Hostname         :kali-ops
Operating System :Kali GNU/Linux
Kernel           :Linux 6.8.11-amd64
Architecture     :x86-64
Uptime           :2 hours
Chassis          :laptop
Hardware Model   :ThinkPad T480

USER 
----------------------------------
Username         :imran
UID              :1000
GID              :1000

CPU
----------------------------------
Model            :Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz
CPU Cores        :4
CPU Threads      :8

MEMORY
----------------------------------
Total RAM        :15Gi
Used RAM         :4.2Gi
Available Ram    :10.8Gi

STORAGE
----------------------------------
Root Filesystem  :/dev/nvme0n1p2
Partition Space  :234G
Usage            :42G 18%
Free Space       :180G 

NETWORK
----------------------------------
Interfaces       :eth0 wlan0 
Ip Address       :192.168.1.55 10.10.14.8
Mac Address      :00:1a:2b:3c:4d:5e
```

---

## 5. Tactical Relevance & Cyber Operations Focus

```
┌────────────────────────────────────────────────────────────────────────┐
│                   TACTICAL CYBER OPS RECONNAISSANCE                    │
├──────────────────────────┬─────────────────────────────────────────────┤
│ 1. Post-Exploitation     │ First-stage situational awareness upon      │
│    Triage                │ gaining initial shell ingress on a target   │
│ 2. Exploit Targeting     │ Cross-referencing Kernel release (`uname -r`)│
│                          │ against known local privilege exploits      │
│ 3. Defense Evasion       │ Auditing chassis & hardware model to detect │
│                          │ virtualized sandboxes and analysis honeypots│
└──────────────────────────┴─────────────────────────────────────────────┘
```

---

<!-- =========================================================================
   [IW CYBER OPS] - INTERNAL RESEARCH USE ONLY
   Repository: https://github.com/iwcyberops/IW-Arsenal
   ========================================================================= -->
