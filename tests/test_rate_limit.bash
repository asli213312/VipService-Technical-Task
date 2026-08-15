#!/bin/bash

GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
NC='\033[0m' # no color

URL="http://localhost/ping"
TOTAL=20

echo "Sending $TOTAL requests back-to-back to $URL ..."

CODES=$(for i in $(seq 1 $TOTAL); do
    curl -s -o /dev/null -w "%{http_code}\n" "$URL"
done)

OK=$(echo "$CODES" | grep -c 200)
LIMITED=$(echo "$CODES" | grep -c 429)

echo -e "Passed (200):     ${GREEN}$OK${NC}"
echo -e "Limited (429):    ${RED}$LIMITED${NC}"

if [ "$LIMITED" -gt 0 ]; then
    echo -e "Result: ${GREEN}rate limiter is working ${NC}"
else
    echo -e "Result: ${RED}no limiting detected, check the config ${NC}"
fi