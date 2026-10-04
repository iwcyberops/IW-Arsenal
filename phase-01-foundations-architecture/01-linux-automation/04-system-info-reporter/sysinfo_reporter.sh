#!/usr/bin/env bash

# System Information Reporter - v1

printf "\033[1;92m==================================\033[0;m\n"
printf "     Linux System Information     \n"
printf "\033[1;92m==================================\033[0;m\n\n"

printf "\033[1;31mSYSTEM\033[0;m\n"
printf "\033[1;31m----------------------------------\033[0;m\n"

HOSTNAME=$(hostname)
OS_NAME=$(cat /etc/os-release | grep -Ei "^(name)" | cut -d "=" -f2 | tr -d '"')
KERNEL=$(uname -s)
K_VERSION=$(uname -r)
ARCH=$(hostnamectl | grep -i "architecture" | cut -d: -f2 | awk '$1=$1' 2>/dev/null)
UTIME=$(uptime -p | cut -d ' ' -f2- 2>/dev/null)
CHASSIS=$(hostnamectl | grep -E -i "(chassis:)" | cut -d: -f2 | tr -d ' ')
HDW_MODEL=$(hostnamectl | grep -i "Hardware Model" | cut -d: -f2 | tr -d ' ')

printf "Hostname         : %s\n" "$HOSTNAME"
printf "Operating System : %s\n" "$OS_NAME"
printf "Kernel           : %s\n" "$KERNEL"
printf "Kernel Version   : %s\n" "$K_VERSION"
printf "Architecture     : %s\n" "$ARCH"
printf "Uptime           : %s\n" "$UTIME"
printf "Chassis          : %s\n" "$CHASSIS"
printf "Hardware Model   : %s\n\n" "$HDW_MODEL"

printf "\033[1;31mUSER \033[0;m\n"
printf "\033[1;31m----------------------------------\033[0;m\n"

USERNAME=$(whoami)
U_ID=$(id -u)
G_ID=$(id -g)

printf "Username         : %s\n" "$USERNAME"
printf "UID              : %s\n" "$U_ID"
printf "GID              : %s\n\n" "$G_ID"

printf "\033[1;31mCPU\033[0;m\n"
printf "\033[1;31m----------------------------------\033[0;m\n"

MODEL=$(lscpu | grep -i "model name" | cut -d: -f2 | awk '$1=$1')
CORES=$(lscpu | grep -Ei "^(core)" | cut -d: -f2 | tr -d ' ')
THREADS=$(nproc)

printf "Model            : %s\n" "$MODEL"
printf "CPU Cores        : %s\n" "$CORES"
printf "CPU Threads      : %s\n\n" "$THREADS"

printf "\033[1;31mMEMORY\033[0;m\n"
printf "\033[1;31m----------------------------------\033[0;m\n"

TOTAL_R=$(free -h | awk '/^Mem:/ {print $2}')
USED_R=$(free -h | grep -i "mem" | awk '{print $3}')
AVAIL_R=$(free -h | grep -i "mem" | awk '{print $7}')

printf "Total RAM        : %s\n" "$TOTAL_R"
printf "Used RAM         : %s\n" "$USED_R"
printf "Available Ram    : %s\n\n" "$AVAIL_R"

printf "\033[1;31mSTORAGE\033[0;m\n"
printf "\033[1;31m----------------------------------\033[0;m\n"

ROOT=$(df -h / | awk 'NR==2 {print $1}')
TOTAL=$(df -h / | awk 'NR==2 {print $2}')
USE=$(df -h / | awk 'NR==2 {print $3,$5}')
FREE=$(df -h / | awk 'NR==2 {print $4}')

printf "Root Filesystem  : %s\n" "$ROOT"
printf "Partition Space  : %s\n" "$TOTAL"
printf "Usage            : %s\n" "$USE"
printf "Free Space       : %s\n\n" "$FREE"

printf "\033[1;31mNETWORK\033[0;m\n"
printf "\033[1;31m----------------------------------\033[0;m\n"

INTERFACES=$(ip -br addr | awk '$1 != "lo" {print $1}' | tr "\n" " ")
IP_ADDR=$(hostname -I)
MAC_ADDR=$(ip -br link | grep -i "eth0" |awk '$1 != "lo" {print $3}')

printf "Interfaces       : %s\n" "$INTERFACES"
printf "Ip Address       : %s\n" "$IP_ADDR"
printf "Mac Address      : %s\n\n" "$MAC_ADDR"

printf "\033[1;92m==================================\033[0;m\n"
printf "     Report Completed     \n"
printf "\033[1;92m==================================\033[0;m\n\n"

# Completed!
# IW Cyber Ops
