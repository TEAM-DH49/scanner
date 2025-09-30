#!/bin/bash

# ANSI Colors
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
RESET='\033[0m'

# === 🔐 PASSWORD PROTECTION ===
PASSWORD="admin"  # <-- Change this to your desired password

read -s -p "Enter password to access HaxShadow: " input
echo

if [[ "$input" != "$PASSWORD" ]]; then
    echo -e "${RED}❌ Access denied! Wrong password.${RESET}"
    exit 1
fi

# === HAXSHADOW BANNER ===
echo -e "${RED}"
cat << "EOF"
██╗  ██╗ █████╗ ██╗  ██╗███████╗██████╗ ██╗  ██╗███████╗██████╗ 
██║  ██║██╔══██╗██║ ██╔╝██╔════╝██╔══██╗██║  ██║██╔════╝██╔══██╗
███████║███████║█████╔╝ █████╗  ██████╔╝███████║█████╗  ██████╔╝
██╔══██║██╔══██║██╔═██╗ ██╔══╝  ██╔══██╗██╔══██║██╔══╝  ██╔══██╗
██║  ██║██║  ██║██║  ██╗███████╗██║  ██║██║  ██║███████╗██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                                
                                       by @TEAM_DH049
EOF
echo -e "${RESET}"

read -p "Enter domain: " DOMAIN
[[ -z "$DOMAIN" ]] && { echo -e "${RED}❌ Empty!${RESET}"; exit 1; }

DOMAIN=$(echo "$DOMAIN" | sed -E 's|https?://||; s|/.*$||')

# === LIVE CHECK ===
if ! timeout 3 getent hosts "$DOMAIN" >/dev/null 2>&1; then
    echo -e "${RED}❌ Invalid domain: $DOMAIN${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Target validated: $DOMAIN${RESET}"

# === RECON ===
TMP=$(mktemp)
gau "$DOMAIN" 2>/dev/null | grep -E '\?[^=]+=' | uro > "$TMP"
[[ ! -s "$TMP" ]] && { echo -e "${YELLOW}⚠️ No param URLs.${RESET}"; exit 0; }

# === LIVE CHECK ===
httpx -l "$TMP" -silent -mc 200,301,302,403 -threads 300 -timeout 6 -rl 200 | cut -d ' ' -f1 > live.txt
[[ ! -s live.txt ]] && { echo -e "${YELLOW}⚠️ No live param URLs.${RESET}"; exit 0; }

# === 💥 RUN NUCLEI IN DAST MODE ===
echo -e "${GREEN}[+] Running DAST scan (max 120 seconds)...${RESET}"

timeout 120s nuclei \
  -dast \
  -l live.txt \
  -retries 2 \
  -silent \
  -timeout 8 \
  -c 50 \
  -o findings.txt

# === OUTPUT ===
FINDINGS=$(wc -l < findings.txt 2>/dev/null || echo 0)
echo -e "\n${GREEN}✅ Done!${RESET}"
echo "• Findings: $FINDINGS"

if [[ $FINDINGS -gt 0 ]]; then
    echo -e "\n${RED}🚨 VULNERABILITIES:${RESET}"
    cat findings.txt
else
    echo -e "\n${YELLOW}💡 No bugs found. Try manual testing on live.txt${RESET}"
fi

# Save for manual
cp live.txt ~/live_params_for_burp.txt
echo -e "${GREEN}📁 Manual test list saved: ~/live_params_for_burp.txt${RESET}"