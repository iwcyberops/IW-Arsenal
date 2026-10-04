#!/usr/bin/env bash

# System Information Reporter - v1

#COLORS
GREEN='\033[1;32m'
RED='\033[1;31m'
L_GREEN='\033[1;92m'
L_RED='\033[1;91m'
RESET='\033[0m'

printf "\n"
printf "${L_GREEN}==================================${RESET}\n"
printf "${L_RED}     Linux System Information     ${RESET}\n"
printf "${L_GREEN}==================================${RESET}\n\n"

printf "${RED}SYSTEM${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

HOSTNAME=$(hostname)
OS_NAME=$(cat /etc/os-release | grep -Ei "^(name)" | cut -d "=" -f2 | tr -d '"')
KERNEL=$(uname -s)
K_VERSION=$(uname -r)
ARCH=$(hostnamectl | grep -i "architecture" | cut -d: -f2 | awk '$1=$1' 2>/dev/null)
UTIME=$(uptime -p | cut -d ' ' -f2- 2>/dev/null)
CHASSIS=$(hostnamectl | grep -E -i "(chassis:)" | cut -d: -f2 | awk '$1=$1')
HDW_MODEL=$(hostnamectl | grep -i "Hardware Model" | cut -d: -f2 | awk '$1=$1')

printf "${GREEN}Hostname         : ${RESET}%s\n" "$HOSTNAME"
printf "${GREEN}Operating System : ${RESET}%s\n" "$OS_NAME"
printf "${GREEN}Kernel           : ${RESET}%s\n" "$KERNEL"
printf "${GREEN}Kernel Version   : ${RESET}%s\n" "$K_VERSION"
printf "${GREEN}Architecture     : ${RESET}%s\n" "$ARCH"
printf "${GREEN}Uptime           : ${RESET}%s\n" "$UTIME"
printf "${GREEN}Chassis          : ${RESET}%s\n" "$CHASSIS"
printf "${GREEN}Hardware Model   : ${RESET}%s\n\n" "$HDW_MODEL"

printf "${RED}USER ${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

USERNAME=$(whoami)
U_ID=$(id -u)
G_ID=$(id -g)

printf "${GREEN}Username         : ${RESET}%s\n" "$USERNAME"
printf "${GREEN}UID              : ${RESET}%s\n" "$U_ID"
printf "${GREEN}GID              : ${RESET}%s\n\n" "$G_ID"

printf "${RED}CPU${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

MODEL=$(lscpu | grep -i "model name" | cut -d: -f2 | awk '$1=$1')
CORES=$(lscpu | grep -Ei "^(core)" | cut -d: -f2 | tr -d ' ')
THREADS=$(nproc)

printf "${GREEN}Model            : ${RESET}%s\n" "$MODEL"
printf "${GREEN}CPU Cores        : ${RESET}%s\n" "$CORES"
printf "${GREEN}CPU Threads      : ${RESET}%s\n\n" "$THREADS"

printf "${RED}MEMORY${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

TOTAL_R=$(free -h | awk '/^Mem:/ {print $2}')
USED_R=$(free -h | grep -i "mem" | awk '{print $3}')
AVAIL_R=$(free -h | grep -i "mem" | awk '{print $7}')

printf "${GREEN}Total RAM        : ${RESET}%s\n" "$TOTAL_R"
printf "${GREEN}Used RAM         : ${RESET}%s\n" "$USED_R"
printf "${GREEN}Available Ram    : ${RESET}%s\n\n" "$AVAIL_R"

printf "${RED}STORAGE${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

ROOT=$(df -h / | awk 'NR==2 {print $1}')
TOTAL=$(df -h / | awk 'NR==2 {print $2}')
USE=$(df -h / | awk 'NR==2 {print $3,$5}')
FREE=$(df -h / | awk 'NR==2 {print $4}')

printf "${GREEN}Root Filesystem  : ${RESET}%s\n" "$ROOT"
printf "${GREEN}Partition Space  : ${RESET}%s\n" "$TOTAL"
printf "${GREEN}Usage            : ${RESET}%s\n" "$USE"
printf "${GREEN}Free Space       : ${RESET}%s\n\n" "$FREE"

printf "${RED}NETWORK${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

INTERFACES=$(ip -br addr | awk '$1 != "lo" {print $1}' | tr "\n" " ")
LOCAL_IP_ADDR=$(hostname -I)
PUBLIC_IP=$((curl -6 -sf icanhazip.com || curl -4 -sf icanhazip.com) || printf '%s\n' "Couldn't Get Public Ip Address")
MAC_ADDR=$(ip -br link | awk '$1 != "lo" {print $3; exit}')

printf "${GREEN}Interfaces       : ${RESET}%s\n" "$INTERFACES"
printf "${GREEN}Local Ip Address : ${RESET}%s\n" "$LOCAL_IP_ADDR"
printf "${GREEN}Public IP        : ${RESET}%s\n" "$PUBLIC_IP"
printf "${GREEN}Mac Address      : ${RESET}%s\n\n" "$MAC_ADDR"

printf "${L_GREEN}==================================${RESET}\n"
printf "${L_RED}         Report Completed         ${RESET}\n"
printf "${L_GREEN}==================================${RESET}\n\n"

# Completed!
# IW Cyber Ops
