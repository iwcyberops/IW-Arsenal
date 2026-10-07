#!/usr/bin/env bash

# System Information Reporter - v1

# COLORS

GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\e[0;96m'
L_GREEN='\033[1;92m'
L_RED='\033[1;91m'
RST_CYAN='\e[0m'
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
ARCH=$(uname -m)
UTIME=$(uptime -p | cut -d ' ' -f2- 2>/dev/null)
CHASSIS=$( (hostnamectl | grep -E -i "(chassis:)" | cut -d: -f2 | awk '$1=$1') || printf " %s\n" "Not Found")
HDW_MODEL=$( (hostnamectl | grep -i "Hardware Model" | cut -d: -f2 | awk '$1=$1') || printf "%s\n" "Not Found")

printf "${GREEN}Hostname         : ${RESET}${CYAN}%s${RST_CYAN}\n" "$HOSTNAME"
printf "${GREEN}Operating System : ${RESET}${CYAN}%s${RST_CYAN}\n" "$OS_NAME"
printf "${GREEN}Kernel           : ${RESET}${CYAN}%s${RST_CYAN}\n" "$KERNEL"
printf "${GREEN}Kernel Version   : ${RESET}${CYAN}%s${RST_CYAN}\n" "$K_VERSION"
printf "${GREEN}Architecture     : ${RESET}${CYAN}%s${RST_CYAN}\n" "$ARCH"
printf "${GREEN}Uptime           : ${RESET}${CYAN}%s${RST_CYAN}\n" "$UTIME"
printf "${GREEN}Chassis          : ${RESET}${CYAN}%s${RST_CYAN}\n" "$CHASSIS"
printf "${GREEN}Hardware Model   : ${RESET}${CYAN}%s${RST_CYAN}\n\n" "$HDW_MODEL"

printf "${RED}USER ${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

USERNAME=$(whoami)
U_ID=$(id -u)
G_ID=$(id -g)

printf "${GREEN}Username         : ${RESET}${CYAN}%s${RST_CYAN}\n" "$USERNAME"
printf "${GREEN}UID              : ${RESET}${CYAN}%s${RST_CYAN}\n" "$U_ID"
printf "${GREEN}GID              : ${RESET}${CYAN}%s${RST_CYAN}\n\n" "$G_ID"

printf "${RED}CPU${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

MODEL=$(lscpu | grep -i "model name" | cut -d: -f2 | awk '$1=$1')
CORES=$(lscpu | grep -Ei "^(core)" | cut -d: -f2 | tr -d ' ')
THREADS=$(nproc)

printf "${GREEN}Model            : ${RESET}${CYAN}%s${RST_CYAN}\n" "$MODEL"
printf "${GREEN}CPU Cores        : ${RESET}${CYAN}%s${RST_CYAN}\n" "$CORES"
printf "${GREEN}CPU Threads      : ${RESET}${CYAN}%s${RST_CYAN}\n\n" "$THREADS"

printf "${RED}MEMORY${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

TOTAL_R=$(free -h | awk '/^Mem:/ {print $2}')
USED_R=$(free -h | grep -i "mem" | awk '{print $3}')
AVAIL_R=$(free -h | grep -i "mem" | awk '{print $7}')

printf "${GREEN}Total RAM        : ${RESET}${CYAN}%s${RST_CYAN}\n" "$TOTAL_R"
printf "${GREEN}Used RAM         : ${RESET}${CYAN}%s${RST_CYAN}\n" "$USED_R"
printf "${GREEN}Available Ram    : ${RESET}${CYAN}%s${RST_CYAN}\n\n" "$AVAIL_R"

printf "${RED}STORAGE${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

read -r ROOT TOTAL USED FREE USE_PCT _ < <(df -h / | awk 'NR==2 {print $1, $2, $3, $4, $5}')

printf "${GREEN}Root Filesystem  : ${RESET}${CYAN}%s${RST_CYAN}\n" "$ROOT"
printf "${GREEN}Partition Space  : ${RESET}${CYAN}%s${RST_CYAN}\n" "$TOTAL"
printf "${GREEN}Usage            : ${RESET}${CYAN}%s${RST_CYAN}\n" "$USE_PCT"
printf "${GREEN}Used             : ${RESET}${CYAN}%s${RST_CYAN}\n" "$USED"
printf "${GREEN}Free Space       : ${RESET}${CYAN}%s${RST_CYAN}\n\n" "$FREE"

printf "${RED}NETWORK${RESET}\n"
printf "${RED}----------------------------------${RESET}\n"

INTERFACES=$(ip -br addr | awk '$1 != "lo" {print $1}' | tr "\n" " ")
LOCAL_IP_ADDR=$(hostname -I)
PUBLIC_IP=$( (curl -6 -sf icanhazip.com || curl -4 -sf icanhazip.com) || printf '%s\n' "Couldn't Get Public Ip Address")
MAC_ADDR=$(ip -br link | awk '$1 != "lo" {print $3; exit}')

printf "${GREEN}Interfaces       : ${RESET}${CYAN}%s${RST_CYAN}\n" "$INTERFACES"
printf "${GREEN}Local Ip Address : ${RESET}${CYAN}%s${RST_CYAN}\n" "$LOCAL_IP_ADDR"
printf "${GREEN}Public IP        : ${RESET}${CYAN}%s${RST_CYAN}\n" "$PUBLIC_IP"
printf "${GREEN}Mac Address      : ${RESET}${CYAN}%s${RST_CYAN}\n\n" "$MAC_ADDR"

printf "${L_GREEN}==================================${RESET}\n"
printf "${L_RED}         Report Completed         ${RESET}\n"
printf "${L_GREEN}==================================${RESET}\n\n"

# Completed!
# IW Cyber Ops
